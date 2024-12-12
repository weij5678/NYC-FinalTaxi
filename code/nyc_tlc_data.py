import pandas as pd
import numpy as np
from sodapy import Socrata
import urllib.parse
#from IPython.display import display, HTML
import time
import pickle
from datetime import date, timedelta
import googlemaps
from meteostat import Hourly, Point
from datetime import datetime

#############################################
# Program configuration
#
# --------------------------------
# Replace with your actual API key
API_KEY = "Use your own google map key"
gmaps = googlemaps.Client(key=API_KEY)

# source domain for NYC Open Data on Socrata
socrata_domain = 'data.cityofnewyork.us'
# dataset id for 2023 High Volume FHV Trip Data 
socrata_dataset_identifier = 'u253-aew4'
# taxi zones is exported from NYC open data as CSV
# https://data.cityofnewyork.us/Transportation/NYC-Taxi-Zones/d3c5-ddgc
taxiZone = pd.read_csv("NYC_taxi_zones.csv")
#############################################

geolocs = {} # taxizone geo location cache

def daterange(start_date: date, end_date: date):
    days = int((end_date - start_date).days)
    for n in range(days):
        yield start_date + timedelta(n)

def getDateRange(start=date(2023, 10, 15), end=date(2023,11,15)):
    range = []
    for single_date in daterange(start, end):
        range.append(str(single_date.strftime("%Y-%m-%d")))
    return range


def dataFetch(domain, datasetID, startdate="2023-10-15", enddate="2023-11-15", starttime="08:00:00", endtime="08:10:00",limit=1000, total=-1, sleeptime=0.5):
    client = Socrata(
        domain,
        app_token=None,
        timeout=10000
    )

    query = """
    SELECT
        *
    WHERE
        request_datetime
        BETWEEN "{}T{}" :: floating_timestamp
        AND "{}T{}" :: floating_timestamp
    LIMIT
        {}
    OFFSET
        {}
    """ 
    
    size = limit
    
    dataset = []
    curOffset = 0
    curSum = 0
    
    retry = 0
    
    if (total > 0) and (total < limit):
        limit = total
    
    while size == limit:
        sql = query.format(startdate, starttime, enddate, endtime, limit, curOffset)
        try:
            results = client.get(
                datasetID,
                query=sql
            )
            time.sleep(sleeptime)
        
            dataset += results
            #print("curSum = {}, curOffset = {}, sql = {}".format(curSum, curOffset, sql))
            size = len(results)
            curSum += size
            curOffset += size
            
            if (curSum % 10000) == 0:
                print("curSum ==> {}".format(curSum))

        
            if (total > 0) and (curSum >= total):
                # total -1 is unlimited, which means retrieve all the data records
                # otherwise only fetch total records rounding up to the limit(per batch)
                break
        except Exception as e:
            print(e)
            if retry > 5:
                print("Retried more than 5 times, breakout!!!")
                break
            else:
                retry += 1
                time.sleep(retry*10)
        
    client.close()
    return pd.DataFrame.from_records(dataset)

def get_lat_lng(location_name):
    """Gets the latitude and longitude for a given location name."""

    geocode_result = gmaps.geocode(location_name)

    if geocode_result:
        location = geocode_result[0]['geometry']['location']
        return location['lat'], location['lng']
    else:
        return None, None
    
def getMeteoData(lat=40.6056632, lng=73.8713099, startdt=datetime(2023,10,15,8), enddt=datetime(2023,10,15,8)):
    data = Hourly(loc=Point(lat, lng), start=startdt, end=enddt)
    return data.fetch()

def meteoCoLUT(coco):
    lut = {
        1:  'Clear',
        2:  'Fair',
        3:	'Cloudy',
        4:	'Overcast',
        5:	'Fog',
        6:	'Freezing Fog',
        7:	'Light Rain',
        8:	'Rain',
        9:	'Heavy Rain',
        10:	'Freezing Rain',
        11:	'Heavy Freezing Rain',
        12:	'Sleet',
        13:	'Heavy Sleet',
        14:	'Light Snowfall',
        15:	'Snowfall',
        16:	'Heavy Snowfall',
        17:	'Rain Shower',
        18:	'Heavy Rain Shower',
        19:	'Sleet Shower',
        20:	'Heavy Sleet Shower',
        21:	'Snow Shower',
        22:	'Heavy Snow Shower',
        23:	'Lightning',
        24:	'Hail',
        25:	'Thunderstorm',
        26:	'Heavy Thunderstorm',
        27:	'Storm',
    }
    return lut.get(coco, "UNKNOWN")

def queryZoneGeoloc(locID):
    try:
        if geolocs.get(locID, None) != None:
            # taxi zone geolocation cache lookup
            return geolocs[locID][0], geolocs[locID][1]
                
        loc = taxiZone.loc[taxiZone['LocationID'] == locID]['zone'].to_list()[0] + ", New York City, NY"
        lat, lng = get_lat_lng(loc)
        geolocs.update({locID: [lat, lng]})
        return lat, lng
    except Exception as e:
        print("unknown locID => {}, use Wall Stree by default".format(locID))
        lat, lng = get_lat_lng("Wall Street, New York City, NY")
        geolocs.update({locID: [lat, lng]})

def getMeteoDataByZoneidTime(locID, startdt=datetime(2023,10,15,8), enddt=datetime(2023,10,15,8)):
    lat, lng = queryZoneGeoloc(locID)
    return getMeteoData(lat=lat, lng=lng, startdt=startdt, enddt=enddt)

def getPeriodOfDay(hr):
    res = ""
    if hr < 12:
        res = "Morning"
    elif hr == 12:
        res = "Noon"
    else:
        res = "Evening"
    return res


def main():
    alldf = []
    
    # Fetch 3 time period of data between 10/15/2023 and 11/15/2023
    for day in getDateRange(start=date(2023,10,15),end=date(2023,11,15)):
        alldf.append(dataFetch(socrata_domain, socrata_dataset_identifier, startdate=day, enddate=day, starttime="08:00:00", endtime="08:03:00",limit=1000, total=100000))
        alldf.append(dataFetch(socrata_domain, socrata_dataset_identifier, startdate=day, enddate=day, starttime="12:00:00", endtime="12:03:00",limit=1000, total=100000))
        alldf.append(dataFetch(socrata_domain, socrata_dataset_identifier, startdate=day, enddate=day, starttime="18:00:00", endtime="18:03:00",limit=1000, total=100000))

    df = pd.concat(alldf)
    
    df['pickup_datetime'] = pd.to_datetime(df['pickup_datetime'])
    df['request_datetime'] = pd.to_datetime(df['request_datetime'])
    df['dropoff_datetime'] = pd.to_datetime(df['dropoff_datetime'])
    
    df = df.drop('originating_base_num', axis=1)
    df = df.drop('on_scene_datetime', axis=1)
    
    # Save the raw data
    df.to_csv("2023_NYC_High_Volume_FHV_Trip_Data_1015_1115-3sets.csv", index=False)
   
    geolocs = {} # geo location cache
    # Lookup the taxi pickup location meteorology data by its geolocation
    # merge the data to each trip 
    for idx, row in df.iterrows():
        reqdt = df.at[idx, 'request_datetime']
        puloc = df.at[idx, 'pulocationid']
        doloc = df.at[idx, 'dolocationid']
        if idx % 2000 == 0: # show progress every 2000 rows
            print("{} rows have been processed".format(idx+1))
        meteodf = getMeteoDataByZoneidTime(puloc, startdt=reqdt, enddt=reqdt)
        meteodf = meteodf.reset_index(drop=True)
        #print(meteodf.info())
        #display(HTML(meteodf.to_html()))
        for col in meteodf.columns:
            df.at[idx, col] = meteodf.at[0, col] if meteodf.shape[0] > 0 else np.nan
        df.at[idx, 'WeatherCondition'] = meteoCoLUT(meteodf.at[0, 'coco']) if meteodf.shape[0] > 0 else 'UNKNOWN'
       
        pugeo_lat, pugeo_lng = queryZoneGeoloc(puloc)
        dogeo_lat, dogeo_lng = queryZoneGeoloc(doloc) 
        df.at[idx, 'puloc_lat'] = pugeo_lat
        df.at[idx, 'puloc_lng'] = pugeo_lng
        df.at[idx, 'doloc_lat'] = dogeo_lat
        df.at[idx, 'doloc_lng'] = dogeo_lng
            
    print(df.info())
    df.drop(df[df.WeatherCondition == "UNKNOWN"].index)
    df.reset_index(drop=True)
    
    # save the merged trip+metro data
    df.to_csv("2023_NYC_High_Volume_FHV_1015-1115_meteo.csv", index=False)
    
    df['request_datetime'] = df['request_datetime'].astype('datetime64[ns]')
    
    for idx, row in df.iterrows():
        df.at[idx, "PeriodOfDay"] = getPeriodOfDay(df.at[idx, "request_datetime"].hour)
        
    #dump the final data
    df.to_csv("2023_NYC_High_Volume_FHV_1015-1115_meteo_cleaned.csv")
    
if __name__ == "__main__":
    main()

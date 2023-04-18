import asyncio
from multiprocessing.connection import wait
from multiprocessing.sharedctypes import Value
from os import environ
from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub import EventData
import csv
from zipfile import ZipFile
from pathlib import Path
import io
import time
import sys

dir  = environ['FARE_DATA_PATH']
ehConnectionString = environ['FARE_EVENTH_HUB_CONNSTR']
ehName = environ['FARE_EVENT_HUB_NAME']

# Ensure Environment Variables are set
if dir is None:
    raise ValueError("Directory Environment Variable not set.")

if ehConnectionString is None:
    raise ValueError("Event Hub Connection String Environment Variable not set.")

if ehName is None:
    raise ValueError("Event Hub Name Environemtn Variable not set.")

#function to get count and list of zip files
def getZipFiles():
    zipCount= 0
    listZIPs = []

    for child in Path(dir).glob('*.zip'):
        listZIPs.append(child)
        zipCount += 1
    
    return zipCount, listZIPs

# Function to get count and list of csv files
def getCSVFiles():
    csvCount=0
    listCSVs = []

    for child in Path(dir).glob('*.csv'):
        listCSVs.append(child)
        csvCount += 1
    
    return csvCount,listCSVs

# Function to unzip files from provided list
def unzipFiles(unzipList):
    for child in unzipList:
        with ZipFile(f"{child}") as zipFilePath:
            zipFilePath.extractall(path=dir)

# Function to send to Event Hubs
async def main(listOfLines):
    # Create a producer client to send messages to the event hub.
    # Specify a connection string to your event hubs namespace and
    # the event hub name.
    producer = EventHubProducerClient.from_connection_string(conn_str=ehConnectionString, eventhub_name=ehName)
    async with producer:
        # Create a batch.
        event_data_batch = await producer.create_batch()

        # Add events to the batch.
        for line in listOfLines:
            event_data_batch.add(EventData(line))
        
        # Send the batch of events to the event hub.
        await producer.send_batch(event_data_batch)

# Unzip files if needed
ctZipFiles, zipFiles = getZipFiles()
ctCsvFiles, csvFiles = getCSVFiles()

if (ctZipFiles != ctCsvFiles):
    unzipFiles(zipFiles)
    ctCsvFiles, csvFiles = getCSVFiles()

# Loop through files and send to Event Hub
for csvFile in csvFiles:
    openFile = io.open(csvFile,'r')
    count = 0
    print(f"Starting {csvFile}")
    lineList = []

    while True:
        count +=1

        line = openFile.readline().strip()

        # I guarantee there's a more elegant way to do this. However, I want to control the number of lines going through and how they are shaped.
        if line.startswith("medallion") == False and line != '':
            splitLine       = line.split(",")
            buildJsonString = "{"
            buildJsonString = f"{buildJsonString}\"medallion\":\"{splitLine[0]}\","
            buildJsonString = f"{buildJsonString}\"hack_license\":\"{splitLine[1]}\","
            buildJsonString = f"{buildJsonString}\"vendor_id\":\"{splitLine[2]}\","
            buildJsonString = f"{buildJsonString}\"pickup_datetime\":\"{splitLine[3]}\","
            buildJsonString = f"{buildJsonString}\"payment_type\":\"{splitLine[4]}\","
            buildJsonString = f"{buildJsonString}\"fare_amount\":\"{splitLine[5]}\","
            buildJsonString = f"{buildJsonString}\"surcharge\":\"{splitLine[6]}\","
            buildJsonString = f"{buildJsonString}\"mta_tax\":\"{splitLine[7]}\","
            buildJsonString = f"{buildJsonString}\"tip_amount\":\"{splitLine[8]}\","
            buildJsonString = f"{buildJsonString}\"tolls_amount\":\"{splitLine[9]}\","
            buildJsonString = f"{buildJsonString}\"total_amount\":\"{splitLine[10]}\""
            buildJsonString = f"{buildJsonString}}}"
            lineList.append(buildJsonString)        

        if count % 3500 == 0:
            try:
                if __name__ == "__main__":
                    try:
                        asyncio.run(
                            main(lineList)
                        )
                    except KeyboardInterrupt:
                        pass
            except Exception as e:
                print(f"Batch {count} in file {csvFile} failed to send to Event Hubs")
                print(e)
            finally:                
                lineList = []
                # time.sleep(1)

        if count % 12000 == 0:
            print(f"{count} lines sent")
            sys.stdout.flush()

        if not line:
            break

    # Send remaining lines to event hubs since not all files will show a remainder of 0 when dividing by 3500
    if count % 3500 != 0:
        try:
            if __name__ == "__main__":
                try:
                    asyncio.run(
                        main(lineList)
                    )
                except KeyboardInterrupt:
                    pass
        except Exception as e:
            print(f"Batch {count} in file {csvFile} failed to send to Event Hubs")
            print(e)
        finally:                
            lineList = []

    openFile.close()
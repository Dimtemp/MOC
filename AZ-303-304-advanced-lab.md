# Azure Architect Advanced Lab

In this lab we're going to try to combine several Azure resources. You will experience how these resources can be connected together.

Build the following resources in this order:
1. Cosmos DB
1. Event Hub Namespace, containing a Event Hub with the name Hub1. CAPTURE???????? ANALYTICS????????
1. Virtual Machine: Windows Server
1. SQL DB
1. Function App
1. Logic App

## Scenario
VM -> Event Hub -> Storage Account -> 
Logic App -> SQL DB
Function App -> Storage account -> Data Factory -> Cosmos DB
Logic App timed trigger -> Blob store -> Data Factory -> ???????
Public REST API -> ADF

## High level steps

### Produce ongoing output for the Event Hub
1. Using you web browser, download the zip file from this location: [DP-200 Source files](https://github.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/archive/master.zip)
1. Log on to the VM using RDP.
1. Minimize the RDP session.
1. Wait for the download to finish. Right click the file and select Copy.
1. Open the RDP session you just minimized, right click the desktop, and select Paste.
1. Extract the zipfile.
1. Using Windows Explorer, navigate to the folder that contains the datagenerator:
1. DP-200-Implementing-an-Azure-Data-Solution/Labfiles/Starter/DP-200.6/DataGenerator
1. At this moment, you might want to create a copy of the **telcodatagen.exe.config** file. Copy it to any other folder.
1. Edit the (original) **telcodatagen.exe.config** file using Notepad.
1. Without changing the file, and leaving Notepad open, minimize the RDP session.
1. Open the Azure Portal and navigate to the Event Hub Namespace.
1. Open the default Shared Access Policy with the name **RootManageSharedAccessKey**.
1. Copy the **Connection string–primary key** to the clipboard.
1. Open the RDP session you just minimized, and return to Notepad.
1. Replace the value of the event hub name: ctoo-phoneanalysis-eh with the actual name of your event hub (Hub1).
1. <add key="EventHubName" value="Hub1"/>
1. Replace the connection string with the actual connection string. Make sure you're replacing the connection string entirely!
1. Open PowerShell and navigate to the Datagenerator folder using this command:
1. ```CD $home```
1. ```CD Desktop\DP-200-Implementing-an-Azure-Data-Solution-master\Labfiles\Starter\DP-200.6\DataGenerator```
1. Run the Data generator application using this command: ```.\telcodatagen.exe 1000 0.1 1```
1. The program now writes data to the Event Hub. There should be no errors.
1. Using the specified parameters, the program will write 1000 events to the eventhub, and it will run for 1 hour.
1. Return to the Azure Portal and inspect the graphs on the Event Hubs service.

### Process data in the Event Hub using a Logic App. Store it in both SQL DB and Cosmos DB.



### Process data in the Event Hub using Data Factory. Store it in both SQL DB and Cosmos DB.
1. In The Azure Portal, open the Data Factory.
1. In the overview pane, click **Author and Monitor**.
1. A separate window will open.
1. 

# Azure Architect Advanced Lab

In this lab we're going to try to combine several Azure resources. You will experience how these resources can be connected together.

Build the following resources in this order:
1. Cosmos DB
1. Event Hub
1. Virtual Machine: Windows Server
1. SQL DB
1. Function App
1. Logic App

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
1. Within the Event Hub Namespace, open the (only) hub.
1. Create a Shared Access Policy with Send permission.
1. Open the Shared Access Policy and copy the **Connection string–primary key** to the clipboard.
1. Open the RDP session you just minimized, and return to Notepad.
    <add key="EventHubName" value="ctoo-phoneanalysis-eh"/>

### Process data in the Event Hub using Data Factory. Store it in both SQL DB and Cosmos DB.



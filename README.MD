## Repo Descripiton
___

This Repo is meant to detail the steps to use Azure Data Factory, Azure Data Explorer, Azure Databricks, and Azure Databricks to create an Architecture that supports both Batch and Streaming use cases in a user-friendly environment. 

## Pre-Requisites
___
1) A sandbox Resource Group in Azure with Contributor Access for all users deploying and using the Proof of Concept.
2) Unity Catalog (and Access Connector) set up for use in Azure Databricks.
3) The necessary resource providers for the Data Factory, Event Hubs, Key Vault, and Kusto.

## Acronyms
____
__ADF:__ Azure Data Factory

__ADX:__ Azure Data Explorer

__VM:__ Virtual Machine

__ADLS:__ Azure Data Lake Storage
   
## Steps
___
1) __VSCode:__ [Deploy Resources](./docs/bicep/deploy.md)
2) __Logic Apps:__ [Manage Azure Bastion with Logic Apps](./docs/logicapps/setUpBastionLogicApps.md)
3) __VM:__ Create Self Hosted Integration Runtime service.
4) __VM:__ [Set up Docker container for Streaming dataset from SHIR server](./docs/shirvm/streamingSetUp.md)
5) __ADF:__ Set up Linked Services and Copy Pipelines in Azure Data Factory
6) __ADX:__ Set up Ingestion Streams
7) __ADX:__ Set up Continuous Export to ADLS
8) __Databricks:__ Set up connection to Raw storage in Azure Databricks Unity Catalog
9) __Databricks:__ Create a notebook to bring data to the Bronze layer
10) __Databricks:__ Create SQL Scripts to bring data through the Silver and Gold layers
11) __Databricks:__ Create a Workflow to Automate Medallion load
12) 
## Repo Descripiton

This Repo is meant to detail the steps to use Azure Data Factory, Azure Data Explorer, Azure Databricks, and Azure Databricks to create an Architecture that supports both Batch and Streaming use cases in a user-friendly environment. 

## Pre-Requisites
1) A sandbox Resource Group in Azure with Contributor Access for all users deploying and using the Proof of Concept.
2) Unity Catalog (and Access Connector) set up for use in Azure Databricks.
3) The necessary resource providers for the Data Factory, Event Hubs, Key Vault, and Kusto.
   
## Steps
1) Deploy Resources using Visual Studio Code
2) Deploy Bastion using Logic App
3) Set up Self Hosted Integration Runtime and Streaming Server
4) 
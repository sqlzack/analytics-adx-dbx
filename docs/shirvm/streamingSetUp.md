## Install Ubuntu in Windows Subsystem for Linux
1) Open command line by going to the Start Menu>Run>cmd
2) Install WSL
```
wsl --install
```
1) Reboot server. You can stay connected to Bastion and wait for it to come back up.
```
shutdown -r
```
1) After restarting, wait for Ubuntu to install.
2) Set your username and password for Linux. Once you've done this you should be able to open up Ubuntu from the Start Menu

## Download Sample File

1) In Ubuntu, create a storage location for raw files.
```
mkdir /mnt/c/rawfiles/faredata
```
2) Run the below command to download the sample NYC Taxi Data file.
```
wget https://raw.githubusercontent.com/sqlzack/eh-adx-adls-analytics/main/data/sample.csv -O /mnt/c/rawfiles/faredata/sample.csv
```
3) 

## Install Docker and Pull Image
1) In the Ubuntu prompt, upgrade package lists by running the below command.
```
sudo apt-get update
```
2) Run the below command to install Docker
```
sudo apt-get install docker
```
3) 
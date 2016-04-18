# Airbox Taipei map
(Chinese version will be here later)
Thanks for open data from Taipei, we can understand our city better !
Using python to download, decompress the .gz file from data.taipei and draw them on the map using GMT 5.2.1 .

The Digital Elevation model provided here is from ASTER GDEM project. You can download the data from Acdemia Sinica for merged version of Taiwan(1) or the project website(2) to get global GDEM data.

===== Requirement software =====
* Python 3
* Generic Mapping Tool 5.2.1 (availible in (3) )
* Internet connection
===== How to use =====
In terminal, execute "Airbox_Taipei_map.sh".

eg.
$sh Airbox_Taipei_map.sh

The script should download, process and draw the data and map automatically.

===== Tested environment =====
* Python version : 3.5.1 (v3.5.1:37a07cee5969, Dec  5 2015, 21:12:44) 
* GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin15)
* Generic Mapping Tool : 5.2.1 

===== Work to do in the future =====
* Find high resolution DEM of Taiwan
* Collect other government open data (like http://data.gov.tw/node/6074)
 
===== Issue =====
Refer to g0v pm2.5 map website (4), the Airbox PM2.5 data from Taipei government open data seems be different from the 

===== Links =====
(1) Taiwan GDEM data from AC, Taiwan : http://gis.rchss.sinica.edu.tw/qgis/?p=1619
(2) ASTER GDEM project website : https://asterweb.jpl.nasa.gov/gdem.asp
(3) Generic Mapping Tool : http://gmt.soest.hawaii.edu/projects/gmt/wiki/Download
(4) g0v pm2.5 map website, merged many makers' projects and covernment open data : http://g0vairmap.3203.info/map.html

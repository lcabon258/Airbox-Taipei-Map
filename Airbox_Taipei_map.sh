#Taipei pm25 map
#Original code : lcabon258 @ github 2016.04
ps=Taipei_pm25.ps
taipei=./dem/aster_taipei.nc
range=121.43485/121.684087/24.957789/25.159322
cpt=pm25.cpt
pm25data=./AirboxDATA_GPS.txt
taipei_dist=Taipei_Districts.txt

#===== run python3 script =====
python3 AirboxDataParserPy3k.py
#===== set time stamp (will plot on the title) =====
timestamp=$(head -n1 AirboxDATA_GPS.txt | awk '{print $4,$5}' )

#===== gmt code starts here =====
gmt gmtset PS_CHAR_ENCODING Standard+ FORMAT_GEO_MAP ddd.xxG
#===== display information of gridfile =====
gmt grdinfo $taipei -V > $taipei.info
echo "===== information of $taipei ====="
cat $taipei.info
echo "----------------------------------"
#===== make intensity file (DEM) =====
gmt grdgradient $taipei -Ne0.7 -A250/330 -G$taipei.int
#===== construct basemap =====
gmt psbasemap -R$range -JM17c -Bxa0.05f0.01 -Bya0.05f0.01 -BNESW+t"PM2.5 map of Taipei $timestamp" -Tdx15c/11.7c+w3.5c+f2+l" "," "," ",n -UBL/0c/-1.5c/"PM2.5 : Airbox Taipei open data ; DEM : ASTER GDEM v2 ; code : lcabon258 @@github" -X2c -Y10c -K -P -V > $ps
#===== pre-process : using block-mean =====
awk '{print $1,$2,$3}' $pm25data | gmt blockmean -R$taipei -I2k > pm25.2km.tmp
#===== surface : convert xyz data to grd file =====
gmt surface pm25.2km.tmp -R$taipei -Gpm25now.nc.tmp -V
#===== Draw the color on the map =====
gmt grdimage pm25now.nc.tmp -R$range -JM -I$taipei.int -Cpm25.cpt -O -K -P -V >> $ps
#===== Plot position of sensor ===== 
awk '{print $1,$2,$3}' $pm25data | gmt psxy -R$range -J -Sc5p -Cpm25.cpt -W1p,black,solid -O -K -P -V >> $ps 
echo 121.65 24.94 45 | gmt psxy -R$range -J -Sc5p -Cpm25.cpt -W1p,black,solid -N -O -K -P -V >> $ps 
#===== Plot Districts of Taipei =====
awk '{print $1,$2,$3}' $taipei_dist | gmt pstext -R$range -J -F+jMC+f9.5p,Helvetica-Bold,white -O -K -P -V >> $ps
echo 121.656 24.94 "Airbox sensor" | gmt pstext -R$range -J -F+jML+f9p,Helvetica-Bold,black -N -O -K -P -V >> $ps
#===== Draw scale bar of PM2.5 =====
gmt psscale -R -Cpm25.cpt -Dx0c/-2c+w17c/0.5c+jML+ef+h -Bxa10f5+l"PM2.5 (\225g/m3)" -O -P -V >>$ps
#===== Convert postscript file to jpeg =====
gmt psconvert $ps -E400 -Tj -A0.5i -V

#===== remove files =====
rm $taipei.int
rm ./*.tmp
rm ./AirBoxData
rm ./AirBoxDevice
rm ./gmt.*

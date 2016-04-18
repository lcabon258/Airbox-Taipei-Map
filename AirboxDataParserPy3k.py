import io,sys,json,csv,gzip,urllib.request as urq
##Taipei pm25 map
#Original code : lcabon258 @ github 2016.04
# open data : http://data.taipei/opendata/datalist/datasetMeta?oid=4ba06157-3854-4111-9383-3b8a188c962a
def build_Device_info():
    print("build_Device_info")
    with io.open("AirBoxDevice","rt") as infile :
        with io.open("AirboxID_GPS.csv","wt") as outfile:
            line = infile.readline()
            deviceinfo = json.loads(line)
            devices = deviceinfo["entries"]
            outfile.write("device_id,gps,device\n")
            for i in range(len(devices)):
                tmplist=[]
                tmplist.append(str(devices[i]["device_id"]))
                tmplist.append(str(devices[i]["gps_lon"])+" "+str(devices[i]["gps_lat"]))
                tmplist.append(str(devices[i]["device"]))
                #tmplist.append()
                tmplist.append("\n")
                outfile.write(",".join(tmplist))
                sys.stdout.write("*")
    sys.stdout.write("\n")
    print("[OK] Built information of Airbox devices" )

def zip_Data_Location():
    print("Pairing data with device...")
    with io.open("AirBoxData","rt") as infile :
        with io.open("AirboxID_GPS.csv","rt") as ref:
            refREADER = csv.DictReader(ref)
            refList= [row for row in refREADER]  #[DeviceID,GPSLat Lon,device]
            with io.open("AirboxDATA_GPS.txt","wt") as outfile:
                line = infile.readline()
                deviceinfo = json.loads(line)
                devicesDATA = deviceinfo["entries"]
                used_station=[]
                for data in reversed(devicesDATA):
                    #sys.stdout.write(".") 
                    for ref_item in refList:
                        if data["device_id"] == ref_item["device_id"] and data["device_id"] not in used_station:
                            used_station.append(data["device_id"])
                            tmp = []
                            tmp.append(str(ref_item["gps"]))
                            tmp.append(str(data["s_t0"])) #pm2.5
                            tmp.append(str(data["time"]))
                            tmp.append(str(ref_item["device_id"]))
                            tmp.append(str(ref_item["device"]))
                            tmp.append("\n")
                            outfile.write(" ".join(tmp))
                            sys.stdout.write("+")
    sys.stdout.write("\n")
    print("[OK]Paired complete.")
def download_data():
    dataurl=r"https://tpairbox.blob.core.windows.net/blobfs/AirBoxData.gz"
    print("downloading data from http://data.taipei/")
    response = urq.urlopen(dataurl)
    print("decompressing the gzip file")
    with io.open("AirBoxData","wb") as out:
        out.write(gzip.decompress(response.read()))
 
def download_device_info():       
    deviceurl=r"https://tpairbox.blob.core.windows.net/blobfs/AirBoxDevice.gz"
    print("downloading data from http://data.taipei/")
    response = urq.urlopen(deviceurl)
    print("decompressing the gzip file")
    with io.open("AirBoxDevice","wb") as out:
        out.write(gzip.decompress(response.read()))
                            
                          
                    
                            
def find_unique_value():
    pass
if __name__ == "__main__":
    download_device_info()
    build_Device_info()
    download_data()
    zip_Data_Location()

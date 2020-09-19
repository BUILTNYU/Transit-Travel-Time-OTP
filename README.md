# Transit-Travel-Time-OTP
Query transit travel times through OTP API in R

This guide derives from the tutorial of Marcus Young. Details can be found in https://github.com/marcusyoung/otp-tutorial.git. 

In this guide, the "Utah-example.R" file is the R code to query transit travel times, "ODflows_coord_service_region_Utah.csv" is the coordiantes of origin/destination, "transit_TT.csv" is the output. GTFS and OSM data are saved in "~/graph/current".

1. Download the files from Github and unzip them. Make sure you installed Java Development Kit (JDK) on the local computer. 

2. Download OSM road network and GTFS of the research area and save in "~/graph/current" folder. The OSM data needs to be in .pbf format and GTFS data needs to be in .zip format. Here we used OSM and GTFS of Salt Lake City in Utah as an example.

3. Go to the root folder (the folder saved otp.jar) in the command line.

4. Run java -Xmx2G -jar otp.jar --build graphs/current to set up local graph. "-Xmx2G" is allocating RAM to set up the graph. It's better to allocate large RAM if you are working on a large road network.

5. Run java -Xmx2G -jar otp.jar --router current --graphs graphs --server to start up the OTP server on local computer. Remember to allocate enough RAM for the server, too.

6. You can access the web interface by URL: http://localhost:8080 in the web browser. To query travel times for a set of OD pairs, please open the Utah-example.R file in the root folder.

7. Install packages "progress" and "otpr". Remember to update R into the latest version.

8. Read the coordinates of ODs from the csv file. Here we use the centroids of the census tract in Salt Lake City as the ODs. Replace the "ODflows_coord_service_region_Utah.csv" with your own ODs (Keep the column names the same).

9. Run R code and output transit travel times to "transit_TT.csv".


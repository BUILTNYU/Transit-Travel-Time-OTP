# Accompanying code for Part 3 of OTP Tutorial

# install and load progress bar package
# install.packages("progress")
library(progress)

# Import LSO centroids CSV file
gm_lsoa_centroids <- read.csv("ODflows_coord_service_region_Utah.csv", stringsAsFactors = FALSE)

# Install the otpr package
# install.packages("otpr")

# Now load the package
library(otpr)

# Call otpConnect() to define a connection called otpcon
otpcon <-
  otp_connect(
    hostname = "localhost",
    router = "current",
    port = 8080,
    ssl = FALSE
  )

# As most of the default values of the function arguments are fine for us, we
# could also use:
# otpcon <- otp_connect(router = "current")

# Call otp_get_times to get attributes of an itinerary
otp_get_times(
  otpcon,
  fromPlace = c(53.43329,-2.13357),
  toPlace =   c(53.36274,-2.27293),
  mode = 'TRANSIT',
  detail = TRUE,
  date = '04-28-2020',
  time = '08:00:00',
  maxWalkDistance = 1600,
  walkReluctance = 5,
  minTransferTime = 600
)

total <- nrow(gm_lsoa_centroids) # set number of records
pb <- progress_bar$new(total = total, format = "(:spin)[:bar]:percent") #progress bar

# Begin the loop  
for (i in 1:(total)) {
  pb$tick()   # update progress bar
  response <-
    otp_get_times(
      otpcon,
      fromPlace = c(gm_lsoa_centroids[i, ]$Y_Org , gm_lsoa_centroids[i, ]$X_Org),
      toPlace =  c(gm_lsoa_centroids[i, ]$Y_Dest , gm_lsoa_centroids[i, ]$X_Dest),
      mode = 'TRANSIT',
      detail = TRUE,
      date = '09-04-2020',
      time = '08:00:00',
      maxWalkDistance = 16000, # allows 800m at both ends of journey
      walkReluctance = 5,
      minTransferTime = 600,
    )
  # If response is OK update dataframe
  if (response$errorId == "OK") {
    gm_lsoa_centroids[i, "status"] <- response$errorId
    gm_lsoa_centroids[i, "in-vehicleTime"] <- response$itineraries$transitTime
    gm_lsoa_centroids[i, "waitingTime"] <- response$itineraries$waitingTime
    gm_lsoa_centroids[i, "transfers"] <-response$itineraries$transfers
    gm_lsoa_centroids[i, "accessTime"] <- response$itineraries$walkTime
  } else {
    # record error
    gm_lsoa_centroids[i, "status"] <- response$errorId
  }
}

# Export gm_lsoa_centroids df
write.csv(gm_lsoa_centroids, file="transit_TT.csv")

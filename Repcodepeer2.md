# Reproducible Research Project 2 - NOAA Storm damage database
Tom B  
Sunday, October 25, 2015  

## Executive Summary

This analysis summarises the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database, which tracks characteristics of major storms and weather events in the United States between 1950 and 2011, including records of fatalities, injuries, and property damage.

These data show that while tornadoes are the most harmful US weather event with respect to direct impact on population health (deaths and injuries), A greater economic impact has been caused by floods and related events. 

Note that in major cases of loss, categorisation of the loss may be ambiguous - the majority of major flooding will have been caused by a particular storm.  

However the weather events of particular concern vary by state and prioritisation of resources will vary accordingly.

## Data Processing

The data file contains details of over 900,000 weather events between 1950 and 2011, with the majority of data being recorded in recent years as reporting standards improved over time. Individual records show time, location, estimated fatalities and injuries, brief categorisation of the loss, damage to property and crops, and (ususally for the more significant events have substantial narrative detail. The original data file can be downloaded from https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv .
These data have been processed as follows:

- After examination of the records detailing the most significant losses, property damage loss for the flooding recorded in the Napa Valley in 2006 has been corrected from $115 Billion to $115 Million.  This is consistent with the recorded narrative details of the event (and with wider media).
 - The original data file contains over 900 differing categorisations of weather events, some of which are very similar in nature.  These have been grouped together in the following largely self explanatory categories:
 
FLOODING  
TORNADO	 
STORM	  
HAIL	 (the most numerous single category recorded)

COASTAL	  (including events specifically reflecting damage from high seas and similar)

HOT/DRY	 (including fire damage)

WIND	  
WINTRY	  (snow, blizzard, etc but specifically excluding avalanches)

LANDSLIDE	    
FOG	      
AVALANCHE	    
MISC (miscellaneous)	        
VOLCANO

Code used for data processing and results production is included below.


```r
# download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2","CloudfrontData.csv")
 CloudfrontData <- read.csv("~/R/CloudfrontData.csv")

library(plyr)
```

```
## Warning: package 'plyr' was built under R version 3.1.2
```

```r
options(warn=-1)
CloudfrontData[605953,26]="m"
# table(CloudfrontData$PROPDMGEXP) tells us how this is encoded - cleaned by changing the exponents into numerical form;
CloudfrontData$CPROPEXP = 0
CloudfrontData[CloudfrontData$PROPDMGEXP =="K",]$CPROPEXP=3
CloudfrontData[CloudfrontData$PROPDMGEXP =="M",]$CPROPEXP=6
CloudfrontData[CloudfrontData$PROPDMGEXP =="m",]$CPROPEXP=6
CloudfrontData[CloudfrontData$PROPDMGEXP =="B",]$CPROPEXP=9
# then calculate a numerical value...
CloudfrontData$PROPD=CloudfrontData$PROPDMG*10^CloudfrontData$CPROPEXP
# ... and do the same for crop damage.
CloudfrontData$CCROPEXP = 0
CloudfrontData[CloudfrontData$CROPDMGEXP =="K",]$CCROPEXP=3
CloudfrontData[CloudfrontData$CROPDMGEXP =="k",]$CCROPEXP=3
CloudfrontData[CloudfrontData$CROPDMGEXP =="M",]$CCROPEXP=6
CloudfrontData[CloudfrontData$CROPDMGEXP =="m",]$CCROPEXP=6
CloudfrontData[CloudfrontData$CROPDMGEXP =="B",]$CCROPEXP=9

CloudfrontData$CROPD=CloudfrontData$CROPDMG*10^CloudfrontData$CCROPEXP
CloudfrontData$TOTD=CloudfrontData$CROPD+CloudfrontData$PROPD

# over 900 different categorisations of weather event type.  Summarised by looking for particular strings in the description data...

CloudfrontData$TYPE="MISC"

CloudfrontData[grep("FUNNEL",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("TSTM",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("THUNDER",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("TROPICAL",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("THUNDER",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("LIGHTNING",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("STORM",CloudfrontData$EVTYPE),]$TYPE="STORM"
CloudfrontData[grep("HURRICANE",CloudfrontData$EVTYPE),]$TYPE="STORM"

CloudfrontData[grep("RAIN",CloudfrontData$EVTYPE),]$TYPE="FLOODING"
CloudfrontData[grep("FLOOD",CloudfrontData$EVTYPE),]$TYPE="FLOODING"
CloudfrontData[grep("FLD",CloudfrontData$EVTYPE),]$TYPE="FLOODING"

CloudfrontData[grep("WARM",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"
CloudfrontData[grep("HEAT",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"
CloudfrontData[grep("DROUGHT",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"
CloudfrontData[grep("FIRE",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"
CloudfrontData[grep("DRY",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"
CloudfrontData[grep("HIGH TEMP",CloudfrontData$EVTYPE),]$TYPE="HOT/DRY"

CloudfrontData[grep("WIND",CloudfrontData$EVTYPE),]$TYPE="WIND"

CloudfrontData[grep("FREEZ",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("COLD",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("BLIZZ",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("WINT",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("SNOW",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("ICE",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("LOW TEMP",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("HYPOTHER",CloudfrontData$EVTYPE),]$TYPE="WINTRY"
CloudfrontData[grep("Hypother",CloudfrontData$EVTYPE),]$TYPE="WINTRY"

CloudfrontData[grep("VOLCA",CloudfrontData$EVTYPE),]$TYPE="VOLCANO"

CloudfrontData[grep("HAIL",CloudfrontData$EVTYPE),]$TYPE="HAIL"
CloudfrontData[grep("FOG",CloudfrontData$EVTYPE),]$TYPE="FOG"

CloudfrontData[grep("COASTAL",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("MARINE",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("TIDE",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("TSUNA",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("SURF",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("WATERSPOUT",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("CURRENT",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("ROUGH",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep("SURGE",CloudfrontData$EVTYPE),]$TYPE="COASTAL"
CloudfrontData[grep(" SEAS",CloudfrontData$EVTYPE),]$TYPE="COASTAL"

CloudfrontData[grep("TORNAD",CloudfrontData$EVTYPE),]$TYPE="TORNADO"

CloudfrontData[grep("SLIDE",CloudfrontData$EVTYPE),]$TYPE="LANDSLIDE"
CloudfrontData[grep("slide",CloudfrontData$EVTYPE),]$TYPE="LANDSLIDE"

CloudfrontData[grep("AVALAN",CloudfrontData$EVTYPE),]$TYPE="AVALANCHE"
```

## Results

### Summary of fatalities by cause



```r
# calculate sort and chart total deaths by TYPE of event
Fatalities = ddply (CloudfrontData, "TYPE", summarise, sum = sum (FATALITIES)) 
colnames(Fatalities)<-c("Type","Fatalities")
Injuries = ddply (CloudfrontData, "TYPE", summarise, sum = sum (INJURIES)) 
colnames(Injuries)<-c("Type","Injuries")
DeathInjuries = merge (Fatalities,Injuries, by = "Type")
DeathInjuries = merge (Fatalities,Injuries, by = "Type")
DeathInjuries = DeathInjuries[order(-1*DeathInjuries$Fatalities),]

par(las=2)
 barplot(DeathInjuries[,2],names.arg=DeathInjuries[,1], main = "Total recorded fatalities by cause")
```

![](Repcodepeer2_files/figure-html/unnamed-chunk-2-1.png) 

### Summary of total economic damage by cause


```r
# calculate sort and chart total economic cost by TYPE of event
Cost = ddply(CloudfrontData, "TYPE", summarise, sum = sum (TOTD)) 
colnames(Cost)<-c("Type","Total_Damage_Cost")
Cost = Cost[order(-1*Cost$Total_Damage_Cost),]
 barplot(Cost[,2],names.arg=Cost[,1], main = "Total recorded economic damage by cause")
```

![](Repcodepeer2_files/figure-html/unnamed-chunk-3-1.png) 

(These figures have not been adjusted for inflation.)

### Statewide summary

The tabulated output below shows the state codes attached to the data - some of these presumably relating to multiple states - and the top cause of death recorded for that state.  As can be seen, this varies from state to state - the top cause of weather related fatalities in Alaska is avalanches, a minor issue on a national scale. 


```r
#extract a list of state codes in the data
states = table(CloudfrontData$STATE)
  
# for each state code, calculate total fatalities by TYPE and return the highest cause 
for (k in rownames(states))
    {
    Fatalities = ddply (CloudfrontData[CloudfrontData$STATE==k,], "TYPE", summarise, sum = sum (FATALITIES))
    colnames(Fatalities)<-c("Type","d")
    Table = Fatalities[order(-1*Fatalities$d),]
    print (c( k, Table [1,1]))}
```

```
## [1] "AK"        "AVALANCHE"
## [1] "AL"      "TORNADO"
## [1] "AM"      "COASTAL"
## [1] "AN"      "COASTAL"
## [1] "AR"      "TORNADO"
## [1] "AS"      "COASTAL"
## [1] "AZ"       "FLOODING"
## [1] "CA"      "HOT/DRY"
## [1] "CO"        "AVALANCHE"
## [1] "CT"   "WIND"
## [1] "DC"      "HOT/DRY"
## [1] "DE"      "HOT/DRY"
## [1] "FL"      "COASTAL"
## [1] "GA"      "TORNADO"
## [1] "GM"      "COASTAL"
## [1] "GU"      "COASTAL"
## [1] "HI"      "COASTAL"
## [1] "IA"      "TORNADO"
## [1] "ID"        "AVALANCHE"
## [1] "IL"      "HOT/DRY"
## [1] "IN"      "TORNADO"
## [1] "KS"      "TORNADO"
## [1] "KY"      "TORNADO"
## [1] "LA"      "TORNADO"
## [1] "LC"      "COASTAL"
## [1] "LE"      "COASTAL"
## [1] "LH"      "COASTAL"
## [1] "LM"      "COASTAL"
## [1] "LO"      "COASTAL"
## [1] "LS"      "COASTAL"
## [1] "MA"      "TORNADO"
## [1] "MD"      "HOT/DRY"
## [1] "ME"    "STORM"
## [1] "MH"      "COASTAL"
## [1] "MI"      "TORNADO"
## [1] "MN"      "TORNADO"
## [1] "MO"      "TORNADO"
## [1] "MS"      "TORNADO"
## [1] "MT"     "WINTRY"
## [1] "NC"      "TORNADO"
## [1] "ND"      "TORNADO"
## [1] "NE"      "TORNADO"
## [1] "NH"   "WIND"
## [1] "NJ"      "HOT/DRY"
## [1] "NM"     "WINTRY"
## [1] "NV"      "HOT/DRY"
## [1] "NY"      "HOT/DRY"
## [1] "OH"      "TORNADO"
## [1] "OK"      "TORNADO"
## [1] "OR"   "WIND"
## [1] "PA"      "HOT/DRY"
## [1] "PH"      "COASTAL"
## [1] "PK"      "COASTAL"
## [1] "PM"      "COASTAL"
## [1] "PR"       "FLOODING"
## [1] "PZ"      "COASTAL"
## [1] "RI"      "COASTAL"
## [1] "SC"      "TORNADO"
## [1] "SD"     "WINTRY"
## [1] "SL"      "COASTAL"
## [1] "ST"   "WIND"
## [1] "TN"      "TORNADO"
## [1] "TX"      "TORNADO"
## [1] "UT"        "AVALANCHE"
## [1] "VA"       "FLOODING"
## [1] "VI"      "COASTAL"
## [1] "VT"       "FLOODING"
## [1] "WA"   "WIND"
## [1] "WI"      "HOT/DRY"
## [1] "WV"       "FLOODING"
## [1] "WY"        "AVALANCHE"
## [1] "XX"      "COASTAL"
```
 



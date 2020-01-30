#Data manipulation with Dplyr package
require(plyr)
require(dplyr)
#For demonstration we will use the data hflights from hflights pkg
install.packages("hflights")
require(hflights)
head(data("hflights"))
Mydata<-tbl_df(hflights)#Convert the data into normal local df
Mydata[5,]
help("dplyr")
attach(Mydata)
#We can subset our data using filter command in dplyr as follow
names(Mydata)
Sub1<-filter(Mydata,DayofMonth==1&Month==1)
head(Sub1)
Sub2<-filter(Mydata,Year==2011,UniqueCarrier=="AA"&ActualElapsedTime<100)
head(Sub2)

###Chaining method using %>% (Read as "then") to simplify redability
#Example 
x1<-c(2,4,6,8)
x2<-c(9,6,2,1)
distance1<-sqrt(sum((x1-x2)^2))
distance1

#We can do the same using %>% as follows
distance2<-(x1-x2)^2 %>% sum() %>% sqrt()
distance2

#Uses of chaining method (%>%) with dplyr when providing multiple conditions to your codes
Sub3<-Mydata %>%
  select(Year,DepTime)%>%
  filter(UniqueCarrier=="AA"&ActualElapsedTime<70)
head(Sub3)
 
#Use of arrange command in dply
#When we select and sort rows in our data frame we can write basic R codes as
Mydata[order(DepDelay),c("UniqueCarrier","Year")]

##Using dplyr we can write the above as
Sub4<-Mydata%>%
  select(UniqueCarrier,Year)%>%
  arrange(DepDelay)
Sub4
#Adding new variable to a data frame in base R we can write as 
Mydata$speed<-(Distance/AirTime)*60
#Select the three columns in base R
Sub5<-Mydata[,c("Distance","AirTime","speed")]
Sub5
#Using the dplyr package we can do the same as
Sub7<-Mydata %>%
  select(Distance,AirTime) %>%
  mutate(speed=(Distance/AirTime)*60)
Sub7

#The above codes did not add speed toa data frame. To add it using mutate command consider
Mydata<-Mydata %>%
  mutate(speed=(Distance/AirTime)*60)

#To calculate average delay by destination using base R we can either use
Sub8<-with(Mydata, tapply(ArrDelay,Dest, mean,na.rm=TRUE))#Using with commad
Sub9<-aggregate(ArrDelay~Dest,Mydata,mean)#Using Aggregate command
Sub8
Sub9

#Using dplyr package (We apply summarize command)
Mydata %>%
  group_by(Dest) %>%
  summarise(Avg_del=mean(ArrDelay,na.rm = TRUE))

#More example
head(with(Mydata,tapply(ArrDelay,Dest,mean,na.rm=TRUE)))
head(aggregate(ArrDelay~Dest,Mydata,mean))

T1<-Mydata %>%
  select(ArrDelay,Dest) %>%
  summarise(Avgd=mean(ArrDelay,na.rm = TRUE))
head(T1)
T1

#Summarize each and Mutate each comands in dplyr
#Lets summarize mean cancelled and diverted flights for each carrier
T2<-Mydata%>%
  group_by(UniqueCarrier)%>%
  summarise_each(funs(mean),Cancelled,Diverted)
T2

#We can obtain Maximum and minimum departure and arrival delays for each carrier

Mydata%>%
  group_by(UniqueCarrier)%>%
  summarise_each(funs(min(.,na.rm = TRUE),max(.,na.rm = TRUE)),matches("Delay"))
 #If we want to count number of flight on each day of a year and arrange them in increasing order
T4<-Mydata %>%
  dplyr::group_by(Month, DayofMonth)%>%
  dplyr::summarise(Flight_Counts=n())%>%
  dplyr::arrange(desc(Flight_Counts))
T4

#Tally function can also do the same job
T5<-Mydata %>%
  group_by(Month, DayofMonth) %>%
  tally(sort = TRUE)
T5

#For each destination to find the number of cancelled flights
Mydata %>%
  group_by(Dest) %>%
  select(Cancelled) %>%
  table() %>%
  head()

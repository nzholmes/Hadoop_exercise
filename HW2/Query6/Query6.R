Sys.setenv(HADOOP_HOME="/usr/share/hadoop/hadoop-1.2.1") 

Sys.setenv(HADOOP_CMD="/usr/share/hadoop/bin/hadoop")

Sys.setenv(HADOOP_STREAMING="/usr/share/hadoop/contrib/streaming/hadoop-streaming-1.2.1.jar") 

Sys.setenv(JAVA_HOME="/usr/local/java/jdk1.7.0_45") 

library("rmr2")
library("rhdfs")
hdfs.init()

query6 = function(input, output = NULL){
  query6.map = function(., lines) {
    t = unlist(strsplit( x = lines,split = ","))
    keyval(t[seq(4,length(t),5)],1)
    
  }
  query6.reduce =function(word, counts ) {
    keyval(word, sum(counts))
  }         
  mapreduce(input = input ,output = output, input.format = "text", map = query6.map, reduce = query6.reduce,combine = T)
}

inputPath = '/user/hadoop/input/Customers.txt'
outputPath = '/user/hadoop/output/hw2_query6_6'

query6(inputPath, outputPath)

## Get Results from HDFS
results <- from.dfs(outputPath)
from.dfs(outputPath)

## Decompose the key and value columns
x <- results$key
y <- as.integer(results$val)

## Plot the values
barplot(y, main="Customer count", xlab="CountryCode", ylab="count", names.arg=x)

## Sort the values and Plot them
t = cbind(x,y)
tt = t[order(t[,2]),]

barplot(as.integer(tt[,2]), main="Sorted Customer count", xlab="CountryCode", ylab="count", names.arg=tt[,1], col="blue")
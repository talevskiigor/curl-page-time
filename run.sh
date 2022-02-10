#!/bin/bash
INPUT=input.csv
DATE=$(date +"%Y-%m-%d %T")
OUTPUT=${DATE//':'/''}
OUTPUT=${OUTPUT//'-'/''}
OUTPUT=${OUTPUT//' '/'-'}".csv"
HEADER="date,domain,visits,http_code,time_namelookup,time_connect,time_appconnect,time_pretransfer,time_total,timestamp"
echo $HEADER > $OUTPUT
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read domain visits
do
    # responseTime=$(curl -s -w %{time_total}\\n -o /dev/null "$domain")
	# echo "Domain : $domain Visits : $visits Time: $responseTime"
    # echo $OUTPUT
    TIMESTAMP=$(date +"%Y-%m-%d %T")
    x=$(curl -L --output /dev/null --silent --show-error  --write-out \
    '%{http_code};%{time_namelookup};%{time_connect};%{time_appconnect};%{time_pretransfer};%{time_total}'\
     "$domain")
    LINE="$DATE;$domain;$visits;$x;$TIMESTAMP"
    echo $LINE >> $OUTPUT

    echo $LINE

done < $INPUT
IFS=$OLDIFS
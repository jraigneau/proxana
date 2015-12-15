#!/bin/bash

COOKIEJAR=$(mktemp)
trap 'unlink ${COOKIEJAR}' EXIT

#Setup Grafana
function setup_grafana_session {
  if ! curl -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary '{"user":"superman","email":"","password":"paint"}' \
    --cookie-jar "$COOKIEJAR" \
    'http://picasso:3000/login' > /dev/null 2>&1 ; then
    echo
    error "Grafana Session: Couldn't store cookies at ${COOKIEJAR}"
  fi
}

#Get and save graphs
function get_graph {
    DASHBOARD=$1
    ID=$2
    DATE_FROM=$3
    DATE_TO=$4
    FILE="dashboard/graphs/$5"
    WIDTH=$6
    HEIGHT=$7
    echo "Creating graph for $FILE"
    curl --silent --cookie "$COOKIEJAR" "http://picasso:3000/render/dashboard-solo/db/$DASHBOARD?from=$DATE_FROM&to=$DATE_TO&panelId=$ID&fullscreen&width=$WIDTH&height=$HEIGHT" > $FILE

}

setup_grafana_session

DATE_TO=$(($(date +%s)*1000)) # Milliseconds
DATE_FROM_1H=$(( $DATE_TO - 3600000 )) # now - 1H
DATE_FROM_24H=$(( $DATE_TO - 3600000*24 )) #now -24H
DATE_FROM_7D=$(( $DATE_TO - 3600000*24*7 )) #now - 7days
DATE_FROM_30D=$(( $DATE_TO - 3600000*24*30 )) #now - 30days
DATE_FROM_12M=$(( $DATE_TO - 3600000*24*365 )) #now - 365days

#Define your graph

#Température
get_graph "temperature" "2" $DATE_FROM_24H $DATE_TO "temperature-Igny.png" "300" "250"
get_graph "temperature" "1" $DATE_FROM_24H $DATE_TO "temperature-Bureau.png" "300" "250"
get_graph "temperature" "3" $DATE_FROM_24H $DATE_TO "temperature-Salon.png" "300" "250"
get_graph "temperature" "4" $DATE_FROM_24H $DATE_TO "temperature-Agathe.png" "300" "250"
get_graph "temperature" "5" $DATE_FROM_24H $DATE_TO "temperature-Maxime.png" "300" "250"
get_graph "temperature" "6" $DATE_FROM_24H $DATE_TO "temperature-Parents.png" "300" "250"
get_graph "temperature" "12" $DATE_FROM_24H $DATE_TO "temperature-Amis.png" "300" "250"
get_graph "temperature" "7" $DATE_FROM_24H $DATE_TO "temperature-Datacenter.png" "300" "250"
get_graph "temperature" "13" $DATE_FROM_24H $DATE_TO "temperature-Cuisine.png" "300" "250"
get_graph "temperature" "14" $DATE_FROM_24H $DATE_TO "temperature-Douche.png" "300" "250"

get_graph "temperature" "8" $DATE_FROM_24H $DATE_TO "temperature-24H.png" "700" "250"
get_graph "temperature" "15" $DATE_FROM_30D $DATE_TO "temperature-30D.png" "700" "250"
get_graph "temperature" "16" $DATE_FROM_12M $DATE_TO "temperature-12M.png" "700" "250"
get_graph "temperature" "11" $DATE_FROM_7D $DATE_TO "temperature-datacenter-7D.png" "700" "250"

#Electricite
get_graph "electricite" "3" $DATE_FROM_24H $DATE_TO "electricite-Instant.png" "400" "250"
get_graph "electricite" "4" $DATE_FROM_24H $DATE_TO "electricite-Cumul.png" "400" "250"

get_graph "electricite" "1" $DATE_FROM_7D $DATE_TO "electricite-Instant-7D.png" "700" "250"
get_graph "electricite" "2" $DATE_FROM_7D $DATE_TO "electricite-Cumul-7D.png" "700" "250"
get_graph "electricite" "5" $DATE_FROM_12M $DATE_TO "electricite-Cumul-365D.png" "700" "250"

#Hygrometrie
get_graph "hygrometrie" "1" $DATE_FROM_24H $DATE_TO "hygrometrie-Temperature.png" "300" "250"
get_graph "hygrometrie" "2" $DATE_FROM_24H $DATE_TO "hygrometrie-Instant.png" "300" "250"

get_graph "hygrometrie" "3" $DATE_FROM_24H $DATE_TO "hygrometrie-24H.png" "700" "250"
get_graph "hygrometrie" "4" $DATE_FROM_30D $DATE_TO "hygrometrie-30D.png" "700" "250"
get_graph "hygrometrie" "5" $DATE_FROM_12M $DATE_TO "hygrometrie-365D.png" "700" "250"

#Traffic
get_graph "traffic-internet" "3" $DATE_FROM_24H $DATE_TO "traffic-cerbere-eth0-rx.png" "300" "100"
get_graph "traffic-internet" "4" $DATE_FROM_24H $DATE_TO "traffic-cerbere-eth0-tx.png" "300" "100"
get_graph "traffic-internet" "5" $DATE_FROM_24H $DATE_TO "traffic-cerbere-pppoe-rx.png" "300" "100"
get_graph "traffic-internet" "6" $DATE_FROM_24H $DATE_TO "traffic-cerbere-pppoe-tx.png" "300" "100"
get_graph "traffic-internet" "1" $DATE_FROM_1H $DATE_TO "traffic-cerbere-eth0.png" "700" "250"
get_graph "traffic-internet" "2" $DATE_FROM_1H $DATE_TO "traffic-cerbere-pppoe.png" "700" "250"

get_graph "traffic-internet" "7" $DATE_FROM_24H $DATE_TO "traffic-d2r2-eth0-rx.png" "300" "100"
get_graph "traffic-internet" "8" $DATE_FROM_24H $DATE_TO "traffic-d2r2-eth0-tx.png" "300" "100"
get_graph "traffic-internet" "9" $DATE_FROM_1H $DATE_TO "traffic-d2r2-eth0.png" "700" "250"
#Usage: bash stop_graph_analytics.sh [data container name] [application container name]
#Ex: bash stop_graph_analytics.sh data graph

DATA_NAME=$1
APP_NAME=$2

sudo docker rm -f ${APP_NAME}
sudo docker rm -f ${DATA_NAME}

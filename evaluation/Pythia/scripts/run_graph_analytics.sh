#Usage bash run_graph_analytics.sh [name of data container] [name of application container] [driver memory (4g minimumn)] [executor memory]
#Ex: bash run_graph_analytics.sh data graph 4g 500m $Core

CORE=$5
DATA_NAME=$1
APP_NAME=$2
DRV_MEM=$3
EXEC_MEM=$4

sudo docker create --name ${DATA_NAME} --cpuset-cpus="${CORE}" --cpuset-mems="0" cloudsuite/twitter-dataset-graph
sudo docker run -d --rm --name ${APP_NAME} --cpuset-cpus="${CORE}" --cpuset-mems="0" --volumes-from ${DATA_NAME} cloudsuite/graph-analytics --driver-memory ${DRV_MEM} --executor-memory ${EXEC_MEM}

#Usage: bash run_in_mem.sh [data container name] [application container name] [driver memory (at least 3g)] [executor memory]
#Ex: bash run_in_mem.sh data in-mem 3g 100m $core

CORE=$5
DATA_NAME=$1
APP_NAME=$2
DRV_MEM=$3
EXEC_MEM=$4

sudo docker create --name ${DATA_NAME} --cpuset-cpus="${CORE}" --cpuset-mems="0" cloudsuite/movielens-dataset
sudo docker run -d --rm --name ${APP_NAME} --cpuset-cpus="${CORE}" --cpuset-mems="0" --volumes-from ${DATA_NAME} cloudsuite/in-memory-analytics /data/ml-latest /data/myratings.csv --driver-memory $DRV_MEM --executor-memory $EXEC_MEM

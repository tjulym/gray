pqos -R

curl -d 2 http://127.0.0.1:30400
python3 set_qps.py 0 10
python3 get_ml_data.py 10

curl -d 2 http://127.0.0.1:30400
python3 set_qps.py 0 20
python3 get_ml_data.py 20

curl -d 2 http://127.0.0.1:30400
python3 set_qps.py 0 30
python3 get_ml_data.py 30

curl -d 2 http://127.0.0.1:30400
python3 set_qps.py 0 40
python3 get_ml_data.py 40

curl -d 2 http://127.0.0.1:30400
python3 set_qps.py 0 50
python3 get_ml_data.py 50

python3 set_qps.py 1

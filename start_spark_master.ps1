docker run --network spark_network -d -h spark_master -p 4000:8080 -p 4001:7077 --rm -i -t --name spark_master ilfat/spark tail -f /dev/null
docker exec spark_master ./sbin/start-master.sh
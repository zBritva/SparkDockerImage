docker run --network spark_network -d -h spark_master -p 4000:8080 --rm -i -t --name spark_master spark tail -f /dev/null
docker exec spark_master ./sbin/start-master.sh
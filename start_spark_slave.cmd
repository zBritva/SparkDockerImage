docker run --name spark_slave --network spark_network -d --rm -i -t spark tail -f /dev/null
docker exec spark_slave ./sbin/start-slave.sh spark://spark_master:7077
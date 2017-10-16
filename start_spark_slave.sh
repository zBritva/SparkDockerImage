docker run --name spark_slave --network spark_network -d --rm -i -t ilfat/spark tail -f /dev/null
masterip="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' spark_master)"
docker exec spark_slave ./sbin/start-slave.sh spark://${masterip}:7077
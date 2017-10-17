name="$(hostname)";
if [ "$name" = "spark_master" ]
then
        echo "master";
        /etc/init.d/ssh start
else
        echo "slave";
fi
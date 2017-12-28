#!/bin/sh

# nohup java -jar jenkins.war --httpPort=8088 -XX:PermSize=512M -XX:MaxPermSize=2048M -Xmn128M -Xms1024M -Xmx2048M &

source /duitang/dist/cmd/env.sh
#source /opt/rh/devtoolset-2/enable
DESC="Jenkins CI Server"
NAME=jenkins
PIDFILE=/var/run/$NAME.pid
RUN_AS=jenkins
LOGFILE=/duitang/logs/sys/jenkins/jenkins.log
JAVA_ARGS="-XX:MaxPermSize=5120m -Xms5120m -Xmx2048m"
#COMMAND=java -- -jar /duitang/dist/sys/jenkins/jenkins.war --httpPort=8088 > $LOGFILE 2>&1VA_ARGS="-XX:MaxPermSize=512m -Xms512m -Xmx1024m"
COMMAND=/duitang/dist/sys/java8/bin/java -jar -Dhudson.ClassicPluginStrategy.noBytecodeTransformer=true /app_jenkins/jenkins/jenkins.war -Dfile.encoding=UTF-8 --httpPort=8088 > $LOGFILE 2>&1

d_start() {
        #/usr/local/bin/start-stop-daemon --start --quiet --background --make-pidfile --pidfile $PIDFILE --chuid $RUN_AS --exec $COMMAND
        /duitang/dist/sys/java8/bin/java $JAVA_ARGS -jar -Xms1024m -Xms2048m -XX:MaxPermSize=1024m -Dhudson.ClassicPluginStrategy.noBytecodeTransformer=true  -Dhudson.slaves.WorkspaceList='_' /app_jenkins/jenkins/jenkins.war --httpPort=8088 > $LOGFILE 2>&1 &     
}

d_stop() {
        sudo /bin/netstat -ntpl|grep :8088|grep -v grep|awk '{print $7}'|awk -F'/' '{print $1}'|xargs kill -9
        #/usr/local/bin/start-stop-daemon --stop --quiet --pidfile $PIDFILE
        #if [ -e $PIDFILE ]
        #    then rm $PIDFILE
        #fi
}

case $1 in
    start)
        echo -n "Starting $DESC: $NAME"
        d_start
        echo "."
        ;;
    stop)
        echo -n "Stopping $DESC: $NAME"
        d_stop
        echo "."
        ;;
    restart)
        echo -n "Restarting $DESC: $NAME"
        d_stop
        sleep 1
        d_start
        echo "."
        ;;
    *)
        echo "usage: $NAME {start|stop|restart}"
        exit 1
        ;;
esac

exit 0

#!/bin/sh

JAVA_HOME=/u00/app/oracle/product/11.2.0.4/jdk/jre/
TVDXTAT_HOME=/home/oracle/tvdxtat

$JAVA_HOME/bin/java -Xmx1024m -Dtvdxtat.home=$TVDXTAT_HOME -Djava.util.logging.config.file=$TVDXTAT_HOME/config/logging.properties -jar $TVDXTAT_HOME/lib/tvdxtat.jar $*

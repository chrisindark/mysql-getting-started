#!/bin/bash

sudo apt install -y percona-toolkit


tb_name=("table1" "table2" "table3")

for tb in ${tb_name[@]}; do
    echo $tb
    pt-online-schema-change \
        --skip-check-slave-lag --progress --critical-load=Threads_running=10000 \
        --max-load=Threads_running=1000 \
        --alter="ENGINE=InnoDB" --analyze-before-swap --host=localhost --port=3306 --user=trell --password='localhost' \
        --execute D=testDb,t=$tb;
done

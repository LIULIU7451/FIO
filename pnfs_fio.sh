#!/bin/bash

if [ $# -lt 1 ]
then
        echo "please input nvmeX"
        exit 1
fi

pathname=$1

function fiocsv(){
         bw=`cat $5  |grep -i "iops=" |tr -s "," "\n"|grep -i "bw"`
         iops=`cat $5   |grep -i "iops="|tr -s "," "\n"|grep -i iops`
         echo $1,$2,$3,$4,$bw,$iops >>re.csv
}


function pathnametest(){
echo   "RW,BS,Iodepth,Jobs,BW,IOPS"> re.csv
# echo  "One thread sequential read write predonditon"
# fio --name=init_seq  --filename=$pathname/testfile --ioengine=libaio --direct=1 --thread=1 --norandommap --numjobs=1 --iodepth=64   --rw=write --bs=128k --loops=1 --size=100% --group_reporting  >> "$pathname"_one_thread_seq_wr_precondition.log
for rw  in  write read 
do
    for bs in  4k 128k 1m
    do
        for iodepth in 1 32 64
        do
            for jobs in 1 32 64
            do
                echo "$pathname $rw $bs iodepth=$iodepth numjobs=$jobs test satrt"
                fio --directory=$pathname --direct=1  --size=1000G --norandommap --randrepeat=0 --ioengine=libaio --iodepth=$iodepth --bs=$bs --rw=$rw --numjobs=$jobs --runtime=60 --cpus_allowed=1 --cpus_allowed_policy=split  --group_reporting --name=mytest >${rw}_${bs}_${iodepth}_${jobs}.rec
                fiocsv $rw $bs $iodepth $jobs ${rw}_${bs}_${iodepth}_${jobs}.rec
            done        
        done
    done
done

echo "randread randwrite randrw test start"
# fio --name=Precondition --filename=$pathname/testfile --ioengine=libaio --direct=1 --thread=1 --numjobs=1 --iodepth=64 --rw=write --bs=128k --loops=1 --size=100% --group_reporting  >> "$pathname"_one_thread_random_seq_wr_precondition.log
# fio --name=Precondition --filename=$pathname/testfile --ioengine=libaio --direct=1 --thread=1 --numjobs=2 --iodepth=64 --rw=randwrite --bs=4k --loops=1  --size=100% --norandommap=1 --randrepeat=0 --group_reporting  >> "$pathname"_one_thread_random_wr_precondition.log
for rw in  randwrite randread  
do
    for bs in 4k 128k 1m
    do
        for iodepth in 1 32 64
        do
            for jobs in 1 32 64
            do
                echo "$pathname $rw $bs iodepth=$iodepth numjobs=$jobs test satrt"
                fio --directory=$pathname --direct=1 --size=1000G  --norandommap --randrepeat=0 --ioengine=libaio --iodepth=$iodepth --bs=$bs --rw=$rw --numjobs=$jobs --runtime=60 --cpus_allowed=1 --cpus_allowed_policy=split  --group_reporting --name=mytest >${rw}_${iodepth}_${jobs}.rec
                fiocsv $rw $bs $iodepth  $jobs ${rw}_${iodepth}_${jobs}.rec
            done
        done
    done
done
}

pathnametest


fio --name=seq_write_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=write --norandommap --randrepeat=0 --refill_buffers=1 --cpus_allowed=1 --bs=128k --iodepth=64 --numjobs=1 --size=10G --loops=1 --runtime=120 --overwrite=1 --time_based --group_reporting | tee -a SW.log
sleep 30
fio --name=seq_read_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=read --bs=128k --iodepth=64 --numjobs=1  --refill_buffers=1 --cpus_allowed=1 --size=10G --loops=1 --runtime=120 --overwrite=1 --time_based --group_reporting | tee -a SR.log
sleep 30
fio --name=rand_write_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=randwrite --norandommap --randrepeat=0  --refill_buffers=1 --cpus_allowed=1 --bs=4k --iodepth=64 --numjobs=16 --size=10G --loops=1 --runtime=120 --overwrite=1 --time_based --group_reporting | tee -a RW.log
sleep 30
fio --name=rand_read_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=randread --bs=4k --iodepth=64 --numjobs=16  --refill_buffers=1 --cpus_allowed=1  --size=10G --loops=1 --runtime=120 --overwrite=1 --time_based --group_reporting | tee -a RR.log

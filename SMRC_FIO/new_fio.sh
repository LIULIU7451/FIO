fio --name=seq_write_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=write --norandommap --randrepeat=0 --refill_buffers=1 --bs=128k --iodepth=64 --numjobs=1 --size=10G --runtime=60 --time_based --group_reporting | tee -a sw.log
sleep 30
fio --name=seq_read_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=read --norandommap --randrepeat=0 --bs=128k --iodepth=64 --numjobs=1  --refill_buffers=1 --size=10G --runtime=60 --time_based --group_reporting | tee -a sr.log
sleep 30
fio --name=rand_write_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=randwrite --norandommap --randrepeat=0  --refill_buffers=1 --bs=4k --iodepth=64 --numjobs=16 --size=10G --runtime=60 --time_based --group_reporting | tee -a rw.log
sleep 30
fio --name=rand_read_test --directory=/mnt/nfs --ioengine=libaio --direct=1 --rw=randread --norandommap --randrepeat=0 --bs=4k --iodepth=64 --numjobs=16  --refill_buffers=1 --size=10G --runtime=60 --time_based --group_reporting | tee -a rr.log


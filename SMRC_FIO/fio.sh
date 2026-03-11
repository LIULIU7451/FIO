# 128K Sequential Write 
fio --name=seq_write_test \  --directory=/mnt/nfs \  --ioengine=libaio \  --direct=1 \  --rw=write \  --norandommap \  --randrepeat=0 \  --bs=128k \  --iodepth=32 \  --numjobs=1 \  --size=1G \  --loops=1 \  --runtime=120 \  --overwrite=1 \  --time_based \  --group_reporting  
# 128K Sequential Read 
fio --name=seq_read_test \  --directory=/mnt/nfs \  --ioengine=libaio \  --direct=1 \  --rw=read \  --bs=128k \  --iodepth=32 \  --numjobs=1 \  --size=1G \  --loops=1 \  --runtime=120 \  --overwrite=1 \  --time_based \  --group_reporting
# 128K Sequential Write 
fio --name=rand_write_test \  --directory=/mnt/nfs \  --ioengine=libaio \  --direct=1 \  --rw=write \  --norandommap \  --randrepeat=0 \  --bs=4k \  --iodepth=32 \  --numjobs=16 \  --size=1G \  --loops=1 \  --runtime=120 \  --overwrite=1 \  --time_based \  --group_reporting  
# 128K Sequential Read 
fio --name=rand_read_test \  --directory=/mnt/nfs \  --ioengine=libaio \  --direct=1 \  --rw=read \  --bs=4k \  --iodepth=32 \  --numjobs=16 \  --size=1G \  --loops=1 \  --runtime=120 \  --overwrite=1 \  --time_based \  --group_reporting

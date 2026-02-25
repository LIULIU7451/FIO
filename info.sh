#!/usr/bin/env bash  
echo "=== lscpu ==="  
lscpu | grep -E 'CPU\(s\)|Thread|Core|Socket|NUMA|Vendor'

echo "=== nproc ==="  
nproc

echo "=== /proc/cpuinfo (逻辑) ==="  
grep -c ^processor /proc/cpuinfo

echo "=== /proc/cpuinfo (物理) ==="  
awk -F: '/physical id/ {socket=$2} /core id/ {core=$2; print socket"_"core}' /proc/cpuinfo |  
    sort -u | wc -l

echo "=== numactl (NUMA nodes) ==="  
numactl --hardware 2>/dev/null || echo "numactl not installed"  

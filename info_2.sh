#!/usr/bin/env bash  
#================================================================  
#  name: get_system_info.sh  
#  desc: 輸出 CPU 型號、物理核數、邏輯核數、OS 版本、內核版本、內存大小（單位 GiB）  
#  author: DS Assistant  
#  date: 2026-02-26  
#================================================================

set -euo pipefail

#--------------------------------------------------------------  
# 1. CPU 型號  
#--------------------------------------------------------------  
if command -v lscpu >/dev/null 2>&1; then  
    CPU_MODEL=$(lscpu | awk -F: '/Model name/ {gsub(/^ +| +$/,"",$2); print $2}')  
else  
    CPU_MODEL=$(awk -F: '/model name/ {gsub(/^ +| +$/,"",$2); print $2; exit}' /proc/cpuinfo)  
fi

#--------------------------------------------------------------  
# 2. 物理核數（強化實作）  
#--------------------------------------------------------------  
get_physical_cores_lscpu() {  
    local sockets cores_per_socket  
    sockets=$(lscpu | awk -F: '/Socket\(s\)/ {gsub(/^ +| +$/,"",$2); print $2}')  
    cores_per_socket=$(lscpu | awk -F: '/Core\(s\) per socket/ {gsub(/^ +| +$/,"",$2); print $2}')  
    if [[ -n "$sockets" && -n "$cores_per_socket" && "$sockets" != "0" && "$cores_per_socket" != "0" ]]; then  
        echo $((sockets * cores_per_socket))  
        return 0  
    fi  
    return 1  
}

get_physical_cores_proc() {  
    awk -F: '  
        $1=="physical id" {phy=$2}  
        $1=="core id"     {core=$2; key=phy":"core; seen[key]=1}  
        END {  
            cnt=0  
            for (k in seen) cnt++  
            print cnt  
        }  
    ' /proc/cpuinfo  
}

if command -v lscpu >/dev/null 2>&1 && get_physical_cores_lscpu >/dev/null 2>&1; then  
    PHYSICAL_CORES=$(get_physical_cores_lscpu)  
else  
    PHYSICAL_CORES=$(get_physical_cores_proc)  
fi

# 防止極端情況（仍然為 0）時使用邏輯核數作兜底  
if [[ "$PHYSICAL_CORES" -eq 0 ]]; then  
    PHYSICAL_CORES=$(grep -c '^processor' /proc/cpuinfo)  
fi

#--------------------------------------------------------------  
# 3. 邏輯核數  
#--------------------------------------------------------------  
LOGICAL_CORES=$(grep -c '^processor' /proc/cpuinfo)

#--------------------------------------------------------------  
# 4. 操作系統版本  
#--------------------------------------------------------------  
if [[ -f /etc/os-release ]]; then  
    . /etc/os-release  
    OS_VERSION="${PRETTY_NAME:-${NAME} ${VERSION_ID}}"  
else  
    if command -v lsb_release >/dev/null 2>&1; then  
        OS_VERSION=$(lsb_release -sd)  
    else  
        OS_VERSION=$(cat /etc/*release 2>/dev/null | head -n1 || echo "Unknown")  
    fi  
fi

#--------------------------------------------------------------  
# 5. 內核版本  
#--------------------------------------------------------------  
KERNEL_VERSION=$(uname -r)

#--------------------------------------------------------------  
# 6. 內存大小（單位 GiB，二進位制）  
#--------------------------------------------------------------  
if command -v free >/dev/null 2>&1; then  
    MEM_TOTAL_KB=$(free -k | awk '/^Mem:/ {print $2}')  
else  
    MEM_TOTAL_KB=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)  
fi

#  KB → MiB → GiB（除以 1024 的兩次）  
MEM_TOTAL_GIB=$(awk "BEGIN {printf \"%.2f\", $MEM_TOTAL_KB/1024/1024}")

#--------------------------------------------------------------  
# 7. 輸出結果  
#--------------------------------------------------------------  
echo "===== Linux 系統硬件/軟件資訊 ====="  
printf "CPU 型號      : %s\n" "$CPU_MODEL"  
printf "物理核數      : %s\n" "$PHYSICAL_CORES"  
printf "邏輯核數      : %s\n" "$LOGICAL_CORES"  
printf "操作系統版本  : %s\n" "$OS_VERSION"  
printf "內核版本      : %s\n" "$KERNEL_VERSION"  
printf "內存大小 (GiB): %s GiB\n" "$MEM_TOTAL_GIB"  
echo "===================================="  

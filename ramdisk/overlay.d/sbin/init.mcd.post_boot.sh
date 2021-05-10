#!/vendor/bin/sh

echo "mcd: post_boot start" > /dev/kmsg

# Replace msm_irqbalance.conf
echo "PRIO=1,1,1,1,0,0,0,0
#arch_timer,arm-pmu,arch_mem_timer,glink_lpass,kgsl-3d0
IGNORED_IRQ=19,21,38,188,332" > /dev/msm_irqbalance.conf
chmod 644 /dev/msm_irqbalance.conf
mount --bind /dev/msm_irqbalance.conf /vendor/etc/msm_irqbalance.conf
chcon "u:object_r:vendor_configs_file:s0" /vendor/etc/msm_irqbalance.conf
killall msm_irqbalance

# Wait to set proper init values
sleep 20

# Setup readahead
find /sys/devices -name read_ahead_kb | while read node; do echo 128 > $node; done

# Disable CAF task placement for Big Cores
# echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks

# GPU config
echo 257 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/min_clock_mhz
echo 710 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_clock_mhz

# Enable OTG by default
echo 1 > /sys/class/power_supply/usb/otg_switch

# Disable vendor swap file
swapoff /data/vendor/swap/swapfile

# Set swappiness reflecting the device's RAM size
RamStr=$(cat /proc/meminfo | grep MemTotal)
RamMB=$((${RamStr:16:8} / 1024))
if [ $RamMB -le 6144 ]; then
    echo 190 > /proc/sys/vm/swappiness
elif [ $RamMB -le 8192 ]; then
    echo 160 > /proc/sys/vm/swappiness
else
    echo 130 > /proc/sys/vm/swappiness
fi

echo "mcd: post_boot end" > /dev/kmsg

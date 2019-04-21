#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

# macro to write pids to system-background cpuset
function writepid_sbg() {
    until [ ! "$1" ]; do
        echo -n $1 > /dev/cpuset/system-background/tasks;
        shift;
    done;
}

function writepid_top_app() {
    until [ ! "$1" ]; do
        echo -n $1 > /dev/cpuset/top-app/tasks;
        shift;
    done;
}
################################################################################

{

sleep 5

# cpu
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
chown system system /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

# gpu
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/min_freq

# display kcal calibration
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

# Disable sched_boost
echo "0" > /proc/sys/kernel/sched_boost

# Set default schedTune value for foreground/top-app
echo "0" > /dev/stune/top-app/schedtune.boost

# Dynamic Stune Boost during sched_boost
echo "10" > /dev/stune/top-app/schedtune.sched_boost

# Stune configuration
echo "10" > /sys/module/cpu_boost/parameters/dynamic_stune_boost
echo "300" > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# Set default schedTune value for foreground/top-app
echo "1" > /dev/stune/foreground/schedtune.prefer_idle
echo "1" > /dev/stune/top-app/schedtune.prefer_idle

# Bring back main cores CPU 0,2
echo "1" > /sys/devices/system/cpu/cpu0/online
echo "1" > /sys/devices/system/cpu/cpu2/online

# Configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable

# Configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us
echo "10000" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
echo "0" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable

# CPUFreq control
echo "307200" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "1593600" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "307200" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "2342400" > sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq

# Touchboost configuration
echo "0" > /sys/module/msm_performance/parameters/touchboost

# Input boost configuration
echo "1" > /sys/module/cpu_boost/parameters/input_boost_enabled
echo "0:844800 2:748800" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "100" > /sys/module/cpu_boost/parameters/input_boost_ms

# Set thermal restrictions
echo "0" > /sys/kernel/msm_thermal/enabled
echo "1516800 2246400 41 40" > /sys/kernel/msm_thermal/zone0
echo "1440000 2150400 42 41" > /sys/kernel/msm_thermal/zone1
echo "1363200 2054400 43 42" > /sys/kernel/msm_thermal/zone2
echo "1363200 1977600 44 43" > /sys/kernel/msm_thermal/zone3
echo "1286400 1900800 45 44" > /sys/kernel/msm_thermal/zone4
echo "1286400 1824000 47 45" > /sys/kernel/msm_thermal/zone5
echo "1132800 1670400 49 47" > /sys/kernel/msm_thermal/zone6
echo "1056000 1363200 54 49" > /sys/kernel/msm_thermal/zone7
echo "902400 1056000 58 54" > /sys/kernel/msm_thermal/zone8
echo "844800 902400 60 58" > /sys/kernel/msm_thermal/zone9
echo "768000 748800 63 60" > /sys/kernel/msm_thermal/zone10
echo "4000" > /sys/kernel/msm_thermal/sampling_ms
echo "1" > /sys/kernel/msm_thermal/enabled

# Configure governor for devfreq/kgsl
echo "bw_hwmon" > /sys/class/devfreq/soc:qcom,cpubw/governor
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor

# Set I/O scheduler
setprop sys.io.scheduler "maple"

# Tweak IO performance after boot complete
echo "1" > /sys/block/sda/queue/iostats
echo "1" > /sys/block/sde/queue/iostats
echo "maple" > /sys/block/sda/queue/scheduler
echo "maple" > /sys/block/sde/queue/scheduler
echo "maple" > /sys/block/dm-0/queue/scheduler
echo "maple" > /sys/block/dm-1/queue/scheduler
echo "128" > /sys/block/sda/queue/nr_requests
echo "128" > /sys/block/sde/queue/nr_requests
echo "256" > /sys/block/sda/queue/read_ahead_kb
echo "256" > /sys/block/sde/queue/read_ahead_kb
echo "256" > /sys/block/dm-0/queue/read_ahead_kb
echo "256" > /sys/block/dm-1/queue/read_ahead_kb

# Enable all LPMs by default
# This will enable C4, D4, D3, E4 and M3 LPMs
echo "N" /sys/module/lpm_levels/parameters/sleep_disabled

# Disable Serial Console
echo "N" > /sys/module/printk/parameters/console_suspend

# Set sync wakee policy tunable
echo "1" > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker

# according to Qcom this legacy value improves first launch latencies
# stock value is 512k
setprop dalvik.vm.heapminfree 2m

## write pids to system-background cpuset

sleep 20

QSEECOMD=`pidof qseecomd`
THERMAL-ENGINE=`pidof thermal-engine`
TIME_DAEMON=`pidof time_daemon`
IMSQMIDAEMON=`pidof imsqmidaemon`
IMSDATADAEMON=`pidof imsdatadaemon`
DASHD=`pidof dashd`
CND=`pidof cnd`
DPMD=`pidof dpmd`
RMT_STORAGE=`pidof rmt_storage`
TFTP_SERVER=`pidof tftp_server`
NETMGRD=`pidof netmgrd`
IPACM=`pidof ipacm`
QTI=`pidof qti`
LOC_LAUNCHER=`pidof loc_launcher`
QSEEPROXYDAEMON=`pidof qseeproxydaemon`
IFAADAEMON=`pidof ifaadaemon`
LOGCAT=`pidof logcat`
LMKD=`pidof lmkd`

writepid_sbg $QSEECOMD
writepid_sbg $THERMAL-ENGINE
writepid_sbg $TIME_DAEMON
writepid_sbg $IMSQMIDAEMON
writepid_sbg $IMSDATADAEMON
writepid_sbg $DASHD
writepid_sbg $CND
writepid_sbg $DPMD
writepid_sbg $RMT_STORAGE
writepid_sbg $TFTP_SERVER
writepid_sbg $NETMGRD
writepid_sbg $IPACM
writepid_sbg $QTI
writepid_sbg $LOC_LAUNCHER
writepid_sbg $QSEEPROXYDAEMON
writepid_sbg $IFAADAEMON
writepid_sbg $LOGCAT
writepid_sbg $LMKD

## end write pids to system-background cpuset

echo "mcd: mcd-power executed" > /dev/kmsg

}&


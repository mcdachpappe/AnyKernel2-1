# Stune-Boost
    write /dev/stune/top-app/schedtune.sched_boost 50
    write /dev/stune/foreground/schedtune.prefer_idle 0
    write /dev/stune/top-app/schedtune.boost 1
    write /dev/stune/top-app/schedtune.prefer_idle 0
# Governor
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 500
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 25000
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 0
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us 500
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us 25000
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable 0
# CPU-Freq
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 614400
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2188800
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 614400
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 2342400
# Touchboost
    write /sys/module/msm_performance/parameters/touchboost 1
# Input-Boost
    write /sys/module/cpu_boost/parameters/input_boost_enabled 1
    write /sys/module/cpu_boost/parameters/input_boost_freq "0:1132800 2:1056000"
    write /sys/module/cpu_boost/parameters/input_boost_ms 1000
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost 50
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 1000
# Scheduler
    setprop sys.io.scheduler "cfq"
# Thermal
    write /sys/kernel/msm_thermal/enabled 0
    write /sys/kernel/msm_thermal/zone0 "1996800 2246400 46 45"
    write /sys/kernel/msm_thermal/zone1 "1593600 2150400 47 46"
    write /sys/kernel/msm_thermal/zone2 "1516800 2054400 48 47"
    write /sys/kernel/msm_thermal/zone3 "1440000 1977600 49 48"
    write /sys/kernel/msm_thermal/zone4 "1363200 1900800 50 49"
    write /sys/kernel/msm_thermal/zone5 "1286400 1824000 52 50"
    write /sys/kernel/msm_thermal/zone6 "1132800 1670400 54 52"
    write /sys/kernel/msm_thermal/zone7 "1056000 1363200 59 54"
    write /sys/kernel/msm_thermal/zone8 "902400 1056000 63 59"
    write /sys/kernel/msm_thermal/zone9 "844800 902400 65 63"
    write /sys/kernel/msm_thermal/zone10 "768000 748800 70 65"
    write /sys/kernel/msm_thermal/sampling_ms 1000
    write /sys/kernel/msm_thermal/enabled 1
# dmsg output
    write /dev/kmsg "mcd: set profile Gaming"
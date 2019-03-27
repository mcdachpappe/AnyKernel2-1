# Stune-Boost
    write /dev/stune/top-app/schedtune.sched_boost 30
    write /dev/stune/foreground/schedtune.prefer_idle 1
    write /dev/stune/top-app/schedtune.boost 1
    write /dev/stune/top-app/schedtune.prefer_idle 1
# Governor
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 500
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 20000
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 0
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us 500
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us 20000
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable 0
# CPU-Freq
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 307200
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2188800
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 307200
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 2342400
# Touchboost
    write /sys/module/msm_performance/parameters/touchboost 0
# Input-Boost
    write /sys/module/cpu_boost/parameters/input_boost_enabled 1
    write /sys/module/cpu_boost/parameters/input_boost_freq "0:1056000 2:1056000"
    write /sys/module/cpu_boost/parameters/input_boost_ms 1000
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost 30
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 750
# Scheduler
    setprop sys.io.scheduler "maple"
# Thermal
    write /sys/kernel/msm_thermal/enabled 0
    write /sys/kernel/msm_thermal/zone0 "1996800 2246400 44 43"
    write /sys/kernel/msm_thermal/zone1 "1593600 2150400 45 44"
    write /sys/kernel/msm_thermal/zone2 "1516800 2054400 46 45"
    write /sys/kernel/msm_thermal/zone3 "1440000 1977600 47 46"
    write /sys/kernel/msm_thermal/zone4 "1363200 1900800 48 47"
    write /sys/kernel/msm_thermal/zone5 "1286400 1824000 50 48"
    write /sys/kernel/msm_thermal/zone6 "1132800 1670400 52 50"
    write /sys/kernel/msm_thermal/zone7 "1056000 1363200 57 52"
    write /sys/kernel/msm_thermal/zone8 "902400 1056000 61 57"
    write /sys/kernel/msm_thermal/zone9 "844800 902400 63 61"
    write /sys/kernel/msm_thermal/zone10 "768000 748800 66 63"
    write /sys/kernel/msm_thermal/sampling_ms 4000
    write /sys/kernel/msm_thermal/enabled 1
# dmsg output
    write /dev/kmsg "mcd: set profile Performance"
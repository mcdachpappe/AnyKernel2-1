# Stune-Boost
    write /dev/stune/top-app/schedtune.sched_boost 10
    write /dev/stune/foreground/schedtune.prefer_idle 1
    write /dev/stune/top-app/schedtune.boost 0
    write /dev/stune/top-app/schedtune.prefer_idle 1
# Governor
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 1000
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 10000
    write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 0
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "schedutil"
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us 1000
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us 10000
    write /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable 0
# CPU-Freq
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 307200
    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1593600
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 307200
    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 2342400
# Touchboost
    write /sys/module/msm_performance/parameters/touchboost 0
# Input-Boost
    write /sys/module/cpu_boost/parameters/input_boost_enabled 1
    write /sys/module/cpu_boost/parameters/input_boost_freq "0:844800 2:691200"
    write /sys/module/cpu_boost/parameters/input_boost_ms 80
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost 10
    write /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 300
# Scheduler
    setprop sys.io.scheduler "maple"
# Thermal
    write /sys/kernel/msm_thermal/enabled 0
    write /sys/kernel/msm_thermal/zone0 "1516800 2246400 41 40"
    write /sys/kernel/msm_thermal/zone1 "1440000 2150400 42 41"
    write /sys/kernel/msm_thermal/zone2 "1363200 2054400 43 42"
    write /sys/kernel/msm_thermal/zone3 "1363200 1977600 44 43"
    write /sys/kernel/msm_thermal/zone4 "1286400 1900800 45 44"
    write /sys/kernel/msm_thermal/zone5 "1286400 1824000 47 45"
    write /sys/kernel/msm_thermal/zone6 "1132800 1670400 49 47"
    write /sys/kernel/msm_thermal/zone7 "1056000 1363200 54 49"
    write /sys/kernel/msm_thermal/zone8 "902400 1056000 58 54"
    write /sys/kernel/msm_thermal/zone9 "844800 902400 60 58"
    write /sys/kernel/msm_thermal/zone10 "768000 748800 63 60"
    write /sys/kernel/msm_thermal/sampling_ms 4000
    write /sys/kernel/msm_thermal/enabled 1
# dmsg output
    write /dev/kmsg "mcd: set profile Balance"
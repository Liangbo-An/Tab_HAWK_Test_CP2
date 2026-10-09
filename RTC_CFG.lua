-- 全局配置（单位：秒）
MAX_TIME_DIFF = 5  -- 允许的最大时间偏差（秒）


-- 将RTC时间字符串转换为时间戳（秒）
local function parseRTCtime(rtc_str)
    if not rtc_str or type(rtc_str) ~= "string" then return nil end
    
    -- 匹配年月日时分秒
    local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = rtc_str:match(pattern)
    if not year then return nil end
    
    -- 使用os.time转换为时间戳
    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    })
end

function RTC_SYS_TIME_COMPARISON()
	local ret = 0
    -- 获取RTC时间（字符串格式）
    local rtc_str = SYS.GET_TIME() or "N/A"
    --LOG.INFO("[RTC] Time: " .. rtc_str)
    
    -- 转换为时间戳
    local rtc_timestamp = parseRTCtime(rtc_str)
    if not rtc_timestamp then
        LOG.ERROR("Failed to parse RTC time")
        return nil
    end
    
    -- 获取系统时间（毫秒→秒）
    local sys_timestamp = math.floor(TIME.TICK() / 1000)
    local sys_time_str = os.date("%Y-%m-%d %H:%M:%S", sys_timestamp)
    --LOG.INFO("[SYS] Time: " .. sys_time_str)
    
    -- 计算时间差（秒）
    local time_diff = math.abs(sys_timestamp - rtc_timestamp)
    local is_sync = time_diff <= MAX_TIME_DIFF
    
    -- 输出比较结果
	if is_sync then
        LOG.INFO(string.format("[SYNC OK] RTC:%s | SYS:%s | DIFF:%ds",
            rtc_str, sys_time_str, time_diff))
        return true
    else
        LOG.ERROR(string.format("[SYNC FAILED] RTC:%s | SYS:%s | DIFF:%ds (MAX:%ds)",
            rtc_str, sys_time_str, time_diff, MAX_TIME_DIFF))
        return false
    end

    
    return ret
end

-- RTC时间校准函数
-- 将系统时间写入硬件RTC时钟
function RTC_TIME_CALIBRATION()
    -- 获取当前系统时间（秒级Unix时间戳）
    local sys_timestamp = math.floor(TIME.TICK() / 1000) // 1
    
    -- 转换为时间表
    local time_table = os.date("*t", sys_timestamp)
    
    -- 调用底层设置函数（参数顺序：年,月,日,时,分,秒,星期）
    local success = SYS.SET_TIME(
        time_table.year, 
        time_table.month, 
        time_table.day,
        time_table.hour,
        time_table.min,
        time_table.sec,
        time_table.wday - 1  -- Lua的wday范围是1-7（周日=1），转换为0-6
    )
    
    -- 处理结果
    if success == 0 then
        local new_time_str = os.date("%Y-%m-%d %H:%M:%S", sys_timestamp)
        LOG.INFO(string.format("[RTC CALIBRATION SUCCESS] Set RTC to: %s (Weekday:%d)",
              new_time_str, time_table.wday - 1))
        return true
    else
        LOG.ERROR("[RTC CALIBRATION FAILED] Could not update RTC time")
        return false
    end
end

-- RTC电池监测配置
RTC_BATTERY_CONFIG = {
    VOLTAGE_MAX = 3.0,    -- 满电电压（100%）
    VOLTAGE_MIN = 2.0,    -- 空电电压（0%）
    WARNING_LEVEL = 10,   -- 低电量报警阈值（%）
}

-- 获取RTC电池电量百分比（带低电量报警）
function GET_RTC_BATTERY()
    -- 1. 读取原始电压值
    local voltage = SYS.GET_BAT()
    --local voltage = 2.1
    if not voltage or type(voltage) ~= "number" then
        LOG.ERROR("[BATTERY] Failed to read voltage")
        return nil
    end
    
    -- 2. 计算电量百分比（线性转换）
    local percent = math.floor(
        (voltage - RTC_BATTERY_CONFIG.VOLTAGE_MIN) / 
        (RTC_BATTERY_CONFIG.VOLTAGE_MAX - RTC_BATTERY_CONFIG.VOLTAGE_MIN) * 100
    )
    
    -- 3. 限制百分比范围（0-100）
    percent = math.max(0, math.min(100, percent))
    --LOG.INFO(string.format("RTC BATTERY:%d",percent).."%%")
    
    -- 4. 低电量检测
    if percent <= RTC_BATTERY_CONFIG.WARNING_LEVEL then
        LOG.ERROR(string.format(
            "[BATTERY WARNING] %.2fV -> %d%% (CRITICALLY LOW)", 
            voltage, percent
        ))
    else
        LOG.INFO(string.format(
            "[BATTERY] %.2fV -> %d%%", 
            voltage, percent
        ))
    end
    
    -- 5. 返回结构化数据
    return {
        voltage = voltage,
        percent = percent,
        status = (percent > RTC_BATTERY_CONFIG.WARNING_LEVEL) and "OK" or "LOW"
    }
end


function RTC_CHECK()

	LOG.INFO("[CHECK] start comparison rtc and system time")
	local ret = RTC_SYS_TIME_COMPARISON()
	if ret then
		LOG.INFO("[CHECK OK] comparison succeed!")
	else
		LOG.ERROR("[CHECK FAILED] comparison failed,Start RTC calibration")
		RTC_TIME_CALIBRATION()
	end
	LOG.INFO("[CHECK] Start Check Battery")
	local battery_data = GET_RTC_BATTERY()
	LOG.INFO(string.format("RTC VOLTAGE:%.2fV",battery_data.voltage))
	LOG.INFO(string.format("RTC BATTERY:%d",battery_data.percent).."%%")
	LOG.INFO(string.format("RTC BATTERY STATUS:%s",battery_data.status))
end

--RTC_CHECK()




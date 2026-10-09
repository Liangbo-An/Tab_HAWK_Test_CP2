-- 版本更新日志 / Changelog
Changelog = {
    -- 新版本写在最上面
    
    {
        version = "v1.0.2",
        name = "PEQUIN_Test_Flow_0430",
        date    = "2026-04-30",
        type    = "bugfix",
        content = {
        	"修改 Display_Frames_WithPulse()中的温度计算，CP2模式下使用温度校准值计算温度",
        	"CP2中，DAC_CAL烧录重复操作，已删除",
        	"AVEE1电流不稳定，修改RSYNC_CFG中值:0X280改为0X2D0",
        	"优化MIPI_TERM的TT时间",
        	"删除I_O正数测试", 
        	"AVEE_SEEP()接口电压测试范围修改为R：1V-3V。G/B:2V-3.5V",
        	"CRC5计算公式更新，使用此CRC_CRC_Calculation_NEW_4BIT",
        	"修改BUG AVEE_SWEEP()中Sw_by_name更新为(W255.bmp)",
        	"增加MIPI_RESET()接口",
        	"修改efuse_post()中数据返回逻辑,不写入时也返回预期值",
        	"获取电流不线性AVEE_SWEEP()中的delay更新为200ms",
        	"AVEE电流获取不到,Idle_Power_Test()新增TIME.DELAY(100)",
        	"MIPI_Communication_Test()由TIME.DELAY(10)改为TIME.DELAY(12)",
        	"CP2中test_bandgap_trim(),test_temperature_sensor_thermometer(),dac_full_range_calibration(),增加GPIO操作,",
        	"CP2中test_temperature_sensor_thermometer()增加Ain[adc_source]电压计算",
        	"EFuse_PostTest()增加传参,S 需要按照工位号进行烧录",
        	"Demura 烧录流程更新,烧录所需图片减少为1张,8个SRAM区域均进行校验"
        }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	},
	
    {
        version = "v1.0.1",
        name = "PEQUIN_Test_Flow_0418",
        date    = "2026-04-18",
        type    = "bugfix",
        content = {
            "AVEE_SWEEP(),红色测试电压条件修改",
            "efuse_post(),MT增加MIPI_TERM特殊字段处理"
           
        }
    },
    
    
    
    {
        version = "v1.0.0",
        name = "PEQUIN_Test_Flow_0417",
        date    = "2026-04-17",
        type    = "bugfix",
        content = {
            "初始版本",
        }
    }
}
function ShowChangelog()
    for _, v in ipairs(Changelog) do
    	LOG.DEBUG("-----------------------------")
        LOG.INFO(string.format("[%s] %s  %s", v.version, v.date, v.type))
        for i, line in ipairs(v.content) do
            LOG.INFO("  - " .. line)
        end
        --LOG.DEBUG("-----------------------------")
    end
    
    local data=SYS.VERSION()
	LOG.INFO(data)
end
--version_mode=0/1
--parameter:0:最新修改 1：代表全部版本
--GetChangelog(0)
function GetChangelog(version_mode)
	local new_modify
    local data_table = {}
	if version_mode == nil then 
		version_mode = 0
	end
	
	if	version_mode==0 then
		new_modify=1
	else
		new_modify=#Changelog
	end
    for i=1,new_modify ,1 do
    -- 基础信息
    	local log_str=""
    	table.insert(data_table, Changelog[i].version) --脚本版本
    	table.insert(data_table, Changelog[i].name)	--脚本名字
    	table.insert(data_table, Changelog[i].date) --更新日期
    	for j = 1 ,#Changelog[i].content do
    		log_str=log_str..","..Changelog[i].content[j]
    	end
    	log_str = string.gsub(log_str, "^,", "")  -- 只删除开头的逗号
    	table.insert(data_table, log_str)  -- 更新日志
	end
	
	
    local sys_ver = SYS.VERSION()     -- 读取PG系统版本

    -- 1. 去掉 [build: 旁边的中括号
    sys_ver = string.gsub(sys_ver, "%[build:", " build:")
    sys_ver = string.gsub(sys_ver, "%]", "")

    -- 2. 按换行分割每一行
    for line in string.gmatch(sys_ver, "([^\n]+)") do
        -- 清理每行多余的空格、换行、斜线
        line = string.gsub(line, "%s+", " ")
        line = string.gsub(line, "^%s+", "")
        table.insert(data_table, line)
    end

    -- 生成标准 JSON（绝对不会出现斜线）
    local json_data = cjson.encode(data_table)
    LOG.INFO(json_data)
    return json_data
end
-- 调用查看
--ShowChangelog()
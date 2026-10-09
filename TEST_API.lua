
Bandgap_code = 0
DAC_cal_trim_step = 0
DAC_calibration_code=0
tempratue_0p25_code=0
tempratue_0p75_code=0
DAC_POINTA_CODE=0
DAC_POINTB_CODE=0
thermal_sensor0_code=0
thermal_sensor1_code=0
DI_trim_code=0
LUT_code = 0
LundyuLED_code=0
caled_temp_point=50



Pixel_Current_uA = 0
Duty_cycle = 0.0459
best_voltage = 0--Bandgap校准值
raw_values = {}--efuse缓存值


bit8 = (DAC_calibration_code >> 8) & 0x01
byte_low = DAC_calibration_code & 0xFF
DAC_cal_buf = {
            0x72,   --1stP
            0x10,   --2ndP
            0x10,   --3rdP
            0x10,   --4thP
            0x20,   --5thP
            0x10,   --6thP
            0x10,   --7thP
            0x25,   --8thP
            0x0A,   --9thP
            0x0A,   --10thP
            0x03,   --11thP
            0x11,   --12thP
            0x20,   --13thP
            bit8,   --14thP  PBIAS_IPXL_TRIM[8]
            byte_low,--15thP  PBIAS_IPXL_TRIM[7:0]
            0x08,   --16thP
            0x08,   --17thP
            0x10,   --18thP
            0x00,   --19thP
            0x00,   --20thP
            0x00,   --21thP
            0x00,   --22thP
            0x00,   --23thP
            0x00,   --24thP
            0x20,   --25thP
            0x20,   --26thP
            0x20,   --27thP
            0x20,   --28thP
            0x88,   --29thP
            0x02,   --30thP
            0x00,   --31thP
            0x02,    --32thP
            0x00,	 --33thp
            0x00	 --34thp
        }
        
Temperature_TRIM_buf = {
			0x72,   --1stP
            0x10,   --2ndP
            0x10,   --3rdP
            0x10,   --4thP
            0x20,   --5thP
            0x10,   --6thP
            0x10,   --7thP
            0x25,   --8thP
            0x0A,   --9thP
            0x0A,   --10thP
            0x03,   --11thP
            0x11,   --12thP
            0x20,   --13thP
            0x01,   --14thP  PBIAS_IPXL_TRIM[8]
            0x00,--15thP  PBIAS_IPXL_TRIM[7:0]
            0x08,   --16thP
            0x08,   --17thP
            0x10,   --18thP
            0x00,   --19thP
            0x00,   --20thP
            0x00,   --21thP
            0x00,   --22thP
            0x00,   --23thP
            0x00,   --24thP
            0x20,   --25thP
            0x20,   --26thP
            0x20,   --27thP
            0x20,   --28thP
            0x88,   --29thP
            TSL_TRIM_High,   --30thP TSL_TRIM_TARGET[9:8]
            TSL_TRIM_Low,   --31thP	TSL_TRIM_TARGET[7:0]
            TSR_TRIM_High,    --32thP TSR_TRIM_TARGET[9:8]
            TSR_TRIM_Low,	 --33thp  TSR_TRIM_TARGET[7:0]
            0x00	 --34thp
}


function datalog_results(tittle, tb)
	println("%s: \n{",tittle)
	for k,v in pairs(tb) do
		println("%s = %s",k,v)

	end
	println("}")
end

function Set_TEST_MODE(Test_Mode)
	if Test_Mode=="MT" or Test_Mode=="CP2" then
		TEST_MODE=Test_Mode
		LOG.DEBUG("Test Mode:"..Test_Mode)
	else
		TEST_MODE="MT"
		LOG.DEBUG("Test Mode:"..Test_Mode)
	end

	RestInit()
	Set_IO_TEST_MODE()
end


--[[
Function: Power_Shorts_Test
Desc: Pinot power pin short test using PPMU. Apply low voltage and clamp current to detect short circuit.
Input:
    Volt    : Test voltage(mV). Nil for default parallel mode.
    delay   : Stabilize delay(ms). Nil for default parallel mode.
    pinlist : Channel list table. Nil for default parallel mode.
Return:
    0       : Function execute status, 0 = success
    Power_name : Json string of power rail names
    voltage    : Json string of measured voltage array
    current    : Json string of measured current array(mA)
--]]
function Power_Shorts_Test(Volt, delay, pinlist)
	-- 1. Set all IO to 0V.
	-- 2. Set all positive power supply pins to 0.1V, AVEE to –0.1V and all clamp to 10mA 
	local result_table ={}
	local Power_name={}
	local voltage={}
	local current={}
	
	if Volt==nil or delay==nil or pinlist==nil then
		local VOLTAGE_VALUE = 100 --mV
		local VOLTAGE_CLAMP = 200 --mV
		local CURRENT_CLAMP = 20*1000*1000 --nA
		local UNDER_VOLTAGE_PROTECTIVE = 0 --mV
		local UNDER_CURRENT_PROTECTIVE = 0  --mV
		--local result_table ={}
		local VQPS_DATA_VOLTAGE = 0.0
		local VDD10_DATA_VOLTAGE = 0.0
		local VDD18_DATA_VOLTAGE = 0.0
		local AVEE_DATA_VOLTAGE = 0.0
		local AVDD18_DATA_VOLTAGE = 0.0 --20251222 add
		
		local VQPS_DATA_CURRENT = 0.0
		local VDD10_DATA_CURRENT = 0.0
		local VDD18_DATA_CURRENT = 0.0
		local AVEE_DATA_CURRENT = 0.0
		local AVDD18_DATA_CURRENT = 0.0 --20251222 add

		PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NC)
		--PPMU.RELAY_CLOSE(CHANNEL_TAB.GPIO6_A)
		--PPMU.RELAY_CLOSE(CHANNEL_TAB.GPIO7_A)
    
		PPMU.RELAY_CLOSE(CHANNEL_TAB.VQPS_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.VDDIO_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.DVDD_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.AVEE1_OUT)

		PPMU.RELAY_CLOSE(CHANNEL_TAB.AVDD_OUT)
			POWER.MULTI_SET(
		    { channel = P_VQPS,			en=1, range = 0x85, mode = 0, vol = 200, ovp = 300, uvp = 0, ocp = 200*1000*100, ucp = 0 },
		    { channel = P_VDD18,		en=1, range = 0x85, mode = 0, vol = 150, ovp = 250, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_VDD10,		en=1, range = 0x85, mode = 0, vol = 100, ovp = 580, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_AVDD18,		en=1, range = 0x85, mode = 0, vol = 100, ovp = 250, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_AVEE,			en=1, range = 0x85, mode = 0, vol = -100, ovp = 200, uvp = 0, ocp = 200*1000*80,  ucp = 0 }
			)
		

		TIME.DELAY(300)
		--3. Measure & Report current at VDD10,VDD18,AVEE,VQPS
		VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT=POWER.VOL_CUR(P_VQPS)
		VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT=POWER.VOL_CUR(P_VDD18)
		VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT=POWER.VOL_CUR(P_VDD10)
		AVDD18_DATA_VOLTAGE,AVDD18_DATA_CURRENT=POWER.VOL_CUR(P_AVDD18)--20251222add
		AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)
		
		VQPS_DATA_CURRENT  = VQPS_DATA_CURRENT/1e6
		VDD10_DATA_CURRENT = VDD10_DATA_CURRENT/1e6
		VDD18_DATA_CURRENT = VDD18_DATA_CURRENT/1e6
		AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
		AVDD18_DATA_CURRENT = AVDD18_DATA_CURRENT/1e6--20251222add
		
		POWER_OFF()
		
		LOG.INFO(string.format("VQPS_DATA :%.4fV, %.4fmA",VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT))
		LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
		LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
		LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
		LOG.INFO(string.format("AVDD18_DATA :%.4fV, %.4fmA",AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT))--20251222add
		
		table.insert(result_table,VQPS_DATA_CURRENT)
		table.insert(result_table,VDD10_DATA_CURRENT)
		table.insert(result_table,VDD18_DATA_CURRENT)
		table.insert(result_table,AVEE_DATA_CURRENT)
		table.insert(result_table,AVDD18_DATA_CURRENT)--20251222add
		
		Power_name=cjson.encode({"VPQS","VDD18","VDD10","AVEE","AVDD18"})
		LOG.INFO(Power_name)
		voltage=cjson.encode({VQPS_DATA_VOLTAGE,VDD18_DATA_VOLTAGE,VDD10_DATA_VOLTAGE,AVEE_DATA_VOLTAGE,AVDD18_DATA_VOLTAGE})
		LOG.INFO(voltage)
		current=cjson.encode({VQPS_DATA_CURRENT,VDD18_DATA_CURRENT,VDD10_DATA_CURRENT,AVEE_DATA_CURRENT,AVDD18_DATA_CURRENT})
		LOG.INFO(current)
	else
		local VOLTAGE_VALUE = Volt
		local delaytime = delay
		--local power_pchannel = pinlist
		local VOLTAGE_CLAMP = 200 --mV
		local CURRENT_CLAMP = 20*1000*1000 --nA
		local DATA_VOLTAGE = 0.0
		local DATA_CURRENT = 0.0
		for k,v in pairs(pinlist) do
			POWER_CHANNEL_VALUE(v, ON,VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
			TIME.DELAY(delaytime)
			
			DATA_VOLTAGE, DATA_CURRENT=POWER.VOL_CUR(v)
			DATA_CURRENT  = DATA_CURRENT/1e6
			LOG.INFO(string.format("CHANNLE:%d,VQPS_DATA :%.4fV, %.4fmA",v,DATA_VOLTAGE, DATA_CURRENT))
			table.insert(result_table,DATA_CURRENT)
			
			POWER_CHANNEL_VALUE(v, OFF,VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
		end
		
		
	end
	
	--local json_data = cjson.encode(result_table)
	--LOG.INFO(json_data)
	return 0,Power_name,voltage,current
end


--[[
Function: IO_Continuity_Test
Desc: Pinot IO continuity test by PPMU. Force +/- current and measure voltage to check open/short.
Input:
    current : Test current(uA). Nil for default full pin test.
    delay   : Stabilize delay(ms). Nil for default full pin test.
    pinlist : Target pin channel. Nil for default full pin test.
Return:
    0       : Success
    pin_table: Json of pin name list
    current_table: Json of forced current list
    voltage_table: Json of measured voltage list
    Return 1 if NG found(OPEN/CLOSE/NG keyword in voltage result)
--]]
function IO_Continuity_Test(current, delay, pinlist)
	--Test Sequence
	--1. Set all power rail to 0V
	--2. Set all IO pin to GND.
	--3. For IO Pin (GPIO,TPAD,I2C, Reset, refclk):
	--a. Connect one pin to PMU, Force 200uA, clamp 1.5V report voltage. Exp pass range(0.2~1.1V)
	--b. Force –200uA, CLAMP -1.5v, report voltage. Exp pass range(-0.2~-1.1V)
	--c. Connect this pin back to GND
	local result_table = {}
	local result_table1 = {}
	--20251226 add
	local pin_table={} 
	local voltage_table={} 
	local current_table={} 
	--20251226 add
	POWER_OFF()
	
	TIME.DELAY(100)
	if current==nil or delay==nil or pinlist==nil then
		local curent = {-200 , 200}
		
		pin_table,current_table,voltage_table = PPMU_IO_CHANNEL_TEST(curent,delay)
	
	else
		--local curent = -100
		
			

				local ioname=""
				for k,v in pairs(IO_PPMU_CHANEL_negative) do
					if pinlist == v.PinNo then
						ioname = v.PinName
		
					end
					--LOG.INFO(string.format("no:%d",k))	
				end

				result_table1 = PPMU_IO_CHANNEL_TEST_Customize(b,pinlist,ioname,delay)
				table.insert(result_table,result_table1)
			
		
	end
	
	--20251226 ADD
	pin_table = cjson.encode(pin_table)
	LOG.INFO(pin_table)
	current_table=cjson.encode(current_table)
	LOG.INFO(current_table)
	voltage_table=cjson.encode(voltage_table)
	LOG.INFO(voltage_table)
	--20251226 ADD	
	
	if voltage_table:find("OPEN") or voltage_table:find("CLOSE") or voltage_table:find("NG") then
		LOG.ERROR("PPMU_IO_TEST NG")
		return 1,voltage_table
	end
	return 0,pin_table,current_table,voltage_table
	
end
--GPIO3_A_SET(0) 
function MIPI_Communication_Test()
	LOG.DEBUG("<MIPI_Communication_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}
	
	--PPMU.CAL_EN(1)
   	--PPMU.CAL_EN(0)    --5V on
	--DMIPI.VID()
	--DMIPI.CMD()
	DMIPI.LP()
	--DMIPI.HS()
	--TIME.DELAY(500)
	for k, v in ipairs(test_data) do
		F_MIPI_WRITE(0xEF, v)
		TIME.DELAY(50)
		local read_data = IIC_R_Tab2(0xEF,4)
		--TIME.DELAY(50)
		--local read_data = F_READ_FOR_MIPI(0xEF, 4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(data_table,hex_str)
		if v ~= read_data then
			LOG.ERROR("IIC read NG")
			ret = -1
		end
	end
	
	--data_table = 0xAAAAAAAA
	--hex_str = string.format("0x%08X",data_table)
	local json_data = cjson.encode(data_table)
	--LOG.INFO(json_data)
	--local json_data = cjson.encode(data_table)
	
	LOG.INFO(json_data)
	return ret,json_data
	
end



function concat_bits(fields,min_len)
    local bin_str = ""
    -- 从后往前拼：timestamp(最高位) → code(最低位)
    for i = #fields, 1, -1 do
        local val = fields[i]
        --local bits = get_bit_length(val)
        bin_str = bin_str .. toBinary_crc(val, min_len[i])
    end
    return bin_str, #bin_str
end


function toBinary_crc(n, min_len)
    min_len = min_len or 1
    if n == 0 then 
        return string.rep("0", min_len) 
    end
    local bin = ""
    while n > 0 do
        bin = (n % 2) .. bin
        n = math.floor(n / 2)
    end
    -- 强制补齐前导0，保证位数不丢
    if #bin < min_len then
        bin = string.rep("0", min_len - #bin) .. bin
    end
    return bin
end



--[[
Function: I2C_Communication_Test
Desc: I2C communication read/write test. Write pattern data to register 0x00EF then readback to verify.
Input: None
Return:
    ret        : 0 = test complete
    json_data  : Json string of readback data
--]]
function I2C_Communication_Test()
	LOG.DEBUG("<I2CCommunication_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}
	local original_slave_addr = IIC_CONFIG.SLAVE_ADDR 
	
	for i=1,#IIC_SLAVE_ADDR_TAB do 
		IIC_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
		I3C_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
    	IIC_CONFIG.init_default()
    	data_table={}
    	LOG.DEBUG(string.format("0x%X",IIC_CONFIG.SLAVE_ADDR))
    	local pass = true 
    	for k, v in ipairs(test_data) do
        	IIC_W_Tab2(0x00EF, v)
        	local read_data = IIC_R_Tab2(0xEF,4)
        	local hex_str = string.format("0x%08X",read_data)
        	println(hex_str)
        	table.insert(data_table,hex_str)

        	if v ~= read_data then
           		LOG.ERROR("IIC read NG")
            	pass = false 
            	break
        	end
    	end

    	if pass then
    	    break
    	else
    		data_table={0X0,0X0,0X0,0X0}
    	end
	end
	
	IIC_CONFIG.SLAVE_ADDR = original_slave_addr 
	LOG.INFO(string.format("0x%08X",IIC_CONFIG.SLAVE_ADDR))
	--POWER_OFF() --20251223 add
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end


function reverse8(x)
    local result = 0
    for i = 0, 7 do
        local bit = (x >> i) & 1
        result = result | (bit << (7 - i))
    end
    return result
end
	

 
--file_id=ChannelID+100
function F_Save_CSV(channel_id, target_res)
     local Y = os.date("%Y")
    local MON = os.date("%m", os.time())
    local D = os.date("%d", os.time())
    local timestamp = os.date("%H%M%S")
    local file_type = "csv"
    local file_name = string.format("C:\\FVMI_4.29_20mV\\%s\\%s\\%s\\CH%s\\ohm_%s_%s_smuCV.csv", Y, MON, D, channel_id, target_res,timestamp)
    local head_Str = "target_ohm,SMU_V(V),SMU_C(uA)\n"
    LOG.CREAT_FILE(file_id..","..file_type..","..file_name..","..head_Str)
    LOG.INFO("CSV文件已创建："..file_name)
end

function Update_CSV(data)
    LOG.WRITE_FILE(string.format("%s,%s", file_id, data))
end


function Average_current_power(power_channel)
	--TIME.DELAY(10)
	local VOLTAGE,CURRENT=POWER.VOL_CUR(power_channel)
	return VOLTAGE,CURRENT
end

--I3C_Communication_Test()
function I3C_Communication_Test()
	LOG.DEBUG("<I3CCommunication_Test>")
	
	local ret = 0
	local data_table = {}
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}	

	I3C_INIT()

	TIME.DELAY(200)
	for k, v in ipairs(test_data) do
		I3C_W_Tab2(0xEF, v)
		--TIME.DELAY(10)
		local read_data = I3C_R_Tab2(0xEf,4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(data_table,hex_str)
		if v ~= read_data then
			LOG.ERROR("I3C read NG")
			ret = -1 
		end
	end
	
	--IIC_CONFIG.init_default()
	
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end



function Average_current()
	local data_table={}
	local data=0
	for i=1,5,1 do
			TIME.DELAY(10)
			local VOLTAGE,CURRENT=POWER.VOL_CUR(6)
			--pixel_current=((math.abs(CURRENT)/1000)-(math.abs(darkcurrent)/1000))/(768*576*DutyCycle)
			table.insert(data_table,CURRENT)
			
	end
		table.sort(data_table)
		table.remove(data_table, 1)
		table.remove(data_table, #data_table)
		--LOG.INFO(#data_table)
		for i=1,#data_table,1 do
			data=data+data_table[i]
		end
		--LOG.INFO(#data_table)
		data=data/#data_table
		return data
end

--[[
Function: Power_Measurement
Desc: Single power rail voltage & current sampling. Remove max/min then calculate average.
Input:
    channel_name : Power rail name, support SMU1/SMU2/VQPS/VDDIO/DVDD/AVDD/AVEE1
Return:
    0           : Success; -1: invalid channel
    result_table: Json string of [avg_voltage, avg_current(mA)]
--]]
--Power_Measurement("VDDIO")
function Power_Measurement(channel_name)

	local result_table = {}
	local average_current_table = {}
	local average_voltage_table = {}
	local average_current = 0
	local average_voltage = 0
	local POWER_DATA_VOLTAGE = 0.0
	local POWER_DATA_CURRENT = 0.0
	local samples = 10
	
	local channel_map = {
		["SMU1"]  = 0,
		["SMU2"]  = 1,
		["VQPS"]  = 2,
		["VDDIO"] = 3,
		["DVDD"]  = 4,
		["AVDD"]  = 5,
		["AVEE1"] = 6
	}
	
	local ch_num = channel_map[channel_name]
	if ch_num == nil then	
		LOG.ERROR(string.format("ERROR: invalid channel name [%s]",tostring(channel_name)))
		return -1,nil
	end
	--TIME.DELAY(1000)
	for i = 1, samples do
		TIME.DELAY(30)
		VOLTAGE, CURRENT = POWER.VOL_CUR(ch_num)
		table.insert(average_current_table, CURRENT)
		table.insert(average_voltage_table, VOLTAGE)
		LOG.INFO(string.format("[%d]：%.15fA, %15fV", i, CURRENT, VOLTAGE))
    end
    table.sort(average_current_table)
    table.sort(average_voltage_table)
    table.remove(average_current_table, 1)
    table.remove(average_voltage_table, 1)
    table.remove(average_current_table, #average_current_table)
    table.remove(average_voltage_table, #average_voltage_table)
    for _, val in ipairs(average_current_table) do
        average_current = average_current + val
    end
    for _, val in ipairs(average_voltage_table) do
        average_voltage = average_voltage + val
    end
    average_current = average_current / #average_current_table
    average_voltage = average_voltage / #average_voltage_table
    LOG.INFO(string.format("%.3fA, %.3fV", average_current, average_voltage))
	
	POWER_DATA_VOLTAGE = average_voltage
	POWER_DATA_CURRENT  = average_current/1e6
	
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",POWER_DATA_VOLTAGE, POWER_DATA_CURRENT))
	table.insert(result_table,POWER_DATA_VOLTAGE)
	table.insert(result_table,POWER_DATA_CURRENT)
	
	result_table=cjson.encode(result_table)
	LOG.INFO(result_table)
	
	return 0,result_table
end


function AVEE_RANG_Setting(Avee_value)
	local avee_value=math.abs(Avee_value)
	local AVEE_RANG_GLBL=0
	local AVEE_RANG_DAC=0 
	if avee_value > 0 and avee_value < 3 then
		AVEE_RANG_GLBL=0
	elseif avee_value > 3 and avee_value < 3.5 then
		AVEE_RANG_GLBL=1
	elseif avee_value > 3.5 and avee_value < 4 then
		AVEE_RANG_GLBL=2
	end
	if avee_value > 0 and avee_value < 4 then
		AVEE_RANG_DAC=0
	elseif avee_value > 4 and avee_value < 5 then
		AVEE_RANG_DAC=1
	end
	return AVEE_RANG_GLBL,AVEE_RANG_DAC
end

--[[
	Function: bist_mode_swich_EN
	Desc:Set VPG Pattern
	Input:number en
--]]

--bist_mode_swich_EN(7,1)
function bist_mode_swich_EN(num,en)
	local run = 1
	if num == 1 then
		VPG_SetFlatField(255)
	elseif num == 2 then
		VPG_SetFlatField(0)
	elseif num == 3 then
		VPG_SetCheckerboard(255,16, 16)
	elseif  num == 5 then
		VPG_SetCheckerboard(255,32, 32)
	elseif  num == 7 then
		VPG_SetCheckerboard(255,64, 64)	
	elseif num == 8 then
		VPG_SetCheckerboard(0,64, 64)	-- Invert checkerboard
	else	
		run = 0
		LOG.INFO(string.format("run = 0"))
	end
	
	if run == 0 then
		if num >= 1 and num <= 24 then
			LOG.INFO(string.format("bist_mode_swich_EN: num = %d backup function", num))
		else
			LOG.ERROR(string.format("bist_mode_swich_EN: num = %d out of range[1~24]", num))
		end
		return -1
	end
	
	return 0

end

--[[
Function: VPG_9SQUARE_FRC
Desc: VPG pattern generator, generate 9 square cross pattern.
Input:
    cx : Cross center X coordinate
    cy : Cross center Y coordinate
    ox : Cross offset X
    oy : Cross offset Y
Return: None
--]]
--  VPG_9SQUARE_FRC(928, 736, 300, 300)
--  VPG_SetCheckerboard(255,128,128)
function VPG_9SQUARE_FRC(cx, cy, ox, oy)

	VPG_SetFlatField(255)
	TIME.DELAY(20)
    local data_buf = {
        -- 1st P: PG_SEL=5, PG_MODE_EN=1
        0xB1,
        -- 2nd ~ 20th 
        0xff,   -- 2 PG_SHADE
        0x00,   -- 3 PG_BAR_WIDTH[10:8]
        0x10,   -- 4 PG_BAR_WIDTH[7:0]
        0x00,   -- 5 PG_BLK_VSIZE[10:8]
        0x10,   -- 6 PG_BLK_VSIZE[7:0]
        0x00,   -- 7 PG_BLK_HSIZE[10:8]
        0x10,   -- 8 PG_BLK_HSIZE[7:0]
        0x02,   -- 9 PG_VLINE[10:8]
        0xE0,   --10 PG_VLINE[7:0]
        0x03,   --11 PG_HLINE[10:8]
        0xA0,   --12 PG_HLINE[7:0]
        0x00,   --13 PG_PAT_VSIZE[10:8]
        0x10,   --14 PG_PAT_VSIZE[7:0]
        0x00,   --15 PG_PAT_HSIZE[10:8]
        0x10,   --16 PG_PAT_HSIZE[7:0]
        0x00,   --17 PG_PAT_X[10:8]
        0x01,   --18 PG_PAT_X[7:0]
        0x00,   --19 PG_PAT_Y[10:8]
        0x01,   --20 PG_PAT_Y[7:0]
        0x01,   --21 PG_PAT_Y[7:0]
        0x01,   --22 PG_PAT_Y[7:0]
        0x01,   --23 PG_PAT_Y[7:0]
        0x01,   --24 PG_PAT_Y[7:0]
        0x01,   --25 PG_PAT_Y[7:0]
        0x01,   --26 PG_PAT_Y[7:0]
        0x01,   --27 PG_PAT_Y[7:0]
        0x01,   --28 PG_PAT_Y[7:0]

        -- 29~32 中心十字坐标（传入参数）
        (cx >> 8) & 0x07,  --29 PG_CROSS_CENTER_X[10:8]
        cx & 0xFF,          --30 PG_CROSS_CENTER_X[7:0]
        (cy >> 8) & 0x07,  --31 PG_CROSS_CENTER_Y[10:8]
        cy & 0xFF,          --32 PG_CROSS_CENTER_Y[7:0]

        -- 33~36 十字偏移量
        (ox >> 8) & 0x07,  --33 PG_CROSS_OFFSET_X[10:8]
        ox & 0xFF,          --34 PG_CROSS_OFFSET_X[7:0]
        (oy >> 8) & 0x07,  --35 PG_CROSS_OFFSET_Y[10:8]
        oy & 0xFF           --36 PG_CROSS_OFFSET_Y[7:0]
    }

    IIC_W_Tab2(0xF6, {0x00, 0x00, 0x3f})
    IIC_W_Tab2(0xFA, data_buf)

    LOG.INFO(string.format(
        "9Cross: CX=%d,CY=%d,OX=%d,OY=%d",
        cx, cy, ox, oy
    ))
end


--[[
Function: VPG_9POINT_FRC
Desc: VPG pattern generator, generate 9 point pattern.
Input:
    cx : Center X coordinate
    cy : Center Y coordinate
    ox : Offset X
    oy : Offset Y
Return: None
--]]

--VPG_9POINT_FRC(928, 736, 300, 300)
function VPG_9POINT_FRC(cx, cy, ox, oy)

	VPG_SetFlatField(255)
	TIME.DELAY(20)
    local data_buf = {
        -- 1st P: PG_SEL=5, PG_MODE_EN=1
        0x51,
        -- 2nd ~ 20th 
        0xff,   -- 2 PG_SHADE
        0x00,   -- 3 PG_BAR_WIDTH[10:8]
        0x10,   -- 4 PG_BAR_WIDTH[7:0]
        0x00,   -- 5 PG_BLK_VSIZE[10:8]
        0x10,   -- 6 PG_BLK_VSIZE[7:0]
        0x00,   -- 7 PG_BLK_HSIZE[10:8]
        0x10,   -- 8 PG_BLK_HSIZE[7:0]
        0x02,   -- 9 PG_VLINE[10:8]
        0xE0,   --10 PG_VLINE[7:0]
        0x03,   --11 PG_HLINE[10:8]
        0xA0,   --12 PG_HLINE[7:0]
        0x00,   --13 PG_PAT_VSIZE[10:8]
        0x10,   --14 PG_PAT_VSIZE[7:0]
        0x00,   --15 PG_PAT_HSIZE[10:8]
        0x10,   --16 PG_PAT_HSIZE[7:0]
        0x00,   --17 PG_PAT_X[10:8]
        0x01,   --18 PG_PAT_X[7:0]
        0x00,   --19 PG_PAT_Y[10:8]
        0x01,   --20 PG_PAT_Y[7:0]
        
 

        -- 21~24 中心十字坐标（传入参数）
        (cx >> 8) & 0x07,  --21 PG_CROSS_CENTER_X[10:8]
        cx & 0xFF,          --22 PG_CROSS_CENTER_X[7:0]
        (cy >> 8) & 0x07,  --23 PG_CROSS_CENTER_Y[10:8]
        cy & 0xFF,          --24 PG_CROSS_CENTER_Y[7:0]

        -- 25~28 十字偏移量
        (ox >> 8) & 0x07,  --25 PG_CROSS_OFFSET_X[10:8]
        ox & 0xFF,          --26 PG_CROSS_OFFSET_X[7:0]
        (oy >> 8) & 0x07,  --27 PG_CROSS_OFFSET_Y[10:8]
        oy & 0xFF           --28 PG_CROSS_OFFSET_Y[7:0]
    }

    IIC_W_Tab2(0xF6, {0x00, 0x00, 0x7f})
    IIC_W_Tab2(0xFA, data_buf)

    LOG.INFO(string.format(
        "9Cross: CX=%d,CY=%d,OX=%d,OY=%d",
        cx, cy, ox, oy
    ))
end


--[[
Function: EFuse_DieID_Read
Desc: Read EFuse area including DieID. Unlock efuse register, read 256 bytes data then lock.
Input: None
Return:
    1          : Return status
    json_data  : Json string of efuse raw byte array
--]]
 --EFuse_DieID_Read()
function EFuse_DieID_Read()

	local efuse_data = {}
	local val_table = {}
	VQPS(ON)
	TIME.DELAY(1000)

    IIC_W_Tab2(0xF0, 0x5A5A)  		--Level2 Key
    IIC_W_Tab2(0xF1, 0x5A5A)		--OTP(efuse) key
    IIC_W_Tab2(0xC0, {0x01,0x01})   --OTP(efuse) Control
    TIME.DELAY(5)

    IIC_W_Tab2(0xC0, 0x0000)

     val_table, efuse_data = IIC_R_Tab2(0xC1, 256)
  
     local json_data = cjson.encode(efuse_data)
     LOG.INFO(json_data)

    --for i = 1, #efuse_data do
        --println("efuse_data[%d]=%02X", i, efuse_data[i])
    --end

    IIC_W_Tab2(0xF0, 0xA5A5)		--Level2 Key
    IIC_W_Tab2(0xF1, 0xA5A5)		--OTP(efuse) key
    
    VQPS(OFF)

    return 1,json_data
end


--[[
Function: EFuse_write256bit
Desc: Write single byte to EFuse. Unlock EFuse, write data buffer and trigger program, then lock.
Input:
    offset : EFuse buffer index(start from 1)
    val    : Byte value to program
Return:
    1 : Function complete status
--]]
--IIC_R_Tab2(0xF1,2)
--EFuse_write256bit(16,0x56)
function EFuse_write256bit(offset, val)

	

  	local efuse_buf  = {}
  	for i = 1, 255 do
  		efuse_buf[i] = 0x00
  	end
  	efuse_buf[offset ] = val
  	VQPS(ON)
	TIME.DELAY(1000)
 
    IIC_W_Tab2(0xF0,  0x5A5A)
    IIC_W_Tab2(0xF1, 0x5A5A)
    IIC_W_Tab2(0xC1, efuse_buf)			--OTP User
    IIC_W_Tab2(0xC0, {0x02,0x00,0x00})
  

    TIME.DELAY(30)

    IIC_W_Tab2(0xC0, 0x0000)		--OTP(efuse) Control
    IIC_W_Tab2(0xF0, 0xA5A5)		--Level2 Key
    IIC_W_Tab2(0xF1, 0xA5A5)		--OTP(efuse) key
    
    VQPS(OFF)

    LOG.INFO(string.format("EFuse  ,offset %d set val=0x%02x",offset,val))
    return 1
end

--function DAC_2point_calibration()
    --local results = {}
     --PPMU.CAL_EN(1)    --5V off
     --TIME.DELAY(10)
	
	--GPIO6_A_SET(1)
	--GPIO3_A_SET(0)	
	--GPIO2_A_SET(1)
	
	--TIME.DELAY(50)
	
	--Power.ValueSetting.SMU2 = 0
     --SMU2(ON,0,0x82)
     --TIME.DELAY(1000)
     --local Vol, Current = POWER.VOL_CUR(P_SMU2)
     --LOG.INFO(string.format("Pre‑set Current:%f",Current))
     
    ---- 两个测试点
     --local test_points = {43, 341}
  	--IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	--IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	--IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
    --IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})
        
    --for idx, trim_val in ipairs(test_points) do
    --TIME.DELAY(1000)
        --LOG.INFO(string.format("===== Test PBIAS_IPXL_TRIM = %d =====", trim_val))

        --local bit8 = (trim_val >> 8) & 0x01
        --local byte_low = trim_val & 0xFF

        --local trim_buf = {
 
            --0x72,   --1stP
            --0x10,   --2ndP
            --0x10,   --3rdP
            --0x10,   --4thP
            --0x20,   --5thP
            --0x10,   --6thP
            --0x10,   --7thP
            --0x25,   --8thP
            --0x0A,   --9thP
            --0x0A,   --10thP
            --0x03,   --11thP
            --0x11,   --12thP
            --0x20,   --13thP
            --bit8,   --14thP  PBIAS_IPXL_TRIM[8]
            --byte_low,--15thP  PBIAS_IPXL_TRIM[7:0]
            --0x08,   --16thP
            --0x08,   --17thP
            --0x10,   --18thP
            --0x00,   --19thP
            --0x00,   --20thP
            --0x00,   --21thP
            --0x00,   --22thP
            --0x00,   --23thP
            --0x00,   --24thP
            --0x20,   --25thP
            --0x20,   --26thP
            --0x20,   --27thP
            --0x20,   --28thP
            --0x88,   --29thP
            --0x02,   --30thP
            --0x00,   --31thP
            --0x02,    --32thP
            --0x00,	 --33thp
            --0x00	 --34thp
            
        --}

        ----IIC_W_Tab2(0xF8, trim_buf)
        
        ----IIC_R_Tab2(0xF8, 34)
        --TIME.DELAY(1000)
        --local refVolt, leakageCurrent = POWER.VOL_CUR(P_SMU2)
        --dac_current=(leakageCurrent)/1000
        --LOG.INFO(string.format("trim=%d  Meas Current = %f", trim_val, dac_current))
        --table.insert(results, math.abs(dac_current))
    --end

	--SMU2(OFF,0,0x82)
	--PPMU.CAL_EN(0)

	--local json_data = cjson.encode(results)	
	--LOG.INFO(results)

    --return 0, json_data
--end
file_id = 100
function F_Save_DAC_CSV()
	local Y = os.date("%Y")
	local MON = os.date("%m", os.time())
	local D = os.date("%d", os.time())
	local H = os.date("%H", os.time())
	local M  = os.date("%M", os.time())
	local S = os.date("%S", os.time())
	local file_type="csv"
	local file_name=string.format("D:\\point_data\\%s\\%s\\%s\\CH%s\\dac_calibration_result.csv",Y,MON,D,ChannelID)
	local head_Str="Index,Trim_Value,DAC_Current(uA),\n"
	LOG.CREAT_FILE(file_id..","..file_type..","..file_name..","..head_Str)
end
function Update_DAC_CSV(line_str)
	LOG.WRITE_FILE(string.format("%s,%s",file_id,line_str))
end


--[[
Function: DAC_Full_Range_Calibration
Desc: DAC full range calibration. Sweep PBIAS_IPXL_TRIM to find trim code for target 5.2uA pixel current.
Input: None
Return:
    0          : Success status
    json_data  : Json array [best_trim, best_measured_current(uA)]
--]]
function DAC_Full_Range_Calibration()
    local results = {}
    local current_table = {}
    local best_trim = nil
    local best_diff = math.huge
    local target_uA = 5.2
    local best_current = nil
    local dac_current = 0
    local notFound = 0
    
    local tim1 = TIME.TICK()
	PPMU.CAL_EN(0)    --5V on
    GPIO6_A_SET(1)
	GPIO3_A_SET(0)	
	GPIO2_A_SET(1)

	IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})
	IIC_R_Tab2(0xFD, 3)
    --PPMU.CAL_EN(1)    --5V off
     
    TIME.DELAY(10)

	Power.ValueSetting.SMU2 = 0
    SMU2(ON,0,0x82)
    TIME.DELAY(1000)
    local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
    LOG.INFO(string.format("Pre?set Current:%f",leakageCurrent))
    
   	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
    IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})--ANALOGTEST
 
     TIME.DELAY(100)
     --IIC_W_Tab2(0xF7, {0x03, 0x00, 0x00,0x00, 0x00,0x00, 0x00})



    for trim_val = 0, 150 ,4 do
        LOG.INFO(string.format("===== Test PBIAS_IPXL_TRIM = %d =====", trim_val))

        local bit8 = (trim_val >> 8) & 0x01
        local byte_low = trim_val & 0xFF

        local trim_buf = {
            0x72,   --1stP
            0x10,   --2ndP
            0x10,   --3rdP
            0x10,   --4thP
            0x20,   --5thP
            0x10,   --6thP
            0x10,   --7thP
            0x25,   --8thP
            0x0A,   --9thP
            0x0A,   --10thP
            0x03,   --11thP
            0x11,   --12thP
            0x20,   --13thP
            bit8,   --14thP  PBIAS_IPXL_TRIM[8]
            byte_low,--15thP  PBIAS_IPXL_TRIM[7:0]
            0x08,   --16thP
            0x08,   --17thP
            0x10,   --18thP
            0x00,   --19thP
            0x00,   --20thP
            0x00,   --21thP
            0x00,   --22thP
            0x00,   --23thP
            0x00,   --24thP
            0x20,   --25thP
            0x20,   --26thP
            0x20,   --27thP
            0x20,   --28thP
            0x88,   --29thP
            0x02,   --30thP
            0x00,   --31thP
            0x02,    --32thP
            0x00,	 --33thp
            0x00	 --34thp
        }

        IIC_W_Tab2(0xF8, trim_buf)  --Trim 
        TIME.DELAY(100)
        
        IIC_R_Tab2(0xF8, 34)

    	
    	 local refVolt, measCurrent = POWER.VOL_CUR(P_SMU2)
    	 measCurrent = (measCurrent) /1000
        LOG.INFO(string.format("trim=%d  Meas Current = %f uA", trim_val, measCurrent))
        table.insert(current_table, {trim = trim_val, current = measCurrent})

 
        local diff = math.abs(math.abs(measCurrent) - target_uA)
        if diff < best_diff then
            best_diff = diff
            best_trim = trim_val
            best_current = measCurrent
            DAC_calibration_code = trim_val
            println("[%02d] DAC best current out:%.4fuA",best_trim,best_current)
        end
    
            
    end

    SMU2(OFF,0,0x82)
    PPMU.CAL_EN(1)
    
	--F_Save_DAC_CSV()
    --for i,data in ipairs(current_table) do
        --local line = string.format("%d,%d,%.4f,\n",i,data.trim,data.current)
        --Update_DAC_CSV(line)
    --end
    
    
    local tim2 = TIME.TICK()
    LOG.INFO("DAC_Full_range time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. "seconds")
    --IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})
   LOG.INFO(string.format("[%02d] DAC best current out:%.4fuA",best_trim,best_current))
    --LOG.INFO(string.format("Best trim code = %d, min diff = %f uA", best_trim, best_diff))

 	table.insert(results,best_trim)
	table.insert(results,best_current)
	--table.insert(results,notFound)
	--table.insert(results,leakageCurrent)
	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0,json_data
end

function DAC_Full_Range_Calibration_M()
    local results = {}
    local best_trim = nil
    local best_diff = math.huge
    local target_uA = 5.2
    local best_current = nil
    local dac_current = 0
    local notFound = 0

    GPIO6_A_SET(1)
	GPIO3_A_SET(0)	
	GPIO2_A_SET(1)

	IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00}) --ANALOGTEST
	IIC_R_Tab2(0xFD, 3)

    TIME.DELAY(10)

	Power.ValueSetting.SMU2 = 0
    SMU2(ON,0,0x02)
    TIME.DELAY(1000)
    local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
    LOG.INFO(string.format("Pre‑set Current:%f",leakageCurrent))
    
   	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
    IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})
    IIC_W_Tab2(0xF6, {0x01, 0x00})
    TIME.DELAY(100)

    for trim_val = 0, 511,4 do
        LOG.INFO(string.format("===== Test PBIAS_IPXL_TRIM = %d =====", trim_val))

        local bit8 = (trim_val >> 8) & 0x01
        local byte_low = trim_val & 0xFF

        local trim_buf = {
            0x72,   --1stP
            0x10,   --2ndP
            0x10,   --3rdP
            0x10,   --4thP
            0x20,   --5thP
            0x10,   --6thP
            0x10,   --7thP
            0x25,   --8thP
            0x0A,   --9thP
            0x0A,   --10thP
            0x03,   --11thP
            0x11,   --12thP
            0x20,   --13thP
            bit8,   --14thP  PBIAS_IPXL_TRIM[8]
            byte_low,--15thP  PBIAS_IPXL_TRIM[7:0]
            0x08,   --16thP
            0x08,   --17thP
            0x10,   --18thP
            0x00,   --19thP
            0x00,   --20thP
            0x00,   --21thP
            0x00,   --22thP
            0x00,   --23thP
            0x00,   --24thP
            0x20,   --25thP
            0x20,   --26thP
            0x20,   --27thP
            0x20,   --28thP
            0x88,   --29thP
            0x02,   --30thP
            0x00,   --31thP
            0x02,    --32thP
            0x00,	 --33thp
            0x00	 --34thp
        }

        IIC_W_Tab2(0xF8, trim_buf)  --TRIM
        TIME.DELAY(200)       
        IIC_R_Tab2(0xF8, 34)    	
    	local refVolt, measCurrent = POWER.VOL_CUR(P_SMU2)
    	measCurrent = (measCurrent) /1000
        LOG.INFO(string.format("trim=%d  Meas Current = %f uA", trim_val, measCurrent))
        table.insert(results, {trim = trim_val, current = measCurrent})


        local diff = math.abs(math.abs(measCurrent) - target_uA)
        if diff < best_diff then
            best_diff = diff
            best_trim = trim_val
            best_current = measCurrent
            println("[%02d] DAC best current out:%.4fuA",best_trim,best_current)
        end
    
            
    end

    SMU2(OFF,0,0x82)
    --PPMU.CAL_EN(0)
    --IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})
   LOG.INFO(string.format("[%02d] DAC best current out:%.4fuA",best_trim,best_current))
    --LOG.INFO(string.format("Best trim code = %d, min diff = %f uA", best_trim, best_diff))
 
 	--table.insert(results,DAC_cal_trim_step)
	--table.insert(results,best_current)
	--table.insert(results,notFound)
	--table.insert(results,leakageCurrent)
	
	--local json_data = cjson.encode(results)
	--LOG.INFO(json_data)
	return 0
end


--[[
Function: DAC_2point_calibration
Desc: DAC two-point calibration. Fix PBIAS_IPXL_TRIM, measure pixel current at GLBC=43 and GLBC=341, calculate linear coefficient I=k*GLBC+b, judge +/-5% spec.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [current@GLBC43(uA), current@GLBC341(uA)]
--]]
function DAC_2point_calibration()

	----------------------------------------------------------------
	-- 1. Constants
	----------------------------------------------------------------
	local CODE_A        = 43        -- GLBC code, V0.4 Pass/Fail 10
	local CODE_B        = 341       -- GLBC code, V0.4 Pass/Fail 11
	local CODE_MAX      = 511

	local IPXL_TOL_PCT  = 5         -- V0.4 criteria 10 / 11: +/-5% each

	-- *** PENDING META CONFIRMATION ***
	-- V0.4 only says "+/-5% of expected value" and never states the expected
	-- value anywhere. The two numbers below are derived from the p.23 data
	-- points GLBC=146 -> 3.0uA and GLBC=156 -> 3.2uA, which give the nominal
	-- line I(uA) = 0.02 * GLBC + 0.08. They are NOT quoted in the test plan.
	-- Replace directly once the official values are available.
	local EXPECT_A_uA   = 0.94      -- Code 43
	local EXPECT_B_uA   = 6.90      -- Code 341

	local SETTLE_MS     = 300
	local SMU_RANGE     = 0x02      -- auto range, matches the working Full Range
	local CUR_SIGN      = -1        -- SMU2 reads negative (sink); flip to compare

	-- PBIAS_IPXL_TRIM is held for the whole test and must not change
	local PBIAS = pbias_trim or PBIAS_IPXL_code or 256

	local results = {}
	PPMU.CAL_EN(0)

	LOG.INFO(string.format("===== DAC 2-Point : GLBC %d / %d, PBIAS_IPXL_TRIM fixed %d =====",
	         CODE_A, CODE_B, PBIAS))

	----------------------------------------------------------------
	-- 2. Local helpers
	----------------------------------------------------------------
	-- F8h 34-byte payload; only bytes 14/15 carry PBIAS_IPXL_TRIM
	local function make_trim_payload(trim_val)
		local bit8     = (trim_val >> 8) & 0x01
		local byte_low =  trim_val       & 0xFF
		return {
			0x72,   --1stP   OSC_FTRIM
			0x10,   --2ndP   VDC_VDDPHY_TRIM
			0x10,   --3rdP   VDC_VDDLP_TRIM
			0x10,   --4thP   VDC_VDDPLL_TRIM
			0x20,   --5thP   VDC_VREF_TRIM
			0x10,   --6thP   VDC_VDDA_TRIM
			0x10,   --7thP   VDC_VDDPXL_TRIM
			0x25,   --8thP   VDC_VEEA1P6_TRIM
			0x0A,   --9thP   VDC_VEEA1P2_TRIM
			0x0A,   --10thP  VDC_VEEA1_TRIM
			0x03,   --11thP  VDC_BGR_IBIAS / VDC_MAIN_IBIAS
			0x11,   --12thP  VDC_VT_IBIAS / VDC_LDO_IBIAS
			0x20,   --13thP  VDC_IREF_TRIM
			bit8,       --14thP  PBIAS_IPXL_TRIM[8]
			byte_low,   --15thP  PBIAS_IPXL_TRIM[7:0]
			0x08,   --16thP  PHY_TERM50_TRIM   must match Full Range exactly
			0x08,   --17thP  PHY_TERM80_TRIM
			0x10,   --18thP  PHY_BIAS_TRIM
			0x00,   --19thP  PHY_OCALAP
			0x00,   --20thP  PHY_OCALAN
			0x00,   --21thP  PHY_OCALBP
			0x00,   --22thP  PHY_OCALBN
			0x00,   --23thP  PHY_OCALCP
			0x00,   --24thP  PHY_OCALCN
			0x20,   --25thP  TSL_TOP_TRIM
			0x20,   --26thP  TSR_TOP_TRIM
			0x20,   --27thP  TSL_BOT_TRIM
			0x20,   --28thP  TSR_BOT_TRIM
			0x88,   --29thP  TSR_BGR_TRIM / TSL_BGR_TRIM
			0x02,   --30thP  TSL_TRIM_TARGET[9:8]
			0x00,   --31thP  TSL_TRIM_TARGET[7:0]
			0x02,   --32thP  TSR_TRIM_TARGET[9:8]
			0x00,   --33thP  TSR_TRIM_TARGET[7:0]
			0x00    --34thP  TRIM_DUM1
		}
	end

	-- F6h VDC GLBC: 3 parameters
	local function set_glbc(code)
		IIC_W_Tab2(0xF6, {0x00, (code >> 8) & 0x01, code & 0xFF})
		IIC_W_Tab2(0xF4, {0x01})    -- Update, per IC.lua:212 / _debug2.lua:35
	end

	----------------------------------------------------------------
	-- 3. Power up and measurement path
	--    (sequence matches the Full Range function that is known to work)
	----------------------------------------------------------------
	GPIO6_A_SET(1)    -- PG_GPIO5 -> X_CBIT3 = 1
	GPIO3_A_SET(0)    -- PG_GPIO2 -> X_CBIT2 = 0
	GPIO2_A_SET(1)    -- PG_GPIO1 -> X_CBIT1 = 1   -> U3 Y5 = AMON

	IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})   -- clear FDh first
	IIC_R_Tab2(0xFD, 3)

	-- Do NOT switch 5V off: the CBIT relay coils (K11/K12) run on 5V_A
	--PPMU.CAL_EN(1)    --5V off
	TIME.DELAY(10)

	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 0, SMU_RANGE)
	TIME.DELAY(1000)

	local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("Pre-set (leakage) Current: %f nA", leakageCurrent))

	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a})    -- Level2 Key
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})    -- OTP Key
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})    -- third key

	-- FDh per the test plan's s25m11_otp_ipxl_0420().
	-- Measured: 0x02 and 0x12 behave identically here.
	IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})
	TIME.DELAY(100)

	-- Write PBIAS_IPXL_TRIM once and hold it. Equivalent to the Pequin step
	-- "Apply calibrated trim value to bandgap".
	IIC_W_Tab2(0xF8, make_trim_payload(PBIAS))
	TIME.DELAY(SETTLE_MS)

	----------------------------------------------------------------
	-- 4. Measure: only GLBC changes
	----------------------------------------------------------------
	local function measure_at_glbc(code, tag)
		set_glbc(code)
		TIME.DELAY(SETTLE_MS)
		local refVolt, measCurrent = POWER.VOL_CUR(P_SMU2)
		local cur_uA = CUR_SIGN * (measCurrent - leakageCurrent) / 1000
		LOG.INFO(string.format("%s GLBC=%3d  I = %.4f uA", tag, code, cur_uA))
		return cur_uA
	end

	local curA_uA = measure_at_glbc(CODE_A, "[point A]")
	local curB_uA = measure_at_glbc(CODE_B, "[point B]")

	-- Read F6h back to confirm the GLBC write landed (3 bytes)
	IIC_R_Tab2(0xF6, 3)

	----------------------------------------------------------------
	-- 5. Tear down
	----------------------------------------------------------------
	SMU2(OFF, 0, SMU_RANGE)
	GPIO2_A_SET(0)
	GPIO3_A_SET(0)
	GPIO6_A_SET(0)

	----------------------------------------------------------------
	-- 6. Solve I = k * GLBC + b
	----------------------------------------------------------------
	local k_uA = (curB_uA - curA_uA) / (CODE_B - CODE_A)
	local b_uA =  curA_uA - k_uA * CODE_A
	local fs_uA = k_uA * CODE_MAX + b_uA

	LOG.INFO(string.format("k = %.2f nA/code, b = %.1f nA, full scale @%d = %.3f uA",
	         k_uA * 1000, b_uA * 1000, CODE_MAX, fs_uA))

	-- Sanity check on the ratio of the two points. Expected 6.90/0.94 = 7.34.
	-- A ratio near 1 means the GLBC write had no effect, or GLBC is not on
	-- this monitor path; k / b / Pass-Fail below would all be meaningless.
	local ratio = (curA_uA ~= 0) and (curB_uA / curA_uA) or 0
	LOG.INFO(string.format("Sanity: I(341)/I(43) = %.2f  (expect ~7.34)", ratio))
	if math.abs(ratio - 1) < 0.2 then
		LOG.ERROR("2Point sanity FAIL: two points nearly identical -> GLBC write not effective")
	end

	----------------------------------------------------------------
	-- 7. Pass / Fail (V0.4 criteria 10 / 11)
	----------------------------------------------------------------
	local tolA_uA = EXPECT_A_uA * IPXL_TOL_PCT / 100
	local tolB_uA = EXPECT_B_uA * IPXL_TOL_PCT / 100

	local passA = (math.abs(curA_uA - EXPECT_A_uA) <= tolA_uA) and 1 or 0
	local passB = (math.abs(curB_uA - EXPECT_B_uA) <= tolB_uA) and 1 or 0

	LOG.INFO(string.format("Point A: %.4f uA  expect %.3f +/- %.3f  -> %s",
	         curA_uA, EXPECT_A_uA, tolA_uA, (passA == 1) and "PASS" or "FAIL"))
	LOG.INFO(string.format("Point B: %.4f uA  expect %.3f +/- %.3f  -> %s",
	         curB_uA, EXPECT_B_uA, tolB_uA, (passB == 1) and "PASS" or "FAIL"))

	if passA == 0 then LOG.ERROR("2Point criteria 10: current at Code 43 out of +/-5%")  end
	if passB == 0 then LOG.ERROR("2Point criteria 11: current at Code 341 out of +/-5%") end

	-- Criterion 12 "Linearity error exceeds specification": not judged.
	--   (a) V0.4 gives no number; the "specification" is blank
	--   (b) Two points cannot yield an INL figure - any two points define a
	--       perfect straight line, so the residual is always zero
	--   k / b are still computed and datalogged; add a verdict once the
	--   design team supplies a limit.
	LOG.INFO("Criteria 12 (linearity): no spec value given, not judged. k/b datalogged only.")

	----------------------------------------------------------------
	-- 8. Cache globals for eFuse and downstream back-calculation
	----------------------------------------------------------------
	IPXL_2P_POINTA_nA = curA_uA * 1000
	IPXL_2P_POINTB_nA = curB_uA * 1000
	IPXL_2P_K_nA      = k_uA * 1000
	IPXL_2P_B_nA      = b_uA * 1000
	IPXL_2P_PBIAS     = PBIAS

	----------------------------------------------------------------
	-- 9. Datalog
	--    RESULT ORDER:
	--      [1] PBIAS_IPXL_TRIM used
	--      [2] I @ GLBC 43   (uA)   <-- to be eFused
	--      [3] I @ GLBC 341  (uA)   <-- to be eFused
	--      [4] k             (nA/code)
	--      [5] b             (nA)
	--      [6] Pass Point A  (1/0)
	--      [7] Pass Point B  (1/0)
	----------------------------------------------------------------
	--table.insert(results, PBIAS)
	table.insert(results, curA_uA)
	table.insert(results, curB_uA)
	--table.insert(results, k_uA * 1000)
	--table.insert(results, b_uA * 1000)
	--table.insert(results, passA)
	--table.insert(results, passB)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)

	-- Existing convention returns 0 unconditionally. If the harness treats
	-- non-zero as fail, use:
	--   return (passA==1 and passB==1) and 0 or 1, json_data
	return 0, json_data
end


--[[
Function: Temperature_Sensor_Thermometer
Desc: Chip internal temperature sensor read function. Unlock register, configure left(TSL)/right(TSR) temperature sensor, read raw ADC code and convert to temperature.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [LeftTemp(℃), RightTemp(℃), TSL_RAW_CODE, TSR_RAW_CODE]
--]]
function Temperature_Sensor_Thermometer()
 
 	local results = {}
 	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a})    -- Level2 Key
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})    -- OTP Key
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})    -- third key
	
	--IIC_W_Tab2(0xFE, {0x02, 0x03}) 
	
	-- 温度控制寄存器配置
	IIC_W_Tab2(0xE0, {0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})  --Temperature Control
	IIC_W_Tab2(0xE0, {0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})	--Temperature Control
	IIC_W_Tab2(0xE0, {0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})	--Temperature Control
	--IIC_W_Tab2(0xE0,0x70)
	
	--Temperature_TRIM_buf[30]  = 0x1
	--Temperature_TRIM_buf[31]  = 0x55
	--Temperature_TRIM_buf[32]  = 0x1
	--Temperature_TRIM_buf[33]  = 0x55
	--IIC_W_Tab2(0xF8,Temperature_TRIM_buf)
	--IIC_R_Tab2(0xF8, 34)

    local _,readData = IIC_R_Tab2(0xE1, 4)
    -- rData[1] → 1st P: TSL_DATA_OUT[9:8]
    -- rData[2] → 2nd P: TSL_DATA_OUT[7:0]
    -- rData[3] → 3rd P: TSR_DATA_OUT[9:8]
    -- rData[4] → 4th P: TSR_DATA_OUT[7:0]
    local tsl_high = readData[1] & 0x03  -- 低2bit
    local tsl_low  = readData[2] & 0xFF
    local TSL_CODE = (tsl_high << 8) | tsl_low

    local tsr_high = readData[3] & 0x03  -- 低2bit
    local tsr_low  = readData[4] & 0xFF
    local TSR_CODE = (tsr_high << 8) | tsr_low


   local function Code2Temp(code)
        -- 292(-25℃) ~ 732(85℃)
        if code < 292 or code >732 then
            return nil
        end
        return -25 + (code - 292) * 0.25
    end

    local tempLeft = Code2Temp(TSL_CODE)
    local tempRight = Code2Temp(TSR_CODE)

    LOG.INFO(string.format("TSL_CODE = %d, Left Temp = %s ℃", TSL_CODE, tostring(tempLeft or "OutRange")))
    LOG.INFO(string.format("TSR_CODE = %d, Right Tmp = %s ℃", TSR_CODE, tostring(tempRight or "OutRange")))

 
    table.insert(results,tempLeft)
	table.insert(results,tempRight)
	table.insert(results,TSL_CODE)
	table.insert(results,TSR_CODE)

	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
   return 0,json_data

 end
 
--Set_Brightness(100) 
 function Set_Brightness(glbc_value)
 
 	local results = {}
 	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a})    -- Level2 Key
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})    -- OTP Key
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})    -- third key
	
	--IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xFF}) -- Pixel current to max
	--IIC_R_Tab2(0xF6,3)
	
	--IIC_W_Tab2(0xFA, {0x91, 0x00, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})
	--IIC_W_Tab2(0xFA, {0x91, 0xFF, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})
	
	local bit8 = (glbc_value >> 8) & 0x01
	local bit7_0  = glbc_value & 0xFF
	
	LOG.INFO(string.format("bit8 val:0x%X, bbit7_0 val:0x%X",bit8,bit7_0))
	IIC_W_Tab2(0xF6,{0x00,bit8,bit7_0})
	
	IIC_R_Tab2(0xF6,3)
	return 0
 end
 
 function F_CLK_IN_TEST()
 	--MCU.CHANNEL_LEVEL(2,1,1.80)--gpio 1.8V
	PPMU.PIXEL_IN(1)--CLK_OUT EN
	--PPMU.RELAY_EN(0x200)
	--PPMU.CAL_EN(0)
	--Pre_Clk=Real_Clk1
	local Real_Clk1 = DEDP.GET_FRQ(1)/1000000
	local Real_Clk2 = DEDP.GET_FRQ(2)/1000000
	
	
	local real1 = Real_Clk1 * 2
	local real2 = Real_Clk2 * 8

	LOG.DEBUG(string.format("CLK_MEASURE: ch1_real=%.3fMHZ, ch2_real=%3fMHZ", real1, real2))

	return real1
	
	--if (isInRange(Pre_Clk, Real_Clk1*2, 0.1)) then
		--LOG.DEBUG(string.format("CLK_IN1_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	--else
		--LOG.ERROR(string.format("CLK_IN1_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	--end
	
	--if (isInRange(Pre_Clk, Real_Clk2*8, 0.1)) then
		--LOG.DEBUG(string.format("CLK_IN2_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	--else
		--LOG.ERROR(string.format("CLK_IN2_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	--end
	--DEDP.SI5351_SET(64*1000*1000,5)--64M
	--return meas_freq_mhz

end


--[[
Function: Internal_Osc_trim
Desc: Internal oscillator trim calibration. Sweep OSC_FTRIM code, measure clock frequency, find the trim value closest to target 12.5MHz, then verify and judge PASS/FAIL.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [target_freq(MHz), best_osc_ftrim, best_meas_freq(MHz), final_verify_freq(MHz)]
--]]
function Internal_Osc_trim()
	local json_data = {}
	local results = {}
	local pass_fail_str
	
	local target_frequency = 12.5  -- Unit: MHz
	local freq_low_limit = 12.375
	local freq_high_limit = 12.625
	--local target_frequency = 386  -- Unit: MHz
	--local freq_low_limit = 381
	--local freq_high_limit = 391
	local best_frequency = 0
	local best_osc_ftrim = 0
	local min_diff = math.huge
	local pre_default_freq = 0
	
	--PPMU.CAL_EN(1)    --5V on
	--IIC_W_Tab2(0xFE, {0x1A, 0x00})
	IIC_W_Tab2(0xFE, {0x1A, 0x00})		--LOGICPTEST
	--IIC_W_Tab2(0xFE, {0x08, 0x00})
	--IIC_W_Tab2(0xFF, {0x03, 0x00})
	IIC_W_Tab2(0xFF, {0x03, 0x02})		--EDSTEST
	--IIC_R_Tab2(0xFF, 2)
	--IIC_R_Tab2(0xFE, 2)
	IIC_W_Tab2(0xF8, {0x80,0x10,0x10,0x10,0x20,0x10,0x10,0x25})

	
	TIME.DELAY(200)
	pre_default_freq = F_CLK_IN_TEST()
	LOG.DEBUG(string.format("pre_default_fpreq = %.5f",pre_default_freq))

	for osc_ftrim = 0, 0x32 do
		--reg_0xF8[1] = osc_ftrim
		IIC_W_Tab2(0xF8, {osc_ftrim,0x10,0x10,0x10,0x20,0x10,0x10,0x25})

		TIME.DELAY(200)
		IIC_R_Tab2(0xF8, 8)

		local measured_freq = F_CLK_IN_TEST()
		LOG.DEBUG(string.format("===OSC_TRIM = %d,measured_freq = %.5f",osc_ftrim,measured_freq))
		local diff = math.abs(measured_freq - target_frequency)
		if diff < min_diff then
			min_diff = diff
			best_frequency = measured_freq
			best_osc_ftrim = osc_ftrim
		end
	end
	LOG.DEBUG(string.format("***best_trim: %d, bset_fre: %.5f",best_osc_ftrim,best_frequency))

	-- Step9: Identify the trim code that produces the closest match to 12.5 MHz
	-- Step10: Write optimal trim code to register
	--IIC_W_Tab2(0xF8, best_osc_ftrim)
	TIME.DELAY(50)

	local final_verify_freq = F_CLK_IN_TEST()

	if final_verify_freq >= freq_low_limit and final_verify_freq <= freq_high_limit and best_osc_ftrim >=0 and best_osc_ftrim <=0xFF then
		pass_fail_str = "PASS"
	else
		pass_fail_str = "FAIL"
	end
	
	--table.insert(results, pass_fail_str)
	table.insert(results, target_frequency)
	--table.insert(results, pre_default_freq)
	table.insert(results, best_osc_ftrim)
	table.insert(results, best_frequency)
	table.insert(results, final_verify_freq)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	
	return 0, json_data
end


--  Set_Pixel_Current(0.68)
function Set_Pixel_Current(target_cur_uA)
	local i_amp = target_cur_uA * 1e-6
	local x =  (i_amp - 4e-9) / (2e-8)
	local glbc = math.floor(x)
	LOG.INFO(string.format("target_cur_uA: %.2f,glbc value = %d",target_cur_uA,glbc))
	
	--x range 0-511
	if glbc < 0 then glbc = 0 end
	if glbc > 511 then glbc = 511 end
	
	local bit8 = (glbc >> 8) & 0x01
	local bit7_0  = glbc & 0xFF
	LOG.INFO(string.format("bit8 val:0x%X, bbit7_0 val:0x%X",bit8,bit7_0))
	IIC_W_Tab2(0xF6,{0x00,bit8,bit7_0})		--VDC GLBC
	
	IIC_R_Tab2(0xF8,15)


end


function ConvertTo10BitBinary(num)
    -- 范围0 ~7.9921875
    if num < 0 then num = 0 end
    if num >= 8 then num = 7.9921875 end

    local raw_int = math.floor(num * 128)
    local bin_str = ""

    -- 从bit9循环到bit0
    for i = 9, 0, -1 do
        local bit = math.floor(raw_int / (2^i)) % 2
        bin_str = bin_str .. tostring(bit)
        --3bit整数结束，i==7，插入小数点
        if i == 7 then
            bin_str = bin_str .. "."
        end
    end
    return bin_str, raw_int
end


--Set_Duty_Cycle(0.1)
function Set_Duty_Cycle(target_duty)
	LOG.INFO(string.format("[Set_Duty_Cycle] INPUT target_duty = %.4f", target_duty))
    local BASE_DUTY = 0.3   -- EOTF_LUT默认30%@90Hz
	--local MAX_INT = 0x3FF
    -- 1.计算multi倍率
    local multi = target_duty / BASE_DUTY
	
    if multi < 0 then multi = 0 end
    if multi > 7.9921875 then multi =7.9921875 end
	LOG.INFO(string.format("[Set_Duty_Cycle] multi = %.4f",multi))	
    local bin_str, raw_int = ConvertTo10BitBinary(multi)

    -- PWM_TYP_MULTI_VAL[9:8] 高2bit；[7:0]低8bit
    local high2 = math.floor(raw_int / (2^8))   -- bit9 bit8
    local low8  =raw_int  % 256 -- bit7~bit0

    
  --IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40,high2,low8,0x00,0x00,0x00,0x00})  --PWM Timing Gen
 	IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x01,0x00,  0x01,0x00  ,0x01,0x00,0x00,0x00})  --PWM Timing Gen
    --E5為shadow register，需寫F4=01觸發Update才會生效（同IC.lua:133 / debug_mipi.lua:33）
    IIC_W_Tab2(0xE3, {0x01})
    IIC_W_Tab2(0xF4, {0x01})
  	
  	result = IIC_R_Tab2(0xE5,13)
  	LOG.INFO(string.format("[Set_Duty_Cycle] E5 read log", result))	
    LOG.INFO(string.format("[Set_Duty_Cycle] target=%.2f%%, multi=%.4f, raw=0x%03X, high2=0x%02X, low8=0x%02X, bin=%s",
        target_duty*100, multi, raw_int, high2, low8, bin_str))

 
    return multi, raw_int, high2, low8
end

function Bandgap_Trim()
	 local tim1 = TIME.TICK()
	 local target_voltage = 1.227
	 local best_trim = 0
	 local best_voltage = 0
	 local results = {}
	 local result_table = {}
	 
	IIC_W_Tab2(0xE0, {0x20,0x82,0x00,0x40,0x14,0x00,0x02,0xA0,0x02,0xA0,0x01,0xB0,0xCF,0x20})
	DisplayOff()
	TIME.DELAY(100)
	DisplayOn()
	--IIC_W_Tab2(0xFD, {0x80, 0x10, 0x11})
	IIC_W_Tab2(0xFD, {0x80, 0x00, 0x91})
	
	PPMU.CAL_EN(0)    --5V on
	--TIME.DELAY(10)
    --GPIO6_A_SET(0)
    --TIME.DELAY(10)
	--GPIO3_A_SET(1)
	--TIME.DELAY(10)
	--GPIO2_A_SET(0)

    GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)

    --TIME.DELAY(10)
    --Power.ValueSetting.DVDD = 800
    --DVDD(ON)
    
    --Power.ValueSetting.VDDIO = 2000
    --VDDIO(ON)

	--IIC_W_Tab2(0xE0, {0x20,0x82,0x00,0x40,0x14,0x00,0x02,0xA0,0x02,0xA0,0x01,0xB0,0xCF,0x20})
	IIC_R_Tab2(0xE0,14)
	IIC_R_Tab2(0xF2,2)
	IIC_W_Tab2(0xF2,{0x12,0x00})
	Power.ValueSetting.SMU2 = 0
    SMU2(ON,1,0x82)
    TIME.DELAY(1000)
    local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
    LOG.INFO(string.format("Preset Vol:%f",Vol))
    
    --IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0A,0x0A,0x3F,0x33,0x3F,0x01,0xFF})
    
    --IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x3F,0x10,0x10,0x25,0x0A,0x0A,0x03})
    for bgr_ibias = 0, 3 do
    	for main_ibias  = 0,15 do
    
		    --trim_byte = (trim_code << 4) | 0x08
		    --trim_byte = 0x80 | trim_code
		    --trim_byte = (trim_code << 4) | trim_code
		    --trim_byte = (trim_code << 4) | 0x03
		    --trim_byte = trim_code & 0x3F
		    trim_byte = (bgr_ibias << 4) | main_ibias
		    IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0A,0x0A,trim_byte})
		    	--0x11,0x20,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		    	--0x20,0x20,0x20,0x20,trim_byte})
		    LOG.INFO(string.format("trim_byte = 0x%x",trim_byte))
		    TIME.DELAY(200)
		    local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)
		    
		    --local average_voltage = 0
		    --for i =0, 10 do
		    	--TIME.DELAY(10)
		    	--local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)
		    	--average_voltage = average_voltage + measure_voltage
		    --end
		    --average_voltage = average_voltage / 11
		    
		    LOG.INFO(string.format("BGR_IBIAS = %d,VOL= %.6f",trim_byte,measure_voltage))
		    table.insert(result_table,measure_voltage)
		    if math.abs(measure_voltage - target_voltage) < math.abs(best_voltage - target_voltage) then
				best_voltage = measure_voltage
				best_trim = trim_byte
				LOG.INFO(string.format("best_voltage:%.6f",best_voltage))
			end
    
    	end
    end
    LOG.INFO(string.format("best_trim= %d, best_voltage:%.6f",best_trim,best_voltage))
    
    table.insert(result_table,best_voltage)
    table.insert(result_table,best_trim)
    local json_data = cjson.encode(result_table) 
    LOG.INFO(json_data)
    
    Power.ValueSetting.DVDD = 800
    DVDD(ON)
    PPMU.CAL_EN(1)
     GPIO6_A_SET(1)
	GPIO3_A_SET(0)	
	GPIO2_A_SET(1)
	TIME.DELAY(20)
    SMU2(OFF,0)
    --SMU2(OFF,0)
    --PPMU.CAL_EN(1)
    --TIME.DELAY(100)
    --GPIO6_A_SET(1)
    --TIME.DELAY(10)
	--GPIO3_A_SET(0)	
	--TIME.DELAY(10)
	--GPIO2_A_SET(1)
    
  
    
    return 0,json_data


end

function Bandgap_Trim_2()
	 local tim1 = TIME.TICK()
	 local target_voltage = 1.227
	 --local target_voltage = 1.183
	 local best_trim = 0
	 local best_voltage = 0
	 local results = {}
	 local result_table = {}
	 
	IIC_W_Tab2(0xE0, {0x20,0x82,0x00,0x40,0x14,0x00,0x02,0xA0,0x02,0xA0,0x01,0xB0,0xCF,0x20})
	DisplayOff()
	TIME.DELAY(100)
	DisplayOn()
	IIC_W_Tab2(0xFD, {0x80, 0x10, 0x11})
	--IIC_W_Tab2(0xFD, {0x80, 0x00, 0x91})
	
	PPMU.CAL_EN(0)    --5V on
	--TIME.DELAY(10)
    --GPIO6_A_SET(0)
    --TIME.DELAY(10)
	--GPIO3_A_SET(1)
	--TIME.DELAY(10)
	--GPIO2_A_SET(0)

    GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)

    --TIME.DELAY(10)
    --Power.ValueSetting.DVDD = 900
    --DVDD(ON)
    
    --Power.ValueSetting.VDDIO = 1900
    --VDDIO(ON)

	--IIC_W_Tab2(0xE0, {0x20,0x82,0x00,0x40,0x14,0x00,0x02,0xA0,0x02,0xA0,0x01,0xB0,0xCF,0x20})
	IIC_R_Tab2(0xE0,14)
	IIC_R_Tab2(0xF2,2)
	IIC_W_Tab2(0xF2,{0x12,0x00})
	Power.ValueSetting.SMU2 = 0
    SMU2(ON,1,0x82)
    TIME.DELAY(1000)
    local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
    LOG.INFO(string.format("Preset Vol:%f",Vol))
    
    --IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0A,0x0A,0x3F,0x33,0x3F,0x01,0xFF})
    
    --IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x3F,0x10,0x10,0x25,0x0A,0x0A,0x03})
    --for bgr_ibias = 0, 3 do
    	for trim_code  = 0,63 do
    
		    --trim_byte = (trim_code << 4) | 0x08
		    --trim_byte = 0x80 | trim_code
		    --trim_byte = (trim_code << 4) | trim_code
		    --trim_byte = (trim_code << 4) | 0x03
		    trim_byte = trim_code & 0x1F
		    --trim_byte = (bgr_ibias << 4) | main_ibias
		    IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0A,0x0A,trim_byte})
		    	--0x11,0x20,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		    	--0x20,0x20,0x20,0x20,trim_byte})
		    LOG.INFO(string.format("trim_byte = 0x%x",trim_byte))
		    TIME.DELAY(200)
		    local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)
		    
		    --local average_voltage = 0
		    --for i =0, 10 do
		    	--TIME.DELAY(10)
		    	--local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)
		    	--average_voltage = average_voltage + measure_voltage
		    --end
		    --average_voltage = average_voltage / 11
		    
		    LOG.INFO(string.format("BGR_IBIAS = %d,VOL= %.6f",trim_code,measure_voltage))
		    table.insert(result_table,measure_voltage)
		    if math.abs(measure_voltage - target_voltage) < math.abs(best_voltage - target_voltage) then
				best_voltage = measure_voltage
				best_trim = trim_code
				LOG.INFO(string.format("best_voltage:%.6f",best_voltage))
			end
    
    	end
    --end
    LOG.INFO(string.format("best_trim= %d, best_voltage:%.6f",best_trim,best_voltage))
    
    table.insert(result_table,best_voltage)
    table.insert(result_table,best_trim)
    local json_data = cjson.encode(result_table) 
    LOG.INFO(json_data)
    
    --Power.ValueSetting.DVDD = 800
    --DVDD(ON)
    
    --Power.ValueSetting.VDDIO = 1800
    --VDDIO(ON)
    PPMU.CAL_EN(1)
     GPIO6_A_SET(0)
	GPIO3_A_SET(1)	
	GPIO2_A_SET(0)
	TIME.DELAY(20)
    SMU2(OFF,0)
    --SMU2(OFF,0)
    --PPMU.CAL_EN(1)
    --TIME.DELAY(100)
    --GPIO6_A_SET(1)
    --TIME.DELAY(10)
	--GPIO3_A_SET(0)	
	--TIME.DELAY(10)
	--GPIO2_A_SET(1)
    
  
    
    return 0,json_data


end


-----done
function apply_DAC_calibration_code()
	println("apply_DAC_calibration_code")
	println("DAC_calibration_code:0x%X",DAC_calibration_code)
	IIC_W_Tab2(0xF8, DAC_cal_buf)
	println("Apply DAC_calibration_code:0x%08X",DAC_calibration_code)
end

--apply_DAC_CAL_code(10)
function apply_DAC_CAL_code(DAC_CAL_code)
	println("apply_DAC_CAL_code")
    DAC_calibration_code = DAC_CAL_code
	println("DAC_calibration_code:0x%X",DAC_calibration_code)
	IIC_W_Tab2(0xF8, DAC_cal_buf)
	println("Apply DAC_calibration_code:0x%08X",DAC_calibration_code)
end
------done



function apply_DI_trim_code()
	println("apply_DI_trim_code")
	println("DI_trim_code:0x%X",DI_trim_code)
	IIC_W_Tab2(0xDC, DI_trim_code)
	println("Apply DI_trim_code:0x%08X",DI_trim_code)
end

--apply_DAC_WORD_code(300)
function apply_DAC_WORD_code(DAC_WORD_code)
	println("apply_DAC_WORD_code")
	println("DAC_WORD_code:0x%X",DAC_WORD_code)
	IIC_W_Tab2(0xDC, DAC_WORD_code)
	println("Apply DAC_WORD_code:0x%08X",DAC_WORD_code)
end


--[[
Function: Temperature_Sensor_ADC
Desc: Read temperature sensor raw ADC code. Unlock register, configure TSL/TSR temperature sensor, only fetch raw 10bit code without converting to Celsius temperature.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [TSL_RAW_CODE, TSR_RAW_CODE]
--]]
function Temperature_Sensor_ADC()
	
		local results = {}
 	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a})    -- Level2 Key
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})    -- OTP Key
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})    -- third key
	
	IIC_W_Tab2(0xFE, {0x02, 0x03}) 
	
	-- 温度控制寄存器配置
	IIC_W_Tab2(0xE0, {0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})  --Temperature Control
	IIC_W_Tab2(0xE0, {0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})	--Temperature Control
	IIC_W_Tab2(0xE0, {0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F})	--Temperature Control
	--IIC_W_Tab2(0xE0,0x70)

    local _,readData = IIC_R_Tab2(0xE1, 4)
    -- rData[1] → 1st P: TSL_DATA_OUT[9:8]
    -- rData[2] → 2nd P: TSL_DATA_OUT[7:0]
    -- rData[3] → 3rd P: TSR_DATA_OUT[9:8]
    -- rData[4] → 4th P: TSR_DATA_OUT[7:0]
    local tsl_high = readData[1] & 0x03  -- 低2bit
    local tsl_low  = readData[2] & 0xFF
    local TSL_CODE = (tsl_high << 8) | tsl_low

    local tsr_high = readData[3] & 0x03  -- 低2bit
    local tsr_low  = readData[4] & 0xFF
    local TSR_CODE = (tsr_high << 8) | tsr_low


   --local function Code2Temp(code)
        ---- 292(-25℃) ~ 732(85℃)
        --if code < 292 or code >732 then
            --return nil
        --end
        --return -25 + (code - 292) * 0.25
    --end

    --local tempLeft = Code2Temp(TSL_CODE)
    --local tempRight = Code2Temp(TSR_CODE)

    --LOG.INFO(string.format("TSL_CODE = %d, Left Temp = %s ℃", TSL_CODE, tostring(tempLeft or "OutRange")))
    --LOG.INFO(string.format("TSR_CODE = %d, Right Tmp = %s ℃", TSR_CODE, tostring(tempRight or "OutRange")))

 
    --table.insert(results,tempLeft)
	--table.insert(results,tempRight)
	table.insert(results,TSL_CODE)
	table.insert(results,TSR_CODE)

	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
   return 0,json_data

end

--  PLLdivider
-- Set_PLL_Divider(5)
function Set_PLL_Divider(pll_div)

	--local plldiv_val = 0x50 + pll_div - 1
	IIC_W_Tab2(0xF3, {plldiv_val})

end
-- Set PWM timing 
function PWM_timing_from_Sapien_092326()
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

		IIC_W_Tab2(0xE3, {0x01}) --Content Monitor Off 
		IIC_W_Tab2(0xE4, {0x00,0x08,0x08,0x0B,0x14,0x00}) 	--System Clock <= 200MHz : PWM Pulse width (Min. PWM 400ns-CAP)
		IIC_W_Tab2(0xB4, {0x00,0x00,0x00,0x00}) 			--Image start position
		IIC_W_Tab2(0xF6, {0x00,0x00,0x7f}) 					--GLBC (Pixel Driver Current : 0.2uA) 
		IIC_W_Tab2(0xE5, {0x00,0x36,0xB0,0x02,0xBC}) 		--(Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK   

		 IIC_R_Tab2(0xE3,1)
		 IIC_R_Tab2(0xE4,6)
		 IIC_R_Tab2(0xB4,4)
		 IIC_R_Tab2(0xF6,3)
		 IIC_R_Tab2(0xE5,5)
		 IIC_W_Tab2(0xF4, {0x01}) --panel update

end
function PWM_timing_from_Sapien_092526()
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

		IIC_W_Tab2(0xE3, {0x01}) --Content Monitor Off 
		IIC_W_Tab2(0xE4, {0x00,0x08,0x08,0x0B,0x14,0x00}) 	--System Clock <= 200MHz : PWM Pulse width (Min. PWM 400ns-CAP)
		IIC_W_Tab2(0xB4, {0x00,0x00,0x00,0x00}) 			--Image start position
		IIC_W_Tab2(0xF6, {0x00,0x00,0x0A}) 					--GLBC (Pixel Driver Current : 0.2uA) 
		IIC_W_Tab2(0xE5, {0x00,0x36,0xB0,0x02,0xBC,0x00,0x40,0x00,0x80,0x01}) 		--(Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK, EOTF Bypass 
		VPG_SetFlatField(0)  --display on first picture  flat field

		 IIC_R_Tab2(0xE3,1)
		 IIC_R_Tab2(0xE4,6)
		 IIC_R_Tab2(0xB4,4)
		 IIC_R_Tab2(0xF6,3)
		 IIC_R_Tab2(0xE5,10)

		IIC_W_Tab2(0xF4, {0x01}) --panel update

end
function PWM_timing_from_Sapien_092826()
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

		IIC_W_Tab2(0xE3, {0x01}) --Content Monitor Off 
		IIC_W_Tab2(0xE4, {0x00,0x0a,0x0c,0x0e,0x18,0x00}) 	--System Clock <= 200MHz : PWM Pulse width (Min. PWM 400ns-CAP)
		IIC_W_Tab2(0xB4, {0x00,0x00,0x00,0x00}) 			--Image start position
		IIC_W_Tab2(0xF6, {0x00,0x00,0xff}) 					--GLBC (Pixel Driver Current : 0.2uA) 
		IIC_W_Tab2(0xE5, {0x00,0x36,0xB0,0x02,0xBC}) 		--(Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK, EOTF Bypass 
		VPG_SetFlatField(0)  --display on first picture  flat field

		 IIC_R_Tab2(0xE3,1)
		 IIC_R_Tab2(0xE4,6)
		 IIC_R_Tab2(0xB4,4)
		 IIC_R_Tab2(0xF6,3)
		 IIC_R_Tab2(0xE5,10)
		 
		 IIC_W_Tab2(0xF4, {0x01}) --panel update

end

function PWM_timing_debug_9square()
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key


		IIC_W_Tab2(0xE5, {0x00,0x2a,0x80,0x01,0x54,0x00,0x40,0x00,0x80,0x01}) 		--(Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK, EOTF Bypass 
		--VPG_SetFlatField(0)  --display on first picture  flat field

		IIC_W_Tab2(0xE4, {0x00,0x08,0x08,0x0b,0x15,0x00}) 	--System Clock <= 200MHz : PWM Pulse width (Min. PWM 400ns-CAP)
		IIC_W_Tab2(0xFA, {0x91,0x00})

		 IIC_R_Tab2(0xE4,6)
		 --IIC_R_Tab2(0xB4,4)
		 --IIC_R_Tab2(0xF6,3)
		 --IIC_R_Tab2(0xE5,10)
		  VPG_9SQUARE_FRC(928, 736, 400, 400)
		  
		  IIC_W_Tab2(0xF4, {0x01}) --panel update
end

--function PWM_timing_debug_case0()
		--IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		--IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		--IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key


		--IIC_W_Tab2(0xE5, {0x00,0x2a,0x80,0x01,0x54,0x00,0x40,0x00,0x80,0x01}) 		--(Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK, EOTF Bypass 
		----VPG_SetFlatField(0)  --display on first picture  flat field

		--IIC_W_Tab2(0xE4, {0x00,0x08,0x08,0x09,0x12,0x00}) 	--System Clock <= 200MHz : PWM Pulse width (Min. PWM 400ns-CAP)
		--IIC_W_Tab2(0xFA, {0x91,0xff})

		 --IIC_R_Tab2(0xE4,6)
		 ----IIC_R_Tab2(0xB4,4)
		 ----IIC_R_Tab2(0xF6,3)
		 ----IIC_R_Tab2(0xE5,10)
		 
		  ---- VPG_9SQUARE_FRC(928, 736, 300, 300)
		  
		  --IIC_W_Tab2(0xF4, {0x01}) --panel update
--end

-- 0xE4 / 0xFA settings per case, from the test-condition sheet
-- fields: fa = {2 bytes}, e4 = {6 bytes}, pat = VPG pattern gray level



-- Keep the original entry point working
function PWM_timing_debug_case0()
    PWM_timing_debug_case(0)
end-- 0xE4 / 0xFA settings per case, from the test-condition sheet
-- fields: fa = {2 bytes}, e4 = {6 bytes}, pat = VPG pattern gray level

PWM_CASES = {
  -- Test (1): T_nov1 sweep (T_PWMSET - T_CMPSET)
  [0]  = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x09,0x12,0x00}, pw=360, set=10, param="T_nov1",  pat=0   },
  [1]  = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0A,0x13,0x00}, pw=380, set=20, param="T_nov1",  pat=0   },
  [2]  = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0B,0x14,0x00}, pw=400, set=30, param="T_nov1",  pat=0   },
  [3]  = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x15,0x00}, pw=420, set=40, param="T_nov1",  pat=0   },
  [4]  = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0D,0x16,0x00}, pw=440, set=50, param="T_nov1",  pat=0   },

  -- Test (2): T_PCHGB sweep
  [5]  = { fa={0x91,0x80}, e4={0x00,0x03,0x03,0x07,0x10,0x00}, pw=320, set=30, param="T_PCHGB", pat=128 },
  [6]  = { fa={0x91,0x80}, e4={0x00,0x04,0x04,0x08,0x11,0x00}, pw=340, set=40, param="T_PCHGB", pat=128 },
  [7]  = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x09,0x12,0x00}, pw=360, set=50, param="T_PCHGB", pat=128 },
  [8]  = { fa={0x91,0x80}, e4={0x00,0x06,0x06,0x0A,0x13,0x00}, pw=380, set=60, param="T_PCHGB", pat=128 },
  [9]  = { fa={0x91,0x80}, e4={0x00,0x07,0x07,0x0B,0x14,0x00}, pw=400, set=70, param="T_PCHGB", pat=128 },
  [10] = { fa={0x91,0x80}, e4={0x00,0x08,0x08,0x0C,0x15,0x00}, pw=420, set=80, param="T_PCHGB", pat=128 },
  [11] = { fa={0x91,0x80}, e4={0x00,0x09,0x09,0x0D,0x16,0x00}, pw=440, set=90, param="T_PCHGB", pat=128 },

  -- Test (3): T_nov2 sweep (T_CMPSET - T_PCHGB)
  [12] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x15,0x00}, pw=340, set=0,  param="PWMSET",  pat=0   },
  [13] = { fa={0x91,0x00}, e4={0x00,0x08,0x09,0x0D,0x16,0x00}, pw=360, set=10, param="PWMSET",  pat=0   },
  [14] = { fa={0x91,0x00}, e4={0x00,0x08,0x0A,0x0E,0x17,0x00}, pw=380, set=20, param="PWMSET",  pat=0   },

  -- Test (4): T_PWMTPW sweep (black/white pairs)
  [15] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x10,0x00}, pw=320, set=40, param="PWMSET",  pat=0   },
  [16] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x10,0x00}, pw=320, set=40, param="PWMSET",  pat=255 },
  [17] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x11,0x00}, pw=340, set=50, param="PWMSET",  pat=0   },
  [18] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x11,0x00}, pw=340, set=50, param="PWMSET",  pat=255 },
  [19] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x12,0x00}, pw=360, set=60, param="PWMSET",  pat=0   },
  [20] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x12,0x00}, pw=360, set=60, param="PWMSET",  pat=255 },
  [21] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x13,0x00}, pw=380, set=70, param="PWMSET",  pat=0   },
  [22] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x13,0x00}, pw=380, set=70, param="PWMSET",  pat=255 },
  [23] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x14,0x00}, pw=400, set=80, param="PWMSET",  pat=0   },
  [24] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x14,0x00}, pw=400, set=80, param="PWMSET",  pat=255 },
  [25] = { fa={0x91,0x00}, e4={0x00,0x08,0x08,0x0C,0x15,0x00}, pw=420, set=90, param="PWMSET",  pat=0   },
  [26] = { fa={0x91,0xFF}, e4={0x00,0x08,0x08,0x0C,0x15,0x00}, pw=420, set=90, param="PWMSET",  pat=255 },
  
    -- Test (5a): pulse-width sweep @ Flat Field GL128
  [27] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x08,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=128 },
  [28] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x08,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=128 },
  [29] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x09,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=128 },
  [30] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x09,0x10,0x00}, pw=320, set=nil, param="PWMSET", pat=128 },
  [31] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x09,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=128 },
  [32] = { fa={0x91,0x80}, e4={0x00,0x05,0x05,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=128 },
  [33] = { fa={0x91,0x80}, e4={0x00,0x04,0x04,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=128 },
  [34] = { fa={0x91,0x80}, e4={0x00,0x04,0x04,0x07,0x0C,0x00}, pw=240, set=nil, param="PWMSET", pat=128 },

  -- Test (5b): same sweep @ Flat Field GL1
  [35] = { fa={0x91,0x01}, e4={0x00,0x05,0x05,0x08,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=1   },
  [36] = { fa={0x91,0x00}, e4={0x00,0x05,0x05,0x08,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=1   },
  [37] = { fa={0x91,0x01}, e4={0x00,0x05,0x05,0x09,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=1   },
  [38] = { fa={0x91,0x01}, e4={0x00,0x05,0x05,0x09,0x10,0x00}, pw=320, set=nil, param="PWMSET", pat=1   },
  [39] = { fa={0x91,0x01}, e4={0x00,0x05,0x05,0x09,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=1   },
  [40] = { fa={0x91,0x01}, e4={0x00,0x05,0x05,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=1   },
  [41] = { fa={0x91,0x01}, e4={0x00,0x04,0x04,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=1   },
  [42] = { fa={0x91,0x01}, e4={0x00,0x04,0x04,0x07,0x0C,0x00}, pw=240, set=nil, param="PWMSET", pat=1   },

  -- Test (5c): same sweep @ Flat Field GL254
  [43] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x08,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=254 },
  [44] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x08,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=254 },
  [45] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x09,0x0F,0x00}, pw=300, set=nil, param="PWMSET", pat=254 },
  [46] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x09,0x10,0x00}, pw=320, set=nil, param="PWMSET", pat=254 },
  [47] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x09,0x0E,0x00}, pw=280, set=nil, param="PWMSET", pat=254 },
  [48] = { fa={0x91,0xFE}, e4={0x00,0x05,0x05,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=254 },
  [49] = { fa={0x91,0xFE}, e4={0x00,0x04,0x04,0x08,0x0D,0x00}, pw=260, set=nil, param="PWMSET", pat=254 },
  [50] = { fa={0x91,0xFE}, e4={0x00,0x04,0x04,0x07,0x0C,0x00}, pw=240, set=nil, param="PWMSET", pat=254 },

}

PWM_CASE_MIN = 0
PWM_CASE_MAX = 50

-- helper: format a byte table as hex for logging
local function hexstr(t)
    local parts = {}
    for i = 1, #t do parts[i] = string.format("0x%02X", t[i]) end
    return "{" .. table.concat(parts, ",") .. "}"
end

-- log line: swap print() for your harness's logger if needed
function PWM_log(msg)
    print(msg)
    -- TheExec.Datalog.WriteComment(msg)   -- IG-XL datalog
end

-- display the conditions for a case
function PWM_show_case(n, c)
    c = c or PWM_CASES[n]
    if not c then return end
    local setstr
    if c.set then
        setstr = string.format("%s = %d ns", c.param, c.set)
    else
        setstr = string.format("%s = n/a", c.param)
    end
    PWM_log(string.format(
        "case%-2d  PWMPulsewidth = %d ns   %-18s  GL%-3d  0xE4=%s  0xFA=%s",
        n, c.pw, setstr, c.pat, hexstr(c.e4), hexstr(c.fa)))
end

-- Core routine: everything fixed except 0xE4 and 0xFA
function PWM_timing_debug(e4, fa)
    IIC_W_Tab2(0xF0, {0x5a, 0x5a})   -- level2 key
    IIC_W_Tab2(0xF1, {0x5a, 0x5a})   -- OTP key
    IIC_W_Tab2(0xFC, {0x5a, 0x5a})   -- 3rd key

    -- (Frame Rate 90Hz) PWM_Start_Offset, PWM_HCLOCK, EOTF Bypass
    IIC_W_Tab2(0xE5, {0x00,0x2a,0x80,0x01,0x54,0x00,0x40,0x00,0x80,0x01})

    IIC_W_Tab2(0xE4, e4)             -- System Clock <= 200MHz : PWM pulse width
    IIC_W_Tab2(0xFA, fa)

    IIC_R_Tab2(0xE4, 6)              -- readback
    IIC_R_Tab2(0xFA, 2)              -- readback

    IIC_W_Tab2(0xF4, {0x01})         -- panel update
end

-- PWM_timing_debug_case(7)
-- Run any case by number, logging PWMPulsewidth and the sweep value
function PWM_timing_debug_case(n)
    local c = PWM_CASES[n]
    if not c then
        error(string.format("PWM case %s is not defined (valid: 0..26)", tostring(n)))
    end
    PWM_show_case(n, c)
    ---- VPG_SetFlatField(c.pat)   -- uncomment if you want the pattern set here
    PWM_timing_debug(c.e4, c.fa)
end

-- Sweep a list of cases
function PWM_timing_debug_sweep(list)
    for _, n in ipairs(list) do
        PWM_timing_debug_case(n)
        -- Delay(1000)  -- settle / measure hook
    end
end

-- Print the whole condition table without running anything
function PWM_list_cases()
    for n = PWM_CASE_MIN, PWM_CASE_MAX do PWM_show_case(n) end
end


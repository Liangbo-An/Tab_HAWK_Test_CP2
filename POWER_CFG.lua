
Power = {
	PowerName = {
		[1] = "SMU1",
 		[2] = "SMU2",
 		[3] = "VQPS",
		[4] = "VDDIO",
		[5] = "DVDD",
		[6] = "AVDD",
		[7] = "AVEE1",
		[8] = "AVEE2",
		[9] = "AVEE3",
	},
	--Vnom
	ValueSetting = {
	    SMU1  =  0,
	    SMU2  =  0,
	    VQPS  =  1800,	--VDDEFUSE         			（200mA）
	    VDDIO =  1800,	--VDDIO		   			（200mA）
	    DVDD  =  1200,	--VDDA VDDLP   			（2A）
	    AVDD  =  800,	--VDDL,VDDLED,VDDPLL	（2A）
	   	AVEE1 =  -2500, --VEELED			     (2A)	
	   	AVEE2 =  0,
	   	AVEE3 =  0,
	   	--AVEE1 = -2500,  --R 1800 G/B 2500
    },
	--Vnom 20251223
	ValueSettingNom = {
	    SMU1  =  0,
	    SMU2  =  0,
	    VQPS  =  1400,
	    VDDIO =  1800,	--VDD18
	    DVDD  =  1000,	--VDD10
	    AVDD  =  1800,	--AVDD18
	   	--AVEE1 = -2500,  --R 1800 G/B 2500
	   	AVEE1 = -4000,  --R 1800 G/B 2500
	   	AVEE2 =  0,
	   	AVEE3 =  0,
    },
	--Vmin 20251223
	ValueSettingMin = {
	    SMU1  =  0,
	    SMU2  =  0,	
	    VQPS  =  1400,
	    VDDIO =  1620,	--VDD18
	    DVDD  =  730,	--VDD10
	    AVDD  =  1000,	--AVDD18
	   	--AVEE1 = -2500,  --R 1800 G/B 2500
	   	AVEE1 = -1800,  --R 1800 G/B 2500
	   	AVEE2 =  0,
	   	AVEE3 =  0,
    },
    ChannelSetting = {
	    SMU1  = 0,
	    SMU2  = 1,
	    VQPS  = 2,
	    VDDIO = 3,
	    DVDD  = 4,
	    AVDD  = 5,
	   	AVEE1 = 6,
	   	AVEE2 = 7,
	   	AVEE3 = 8,
    },
    OVPSetting   = { --Max voltage
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 1900,
	    VDDIO = 2200,
	    DVDD  = 1300,
	    AVDD  = 1900,
	   	AVEE1 = -3700,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    UVPSetting  = { --min voltage
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 0,
	    VDDIO = 0,
	    DVDD  = 0,
	    AVDD  = 0,
	   	AVEE1 = 0,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    OCPSetting  = { --max current(nA)
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 200*1000*1000,
	    VDDIO = 200*1000*1000,
	    DVDD  = 1000*1000*1000,
	    AVDD  = 1500*1000*1000,
	   	AVEE1 = 2000*1000*1000,
	   	--AVEE1 = 4000,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    UCPSetting  = { --min current
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 0,
	    VDDIO = 0,
	    DVDD  = 0,
	    AVDD  = 0,
	   	AVEE1 = 0,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    FLYSetting  = {
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 0,
	    VDDIO = 0,
	    DVDD  = 0,
	    AVDD  = 0,
	   	AVEE1 = 0,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    DischargeDAC  = {
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 0,
	    VDDIO = 0,
	    DVDD  = 0,
	    AVDD  = 0,
	   	AVEE1 = 0,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    DischargeDly  = {
	    SMU1  = 0,
	    SMU2  = 0,
	    VQPS  = 0,
	    VDDIO = 0,
	    DVDD  = 0,
	    AVDD  = 0,
	   	AVEE1 = 0,
	   	AVEE2 = 0,
	   	AVEE3 = 0,
    },
    VOL_ARALM 		= 0XFF,
    CUR_ARALM 		= 0XFF,
    COMP 			= 0XFF,
    MEDIUM_RANGE 	= 0x85,--高位：0自动量程，8：固定量程 ；低位：0小量程，1中量程，2大量程
    BL_FLY_TIME 	= 0,
    VOL_FLY_TIME 	= 100,
    CUR_FLY_TIME 	= 100,
    COMPENSATION_EN = 1,
    DEFAULT_PWR		= 0,
    CUR_ARLAM_SW 	= 1,
    VOL_ARLAM_SW 	= 1,
    CONSTANT_CURRENT = 1,
    CONSTANT_VOLTAGE = 0,
};


P_SMU1  = 0
P_SMU2  = 1
P_VQPS  = 2
P_VDD18 = 3
P_VDD10 = 4
P_AVDD18 = 5
P_AVEE  = 6

function VOL_INIT()
	POWER_OFF()
	TIME.DELAY(200)
	POWER.NAME(Power.PowerName[1],Power.PowerName[2],Power.PowerName[3],Power.PowerName[4],Power.PowerName[5],Power.PowerName[6],
			   Power.PowerName[7],Power.PowerName[8],Power.PowerName[9])
	--POWER.FLY_TIME_SET(Power.VOL_FLY_TIME ,Power.CUR_FLY_TIME)
	POWER.SWITCH(Power.VOL_ARALM, Power.CUR_ARALM)
end

--SMU1(1,0)
--SMU1(1,0)
function SMU1(EN, MODE, range)
	RANGE = (range == nil) and Power.MEDIUM_RANGE or range
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.SMU1, EN, RANGE, MODE , Power.ValueSetting.SMU1, Power.OVPSetting.SMU1, Power.UVPSetting.SMU1, Power.OCPSetting.SMU1, Power.UCPSetting.SMU1, Power.UCPSetting.SMU1)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.SMU1, EN, RANGE, MODE ,Power.DEFAULT_PWR, Power.OVPSetting.SMU1, Power.UVPSetting.SMU1, Power.OCPSetting.SMU1, Power.UCPSetting.SMU1,  Power.UCPSetting.SMU1)
	end
end

function SMU2(EN, MODE, range)
	RANGE = (range == nil) and Power.MEDIUM_RANGE or range
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.SMU2, EN, RANGE, MODE , Power.ValueSetting.SMU2, Power.OVPSetting.SMU2, Power.UVPSetting.SMU2, Power.OCPSetting.SMU2, Power.UCPSetting.SMU2, Power.UCPSetting.SMU2)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.SMU2, EN, RANGE, MODE ,Power.DEFAULT_PWR, Power.OVPSetting.SMU2, Power.UVPSetting.SMU2, Power.OCPSetting.SMU2, Power.UCPSetting.SMU2,  Power.UCPSetting.SMU2)
	end
end

function VQPS(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.VQPS, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.VQPS, Power.OVPSetting.VQPS, Power.UVPSetting.VQPS, Power.OCPSetting.VQPS, Power.UCPSetting.VQPS, Power.UCPSetting.VQPS)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.VQPS, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.VQPS, Power.UVPSetting.VQPS, Power.OCPSetting.VQPS, Power.UCPSetting.VQPS,  Power.UCPSetting.VQPS)
	end
end

function VDDIO(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.VDDIO, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO,  Power.UCPSetting.VDDIO)
	end
end

function DVDD(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.DVDD, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD,  Power.UCPSetting.DVDD)
	end
end

function AVDD(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.AVDD, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD,  Power.UCPSetting.AVDD)
	end
end

function AVEE1(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.AVEE1, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1,  Power.UCPSetting.AVEE1)
	end
end

function AVEE2(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE2, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.AVEE2, Power.OVPSetting.AVEE2, Power.UVPSetting.AVEE2, Power.OCPSetting.AVEE2, Power.UCPSetting.AVEE2, Power.UCPSetting.AVEE2)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE2, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVEE2, Power.UVPSetting.AVEE2, Power.OCPSetting.AVEE2, Power.UCPSetting.AVEE2,  Power.UCPSetting.AVEE2)
	end
end

function AVEE3(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE3, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSetting.AVEE3, Power.OVPSetting.AVEE3, Power.UVPSetting.AVEE3, Power.OCPSetting.AVEE3, Power.UCPSetting.AVEE3, Power.UCPSetting.AVEE3)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE3, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVEE3, Power.UVPSetting.AVEE3, Power.OCPSetting.AVEE3, Power.UCPSetting.AVEE3,  Power.UCPSetting.AVEE3)
	end
end

--Vnom 20251223
function VDDIO_Nom(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingNom.VDDIO, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO,  Power.UCPSetting.VDDIO)
	end
end

function DVDD_Nom(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingNom.DVDD, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD,  Power.UCPSetting.DVDD)
	end
end

function AVDD_Nom(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingNom.AVDD, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD,  Power.UCPSetting.AVDD)
	end
end

function AVEE1_Nom(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingNom.AVEE1, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1,  Power.UCPSetting.AVEE1)
	end
end
--Vnom 20251223

--Vmin 20251223
function VDDIO_Min(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, 0x83, Power.CONSTANT_VOLTAGE , Power.ValueSettingMin.VDDIO, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, EN, 0x83, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO,  Power.UCPSetting.VDDIO)
	end
end

function DVDD_Min(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN, 0x83, Power.CONSTANT_VOLTAGE , Power.ValueSettingMin.DVDD, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.DVDD, EN,0x83, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD,  Power.UCPSetting.DVDD)
	end
end

function AVDD_Min(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingMin.AVDD, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVDD, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD,  Power.UCPSetting.AVDD)
	end
end

function AVEE1_Min(EN)
	if 1==EN then
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , Power.ValueSettingMin.AVEE1, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
	else
		POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,Power.DEFAULT_PWR, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1,  Power.UCPSetting.AVEE1)
	end
end
--Vmin 20251223

function POWER_CHANNEL_VALUE(CHANNEL, EN, VALUE, V_CLAMP, C_CLAMP)
	return POWER.SINGLE_SET(CHANNEL, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , VALUE, V_CLAMP, 0, C_CLAMP , 0, Power.VOL_FLY_TIME)
end

function SMU1_OUT_C(cur)
	local EN=0
	if cur~=0 then
		EN=1
	end
	POWER.SINGLE_SET(Power.ChannelSetting.SMU1, EN, Power.MEDIUM_RANGE, 1 ,cur, Power.OVPSetting.SMU1, Power.UVPSetting.SMU1, Power.OCPSetting.SMU1, Power.UCPSetting.SMU1, Power.UCPSetting.SMU1)
end
--------------------------NEW POWER Control---------------------------------------------
function SMU1_OUT_V(vol,RANGE)
	local EN=0
	if vol~=0 then
		EN=1
	end
	if RANGE==nil then
		RANGE=Power.MEDIUM_RANGE
	end
	POWER.SINGLE_SET(Power.ChannelSetting.SMU1, EN, 0x82, 0 ,vol, Power.OVPSetting.SMU1, Power.UVPSetting.SMU1, Power.OCPSetting.SMU1, Power.UCPSetting.SMU1, Power.UCPSetting.SMU1)
end

function SMU2_OUT_C(cur)
	local EN=0
	if cur~=0 then
		EN=1
	end
	POWER.SINGLE_SET(Power.ChannelSetting.SMU2, EN, Power.MEDIUM_RANGE, 1 ,cur, Power.OVPSetting.SMU2, Power.UVPSetting.SMU2, Power.OCPSetting.SMU2, Power.UCPSetting.SMU2, Power.UCPSetting.SMU2)
end

function SMU2_OUT_V(vol,RANGE)
	local EN=0
	if vol~=0 then
		EN=1
	end
	if RANGE==nil then
		RANGE=Power.MEDIUM_RANGE
	end
	POWER.SINGLE_SET(Power.ChannelSetting.SMU2, EN, 0x82, 0 ,vol, Power.OVPSetting.SMU2, Power.UVPSetting.SMU2, Power.OCPSetting.SMU2, Power.UCPSetting.SMU2, Power.UCPSetting.SMU2)
end
--AVEE1_OUT_V(-1800)
function AVEE1_OUT_V(vol)
	local EN=0
	if vol~=0 then
		EN=1
	end
	POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, EN, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE , vol, Power.OVPSetting.AVEE1, Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
end
--Set_Power(4,500)
function Set_Power(channel,vol,range,voltage_clamp,current_clamp)
	RANGE = (range == nil) and Power.MEDIUM_RANGE or range
	local EN=0
	if vol~=0 then
		EN=1
	end
	if voltage_clamp==nil then
		if channel==0 then
			voltage_clamp=Power.OVPSetting.SMU1
		elseif channel==1 then
			voltage_clamp=Power.OVPSetting.SMU2   
		elseif channel==2 then
			voltage_clamp=Power.OVPSetting.VQPS  
		elseif channel==3 then
			voltage_clamp=Power.OVPSetting.VDDIO  
		elseif channel==4 then
			voltage_clamp=Power.OVPSetting.DVDD  
		elseif channel==5 then
			voltage_clamp=Power.OVPSetting.AVDD 
		elseif channel==6 then
			voltage_clamp=Power.OVPSetting.AVEE1
		end
	end
	if current_clamp==nil then
		if channel==0 then
			current_clamp=Power.OCPSetting.SMU1
		elseif channel==1 then
			current_clamp=Power.OCPSetting.SMU2   
		elseif channel==2 then
			current_clamp=Power.OCPSetting.VQPS  
		elseif channel==3 then
			current_clamp=Power.OCPSetting.VDDIO  
		elseif channel==4 then
			current_clamp=Power.OCPSetting.DVDD  
		elseif channel==5 then
			current_clamp=Power.OCPSetting.AVDD 
		elseif channel==6 then
			current_clamp=Power.OCPSetting.AVEE1
		end
	end
	
	if channel==0 then
		Power.ValueSetting.SMU1=vol
	elseif channel==1 then
		Power.ValueSetting.SMU2 =vol 
	elseif channel==2 then
		Power.ValueSetting.VQPS  =vol
	elseif channel==3 then
		Power.ValueSetting.VDDIO =vol 
	elseif channel==4 then
		Power.ValueSetting.DVDD =vol 
	elseif channel==5 then
		Power.ValueSetting.AVDD =vol
	elseif channel==6 then
		Power.ValueSetting.AVEE1=vol
	end

	POWER.SINGLE_SET(channel, EN, RANGE, Power.CONSTANT_VOLTAGE , vol, voltage_clamp, Power.UVPSetting.AVEE1, current_clamp, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
	local r, measureResults = Power_Measurement(channel)
	local measureResultsDecoded = cjson.decode(measureResults)
	LOG.INFO(string.format("AVEE_Meas:%.4fV, AVEE_Vol:%.4fV",measureResultsDecoded[1], vol))
	if math.floor(math.abs(measureResultsDecoded[1]) + 0.5) ~= math.floor(math.abs(vol/1000) + 0.5) then
		return 0
	else
		return 1
	end

end


--[[
function POWER_ON()
	
  	LOG.INFO("POWER ON")
    DMIPI.LP()        
    TIME.DELAY(100)
    RESET(HIGH)
    TIME.DELAY(100)
    AVDD(ON)        --VDD10
    TIME.DELAY(1000)
    VDDIO(ON)         --VDD18
    TIME.DELAY(100)
    --First output 50Mhz clock
    F_CLK_OUT(50)
    TIME.DELAY(100)
    --Second output RST(HIGH-LOW-HIGH)
    RESET(HIGH)
    TIME.DELAY(100)
    RESET(LOW)
    TIME.DELAY(100)
    RESET(HIGH)
    TIME.DELAY(10)
        
    --AVEE1(ON)        --AVEE
    TIME.DELAY(10)
    --DVDD(ON)        --VDD10_MIPI
    --TIME.DELAY(10)
   -- VQPS(ON)        --VQP
    TIME.DELAY(20)
end
]]--
function POWER_ON()
	
    PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
    GPIO_PGM_EN_SET(0)  --smp gpio_3  PGM_EN
	GPIO_TEST_IM_SET(0)	--smp gpio_6   TEST_IM
	GPIO_RESET_SET(1)  --smp gpio_4 --reset
	
	GPIO6_A_SET(0)
	GPIO3_A_SET(1)	
	GPIO2_A_SET(0)
    TIME.DELAY(200)
	
    LOG.INFO("POWER ON")
    
    VDDIO(ON)	--VDDIO
    TIME.DELAY(200)
    --VQPS(ON)
    --DVDD(ON)	--VDDL
     DVDD(ON)	--VDDLP
    --TIME.DELAY(200)
    --AVDD(ON)	--VDDLP
    AVDD(ON)	--VDDL
    TIME.DELAY(200)
    --AVEE1(ON)	--VEELED
    
    --RESET(HIGH)
    F_CLK_OUT(12.5)
    
    TIME.DELAY(200)
  
   
   	IIC_W_Tab2(0xFB, FB_payload)   -- Bypass
   	
   	println("===== bypass ")
	
   	IIC_R_Tab2(0xFB,5)
   	
   	TIME.DELAY(200)
    AVEE1(ON)	--VEELED
 
   	TIME.DELAY(200)


end

function POWER_ON_EFUSE()
	
    PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
    GPIO_PGM_EN_SET(0)  --smp gpio_3  PGM_EN
	GPIO_TEST_IM_SET(0)	--smp gpio_6   TEST_IM
	GPIO_RESET_SET(1)  --smp gpio_4 --reset
	
	GPIO6_A_SET(0)
	GPIO3_A_SET(1)	
	GPIO2_A_SET(0)
	
    LOG.INFO("POWER ON")
    
    VDDIO(ON)	--VDDIO
    TIME.DELAY(100)
    VQPS(ON)
    --DVDD(ON)	--VDDL
     --AVDD(ON)	--VDDLP
    --TIME.DELAY(100)
    AVDD(ON)	--VDDLP
       --DVDD(ON)	--VDDL
    TIME.DELAY(100)
    --AVEE1(ON)	--VEELED
    
    --RESET(HIGH)
    F_CLK_OUT(12.5)
   
   
   	IIC_W_Tab2(0xFB, FB_payload)   -- Bypass
   	TIME.DELAY(1)
    --AVEE1(ON)	--VEELED
 
    RESET(LOW) 
    TIME.DELAY(10)
    RESET(HIGH)       --ARST_N

end

function POWER_ON_SPEC()
	
    PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
    GPIO4_A_SET(0)  --smp gpio_3  PGM_EN
	GPIO7_A_SET(1)	--smp gpio_6   TEST_IM
	GPIO5_A_SET(1)  --smp gpio_4 --reset
	
	GPIO6_A_SET(0)
	GPIO3_A_SET(1)	
	GPIO2_A_SET(0)
	
    LOG.INFO("POWER ON")
    --OSC_EN_SET(LOW)
    
    VDDIO(ON)	--VDDIO
    TIME.DELAY(100)
    --DVDD(ON)	--VDDL
     AVDD(ON)	--VDDLP
    TIME.DELAY(100)
    --AVDD(ON)	--VDDLP
       DVDD(ON)	--VDDL
    TIME.DELAY(100)
    --AVEE1(ON)	--VEELED
    
    --RESET(HIGH)
    F_CLK_OUT(12.5)
    RESET(LOW) 
    TIME.DELAY(10)
    RESET(HIGH)       --ARST_N
   
   	IIC_W_Tab2(0xFB, FB_payload)
   	

   	TIME.DELAY(1)
    AVEE1(ON)	--VEELED
    
end

function POWER_ON_IDLE_POWER()

	PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
	LOG.INFO("POWER_ON_IDLE_POWER")
    OSC_EN_SET(LOW)   --OSC_EN
    RESET(LOW)       --ARST_N 
    F_CLK_CLOSE()     --CLK_FER
   	PPMU.CAL_EN(0)    --5V on
    VDDIO(ON)         --VDD18

    DVDD(ON)          --VDD10
	if TEST_MODE=="CP2" then
    	AVDD(ON)          --AVDD18
    end
    --TIME.DELAY(10)
    F_CLK_OUT(50)     --CLK_FER    
    TIME.DELAY(50)
    AVEE1(ON)         --AVEE
	RESET(HIGH)       --ARST_N 
end

function POWER_ON_IDLE_POWER_Min()
	PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
	LOG.INFO("POWER_ON_IDLE_POWER")
    OSC_EN_SET(LOW)   --OSC_EN
    RESET(LOW)       --ARST_N 
    F_CLK_CLOSE()     --CLK_FER
   	PPMU.CAL_EN(0)    --5V on
    VDDIO_Min(ON)         --VDD18
    DVDD_Min(ON)          --VDD10
	if TEST_MODE=="CP2" then
    	AVDD_Min(ON)          --AVDD18
    end
    AVEE1_Min(ON)         --AVEE
    F_CLK_OUT(50)     --CLK_FER  
    TIME.DELAY(50)
	RESET(HIGH)       --ARST_N 
end


function POWER_OFF()
	LOG.INFO("POWER OFF")
	GPIO3_A_SET(LOW)
	RESET(LOW)
	OSC_EN_SET(LOW)
	F_CLK_CLOSE()
	POWER.MULTI_SET(
	    { channel = P_VQPS,			en=0, range = 0x85, mode = 0, vol = 0, ovp = Power.OVPSetting.VQPS, uvp = 0, ocp = Power.OCPSetting.VQPS, ucp = 0 },
	    { channel = P_VDD18,		en=0, range = 0x85, mode = 0, vol = 0, ovp = Power.OVPSetting.VDDIO, uvp = 0, ocp = Power.OCPSetting.VDDIO,  ucp = 0 },
	    { channel = P_VDD10,		en=0, range = 0x85, mode = 0, vol = 0, ovp = Power.OVPSetting.DVDD, uvp = 0, ocp = Power.OCPSetting.DVDD,  ucp = 0 },
	    { channel = P_AVDD18,		en=0, range = 0x85, mode = 0, vol = 0, ovp = Power.OVPSetting.AVDD, uvp = 0, ocp = Power.OCPSetting.AVDD,  ucp = 0 },
	    { channel = P_AVEE,			en=0, range = 0x85, mode = 0, vol = 0, ovp = Power.OVPSetting.AVEE1, uvp = 0, ocp = Power.OCPSetting.AVEE1,  ucp = 0 }
	)
	SMU1(OFF,0)
	SMU2(OFF,0)
	PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NC)
end

function Post_Initial_ON()
	println("Post_Initial_ON")
	imIndex = 1
    tim1 = TIME.TICK()
    
    for i = IIC_SLV_Defaul,IIC_SLV_B do 
		IIC_CONFIG.SLAVE_ADDR = i
		IIC_CONFIG.init_default()
		TIME.DELAY(50)
		if i == IIC_SLV_Defaul then
			POWER_ON()
		end
		ret,tb = I2C_Communication_Test()
		if ret == 0 then
			break
		end
	end
    TIME.DELAY(100)
    tim3 = TIME.TICK()
	if bist_mode == 0 then--1:bistmode, 0:PG
		DMIPI.VID()
		DMIPI.HS() --VIDEO Using
		GPIO3_A_SET(LOW) -- somehow must be here to swith MIPI Switch, why?
		F_28M2_I2C_Initial_MIPI()
		FirstPicture_Post_Initial()
		LOG.INFO("do mipi")
	else
		
		F_28M2_I2C_Initial()
		FirstPicture_Post_Initial()
	end
    tim4 = TIME.TICK()
    LOG.INFO("IIC_INIT时间"..(tim4/1000 - tim3/1000))
	SLEEP_OUT()
    tim2 = TIME.TICK()
    LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
    return 0
end

function POWER_ON_0x2D0()
	println("Post_Initial_ON")
	imIndex = 1
    tim1 = TIME.TICK()
    
    for i = IIC_SLV_Defaul,IIC_SLV_B do 
		IIC_CONFIG.SLAVE_ADDR = i
		IIC_CONFIG.init_default()
		TIME.DELAY(50)
		if i == IIC_SLV_Defaul then
			POWER_ON()
		end
		ret,tb = I2C_Communication_Test()
		if ret == 0 then
			break
		end
	end
    TIME.DELAY(100)
    tim3 = TIME.TICK()
	if bist_mode == 0 then--1:bistmode, 0:PG
		DMIPI.VID()
		DMIPI.HS() --VIDEO Using
		GPIO3_A_SET(LOW) -- somehow must be here to swith MIPI Switch, why?
		FirstPicture()
		F_28M2_I2C_Initial_MIPI_0x2d0()
		LOG.INFO("do mipi")
	else
		F_28M2_I2C_Initial_0X2D0()
		FirstPicture()
	end
    tim4 = TIME.TICK()
    LOG.INFO("IIC_INIT时间"..(tim4/1000 - tim3/1000))
	SLEEP_OUT()
    tim2 = TIME.TICK()
    LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
    return 0
end

function SLEEP_OUT()
	IIC.WRITE(0x60,{0x11})   --sleep OUT
	LOG.INFO("Sleep out")
end


function Get_ALL_POWER()
	local result_table = {}
	local VDD18_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local VDD10_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local AVEE_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	} 

	VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT=POWER.VOL_CUR(P_VDD10_MIPI)
	AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT=POWER.VOL_CUR(P_AVEE)
	
	VDD18_DATA.CURRENT = VDD18_DATA.CURRENT/1e6
	VDD10_DATA.CURRENT = VDD10_DATA.CURRENT/1e6
	AVEE_DATA.CURRENT = AVEE_DATA.CURRENT/1e6
	
	
	LOG.INFO(string.format("VDD18_DATA:%.4fV,%.4fmA",VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV,%.4fmA",VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT))
	LOG.INFO(string.format("AVEE_DATA:%.4fV,%.4fmA",AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT))
	table.insert(result_table,VDD18_DATA.CURRENT)
	table.insert(result_table,VDD10_DATA.CURRENT)
	table.insert(result_table,AVEE_DATA.CURRENT)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0 ,json_data
end
--Get_Channle_Power(4)
function Get_Channle_Power(channle)
	local result_table = {}
	local VOLTAGE,CURRENT=POWER.VOL_CUR(channle)
	VOLTAGE=VOLTAGE*1000
	CURRENT = CURRENT /1e6
	LOG.INFO(string.format("CHANNLE_DATA:%.4fV,%.4fmA",VOLTAGE,CURRENT))
	
	table.insert(result_table,VOLTAGE)
	table.insert(result_table,CURRENT)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0 ,json_data
end

function tesst()
	local VDD18_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT=POWER.VOL_CUR(3)
	LOG.INFO(string.format("VDD18_DATA:%.4fV,%.4fuA",VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT/1000))
end

function power_collect_set()
	for i=0,8,1 do
		POWER.AVG_CYCLE(0,i,100)

		POWER.AVG_CYCLE(1,i,100)
		
	end
	POWER.COLLECT_SET(100)
end

power_collect_set()


VOL_INIT()
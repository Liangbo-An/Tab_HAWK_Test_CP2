---------------------------------------------------------------------------
--      AMF6701M 4021 Lua
--
--      Versions: V1.0.0
--      Date:     2025/03/26
--      Author:   SUZHOU-SEICHITECH Penny
---------------------------------------------------------------------------

project_path = SYS.GET_PATH()
VERSION = "V1.0.1"
package.path = project_path .. "/?.lua;"

-- Unload previously loaded modules to ensure fresh imports
package.loaded["HEAD"]        = nil
package.loaded["COMMON"]	  = nil
package.loaded["I3C_CFG"]     = nil
package.loaded["PIC_CFG"]     = nil
package.loaded["IIC_CFG"]     = nil
package.loaded["PPMU_CFG"]    = nil
package.loaded["POWER_CFG"]   = nil
package.loaded["SIGNAL_CFG"]  = nil
package.loaded["IC"]          = nil
package.loaded["RTC_CFG"]	  = nil
--package.loaded["TEST_FLOW_API"] =nil
package.loaded["TEST_API"] = nil
--package.loaded["BIST_9_POINT"]	  = nil
package.loaded["cjson"]       = nil
--package.loaded["DEMURA"]       = nil
package.loaded["Update_Log"]  = nil

-- Load required modules
require "HEAD"
require "COMMON"
require "I3C_CFG"
require "PIC_CFG"
require "IIC_CFG"
require "PPMU_CFG"
require "POWER_CFG"
require "SIGNAL_CFG"
require "IC"
require "RTC_CFG"
--require "BIST_9_POINT"
require "TEST_API"
--require "DEMURA"
require "Update_Log"

cjson = require "cjson"

Color = "Red"
TEST_MODE="CP2" -- 
IS_DEBUG="TRUE" --
EFUSE_WRITE=0 --0:Disability 1:Enable
-------------------------------------------------------------------------------
-- Button-Bound Functions
-------------------------------------------------------------------------------

ThirdPartyMap = 
{
	["01"] = DisplayOn,
	["02"] = F_28M2_I2C_Initial,
	["03"] = F_28M2_MIPI_Color_Read,
	["04"] = F_28M2_MIPI_CReg_Write,
	["05"] = F_28M2_MIPI_LReg_Write,
	["06"] = Sw_by_index,
	["07"] = F_28M2_VandI_Measurement,
	["08"] = F_28M2_Temp_Read,
	["09"] = DisplayOff,
	["10"] = F_28M2_MIPI_DieID_Read,
	["11"] = F_28M2_IDLE_Test,
	["12"] = F_28M2_Interface_Check,
	["13"] = F_28M2_I2CAddr_Write,
	["14"] = F_28M2_TrimAndCal,
	["15"] = F_28M2_OSTest,
	["16"] = F_28M2_eFuse_PostTest,
}
-- This function is bound to the 'Turn On' button
-- Displays the screen and initializes MIPI/IIC
--mode = "MIPI"
function DisplayOn()--仅调试用，生产时该接口不使用
	println("DisplayOn")
	
	CORE.SPI_WRITE(0XBA,0X00,0X00,0X00,0X00)
	TIME.DELAY(5)
	CORE.SPI_WRITE(0XBA,0X00,0X00,0X00,0X01)
	TIME.DELAY(300)
	DMIPI.LP()
	CORE.SPI_WRITE(0XD5,0X00,0X00,0X00,0X00)
	--TIME.DELAY(1000)
	--CORE.SPI_WRITE(0XD5,0X00,0X00,0X00,0X01)
	imIndex = 1
    tim1 = TIME.TICK()
	POWER_ON()
	ret,tb = I2C_Communication_Test()
	if ret ~= 0 then
		for i=1,#IIC_SLAVE_ADDR_TAB do 
			I3C_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
			IIC_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
			IIC_CONFIG.init_default()
			ret,tb = I2C_Communication_Test()
			if ret == 0 then
				break
			end
		end
	end	
	SLEEP_OUT()
	
	VPG_SetActiveArea(1472, 1856, 0, 0) -- Full screen by default
	Display_init(bist_mode)--1:bistmode, 0:PG
	FirstPicture()
	--SLEEP_OUT()
    tim2 = TIME.TICK()
    LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
    return 0
end

-- This function is bound to the 'Turn Off' button
-- Powers off the display
function DisplayOff()
    POWER_OFF()
    TIME.DELAY(5)
    DMIPI.LP()
    CORE.SPI_WRITE(0xD5,0x00,0x00,0x00,0x00)
    TIME.DELAY(300)
    return 0
end

-- This function is bound to the 'Gamma' button
-- Gamma adjustment function (can be modified for specific gamma settings)
function GammaStart()
    return 0
end

-- This function is bound to the 'Inspect' button
-- Cycles through test patterns for display checking
function Check()
    for i = 0, 20 do
        DisplayOn()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        Next()
        TIME.DELAY(500)
        DisplayOff()
        LOG.INFO(i)
        TIME.DELAY(1000)
    end
end

-- This function is bound to the 'Measure' button
-- Used with CA410 for measurements (currently a placeholder)
function Measure()
    -- Measurement logic to be implemented
end

function Test()

	
	local ret = nil
	local data = {}

		--[[ret, data = F_28M2_MIPI_Color_Read()
	local color_data = cjson.encode(data)
	LOG.INFO("Color_Read_RET = :  " ..ret .."Color_Read_RET = " ..color_data)
	
	ret, data = F_28M2_MIPI_CReg_Write(100)
	local creg_data = cjson.encode(data)
	LOG.INFO("Creg_read_RET = :  " ..ret .."Creg_read_RET = " ..creg_data)
	
	ret, data = F_28M2_MIPI_LReg_Write(1000)
	local lreg_data = cjson.encode(data)
	LOG.INFO("Lreg_Read_RET = :  " ..ret .."Lreg_Read_RET = " ..lreg_data)
	
	ret, data = F_28M2_VandI_Measurement()
	local vand_measure_data = cjson.encode(data)
	LOG.INFO("Vand_Read_RET = :  " ..ret .."Vand_Read_RET = " ..vand_measure_data)
	--]]
	ret, data = F_28M2_OSTest()
	LOG.INFO(#data)
	local os_data = cjson.encode(data)
	LOG.INFO("OS_Read_RET = :  " ..ret .."OS_Read_RET = " ..os_data)
	
	ret, data = F_28M2_IDLE_Test()
	local idle_data = cjson.encode(data)
	LOG.INFO("Idle_Read_RET = :  " ..ret .."Idle_Read_RET = " ..idle_data)
	
	ret, data = F_28M2_MIPI_DieID_Read()
	local DieID_data = cjson.encode(data)
	LOG.INFO("Die_Read_RET = :  " ..ret .."Die_Read_RET = " ..DieID_data)
	
	ret, data = F_28M2_I2CAddr_Write()
	local I2CAddr_data = cjson.encode(data)
	LOG.INFO("I2CAddr_Read_RET = :  " ..ret .."I2CAddr_Read_RET = " ..I2CAddr_data)
	
	ret, data = F_28M2_TrimAndCal()
	for k, v in ipairs(data) do 
		LOG.INFO("k = :  " ..k .."  V = " ..v)
	
	end
	--local TrimAndCal_data = cjson.encode(data)
	--LOG.INFO("TrimAndCal_Read_RET = :  " ..ret .."TrimAndCal_Read_RET = " ..TrimAndCal_data)
	
	ret, data = F_28M2_Interface_Check()
	local interface_data = cjson.encode(data)
	LOG.INFO("TrimAndCal_Read_RET = :  " ..ret .."TrimAndCal_Read_RET = " ..interface_data)
	
	
	--ret, data = F_28M2_eFuse_PostTest()
	--local efuse_data = cjson.encode(data)
	--LOG.INFO("TrimAndCal_Read_RET = :  " ..ret .."TrimAndCal_Read_RET = " ..efuse_data)
	


end
Set_TEST_MODE(TEST_MODE)
LOG.INFO("VERSION:"..VERSION)

--DMIPI.HS()
--DEDP.RGB(0,0,0)
--DEDP.RGB(255,255,255)
--DMIPI.CMD()

--PIC.SW("./textures/black.bmp")
--PIC.SW("./textures/r.bmp")

--PIC.MULTI_SW("./textures/41.bmp",10,"./textures/111.bmp",10,"./textures/1.bmp",10)
--PIC.MULTI_SW("./textures/black.bmp",1)
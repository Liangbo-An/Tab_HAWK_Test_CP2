-- VPG******
--Set_TEST_MODE("CP2")
Power_Shorts_Test(Volt, delay, pinlist)--ok--MT &CP2
IO_Continuity_Test()--ok--MT &CP2
POWER_ON()

IIC_R_Tab2(0xDC, 256)


--set duty cycel
IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40,0x00,0x2A,0x00,0x00,0x00,0x00})
IIC_R_Tab2(0xE5,13)
Set_Duty_Cycle(0.01)

VPG_9SQUARE_FRC(928, 736, 300, 300)
VPG_9POINT_FRC(928, 736, 300, 300)
AVEE1_OUT_V(-1800)
Set_Brightness(156) --3.2uA


POWER.SINGLE_SET(4, 1,0x83, Power.CONSTANT_VOLTAGE ,1200, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
local tmp = IIC_R_Tab2(0xc1, 256)
println("type(tmp) = %s, value %02x",type(tmp),tmp)

POWER_ON_EFUSE()
EFuse_DieID_Read()

Set_TEST_MODE(TEST_MODE)
RestInit()
IIC_CONFIG.init_default()
Display.init_lvds()
power_collect_set()
VOL_INIT()

IIC_R_Tab2(0xF8,32)
IIC_R_Tab2(0x29,1)

IIC_W_Tab2(0xE6, {00,0,0,0,0,0}) 
IIC_W_Tab2(0xE4, {00,0,0,0,0,0}) 
IIC_W_Tab2(0xE5, {00,0,0,0,0,0,0,0,0,0,0}) 
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
     AVDD(ON)	--VDDLP
    TIME.DELAY(100)
    --AVDD(ON)	--VDDLP
       DVDD(ON)	--VDDL
    TIME.DELAY(100)
    --AVEE1(ON)	--VEELED
    
    --RESET(HIGH)
    F_CLK_OUT(12.5)
   
   
   	IIC_W_Tab2(0xFB, FB_payload)   -- Bypass
   	TIME.DELAY(1)
    AVEE1(ON)	--VEELED
 
    RESET(LOW) 
    TIME.DELAY(10)
    RESET(HIGH)       --ARST_N
    VQPS(1)

EFuse_write256bit(1, 0x01)

I3C_Communication_Test()

I2C_Communication_Test()

I3C_W_Tab2(0xEF,0x11223344)
I3C_R_Tab2(0xEF,4)

IIC.WRITE(0x60, {0x11})    --sleep out
 
IIC_W_Tab2(0xBD, {0x10}) -- Set to 90hz
IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xff}) -- Pixel current to max
I3C_W_Tab2(0xFA, {0x31, 0xff, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})  -- VPG mode on
I3C_R_Tab2(0xFA,9)

--IIC_W_Tab2(0xBD, {0x10})
  --POWER_ON()
  

  F_I2C_Initial_MIPI()
    local lut_max = {}
  for i = 1, 128 do
      table.insert(lut_max, 0x0F)
      table.insert(lut_max, 0xFF)
  end
  IIC_W_Tab2(0xDD, lut_max)
  IIC_W_Tab2(0xBD, {0x20})
  IIC_W_Tab2(0xF6, {0x00, 0x01, 0xFF})
  IIC_W_Tab2(0xE4, {0x00, 0x05, 0x06, 0x07, 0x0C, 0x03})
  IIC_W_Tab2(0xFA, {0x91, 0xFF})
  IIC_W_Tab2(0xF4, {0x01})
  IIC.WRITE(0x60, {0x11})
  TIME.DELAY(10)
  IIC.WRITE(0x60, {0x29})

  IIC.WRITE(0x60, {0xF0}, {0x5A, 0x5A})
  IIC_R_Tab2_M(0xDC, 8)
  
IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xff}) -- Pixel current
IIC_W_Tab2(0xFA, {0xb1, 0x7f, 0x00, 0x10,0x00,0x20,0x00,0x20,0x00})  -- VPG mode on

IIC.WRITE(0x60,{0x29})   --display on


 IIC_R_Tab2(0xBD,1)
 IIC_R_Tab2(0xF6,3)
 IIC_R_Tab2(0xFA,9)

 --test VPG*****
 POWER_ON()

 IIC.WRITE(0x60, {0x11})    --sleep out
 
 IIC_W_Tab2(0xBD, {0x10}) -- Set to 90hz
 IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xFF}) -- Pixel current to max
 IIC_W_Tab2(0xFA, {0x31, 0xff, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})  -- VPG mode on checkboard

--IIC_W_Tab2(0xFA, {0x51, 0xff, 0x00, 0x10,0x20,0x20})  -- VPG mode on, cross pattern
IIC_W_Tab2(0xFA, {0x91, 0xff}) -- flat field

 IIC.WRITE(0x60, {0x29})    -- Display on
 IIC_W_Tab2(0xFA, {0x30, 0xff, 0x00, 0x10,0x00,0x20,0x00,0x20,0x00})  -- VPG mode on

--DisplayOn()
POWER_ON_SPEC()
GPIO4_A_SET(1)  --smp gpio_3  PGM_EN 
--special light up

GPIO4_A_SET(0)  --smp gpio_3  PGM_EN
GPIO7_A_SET(1)	--smp gpio_6   TEST_IM
GPIO5_A_SET(1)  --smp gpio_4 --reset

IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) --must 1st init
IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a}) --must 1st init
IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a}) --must 1st init

VPG_IIC_WRITE(3, 0, "135")


--******test  iic W /R 256******
local data_256 = {}
for i=0, 256 do
	table.insert(data_256,i)
end
IIC_W_Tab2(0xDD, data_256)
IIC_R_Tab2(0xDD,256)
 IIC_R_Tab2(0xFB,10)

 --*******test  iic W /R 256******

I2C_Communication_Test()

--IIC.WRITE(0x60, {0xF5}, {0x5a,0x5a}) 

IIC.WRITE(0x60, {0xf5}, {0x13,0x01}) 
IIC_R_Tab2_M(0xf5,2)

IIC_R_Tab2(0xDE, 256)

SLEEP_OUT()
Display_init(bist_mode)--1:bistmode, 0:PGwo
FirstPicture()

--****** test VDDPXL/VDDPHY**************
local SMU1DATA_V = 0.0
local SMU1DATA_C = 0.0
 PPMU.RELAY_ALL(0)
GPIO6_A_SET(0)
GPIO3_A_SET(0)	
GPIO2_A_SET(0)
TIME.DELAY(100)
SMU1DATA_V,SMU1DATA_C=POWER.VOL_CUR(1)
LOG.INFO(string.format("1V:%f",SMU1DATA_V))

PPMU.RELAY_ALL(0)
GPIO6_A_SET(0)
GPIO3_A_SET(1)	
GPIO2_A_SET(0)  
--****** test VDDPXL/VDDPHY**************

--SMU2_OUT_V(100)
 SMU2_OUT_V(0)
 
GPIO2_A_SET(0)	--smp gpio_1
GPIO3_A_SET(0)	--smp gpio_2
GPIO4_A_SET(0)  --smp gpio_3
GPIO5_A_SET(0) --smp gpio_4
GPIO6_A_SET(0	--smp gpio_5
GPIO7_A_SET(0)	--smp gpio_6

--IIC_W_Tab2(0x00EF,0x55555555)

PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
POWER.SINGLE_SET(4, 1,0x83, Power.CONSTANT_VOLTAGE ,1200, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, 1, Power.MEDIUM_RANGE, 0 , 200, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
POWER.SINGLE_SET(5,1, Power.MEDIUM_RANGE, 0 ,200, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
POWER.SINGLE_SET(Power.ChannelSetting.AVDD, 1, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,800, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)

IIC_W_Tab2(0xF3, {0x54})
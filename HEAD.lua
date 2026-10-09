
VCC_CTRL_SWITCH = "GPIO4_D5"
IRQ_OUT			= "GPIO4_A6"	--针卡：IRQ_OUT

OSC_EN          = "GPIO4_A4"	--PG GPIO8 ->针卡GPIO7
--PANEL_RST       =  EXT_IO5		--CP2:"GPIO4_A3"   MT:GPIO4_A7

PANEL_RST  = "GPIO3_D6" 

--PANEL_RST = "GPIO4_A5"

VCC_IO_SWITCH   = "GPIO4_D4"
EXT_IO1	        = "GPIO3_D5"
EXT_IO2         = "GPIO4_A7"
EXT_IO3         = "GPIO3_D7"
EXT_IO4         = "GPIO4_A5"	--针卡：OSC_EN
EXT_IO5         = "GPIO3_D6"	--针卡：ARST
EXT_IO6         = "GPIO4_A6"	--针卡：IRQ
EXT_IO7     	= "GPIO4_A3"
POWER_5V_EN		= "GPIO2_A2"

ARM_IO1_1V8     = "GPIO3_D5"
ARM_IO2_1V8     = "GPIO4_A7"
ARM_IO3_1V8     = "GPIO3_D7"
ARM_IO4_1V8     = "GPIO4_A5"
ARM_IO5_1V8     = "GPIO3_D6"
ARM_IO6_1V8     = "GPIO4_A6"
ARM_IO7_1V8     = "GPIO4_A3"
ARM_IO8_1V8     = "GPIO4_A4"
ARM_IO9_1V8     = "GPIO3_D0"
ARM_IO10_1V8    = "GPIO4_A0"
ARM_IO11_3V0    = "GPIO4_D3"
ARM_IO12_3V0    = "GPIO4_D4"
ARM_IO13_3V0    = "GPIO1_C4"
ARM_IO14_3V0    = "GPIO1_C6"
ARM_IO15_3V0    = "GPIO1_C7"
ARM_IO16_3V0    = "GPIO1_D0"


OUT             = "out"
IN              = "in"

HIGH  = 1
LOW   = 0

ON = 1
OFF = 0
IO_LEVEL = 1.8

Pre_Clk=0--当前CLK频率
GPIO.INIT("GPIO2_A2", OUT, LOW, LOW)
GPIO.OUT("GPIO2_A2", 1)
GPIO.INIT(EXT_IO1, OUT, LOW, LOW)
GPIO.OUT(EXT_IO1, 0)
GPIO.INIT(EXT_IO2, OUT, LOW, LOW)
GPIO.OUT(EXT_IO2, 0)

PPMU.CAL_EN(0) --开启5V 电压

function MCU_INIT(MODE)
	MCU.IO_INIT('E' , 0 , MODE) --初始化
	MCU.IO_INIT('E' , 1 , MODE) --初始化
	MCU.IO_INIT('E' , 2 , MODE) --初始化
	MCU.IO_INIT('E' , 3 , MODE) --初始化
	MCU.IO_INIT('B' , 4 , MODE) --初始化
	MCU.IO_INIT('B' , 5 , MODE) --初始化
	MCU.IO_INIT('B' , 6 , MODE) --初始化
	MCU.IO_INIT('B' , 7 , MODE) --初始化
	MCU.IO_INIT('E' , 4 , MODE) --初始化
	MCU.IO_INIT('C' , 7 , MODE) --初始化
	MCU.IO_INIT('C' , 8 , MODE) --初始化
	MCU.IO_INIT('C' , 5 , MODE) --初始化
	MCU.IO_INIT('C' , 12, MODE) --初始化
	MCU.IO_INIT('C' , 13, MODE) --初始化
	MCU.IO_INIT('C' , 14, MODE) --初始化
	MCU.IO_INIT('C' , 15, MODE) --初始化
end

function MCU_OUTPUT(EN)
	MCU.IO_SET ('E' ,0 , EN)	--输出模式
	MCU.IO_SET ('E' ,1 , EN)	--输出模式
	MCU.IO_SET ('E' ,2 , EN)	--输出模式
	MCU.IO_SET ('E' ,3 , EN)	--输出模式
	MCU.IO_SET ('B' ,4 , EN)	--输出模式
	MCU.IO_SET ('B' ,5 , EN)	--输出模式
	MCU.IO_SET ('B' ,6 , EN)	--输出模式
	MCU.IO_SET ('B' ,7 , EN)	--输出模式
	MCU.IO_SET ('E' ,4 , EN)	--输出模式
	MCU.IO_SET ('C' ,7 , EN)	--输出模式
	MCU.IO_SET ('C' ,8 , EN)	--输出模式
	MCU.IO_SET ('C' ,5 , EN)	--输出模式
	MCU.IO_SET ('C' ,12 ,EN)	--输出模式
	MCU.IO_SET ('C' ,13 ,EN)	--输出模式
	MCU.IO_SET ('C' ,14 ,EN)	--输出模式
	MCU.IO_SET ('C' ,15 ,EN)	--输出模式
end

function GPIO_DIR_SET(DIR)
	MCU_INIT(DIR)
	MCU_OUTPUT(DIR)
end
function RestInit()
	if TEST_MODE=="MT" then
		PANEL_RST       = "GPIO4_A7"
	elseif TEST_MODE=="CP2" then
		PANEL_RST       = "GPIO3_D6"
	end
	LOG.DEBUG(string.format("TEST_MODE:%s,RestInit:%s",TEST_MODE,PANEL_RST))
	MCU.IO_LEVEL(IO_LEVEL)
	GPIO.INIT(PANEL_RST, OUT, LOW, LOW)
	--GPIO.INIT(OSC_EN, OUT, LOW, LOW)
	--GPIO.INIT(EXT_IO6, OUT, LOW, LOW)
	GPIO_INIT()
	
	GPIO.OUT(POWER_5V_EN,HIGH)
	GPIO_DIR_SET(1)
	GPIO_ALL_SET(0)
end

function RESET(level)
	GPIO.OUT(PANEL_RST, level)
end

--Tab2
function  GPIO_PGM_EN_SET(level)
	GPIO.OUT(EXT_IO4, level)
end

function GPIO_TEST_IM_SET(level)
	GPIO.OUT(EXT_IO7, level)
end

function GPIO_RESET_SET(level)
	GPIO.OUT(EXT_IO5, level)
end

--Tab2




function GPIO1_A_SET(level)
	GPIO.OUT(EXT_IO1, level)
end

function GPIO2_A_SET(level)
	GPIO.OUT(EXT_IO2, level)
end

function GPIO3_A_SET(level)
	GPIO.OUT(EXT_IO3, level)
end

function GPIO4_A_SET(level)
	GPIO.OUT(EXT_IO4, level)
end

function GPIO5_A_SET(level)
	GPIO.OUT(EXT_IO5, level)
end

function GPIO6_A_SET(level)
	GPIO.OUT(EXT_IO6, level)
end

function GPIO7_A_SET(level)
	GPIO.OUT(EXT_IO7, level)
end

function OSC_EN_SET(level)
	GPIO.OUT(OSC_EN, level)
end

function IRQ_OUT_SET(level)
	GPIO.OUT(EXT_IO6, level)
end

function GPIOGET()
	GPIO.INIT(EXT_IO6, IN, LOW, LOW)
end


function set_pin(pinName, level)
	GPIO.OUT(pinName, level)
end

function GPIO_INIT()
	GPIO.INIT(ARM_IO1_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO2_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO3_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO4_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO5_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO6_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO7_1V8, OUT, LOW, LOW)
	GPIO.INIT(ARM_IO8_1V8, OUT, LOW, LOW)
	GPIO.INIT(POWER_5V_EN, OUT, LOW, LOW)
end

function GPIO_ALL_SET(EN)
	GPIO.OUT(ARM_IO1_1V8,EN)
	GPIO.OUT(ARM_IO1_1V8,EN)
	GPIO.OUT(ARM_IO2_1V8,EN)
	GPIO.OUT(ARM_IO3_1V8,EN)
	GPIO.OUT(ARM_IO4_1V8,EN)
	GPIO.OUT(ARM_IO5_1V8,EN)
	GPIO.OUT(ARM_IO6_1V8,EN)
	GPIO.OUT(ARM_IO7_1V8,EN)
	GPIO.OUT(ARM_IO8_1V8,EN)
end
function GPIO_ALL_READ()
	local level={}
	PPMU.RELAY_ALL(0)
	level[1]=GPIO.IN(ARM_IO1_1V8,0)
	level[2]=GPIO.IN(ARM_IO2_1V8,0)
	level[3]=GPIO.IN(ARM_IO3_1V8,0)
	level[4]=GPIO.IN(ARM_IO4_1V8,0)
	level[5]=GPIO.IN(ARM_IO5_1V8,0)
	level[6]=GPIO.IN(ARM_IO6_1V8,0)
	level[7]=GPIO.IN(ARM_IO7_1V8,0)
	level[8]=GPIO.IN(ARM_IO8_1V8,0)
	
	for i=1,8 do 
		if level[i]==0 then
			LOG.INFO(string.format("GPIO%d-->LOW",i))
		else
			LOG.INFO(string.format("GPIO%d-->HIGH",i))
		end
	end
end


function EXT_IO6_TEST(level)
	flag = GPIO.IN(EXT_IO6, 0)
	LOG.INFO("flag  = "..flag)	
end

function F_DELAY_S(t)
	local ret = 0
	for i=5*t,1,-1 do
		TIME.DELAY(200)
		ret = SYS.IS_RUN_ERR()
		if ret ~= 0 then
			break
		end
	end
	SYS.CLR_RUN_ERR()
	return ret
end

--Global variable definition
AVDD_EN         = "GPIO2_D4"
OUT             = "out"
IN              = "in"
HIGH  = 1
LOW   = 0

function F_INITIAL()
    GPIO.INIT(ARM_IO5_1V8 , IN, LOW, LOW)
end
 --F_CHECK_EN(0, 50)
function F_CHECK_EN(State, Count)
    local Result = -1
    local Cnt = 0
    local en_flag = 0
    if SWIRE_ELON_FLAG == 0 or  DCDC_ENABLE == 1 then
        LOG.INFO("Skip SWIRE&ELON")
        Result = 1
        return Result
    end
    while Cnt < Count do 
        --LOG.INFO("Checked En start")
        en_flag = GPIO.IN(ARM_IO5_1V8,1) --enFlag = 0，EN OK ;  Read IO state;
        LOG.INFO(string.format("EnON=%d", en_flag))
        --LOG.INFO("Checked En end")
        if State == 0 then --Power ON
            if en_flag == 0 then
                LOG.INFO("Checked EnON")
                LOG.INFO("Cnt = "..Cnt)
                Result = 1
                break
            end
        else
            if en_flag ~= 0 then
                LOG.INFO("Checked EnOFF")
                LOG.INFO("Cnt = "..Cnt)
                Result = 0
                break
            end
        end
        TIME.DELAY(1)
        Cnt = Cnt + 1
    end
    if (Result < 1) then
        LOG.ERROR(string.format("EnON=%d", en_flag))
    end
    
    return Result
end


RestInit()

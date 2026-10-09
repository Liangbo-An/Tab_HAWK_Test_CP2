
CHANNEL_NAME = {
	[0] = "PPMU1_OUT",
	[1] = "PPMU2_OUT",
	[2] = "VQPS_OUT",
	[3] = "VDDIO_OUT",
	[4] = "DVDD_OUT",
	[5] = "AVDD_OUT",
	[6] = "AVEE1_OUT",
	[7] = "AVEE2_OUT",
	[8] = "AVEE3_OUT",
	[9] = "Pixel clock_CLK_IN",
	[10] = "Pixel clock_CLK_OUT", --CLK_REF
	[11] = "GPIO1_A", --GPIO1
	[12] = "GPIO2_A", --GPIO2
	[13] = "GPIO3_A", --GPIO3
	[14] = "GPIO4_A", --OSC
	[15] = "GPIO5_A", --ARST_N
	[16] = "GPIO6_A", --IRQ_OUT
	[17] = "GPIO7_A", 
	[18] = "GPIO8_A",
	[19] = "SPI_FPGA_CS",
	[20] = "SPI_FPGA_SCK",
	[21] = "SPI_FPGA_MOSI",
	[22] = "SPI_FPGA_MISO",
	[23] = "SPI_FPGA_IO1",
	[24] = "SPI_FPGA_IO2",
	[25] = "SPI_FPGA_IO3",
	[26] = "SPI_FPGA_IO4",
	[27] = "A_I2C_SCL", --I2C_SCL
	[28] = "A_I2C_SDA", --I2C_SDA
	[29] = "B_I2C_SCL",
	[30] = "B_I2C_SDA"
}

CHANNEL_TAB = {
	SMU1_OUT	= 0,
	SMU2_OUT	= 1,
	VQPS_OUT	= 2,
	VDDIO_OUT	= 3,
	DVDD_OUT	= 4  ,
	AVDD_OUT	= 5  ,
	AVEE1_OUT	= 6  ,
	AVEE2_OUT	= 7  ,
	AVEE3_OUT	= 8  ,
	CLK_IN		= 9  ,
	CLK_OUT		= 10 ,
	GPIO1_A		= 11 ,
	GPIO2_A		= 12 ,
	GPIO3_A		= 13 ,
	GPIO4_A		= 14 ,
	GPIO5_A		= 15 ,
	GPIO6_A		= 16 ,
	GPIO7_A		= 17 ,
	GPIO8_A		= 18 ,
	SPI_FPGA_CS	= 19 ,
	SPI_FPGA_SCK= 20 ,
	SPI_FPGA_MOSI=21 ,
	SPI_FPGA_MISO=22 ,
	SPI_FPGA_IO1= 23 ,
	SPI_FPGA_IO2= 24 ,
	SPI_FPGA_IO3= 25 ,
	SPI_FPGA_IO4= 26 ,
	A_I2C_SCL	= 27 ,
	A_I2C_SDA	= 28 ,
	B_I2C_SCL	= 29 ,
	B_I2C_SDA	= 30 ,
}


PPMU_MODE_TABLE={
	NC=0X00,
	PPMU=0X01,
	GND=0X02,
	PULL_DOWN=0X03,
	NORMAL_MODE=0X04
}



PPMU_MODE=0
Test_item=""
--			PPMU_MANUAL_TEST(3)

--Set_TEST_MODE("MT")
----Set_TEST_MODE("CP2")
--IO_PPMU_CHANEL_negative = {
	--{PinNo = 10 ,PinName =  "CLK_REF"},
	--{PinNo = 11 ,PinName =  "GPIO_INT_L"},
	--{PinNo = 12 ,PinName =  "Reset"},
	--{PinNo = 27 ,PinName =  "I2C_SCL"},
	--{PinNo = 28 ,PinName =  "I2C_SDA"},
--}

--IO_PPMU_CHANEL_Positive = {
	--{PinNo = 10 ,PinName =  "CLK_REF"},
	--{PinNo = 11 ,PinName =  "GPIO_INT_L"},
	--{PinNo = 12 ,PinName =  "Reset"},
	--{PinNo = 27 ,PinName =  "I2C_SCL"},
	--{PinNo = 28 ,PinName =  "I2C_SDA"},
--}

IO_PPMU_CHANEL_Positive = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 17 ,PinName =  "ARST_N"},
			--{PinNo = 18 ,PinName =  "OSC_EN"},
			{PinNo = 27 ,PinName =  "I3C_SCL"},
			{PinNo = 28 ,PinName =  "I3C_SDA"},
		}
IO_PPMU_CHANEL_negative = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 17 ,PinName =  "ARST_N"},
			--{PinNo = 18 ,PinName =  "OSC_EN"},
			{PinNo = 27 ,PinName =  "I3C_SCL"},
			{PinNo = 28 ,PinName =  "I3C_SDA"},
		}

function PPMU_MANUAL_TEST(channel,cur,delayTime)
	PPMU.SEL_SWITCH(0)
	PPMU.RELAY_ALL(1)
	PPMU.SECOND_SWITCH(1)
	PPMU.TMUX_EN(channel)
	PPMU.SET_CUR(cur)
	TIME.DELAY(delayTime)
	LOG.INFO("DelayTime:"..delayTime)
	VOL=PPMU.GET_VOL()
	CUR=PPMU.GET_CUR()
	--PPMU.SECOND_SWITCH(0)
	--PPMU.RELAY_ALL(0)
	--PPMU.SEL_SWITCH(0)
	LOG.INFO(string.format("%s VOL:%.2fmV,CUR:%.2fuA",CHANNEL_NAME[channel+1],VOL*1000,CUR))
end

function PPMU_TEST(count,cur)
	PPMU.OS_TEST(0x02,count,cur)	--0x00:悬空；0x01:PPMU;0x02:GND;0x03:GND
	local delayTime = 440
	TIME.DELAY(delayTime)
	LOG.INFO("delayTime:"..delayTime)
	--自动测试获取电压电流值
	--TIME.DELAY(20)
	read_table = PPMU.OS_VOL() --os test get v c
	--LOG.INFO(string.format("CHANNEL：%s  ,vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],read_table.voltage*1000,read_table.current))
	if math.abs(read_table.voltage) < 0.3 then
		if PPMU_MODE==0 then
			LOG.DEBUG(string.format("CHANNEL：%s  ,%sPASS：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		else
			LOG.ERROR(string.format("CHANNEL：%s  ,%sNG：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		end
	elseif	math.abs(read_table.voltage) > 1.3 then
		if PPMU_MODE==1 then
			LOG.DEBUG(string.format("CHANNEL：%s  ,%sPASS：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		else
			LOG.ERROR(string.format("CHANNEL：%s  ,%sNG：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		end
	else
		if PPMU_MODE==2 and isInRange(cur,read_table.current,0.1) and isInRange(read_table.voltage*1000,read_table.voltage*1000,0.1) then
			LOG.DEBUG(string.format("CHANNEL：%s  ,%sPASS：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		else
			LOG.ERROR(string.format("CHANNEL：%s  ,%sNG：vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],Test_item,read_table.voltage*1000,read_table.current))
		end
			--LOG.DEBUG(isInRange(cur,read_table.current,0.1))
			--LOG.DEBUG(isInRange(read_table.voltage*1000,read_table.current*10,0.1))
			
	end
	
end
function PPMU_TEST_TEST(count,cur,name,delayTime)
	local testState  = ""
	--local delayTime = 50
	if delayTime == nil then
		delayTime = 50
	end
	
	PPMU.OS_TEST(PPMU_MODE_TABLE.GND,count,cur)	--0x00:悬空；0x01:PPMU;0x02:GND;0x03:GND  120
	TIME.DELAY(delayTime)
	LOG.INFO("delayTime:"..delayTime)
	--自动测试获取电压电流值
	read_table = PPMU.OS_VOL()
	--LOG.INFO(string.format("CHANNEL：%s  ,vol: %0.4fmV，cur: %0.2fuA",CHANNEL_NAME[count+1],read_table.voltage*1000,read_table.current))
	if math.abs(read_table.voltage) < 0.2 then

		testState = "短路(SHORT)"
		LOG.ERROR(string.format("CHANNEL: %s ,IO测试%s, vol: %0.4fmV，cur: %0.2fuA",name,testState,read_table.voltage*1000,read_table.current))
	elseif	math.abs(read_table.voltage) > 1.4 then
		testState = "开路(OPEN)"
		LOG.ERROR(string.format("CHANNEL: %s ,IO测试%s, vol: %0.4fmV，cur: %0.2fuA",name,testState,read_table.voltage*1000,read_table.current))
	else
		if isInRange(cur,read_table.current,0.1) and isInRange(read_table.voltage*1000,read_table.voltage*1000,0.1) then
			testState = "OK"
			LOG.DEBUG(string.format("CHANNEL: %s ,IO测试%s, vol: %0.4fmV，cur: %0.2fuA",name,testState,read_table.voltage*1000,read_table.current))
		else
			testState = "NG"
			LOG.ERROR(string.format("CHANNEL: %s ,IO测试%s, vol: %0.4fmV，cur: %0.2fuA",name,testState,read_table.voltage*1000,read_table.current))
		end
			--LOG.DEBUG(isInRange(cur,read_table.current,0.1))
			--LOG.DEBUG(isInRange(read_table.voltage*1000,read_table.current*10,0.1))
			
	end
	return {testState,read_table.voltage*1000,read_table.current}
	
end

function F_PPMU_MODE(MODE)
		PPMU_MODE=MODE
		if MODE==0 then
			Test_item="短路测试"
		elseif MODE==1 then
			Test_item="开路测试"
		else
			Test_item="带载测试"
		end
end

function PPMU_ALL_CHANNEL_TEST(cur)
	tim1 = TIME.TICK()
	PPMU.RELAY_ALL(1)
	TIME.DELAY(100)
	for i=0,30,1 do

		if i == 6 then 
			cur = -cur
		else
		
		end
	 	PPMU_TEST(i,cur)

	end
	PPMU.RELAY_ALL(0)
	tim2 = TIME.TICK()
	LOG.INFO("测试时间"..(tim2/1000 - tim1/1000))

	--LOG.INFO(string.format("PPMUName：SMU_OUT_EN  ,vol: %0.4f，cur: %0.2f",data.voltage,data.current))
end
--

function PPMU_POWER_CHANNEL_TEST(cur)
	tim1 = TIME.TICK()
	--PPMU.RELAY_ALL(1)
	TIME.DELAY(100)
	--for i=2,6,1 do
		--if i == 6 then 
			--cur = -cur
		--end
	 PPMU_TEST(3,cur)
	 PPMU_MANUAL_TEST(3,cur,200)
	 	
	--end
	PPMU.RELAY_ALL(0)
	tim2 = TIME.TICK()
	LOG.INFO("测试时间"..(tim2/1000 - tim1/1000))

	--LOG.INFO(string.format("PPMUName：SMU_OUT_EN  ,vol: %0.4f，cur: %0.2f",data.voltage,data.current))
end


function PPMU_IO_CHANNEL_TEST(cur,delayTime)
	local result = {}
	local result_table = {}
	local pin_table={} 
	local voltage_table={} 
	local current_table={} 
	--tim1 = TIME.TICK()
		PPMU.RELAY_ALL(1)
		TIME.DELAY(10)
		--LOG.INFO(string.format("cur:%d",cur[2]))
		--LOG.INFO(cur)
	for c,z in pairs(cur) do
		if z > 0 then
			for k,v in pairs(IO_PPMU_CHANEL_Positive) do
			
			 	result = PPMU_TEST_TEST(v.PinNo,z,v.PinName,delayTime)
			 	--PPMU_TEST(v.PinNo,cur)
			 	--result_table = result[2]
			 	table.insert(result_table,result[2])
			 	println("PinNo:%d",v.PinNo)
			 	table.insert(pin_table,v.PinName)
			 	table.insert(current_table,z)
			 	table.insert(voltage_table,result[2])
			 	 --PPMU_MANUAL_TEST(v.PinNo,cur,200)
			 
			end
		else
			for k,v in pairs(IO_PPMU_CHANEL_negative) do
			
			 	result = PPMU_TEST_TEST(v.PinNo,z,v.PinName,delayTime)
			 	--PPMU_TEST(v.PinNo,cur)
			 	--result_table = result[2]
			 	table.insert(result_table,result[2])
			 	println("PinNo:%d",v.PinNo)
			 	table.insert(pin_table,v.PinName)
			 	table.insert(current_table,z)
			 	table.insert(voltage_table,result[2])
			 	 --PPMU_MANUAL_TEST(v.PinNo,cur,200)
			 
			end
		end
	end
		 PPMU.RELAY_ALL(0)
	--return result_table
	return pin_table,current_table,voltage_table
end

function PPMU_IO_CHANNEL_TEST_Customize(cur,pinlist,ioname,delayTime)
	local result = {}
	local result_table = {}
	tim1 = TIME.TICK()
		PPMU.RELAY_ALL(1)
		TIME.DELAY(10)
	
	 	result = PPMU_TEST_TEST(pinlist,cur,ioname,delayTime)
	 	--PPMU_TEST(v.PinNo,cur)
	 	--table.insert(result_table,result[2])
	 	--table.insert(result_table,{ioname,result[1],result[2],result[3]})
	 	println("PinNo:%d",pinlist)
	 	 --PPMU_MANUAL_TEST(v.PinNo,cur,200)
	 
	
		 PPMU.RELAY_ALL(0)
	tim2 = TIME.TICK()
	LOG.INFO("测试时间"..(tim2/1000 - tim1/1000))
	return result[2]
end


function PPMU_IO_ALL_MODE(mode)
    if mode == 0 then
        LOG.INFO("in NC mode.")
        PPMU.RELAY_ALL(1)
        PPMU.TMUX_CTR(0xffff)
        PPMU.SEL_SWITCH(0)
    elseif mode == 1 then
		LOG.INFO("in PPMU mode.")
    elseif mode == 2 then
		LOG.INFO("in GND mode.")
		PPMU.RELAY_ALL(1)
		PPMU.TMUX_CTR(0xffff)
		PPMU.SEL_SWITCH(2)
    elseif mode == 3 then
        LOG.INFO("in Pull Down mode.")
        PPMU.RELAY_ALL(1)
        PPMU.TMUX_CTR(0xffff)
        PPMU.SEL_SWITCH(3)
    elseif mode == 4 then
        LOG.INFO("in normal mode.")
        PPMU.RELAY_ALL(0)
    else
        LOG.ERROR("Invalid mode: " .. tostring(mode))
    end
end

function Set_IO_TEST_MODE()
	if TEST_MODE=="MT" then
		IO_PPMU_CHANEL_negative = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 11 ,PinName =  "GPIO_INT_L"},
			{PinNo = 12 ,PinName =  "Reset"},
			{PinNo = 27 ,PinName =  "I2C_SCL"},
			{PinNo = 28 ,PinName =  "I2C_SDA"},
		}
		
		IO_PPMU_CHANEL_Positive = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 11 ,PinName =  "GPIO_INT_L"},
			{PinNo = 12 ,PinName =  "Reset"},
			{PinNo = 27 ,PinName =  "I2C_SCL"},
			{PinNo = 28 ,PinName =  "I2C_SDA"},
		}
	elseif TEST_MODE=="CP2" then
		IO_PPMU_CHANEL_Positive = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 17 ,PinName =  "ARST_N"},
			--{PinNo = 18 ,PinName =  "OSC_EN"},
			{PinNo = 27 ,PinName =  "I3C_SCL"},
			{PinNo = 28 ,PinName =  "I3C_SDA"},
		}
		IO_PPMU_CHANEL_negative = {
			{PinNo = 10 ,PinName =  "CLK_REF"},
			{PinNo = 17,PinName =  "ARST_N"},
			--{PinNo = 18 ,PinName =  "OSC_EN"},
			{PinNo = 27 ,PinName =  "I3C_SCL"},
			{PinNo = 28 ,PinName =  "I3C_SDA"},
		}
	end
	
	LOG.DEBUG(string.format("TEST_MODE:%s,Set_IO_TEST_MODE:%s",TEST_MODE,IO_PPMU_CHANEL_Positive[1].PinName))
	LOG.DEBUG(string.format("TEST_MODE:%s,Set_IO_TEST_MODE:%s",TEST_MODE,IO_PPMU_CHANEL_Positive[2].PinName))
	LOG.DEBUG(string.format("TEST_MODE:%s,Set_IO_TEST_MODE:%s",TEST_MODE,IO_PPMU_CHANEL_Positive[3].PinName))
	LOG.DEBUG(string.format("TEST_MODE:%s,Set_IO_TEST_MODE:%s",TEST_MODE,IO_PPMU_CHANEL_Positive[4].PinName))
	--LOG.DEBUG(string.format("TEST_MODE:%s,Set_IO_TEST_MODE:%s",TEST_MODE,IO_PPMU_CHANEL_Positive[5].PinName))

end

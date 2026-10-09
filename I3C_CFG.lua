I3C_CONFIG = {
    I3C_CHANNEL = 0, --{ CHANNEL_A = 0, CHANNEL_B = 1, CHANNEL_C = 2 },
    I3C_LEVEL = 1800, --{ HIGH = 3.300, MIDDLE = 1.800, OFF = 0 },
    SLAVE_ADDR = 0x60, --38==70  3F = 7E  
    I3C_SPEED = 4000,--{ HIGH = 1000, MIDDLE = 400, LOW = 100 },
    RX_DELAY = 0,
    I3C_DUTY = 1,	--AUTO,0:NORMAL
    I3C_DA = 0x29,
    I3C_STATE = 1,--{ EN = 1, CLOSE = 0 },
}



function I3C_INIT()
	I3C.INIT(I3C_CONFIG.I3C_CHANNEL, I3C_CONFIG.I3C_LEVEL, I3C_CONFIG.I3C_SPEED, I3C_CONFIG.I3C_DUTY, I3C_CONFIG.RX_DELAY, I3C_CONFIG.I3C_STATE)
	I3C.BOARD_CAST(1)
	I3C.SET_DASA(I3C_CONFIG.I3C_DA,I3C_CONFIG.SLAVE_ADDR)
	
	LOG.INFO(string.format("I3C_CHANNEL:%d",I3C_CONFIG.I3C_CHANNEL))
	LOG.INFO(string.format("I3C_SPEED:%d",I3C_CONFIG.I3C_SPEED))
	
end


function I3C_W_Tab2(addr,data)

	I3C.WRITE( {0xF0}, {0x5a,0x5a}) 
	I3C.WRITE( {0xF1}, {0x5a,0x5a})
	I3C.WRITE( {0xFc}, {0x5a,0x5a})
	addr_S = addr
	data_S = data
	local addr = {addr&0xFF}
	if type(data) == "number" then
		-- 传入32位数字
		payload = {(data>>24)&0xFF,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF}
		LOG.INFO("data is number")
	elseif type(data) == "table" then
		payload = data
	else
		LOG.ERROR("Tab2 invalid data type ,actual type", type(data))
		return
	end
	I3C.WRITE(addr,payload)

end


function I3C_R_Tab2(addr,data_len)
	I3C.WRITE( {0xF0}, {0x5a,0x5a}) 
	I3C.WRITE( {0xF1}, {0x5a,0x5a})
	I3C.WRITE( {0xFc}, {0x5a,0x5a})
	local byte_str = ""
	local addre = {addr&0xFF}
	local ReadData = I3C.READ(addre,data_len)
	for i =1,data_len do
		byte_str = byte_str .. " " .. string.format("0x% 02x ",ReadData[i])
	end
	
	local value = 0
	for i = 1,data_len do
		value = (value << 8) | ReadData[i]
	end
	--local value = (ReadData[4]<<24) + (ReadData[3]<<16) + (ReadData[2]<<8) + ReadData[1]
	LOG.INFO(string.format("REG:0x%04x len = %d bytes | Raw:[ %s] ",addr,data_len,byte_str))
	return value
end



--function I3C_Key_Set()

	--IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	--IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	--IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
--end



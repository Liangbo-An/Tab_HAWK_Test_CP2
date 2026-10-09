imShow = {
	--"W.bmp",
	"checkerboard.bmp",
	"W255.bmp",
	--"W0.bmp",
	--"dot.bmp",
	"1by12-1.bmp",
	"1by12-2.bmp",
	"1by12-3.bmp",
	"1by12-4.bmp",
	"1by12-5.bmp",
	"1by12-6.bmp",
	"1by12-7.bmp",
	"1by12-8.bmp",
	"1by12-9.bmp",
	"1by12-10.bmp",
	"1by12-11.bmp",
	--"1by12-12.bmp",
	--"gamma.bmp",
	--"Chessboard_Neg.bmp",
	--"Chessboard_Pos.bmp",
	--"CrossHair_Image.bmp",
	--"Chessboard.bmp",

}


Folder = "./textures_1/" 

imIndex = 1
LOG.INFO(imIndex)
bist_mode = 0	--1:bistmode, 0:PG

function Next()
	if imIndex >= #imShow then
		imIndex = 1
	else
		imIndex = imIndex + 1
	end
	if bist_mode == 1 then
		
		bitset_mode_swich(imIndex)
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
	end
	return imIndex
end


function Prev()
	if imIndex <= 1 then
		imIndex = #imShow
	else
		imIndex = imIndex - 1
	end
	if bist_mode == 1 then
		bitset_mode_swich(imIndex)
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
	end
	return imIndex
end


function Sw_by_index(index)
	if bist_mode == 0 then--1:bistmode, 0:PG
	
		PIC.SW(Folder..'/'..imShow[index])
	else
		bitset_mode_swich(index)
	end
	--LOG.DEBUG("PIC.SW("..Folder..imShow[index]..")")
end


function  FirstPicture()
	if bist_mode == 0 then--1:bistmode, 0:PG
		IIC_W_Tab2(0xBD, {0x00}) -- Set to 45hz
		PIC.SW(Folder..'/'..imShow[1])
		--PIC.SW(Folder..'/'..imShow[1])
		LOG.DEBUG("PIC.SW("..Folder..imShow[1]..")")
	else
		--PWM_timing_from_Sapien_092326()
		--IIC_W_Tab2(0xBD, {0x10}) -- Set to 90hz

		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
		
		IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40, 0x00,0x80  ,0x01,0x00,0x00,0x00})  --PWM Timing Gen
		IIC_W_Tab2(0xE4,{0x00,0x05,0x05,0x08,0x0f,0x00})  --PWM Timing Gen

		-- PWM_timing_debug_9square()
		
		 -- PWM_timing_debug_case(0)
		
		VPG_SetFlatField(255)  --display on first picture  flat field

	end
end

function FirstPicture_Post_Initial()
	if bist_mode == 0 then--1:bistmode, 0:PG
		PIC.SW(Folder..'/'..imShow[2])
		--PIC.SW(Folder..'/'..imShow[1])
		LOG.DEBUG("PIC.SW("..Folder..imShow[2]..")")
	else
		bitset_mode_swich(2)
	end
end

function Sw_by_name(name)
	local result_table = {}
	local ret=""
	imIndex=getImageIndex(name)
	if imIndex==nil then
		ret="NG"
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
		ret="OK"
	end
	table.insert(result_table,ret)
	json_data = cjson.encode(result_table)
	return 0,json_data
end


function bitset_mode_swich(mode)
	if mode == 1 then
		println("Horizontal Bars")
		VPG_IIC_WRITE(1)
	elseif mode == 2 then
		println("Vertical Bars")
		VPG_IIC_WRITE(2)
	elseif mode == 3 then
		println("Checkerboard")
		VPG_IIC_WRITE(3)
	elseif mode == 4 then
		println("Cross hairs")
		VPG_IIC_WRITE(4)
	elseif mode == 5 then
		println("9 cross Pattern")
		VPG_IIC_WRITE(5)
	elseif mode == 6 then
		println("repeated Tile")
		VPG_IIC_WRITE(6)
	elseif mode == 7 then
		println("single Horizontal Stripe")
		VPG_IIC_WRITE(7)
	elseif mode == 8 then
		println("single Vertical Stripe")
		VPG_IIC_WRITE(8)
	elseif mode == 9 then
		println("Flat Field")
		VPG_IIC_WRITE(9)
	elseif mode == 10 then
		println("Gradient")
		VPG_IIC_WRITE(10)
	elseif mode == 11 then
		println("9 Square Pattern")
		VPG_IIC_WRITE(11)
	end

end

function getImageIndex(name)
    for i, v in ipairs(imShow) do
        if v == name then
            return i
        end
    end
    LOG.ERROR("图片不存在")
    return nil  -- 未找到返回nil
end

function Soft_Multi_frame(black1_number,w1_number,black2_number,pic_name, delay_time,trigger_keep_time,delay)
	
	keep_cycle = math.floor(trigger_keep_time/1.85)
	FPGA.PCIE_WRITE(0x25C4, 0x2 | (keep_cycle<<8) | delay<<16)
	
	TIME.DELAY(delay_time)
	PIC.MULTI_SW(1,"./textures1/W0.bmp",black1_number,"./textures_1/"..pic_name,w1_number,"./textures_1/W0.bmp",black2_number)
	--PIC.MULTI_SW(1,"./textures/"..pic_name,black1_number,"./textures/"..pic_name,w1_number,"./textures/"..pic_name,black2_number)
	
end

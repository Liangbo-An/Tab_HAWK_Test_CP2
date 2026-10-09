DAC_CTRL_value=0x50111
DAC_word_value=0x1FF
LUT_val=0x0F
--RSYNC_CFG=0x30002D0
RSYNC_CFG=0x30002D0
MIPI_TERM=1
BGTRIM_VALUE=0x1




function packBitFh(val)
	val =  val& 0xFFF
	local high4 = val >> 8
	local low8 = val & 0xFF
	return high4, low8
end

 cust_otp_data = {}
for i = 0, 255 do
    table.insert(cust_otp_data, 0x00)
end

Reg_DC_Table = {}
function Read_Reg_EOFT_LUT(reg)
	local read_data = {}
	value,read_data =  IIC_R_Tab2(reg, 256)
	--Reg_DC_Table = read_data
	
	--for i=1,#read_data do
		--LOG.INFO(string.format("[%d]  = 0x%02x",i-1,read_data[i]))
	--end
	
	return read_data

end


-- DCh 
 lut1_0_data = {}
--for i = 0, 127 do
    --local val = i
    --local p1, p2 = packBitFh(val)
    --table.insert(lut1_0_data, p1)
    --table.insert(lut1_0_data, p2)
--end



-- DDh (0xDD) 
 lut1_1_data = {}
--for i = 128, 255 do
    --local val = i
   --local p1, p2 = packBitFh(val)
    --table.insert(lut1_1_data, p1)
    --table.insert(lut1_1_data, p2)
--end



-- DEh (0xDE) 
 lut2_0_data = {}
--for i = 0, 127 do
    --local val = i  -- 
     --local p1, p2 = packBitFh(val)
    --table.insert(lut2_0_data, p1)
    --table.insert(lut2_0_data, p2)
--end


-- DFh (0xDF) 
 lut2_1_data = {}
--for i = 128, 255 do
    --local val = i  --
   --local p1, p2 = packBitFh(val)
    --table.insert(lut2_1_data, p1)
    --table.insert(lut2_1_data, p2)
--end

 FB_payload = {
	0x07,
	0x27,
	0xE5,	--VDC_VEELED_BYPASS_ASS[1:0]=10 
	0x01,
	0x03,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00
}

 trim_data = {
    0x72,  -- 1st P  OSC_FTRIM[7:0]
    0x10,  -- 2nd P  VDC_VDDPHY_TRIM[4:0]
    0x10,  -- 3rd P  VDC_VDDLP_TRIM[4:0]
    0x10,  -- 4th P  VDC_VDDPLL_TRIM[4:0]
    0x20,  -- 5th P  VDC_VREF_TRIM[5:0]
    0x10,  -- 6th P  VDC_VDDA_TRIM[4:0]
    0x10,  -- 7th P  VDC_VDDPXL_TRIM[4:0]
    0x25,  -- 8th P  VDC_VEEA1P6_TRIM[5:0]
    0x0A,  -- 9th P  VDC_VEEA1P2_TRIM[5:0]
    0x0A,  -- 10th P VDC_VEEA1_TRIM[4:0]
    0x03,  -- 11th P VDC_BGR_IBIAS[1:0] , VDC_MAIN_IBIAS[3:0]
    0x11,  -- 12th P VDC_VT_IBIAS[1:0] , VDC_LDO_IBIAS[1:0]
    0x20,  -- 13th P VDC_IREF_TRIM[5:0]
    0x01,  -- 14th P PBIAS_IPXL_TRIM[8]
    0x00,  -- 15th P PBIAS_IPXL_TRIM[7:0]
    0x00,  -- 16th P PHY_TERM50_TRIM[4:0]
    0x00,  -- 17th P PHY_TERM80_TRIM[4:0]
    0x00,  -- 18th P PHY_BIAS_TRIM[5:0]
    0x00,  -- 19th P PHY_OCALAP[6:0]
    0x00,  -- 20th P PHY_OCALBP[6:0]
    0x00,  -- 21st P PHY_OCALCP[6:0]
    0x00,  -- 22nd P PHY_OCALAN[6:0]
    0x00,  -- 23rd P PHY_OCALBN[6:0]
    0x00,  -- 24th P PHY_OCALCN[6:0]
    0x20,  -- 25th P TSL_TOP_TRIM[5:0]
    0x20,  -- 26th P TSR_TOP_TRIM[5:0]
    0x20,  -- 27th P TSL_BOT_TRIM[5:0]
    0x20,  -- 28th P TSR_BOT_TRIM[5:0]
    0x88,  -- 29th P TSR_BGR_TRIM[3:0] , TSL_BGR_TRIM[3:0]
    0x02,  -- 30th P TSL_TRIM_TARGET[9:8]
    0x00,  -- 31st P TSL_TRIM_TARGET[7:0]
    0x02,  -- 32th P TSR_TRIM_TARGET[9:8]
    0x00   -- 33th P TSR_TRIM_TARGET[7:0]
}


function F_I2C_Initial_MIPI()

	local ret = 1
	local data = {}
	
	--Read_Reg_DCh(0xDc)
	
	IIC_W_Tab2(0xF0, 0x5A5A)   --Level2 Key Enable
	IIC_W_Tab2(0xB1, 0x01)     --Tarp mode
	IIC_W_Tab2(0xB2, 0x24)	 --DEMUX CSR
	IIC_W_Tab2(0xB3, {0x0F,0x0F,0x0F,0x0F,0x00,0x03})	 --DEMUX CTRL
	IIC_W_Tab2(0xC1, cust_otp_data)   --Customer OTP

	lut1_0_data =  Read_Reg_EOFT_LUT(0xDC)
	IIC_W_Tab2(0xDC, lut1_0_data)	  --EOTF_LUT1_1
	
	lut1_1_data =  Read_Reg_EOFT_LUT(0xDD)
	IIC_W_Tab2(0xDD, lut1_1_data)	  --EOTF_LUT1_2
	
	lut2_0_data =  Read_Reg_EOFT_LUT(0xDE)
	IIC_W_Tab2(0xDE, lut2_0_data)	  --EOTF_LUT2_1
	
	lut2_1_data =  Read_Reg_EOFT_LUT(0xDF)
	IIC_W_Tab2(0xDF, lut2_1_data)	  --EOTF_LUT2_2
	IIC_W_Tab2(0xF8, trim_data)		  --TRIM
	IIC_W_Tab2(0xF0, 0xA5A5)	  --Level2 Key Disable
	IIC_W_Tab2(0xF4, 0x01)			  --Update
	
	IIC.WRITE(0x60, {0x11})			  --Sleep Out
	IIC.WRITE(0x60, {0x29})			  --Display On
	
	IIC_W_Tab2(0x4A, 0x00)			  --ColorSyncStart
	
	return 0, data
end


function Pack11Bit(val)
    local high3 = (val >> 8) & 0x07
    local low8  = val & 0xFF
    return high3, low8
end


function VPG_IIC_WRITE(VPG_Num)
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

	IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xff}) -- Pixel current to max
	local vpg_pattern = (VPG_Num << 4) | 0x01
	--LOG.INFO(string.format("VPG_Num = %d ,VPG_PATTERN = 0x%02x",VPG_Num,vpg_pattern))
	IIC_W_Tab2(0xFA, {vpg_pattern, 0xff, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})
		
	--IIC_W_Tab2(0xF4, {0x01}) --panel update
 
end

--  VPG_SetFlatField(255)
function VPG_SetFlatField(shade)
	local brightless = shade  --0:black,255:white

	IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
	IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
	IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

	IIC_W_Tab2(0xFA, {0X91, brightless, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})
		 
-- IIC_W_Tab2(0xF4, {0x01}) --panel update

end

--  VPG_CrossHair(255,400, 1371)
function VPG_CrossHair(shade, blk_hloc, blk_vloc)
	local brightless = shade  --0:black,255:white
	
    local byte9 = (blk_vloc >> 8) & 0x07
    local byte10 = blk_vloc & 0xFF
    
    local byte11 = (blk_hloc >> 8) & 0x07
    local byte12 = blk_hloc & 0xFF

		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

	--IIC_W_Tab2(0xF6, {0x00, 0x00 ,0xff}) -- Pixel current to max
	IIC_W_Tab2(0xFA, {0X41, brightless, 0, 0, 0x00,0x80,0x00,0x80,byte9,byte10,byte11,byte12})

end

--  VPG_HLINE(255,0, 10)
function VPG_HLINE(shade, blk_hloc, blk_hsize)
	local brightless = shade  --0:black,255:white
	
    local byte3 = (blk_hsize >> 8) & 0x07
    local byte4 = blk_hsize & 0xFF
    
    local byte9 = (blk_hloc >> 8) & 0x07
    local byte10 = blk_hloc & 0xFF
    
	IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
	IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
	IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

	--IIC_W_Tab2(0xF6, {0x00, 0x00 ,0xff}) -- Pixel current to max
	IIC_W_Tab2(0xFA, {0X71, brightless, byte3, byte4, 0x00,0x80,0x00,0x80,byte9,byte10})

	--IIC_W_Tab2(0xF4, {0x01}) --panel update

end


--  VPG_VLINE(255, 350, 10)
function VPG_VLINE(shade, blk_vloc, blk_vsize)
	local brightless = shade  --0:black,255:white
	
    local byte3 = (blk_vsize >> 8) & 0x07
    local byte4 = blk_vsize & 0xFF
    
    local byte11 = (blk_vloc >> 8) & 0x07
    local byte12 = blk_vloc & 0xFF
    
	IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
	IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
	IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

	--IIC_W_Tab2(0xF6, {0x00, 0x00 ,0xff}) -- Pixel current to max
	IIC_W_Tab2(0xFA, {0X81, brightless, byte3, byte4,0x00,0x80,0x00,0x00,0,0,byte11,byte12})


end

--  VPG_SetCheckerboard(0,128, 128)
function VPG_SetCheckerboard(shade, blk_hsize, blk_vsize)
    -- 1st P: PG_SEL=3，PG_MODE_EN=1
    local byte1 = (3 << 4) | 0x01
    -- 2nd P: PG_SHADE
    local byte2 = shade
    local byte3 = 0x00
    local byte4 = 0x10

    -- 5th P: bit[7:3]=0，bit[2:0] = PG_BLK_VSIZE[10:8]
    local byte5 = (blk_vsize >> 8) & 0x07
    -- 6th P: PG_BLK_VSIZE[7:0]
    local byte6 = blk_vsize & 0xFF
    
    local byte7 = (blk_hsize >> 8) & 0x07
    local byte8 = blk_hsize & 0xFF

    local data_buf = {
        byte1,
        byte2,
        byte3,
        byte4,
        byte5,
        byte6,
        byte7,
        byte8,
        0x00
    }
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

    --IIC_W_Tab2(0xF6, {0x00, 0x01, 0xff})
    	IIC_W_Tab2(0xFA, data_buf)
    	
		IIC_W_Tab2(0xF4, {0x01}) --panel update

    LOG.INFO(string.format("Checkerboard cfg done"))
end


--VPG_SPARSEDGRID_X_Y(20, 20, 1,1)
function VPG_SPARSEDGRID_X_Y(PAT_VSIZE, PAT_HSIZE, PAT_X,PAT_Y)
    -- 1st P: PG_SEL=6，PG_MODE_EN=1
    local byte1 = (6 << 4) | 0x01
    -- 2nd P: PG_SHADE
    local byte2 = 0x00
    
    local byte13 = (PAT_VSIZE >> 8) & 0x07
    local byte14 = PAT_VSIZE & 0xFF
    
    local byte15 = (PAT_HSIZE >> 8) & 0x07
    local byte16 = PAT_HSIZE & 0xFF
    
    local byte17 = (PAT_X >> 8) & 0x07
    local byte18 = PAT_X & 0xFF
    
    local byte19 = (PAT_Y >> 8) & 0x07
    local byte20 = PAT_Y & 0xFF
    

    local data_buf = {
        byte1,
        byte2,
        0x00,
        0x10,
        0x00,
        0x10,
        0x00,
        0x10,
        0x02,
        0xE0,
        0x03,
        0xA0,
        byte13,
        byte14,
        byte15,
        byte16,
        byte17,
        byte18,
        byte19,
        byte20
       
    }
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

    --IIC_W_Tab2(0xF6, {0x00, 0x01, 0xff})
    	IIC_W_Tab2(0xFA, data_buf)
    	
		IIC_W_Tab2(0xF4, {0x01}) --panel update

    LOG.INFO(string.format("Repeated Tile cfg done"))
end


--  VPG_9POINT_FRC(928, 736, 620, 470)
--function VPG_9POINT_FRC(cx, cy, ox, oy)
    --local data_buf = {
        ---- 1st P: PG_SEL=5, PG_MODE_EN=1
        --0x51,
        ---- 2nd ~ 20th 
        --0xFF,   -- 2 PG_SHADE
        --0x00,   -- 3 PG_BAR_WIDTH[10:8]
        --0x10,   -- 4 PG_BAR_WIDTH[7:0]
        --0x00,   -- 5 PG_BLK_VSIZE[10:8]
        --0x10,   -- 6 PG_BLK_VSIZE[7:0]
        --0x00,   -- 7 PG_BLK_HSIZE[10:8]
        --0x10,   -- 8 PG_BLK_HSIZE[7:0]
        --0x02,   -- 9 PG_VLINE[10:8]
        --0xE0,   --10 PG_VLINE[7:0]
        --0x03,   --11 PG_HLINE[10:8]
        --0xA0,   --12 PG_HLINE[7:0]
        --0x00,   --13 PG_PAT_VSIZE[10:8]
        --0x10,   --14 PG_PAT_VSIZE[7:0]
        --0x00,   --15 PG_PAT_HSIZE[10:8]
        --0x10,   --16 PG_PAT_HSIZE[7:0]
        --0x00,   --17 PG_PAT_X[10:8]
        --0x01,   --18 PG_PAT_X[7:0]
        --0x00,   --19 PG_PAT_Y[10:8]
        --0x01,   --20 PG_PAT_Y[7:0]

        ---- 21~24 中心十字坐标（传入参数）
        --(cx >> 8) & 0x07,  --21 PG_CROSS_CENTER_X[10:8]
        --cx & 0xFF,          --22 PG_CROSS_CENTER_X[7:0]
        --(cy >> 8) & 0x07,  --23 PG_CROSS_CENTER_Y[10:8]
        --cy & 0xFF,          --24 PG_CROSS_CENTER_Y[7:0]

        ---- 25~28 十字偏移量
        --(ox >> 8) & 0x07,  --25 PG_CROSS_OFFSET_X[10:8]
        --ox & 0xFF,          --26 PG_CROSS_OFFSET_X[7:0]
        --(oy >> 8) & 0x07,  --27 PG_CROSS_OFFSET_Y[10:8]
        --oy & 0xFF           --28 PG_CROSS_OFFSET_Y[7:0]
    --}

    --IIC_W_Tab2(0xF6, {0x00, 0x01, 0xff})
    --IIC_W_Tab2(0xFA, data_buf)

    --LOG.INFO(string.format(
        --"9Cross: CX=%d,CY=%d,OX=%d,OY=%d",
        --cx, cy, ox, oy
    --))
--end


-- VPG_SetSparseGrid(20, 20, 11, 11)
-- VPG_SetSparseGrid(64, 64, 0, 0)
function VPG_SetSparseGrid(pat_hsize, pat_vsize, pat_x, pat_y)
    local data_buf = {
        -- 1st P: PG_SEL=6, PG_MODE_EN=1 → 0x61
        0x61,
        -- 2nd P PG_SHADE
        0xFF,
        -- 3rd P PG_BAR_WIDTH[10:8]
        0x00,
        -- 4th P PG_BAR_WIDTH[7:0]
        0x10,
        -- 5th P PG_BLK_VSIZE[10:8]
        0x00,
        -- 6th P PG_BLK_VSIZE[7:0]
        0x10,
        -- 7th P PG_BLK_HSIZE[10:8]
        0x00,
        -- 8th P PG_BLK_HSIZE[7:0]
        0x10,
        -- 9th P PG_VLINE[10:8]
        0x02,
        --10th P PG_VLINE[7:0]
        0xE0,
        --11th P PG_HLINE[10:8]
        0x03,
        --12th P PG_HLINE[7:0]
        0xA0,
        --13th P PG_PAT_VSIZE[10:8]
        (pat_vsize >> 8) & 0x07,
        --14th P PG_PAT_VSIZE[7:0]
        pat_vsize & 0xFF,
        --15th P PG_PAT_HSIZE[10:8]
        (pat_hsize >> 8) & 0x07,
        --16th P PG_PAT_HSIZE[7:0]
        pat_hsize & 0xFF,
        --17th P PG_PAT_X[10:8]
        (pat_x >> 8) & 0x07,
        --18th P PG_PAT_X[7:0]
        pat_x & 0xFF,
        --19th P PG_PAT_Y[10:8]
        (pat_y >> 8) & 0x07,
        --20th P PG_PAT_Y[7:0]
        pat_y & 0xFF
    }

		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

    --IIC_W_Tab2(0xF6, {0x00, 0x01, 0xff})
    	IIC_W_Tab2(0xFA, data_buf)
    
		IIC_W_Tab2(0xF4, {0x01}) --panel update

    LOG.INFO(string.format(
        "SparseGrid: HSIZE=%d,VSIZE=%d,PAT_X=%d,PAT_Y=%d",
        pat_hsize, pat_vsize, pat_x, pat_y
    ))
end

--- Configures VPG active area size (VPG_VACTIVE / VPG_HACTIVE, register FAh) and Start Image Position (VSIP / HSIP, register B4h).
-- Reads the chip's current values and uses them as defaults; parameters override.
-- On FAh, only bytes 37-40 (VACTIVE/HACTIVE) are modified.
-- On B4h, all 4 bytes are rewritten (writes back the read values when VSIP/HSIP are not given).
-- Use VPG_SetSparseGrid / VPG_SetCheckerboard to change the pattern itself.
-- @param VPG_VACTIVE number Vertical active area size. Default = read from FAh bytes 37-38.
-- @param VPG_HACTIVE number Horizontal active area size. Default = read from FAh bytes 39-40.
-- @param VSIP number Vertical start image position. Default = read from B4h bytes 1-2.
-- @param HSIP number Horizontal start image position. Default = read from B4h bytes 3-4.
-- @usage VPG_SetActiveArea()                      -- keep chip's current values
-- @usage VPG_SetActiveArea(1272, 1656, 100, 100)  -- override all four
-- VPG_SetActiveArea(1472, 1856, 0, 0)
-- @usage VPG_SetActiveArea(nil, nil, 928, 736)    -- keep VACTIVE/HACTIVE, set VSIP/HSIP
-- @see VPG_SetSparseGrid, VPG_SetCheckerboard
function VPG_SetActiveArea(VPG_VACTIVE, VPG_HACTIVE, VSIP, HSIP)

    ------------------------------------------------------------------------
    -- Step 1 : Read the chip's current values (cur_*) to use as defaults
    ------------------------------------------------------------------------
    -- B4h : Start Image Position
    local _, b4_read = IIC_R_Tab2(0xB4, 4)
    local cur_VSIP = ((b4_read[1] & 0x07) << 8) | b4_read[2]   -- 1st+2nd P : VSIP[10:0]
    local cur_HSIP = ((b4_read[3] & 0x07) << 8) | b4_read[4]   -- 3rd+4th P : HSIP[10:0]

    -- FAh : VPG active area at bytes 37-40
    local _, fa_buf = IIC_R_Tab2(0xFA, 40)
    local cur_VPG_VACTIVE = ((fa_buf[37] & 0x07) << 8) | fa_buf[38]  -- byte 37 = [10:8], byte 38 = [7:0]
    local cur_VPG_HACTIVE = ((fa_buf[39] & 0x07) << 8) | fa_buf[40]  -- byte 39 = [10:8], byte 40 = [7:0]
	
    LOG.INFO(string.format(
        "VPG_SetActiveArea (Read current): cur_VPG_VACTIVE=%d, cur_VPG_HACTIVE=%d, cur_VSIP=%d, cur_HSIP=%d",
        cur_VPG_VACTIVE, cur_VPG_HACTIVE, cur_VSIP, cur_HSIP
    ))
    ------------------------------------------------------------------------
    -- Step 2 : Final value = caller's argument if given, else chip's current
    ------------------------------------------------------------------------
    VPG_VACTIVE = VPG_VACTIVE or cur_VPG_VACTIVE   -- Vertical active area size
    VPG_HACTIVE = VPG_HACTIVE or cur_VPG_HACTIVE   -- Horizontal active area size
    VSIP        = VSIP        or cur_VSIP          -- Vertical start image position
    HSIP        = HSIP        or cur_HSIP          -- Horizontal start image position

    ------------------------------------------------------------------------
    -- Step 3 : Write B4h (Start Image Position)
    ------------------------------------------------------------------------
    local b4_write = {
        (VSIP >> 8) & 0x07,   -- 1st P : VSIP[10:8]
        VSIP & 0xFF,          -- 2nd P : VSIP[7:0]
        (HSIP >> 8) & 0x07,   -- 3rd P : HSIP[10:8]
        HSIP & 0xFF           -- 4th P : HSIP[7:0]
    }
    IIC_W_Tab2(0xB4, b4_write)

    ------------------------------------------------------------------------
    -- Step 4 : Write FAh -- only bytes 37-40 (VACTIVE/HACTIVE) are replaced;
    --          bytes 1-36 (pattern / crosshair / square) keep their read-back
    --          values because fa_buf is modified in place and written back.
    ------------------------------------------------------------------------
    fa_buf[37] = (VPG_VACTIVE >> 8) & 0x07  -- VPG_VACTIVE[10:8]    (high)
    fa_buf[38] =  VPG_VACTIVE & 0xFF        -- VPG_VACTIVE[7:0]     (low)
    fa_buf[39] = (VPG_HACTIVE >> 8) & 0x07  -- VPG_HACTIVE[10:8]    (high)
    fa_buf[40] =  VPG_HACTIVE & 0xFF        -- VPG_HACTIVE[7:0]     (low)

    IIC_W_Tab2(0xF6, {0x00, 0x01, 0xff})  -- Pixel current to max
    IIC_W_Tab2(0xFA, fa_buf)
    TIME.DELAY(30)
	IIC_W_Tab2(0xF4, {0x01})
	
    LOG.INFO(string.format(
        "VPG_SetActiveArea (Final): VPG_VACTIVE=%d, VPG_HACTIVE=%d, VSIP=%d, HSIP=%d",
        VPG_VACTIVE, VPG_HACTIVE, VSIP, HSIP
    ))
end

function Display_init(mode)

	bist_mode = (mode == nil) and 0 or mode
	if bist_mode == 0 then--1:bistmode, 0:PG
		--DMIPI.VID()
		--TIME.DELAY(10)
		--DMIPI.HS() --VIDEO Using
		
		--CORE.SPI_WRITE(0xD5,0x00,0x00,0x00,0x01)  --clk hs
		DMIPI.VID()
		TIME.DELAY(10)
		DMIPI.HS() --VIDEO Using
		--IIC_Key_Set()
		IIC.WRITE(0x60,{0x91})
		IIC_W_Tab2(0xB7, 0x00)
		F_I2C_Initial_MIPI()
		LOG.INFO("do mipi")
	else
		--VPG_IIC_WRITE(9,255,"135")
		LOG.INFO("do VPG")
	end
	
end






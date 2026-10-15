-- 显示信号控制模块
Display = {
         --面板时序配置
   Timing = {
        hdisplay   = 1856,    -- 水平有效像素
        hbp        = 52,--188,     -- 水平后沿 60
        hfp        = 50,--187,     -- 水平前沿
        hs         = 20,--20,      -- 水平同步宽度
        hsync_pola = 0,      -- 水平同步极性
        
        vdisplay   = 1472,    -- 垂直有效行数
        vbp        = 13,--16,     -- 垂直后沿
        vfp        = 9,--16,      -- 垂直前沿
        vs         = 3,--8,      -- 垂直同步宽度
        vsync_pola = 0,      -- 垂直同步极性
        
        vrefresh   = 45,     -- 刷新率(Hz)
        Lane       = 2,      -- MIPI通道数
        clock      = 0       -- 时钟配置
    },
    
    -- 接口类型
    Interface = {
        EDP   = 0,
        DMIPI = 1,
        CMIPI = 2,
        LVDS  = 8
    },
    
    -- LVDS配置
    LvdsConfig = {
        JEITA = 0,
        VESA  = 1,
        BPP6  = 6,
        BPP8  = 8,
        BPP10 = 10
    }
}

----- MIPI信号复位序列
--function Display.reset_mipi()
    --TIME.DELAY(10)
    --DMIPI.RESET(0)
    --TIME.DELAY(10)
    --DMIPI.RESET(1)
    --TIME.DELAY(10)
    --DMIPI.RESET(0)
    --TIME.DELAY(10)
    --DMIPI.RESET(1)
--end

----- 初始化MIPI显示接口
--function Display.init_mipi()
    --local t = Display.Timing
    --DIS.TIMING(t.hdisplay, t.hfp, t.hs, t.hbp, t.hsync_pola,
               --t.vdisplay, t.vfp, t.vs, t.vbp, t.vsync_pola, t.vrefresh)
    
    --DIS.SIGNAL(Display.Interface.DMIPI)
    --DMIPI.CTL()
    --DMIPI.RESET(0)
    --DMIPI.MODE(0, 2)  -- 模式: 0-命令模式, 2-plus传输
    --DMIPI.LANE(t.Lane)
    --DMIPI.POLAR(0, 0, 0)  -- 极性配置
    --DMIPI.RESET(1)
--end

--- 初始化LVDS显示接口
function Display.init_lvds()
    local t = Display.Timing
    -- 计算PLL频率(MHz)
    local pll = ((t.hdisplay + t.hbp + t.hfp + t.hs) * 
               (t.vdisplay + t.vbp + t.vfp + t.vs) * 
               t.vrefresh) / 1000
    
    LOG.INFO("PLL Frequency: "..math.floor(pll).."kHz")
    
    DIS.TIMING(t.hdisplay, t.hfp, t.hs, t.hbp, t.hsync_pola,
               t.vdisplay+1, t.vfp-1, t.vs, t.vbp, t.vsync_pola, t.vrefresh)
    
    DIS.SIGNAL(Display.Interface.LVDS)
    
    --CORE.SPI_WRITE(0XD5,0X00,0X00,0X00,0X02) --Set 2 lane 
    CORE.SPI_WRITE(0xBC,0x00,0x00,0x00,0x17)
    CORE.SPI_WRITE(0XD0,0X00,0X00,0X00,0X00)    
    DEDP.CLOSE(0)
    DEDP.FRQ_SET(math.floor(pll))
    TIME.DELAY(2000)
    CORE.SPI_WRITE(0XD0,0X00,0X00,0X00,0X02)    
    DEDP.POLAR(1, 1, 1)
    DEDP.LVDS_SET(Display.LvdsConfig.VESA, Display.LvdsConfig.BPP8)
    DEDP.LVDS_CH(1, 1, 1, 1)  -- 通道使能
    DEDP.LANE(1)
    
	 TIME.DELAY(500)
    MIPI_FREQ_SET_SEL_00(1600) -- 1.6Gbps
    --MIPI_FREQ_SET_SEL10(800)
    --MIPI DPHY使能
	PPMU.DHPY_SEL(0x00)
    DEDP.OPEN(1)
end


function MIPI_RESET()
    local t = Display.Timing
    -- 计算PLL频率(MHz)
    local pll = ((t.hdisplay + t.hbp + t.hfp + t.hs) * 
               (t.vdisplay + t.vbp + t.vfp + t.vs) * 
               t.vrefresh) / 1000
	CORE.SPI_WRITE(0XD0,0X00,0X00,0X00,0X00)    
    DEDP.CLOSE(1)
    DEDP.FRQ_SET(math.floor(pll))
    TIME.DELAY(2000)
    CORE.SPI_WRITE(0XD0,0X00,0X00,0X00,0X02)  
    TIME.DELAY(500)
end
--MIPI frequency configuration
--idiv 
--fdiv 
--mdiv 
--odiv 
--mipi_frequency = 50M * idiv / fdiv * mdiv / odiv
--if using mipi frequancy between 800Mbps～1600Mbps frimware, using this
--frequency unit is Mbps
function MIPI_FREQ_SET_SEL01(frequency)
    mdiv = frequency / 50
    DMIPI.TIMING(0x01,0x01,0x02,0x02,0x02)
    LOG.INFO(string.format("sel mode:01, mdiv:%d", mdiv))
    DMIPI.FREQ(1,1,mdiv,1) 
end

--if using mipi frequancy between 800Mbps～1600Mbps frimware, using this
--frequency unit is Mbps
function MIPI_FREQ_SET_SEL10(frequency)
    mdiv = frequency / 50 * 2
    DMIPI.TIMING(0x01,0x01,0x02,0x02,0x02)
    LOG.INFO(string.format("sel mode:01, mdiv:%d", mdiv))
    DMIPI.FREQ(1,1,mdiv,1) 
end


function MIPI_FREQ_SET_SEL_00(frequency)
    mdiv = frequency / 50 / 2
    DMIPI.TIMING(0x08,0x03,0x04,0x02,0x02)
    LOG.INFO(string.format("sel mode:01, mdiv:%d", mdiv))
    DMIPI.FREQ(1,1,mdiv,1) 
end

Display.init_lvds()

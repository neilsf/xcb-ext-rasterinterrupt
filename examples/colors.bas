REM * Use one single ISR on more rasterlines by "selfmodifying" (sortof..)
REM * (shows the 16 beautiful colors of the C64 on the borders)

include "../xcb-ext-rasterinterrupt.bas"

const lineheight! = 8
const start! = 76
dim index! fast
dim rasterline! fast
index! = 0
rasterline! = 0

proc colors
	if \index! < 16 then
	
		REM * turn off keyboard and cursor to spare some cpu cycles
		ri_syshandler_off
		
		REM * change border color iterating through the 16 available
		poke 53280, \index!
		inc \index!
		
		REM * calculate next rasterline so that the colorbar is 8 pixels tall
		\rasterline! = \start! + \index! * \lineheight! + \index!
		
		REM * reuse same ISR slot for next colorbar
		ri_set_isr 0, @colors, \rasterline!
		
	REM * we have drawn 16 bars already! let's reset to the default bordercolor until next round
	else
		poke 53280, 14
		ri_set_isr 0, @colors, \start!
		\index! = 0
		
		REM * let's reactivate keyboard and cursor, the hard work is behind us
		ri_syshandler_on
	endif
endproc

print "{CLR}"
ri_isr_count! = 1
ri_set_isr 0, @colors, start!
ri_on
end

include "../xcb-ext-rasterinterrupt.bas"

proc red
  poke 53280, 2
endproc

proc white
  poke 53280, 1
endproc

proc green
  poke 53280, 5
endproc

ri_isr_count! = 3
ri_set_isr 0, @red, 0
ri_set_isr 1, @white, 104
ri_set_isr 2, @green, 208
ri_on

print "press any key"

repeat
until inkey!() > 0

ri_off
poke 53280, 14
end

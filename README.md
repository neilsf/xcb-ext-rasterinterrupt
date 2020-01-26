# xcb-ext-rasterinterrupt

XC=BASIC extension for easy raster interrupts. Compatible with XC=BASIC v2.2.04 or higher. [Click here to learn about XC=BASIC](https://xc-basic.net)

# Usage

Include the file `xcb-ext-rasterinterrupt.bas` in the top of your program:

    include "path/to/xcb-ext-rasterinterrupt.bas"
    
That's it, you can now use all the symbols defined by this extension. Avoid naming collisions by not defining symbols starting with `ri_` in your program.

# Quick start

This extension handles raster interrupts via interrupt service routines (ISR). ISRs are nothing but ordinary XC=BASIC procedures:

    proc my_isr
      <statements>
    endproc

ISR procedures can't have parameters or even if they do define parameters, nothing will be passed to them - which is legal in XC=BASIC.

After writing your procedures specify how many ISRs you're going to use at the same time. This is done by setting the `ri_isr_count!` variable:

    ri_isr_count! = 2
    
The `ri_isr_count!` variable must hold a number between 1 and 8.

Then register your ISRs to the interrupt table using the `ri_set_isr` command:

    ri_set_isr 0, @my_isr, 50 : rem my_isr will be called at raster line 50
    ri_set_isr 1, @second_isr, 260 : rem second_isr will be called at raster line 260

Finally, enable raster interrupts like this:

    ri_on

# Detailed documentation

## Commands defined by this extension

### ri_set_isr &lt;byte entry_no>, &lt;int address>, &lt;int raster line>

Adds an entry to the interrupt table. Parameters:

- `entry_no` the number of this entry (0-7)
- `address` at what address the ISR is found. It is recommended to specify the address of a procedure, using the syntax `@proc_name`
- `raster_line` at which raster line the interrupt should occur (0-311)

### ri_on

Disables CIA interrupts and starts raster interrupts. Make sure that at least one ISR is registered to the interrupt table and `ri_isr_count!` is between 1 to 8 before issuing this command.

### ri_off

Turns off raster interrupts and turns CIA interrupts back on.

### ri_syshandler_on

Instructs the runtime to call the KERNAL interrupt handler at $ea31 on each interrupt cycle  to make sure that keyboard input and cursor blinking works while raster interrupts are on. This is turned on by default.

### ri_syshandler_off

Instructs the runtime NOT to call the KERNAL interrupt handler. If you set this, keyboard and cursor will not work while raster interrupts are on.

## Constants defined by this extension

    const RI_CIA1_ICR     = $dc0d
    const RI_CIA2_ICR     = $dd0d
    const RI_VIC_CTR      = $d011
    const RI_VIC_RASTER   = $d012
    const RI_VIC_IRQ_R    = $d019
    const RI_VIC_IRQ_EN   = $d01a

## Variables defined by this extension

    dim ri_isr_count!	; The number of registered ISRs

Private variables (used internally and should not be directly accessed):

	data ri_isr_addr_lo![]
	data ri_isr_addr_hi![]
	data ri_ras_lo![]
	data ri_ras_hi![]
	ri_current_isr!
	ri_syshandler

## Functions defined by this extension

This extension does not define any functions.

# Examples

Please refer to the file `examples/flag.bas` for an example.

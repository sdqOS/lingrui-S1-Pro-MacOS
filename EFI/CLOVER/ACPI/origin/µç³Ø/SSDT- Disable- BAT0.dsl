DefinitionBlock ("", "SSDT", 2, "INSYDE", "BAT0", 0x00000000)
{
    External (_SB_.PCI0.LPCB.H_EC.BAT0, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.BAT0.XSTA, MethodObj)
    
    Scope(_SB.PCI0.LPCB.H_EC.BAT0)
    {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return(Zero)
                }
                Else
                {
                    Return(XSTA())
                }
            }
    }
}


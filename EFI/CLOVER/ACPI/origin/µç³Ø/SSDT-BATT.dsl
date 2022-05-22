DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.BAT1, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.BAT1.POSW, MethodObj)
    External (_SB_.PCI0.LPCB.H_EC.BAT1.XBIF, MethodObj)
    External (_SB_.PCI0.LPCB.H_EC.BAT1.XBST, MethodObj)
    External (_SB_.PCI0.LPCB.H_EC.BATM, MutexObj)
    External (_SB_.PCI0.LPCB.H_EC.B1IC, FieldUnitObj)
    External (_SB_.PCI0.LPCB.H_EC.B1DI, FieldUnitObj)
    External (_SB_.PCI0.LPCB.H_EC.ECA2, IntObj)
    External (_SB_.PCI0.LPCB.H_EC.B1CH, IntObj)

    Method (B1B2, 2, NotSerialized)
    {
        Return ((Arg0 | (Arg1 << 0x08)))
    }

    Method (B1B4, 4, NotSerialized)
    {
        Local0 = (Arg2 | (Arg3 << 0x08))
        Local0 = (Arg1 | (Local0 << 0x08))
        Local0 = (Arg0 | (Local0 << 0x08))
        Return (Local0)
    }

    Method (W16B, 3, NotSerialized)
    {
        Arg0 = Arg2
        Arg1 = (Arg2 >> 0x08)
    }

    Scope (_SB.PCI0.LPCB.H_EC)
    {
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE) /* \RE1B.BYTE */
        }

        Method (RECB, 2, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }

            Return (TEMP) /* \RECB.TEMP */
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }
        
        OperationRegion (ECFX, EmbeddedControl, Zero, 0xFF)
        Field (ECFX, ByteAcc, NoLock, Preserve)
        {
            Offset (0xB8),
            PVB0,8,
            PVB1,8,
            Offset (0xC2),
            RCA0,8,
            RCA1,8,
            DCA0,8,
            DCA1,8,
            DVA0,8,
            DVA1,8,
            Offset (0xCC),
            FCA0,8,
            FCA1,8,
            Offset (0xD0),
            CR10,8,
            CR11,8
        }
    }

    Scope(_SB.PCI0.LPCB.H_EC.BAT1)
    {
            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                If (_OSI ("Darwin"))
                {
                Name (BPKG, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "EA", 
                    "BAT2016", 
                    "LiP", 
                    "XTY"
                })
                Name (BPKH, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "EA", 
                    "BAT2016", 
                    "LiP", 
                    "XTY"
                })
                Name (MDST, Buffer (0x05)
                {
                    "    "
                })
                Name (SNST, Buffer (0x05)
                {
                    "    "
                })
                Name (TPST, Buffer (0x05)
                {
                    "    "
                })
                Name (LENV, Buffer (0x09)
                {
                    "        "
                })
                If (ECA2)
                {
                    Local0 = B1B2(DCA0,DCA1) /* \_SB_.PCI0.LPCB.H_EC.BADC */
                    Local2 = B1B2(DVA0,DVA1) /* \_SB_.PCI0.LPCB.H_EC.BADV */
                    Local3 = (Local0 * Local2)
                    Local3 /= 0x03E8
                    BPKG [One] = Local3
                    BPKH [One] = Local3
                    Local4 = (Local3 / 0x0A)
                    BPKG [0x05] = Local4
                    BPKH [0x05] = Local4
                    Local5 = (Local3 / 0x14)
                    BPKG [0x06] = Local5
                    BPKH [0x06] = Local5
                    Local0 = B1B2(FCA0,FCA1) /* \_SB_.PCI0.LPCB.H_EC.BAFC */
                    Local2 = B1B2(DVA0,DVA1) /* \_SB_.PCI0.LPCB.H_EC.BADV */
                    Local3 = (Local0 * Local2)
                    Local3 /= 0x03E8
                    BPKG [0x02] = Local3
                    BPKH [0x02] = Local3
                }

                If ((B1CH == 0x0050694C))
                {
                    Return (BPKG) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BIF.BPKG */
                }
                Else
                {
                    Return (BPKH) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BIF.BPKH */
                }
            }
            Else
            {
                Return(XBIF())
            }
        }
            
            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                If (_OSI ("Darwin"))
                {
                Acquire (BATM, 0xFFFF)
                Name (PKG1, Package (0x04)
                {
                    Ones, 
                    Ones, 
                    Ones, 
                    Ones
                })
                If (ECA2)
                {
                    Local0 = (B1IC << One)
                    Local1 = (B1DI | Local0)
                    PKG1 [Zero] = Local1
                    Local2 = B1B2(CR10,CR11) /* \_SB_.PCI0.LPCB.H_EC.B1CR */
                    Local2 = POSW (Local2)
                    Local3 = B1B2(PVB0,PVB1) /* \_SB_.PCI0.LPCB.H_EC.BAPV */
                    Divide (Local3, 0x03E8, Local4, Local3)
                    Local2 *= Local3
                    PKG1 [One] = Local2
                    PKG1 [0x03] = B1B2(PVB0,PVB1) /* \_SB_.PCI0.LPCB.H_EC.BAPV */
                    Local2 = (B1B2(RCA0,RCA1) * B1B2(DVA0,DVA1)) /* \_SB_.PCI0.LPCB.H_EC.BADV */
                    Local2 /= 0x03E8
                    PKG1 [0x02] = Local2
                }

                Release (BATM)
                Return (PKG1) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BST.PKG1 */
            }
            Else
            {
                Return(XBST())
            }
        }
    }
}


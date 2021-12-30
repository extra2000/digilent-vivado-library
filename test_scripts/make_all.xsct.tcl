set pmods [list \
    PmodACL \
    PmodACL2 \
    PmodAD1 \
    PmodAD2 \
    PmodAD5 \
    PmodALS \
    PmodAMP2 \
    PmodAQS \
    PmodBLE \
    PmodBT2 \
    PmodCAN \
    PmodCLS \
    PmodCMPS2 \
    PmodCOLOR \
    PmodDA1 \
    PmodDA4 \
    PmodDHB1 \
    PmodDPG1 \
    PmodENC \
    PmodESP32 \
    PmodGPIO \
    PmodGPS \
    PmodGYRO \
    PmodHYGRO \
    PmodJSTK2 \
    PmodKYPD \
    PmodMAXSONAR \
    PmodMTDS \
    PmodNAV \
    PmodOLED \
    PmodOLEDrgb \
    PmodPIR \
    PmodR2R \
    PmodRTCC \
    PmodSD \
    PmodSF3 \
    PmodTC1 \
    PmodTMP3 \
    PmodToF \
    PmodWIFI \
]

puts "INFO: Running [info script]"

foreach pmod $pmods {
    set argv $pmod
    set script [info script]
    set script_dir [file dirname [file normalize $script]]
    source [file join $script_dir create_sw.xsct.tcl]
}
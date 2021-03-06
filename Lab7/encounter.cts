###############################################################
#  Generated by:      Cadence Encounter 09.11-s084_1
#  OS:                Linux x86_64(Host ID ecegrid-thin5.ecn.purdue.edu)
#  Generated on:      Tue Mar  8 14:56:39 2016
#  Command:           createClockTreeSpec -output encounter.cts
###############################################################
#
# Encounter(R) Clock Synthesis Technology File Format
#

#-- MacroModel --
#MacroModel pin <pin> <maxRiseDelay> <minRiseDelay> <maxFallDelay> <minFallDelay> <inputCap>

#-- Special Route Type --
#RouteTypeName specialRoute
#TopPreferredLayer 4
#BottomPreferredLayer 3
#PreferredExtraSpace 1
#End

#-- Regular Route Type --
#RouteTypeName regularRoute
#TopPreferredLayer 4
#BottomPreferredLayer 3
#PreferredExtraSpace 1
#End

#-- Clock Group --
#ClkGroup
#+ <clockName>

#------------------------------------------------------------
# Clock Root   : clk
# Clock Name   : clk
# Clock Period : 4ns
#------------------------------------------------------------
AutoCTSRootPin clk
Period         4ns
MaxDelay       4ns # default value
MinDelay       0ns   # default value
MaxSkew        300ps # default value
SinkMaxTran    400ps # default value
BufMaxTran     400ps # default value
Buffer         BUFX2 BUFX4 CLKBUF1 INVX1 INVX2 INVX4 INVX8 
NoGating       NO
DetailReport   YES
#SetDPinAsSync  NO
#SetIoPinAsSync NO
#SetASyncSRPinAsSync  NO
#SetTriStEnPinAsSync NO
#SetBBoxPinAsSync NO
#RouteClkNet    NO
#PostOpt        YES
#OptAddBuffer   NO
#RouteType      specialRoute
#LeafRouteType  regularRoute
ThroughPin
END


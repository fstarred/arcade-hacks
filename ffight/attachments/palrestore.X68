*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $E0800
START:                  ; first instruction of program

* Put program code here

L4E86:
    MOVE.W #$4,($0,A5)
    JSR $6451A
    RTS

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

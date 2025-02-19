szazad = 0
mp = 0
perc = 0
OPEN "STAT.TXT" FOR INPUT AS #1
OPEN "__STAT_EXCEL1.TXT" FOR OUTPUT AS #2
DO WHILE NOT EOF(1)
    INPUT #1, arr$
    arr$ = StrReplace$(".", ",", arr$)
    PRINT LTRIM$(RIGHT$(arr$, 8))
    szazad$ = LTRIM$(RIGHT$(arr$, 2))
    REM PRINT "szazad="; VAL(szazad$)
    szazad = szazad + VAL(szazad$)
    mp$ = LTRIM$(LEFT$(RIGHT$(arr$, 5), 2))
    mp = mp + VAL(mp$)
    perc$ = LTRIM$(LEFT$(RIGHT$(arr$, 8), 2))
    perc = perc + VAL(perc$)
    PRINT #2, LTRIM$(RIGHT$(arr$, 8))
LOOP
CLOSE #2
CLOSE #1

addszazad = szazad \ 100
remszazad = szazad MOD 100

'
PRINT "szazadok="; szazad; "="; addszazad; "mp +"; remszazad; "szazad"



mp = mp + addszazad
addperc = mp \ 60
remperc = mp MOD 60

'
PRINT "masodpercek="; mp; "="; addperc; "perc +"; remperc; "mp"
'
PRINT "percek="; perc

totalperc = perc + addperc

'
PRINT "total="; perc + addperc; CHR$(58); remperc; "."; remszazad



PRINT "Total = " + LTRIM$(STR$(totalperc)) + CHR$(58) + LTRIM$(STR$(remperc)) + CHR$(46) + LTRIM$(STR$(remszazad))

'TT export added 2022-09-14
OPEN "__STAT_TT.TXT" FOR OUTPUT AS #4
PRINT #4, "Total = " + LTRIM$(STR$(totalperc)) + CHR$(58) + LTRIM$(STR$(remperc)) + CHR$(46) + LTRIM$(STR$(remszazad))
CLOSE #4
'---

OPEN "STAT.TXT" FOR INPUT AS #1
OPEN "__STAT_EXCEL2.TXT" FOR OUTPUT AS #3
DO WHILE NOT EOF(1)
    INPUT #1, arr$
    PRINT #3, LTRIM$(RIGHT$(arr$, 8))
LOOP
CLOSE #3
CLOSE #1


END

FUNCTION StrReplace$ (oldChars AS STRING, newChars AS STRING, sourceString AS STRING)
    DIM o AS INTEGER, n AS INTEGER, i AS INTEGER

    n = LEN(sourceString)
    o = LEN(oldChars)
    IF n < 1 THEN
        StrReplace$ = ""
        EXIT FUNCTION
    END IF

    IF o > n THEN
        StrReplace$ = sourceString
        EXIT FUNCTION
    END IF

    IF n = o THEN
        IF sourceString = oldChars THEN
            StrReplace$ = newChars
            EXIT FUNCTION
        END IF
    END IF

    StrReplace$ = ""
    FOR i = 1 TO n
        IF i + o <= n THEN
            IF MID$(sourceString, i, o) = oldChars THEN
                StrReplace$ = StrReplace$ + newChars
                i = i + o - 1
            ELSE
                StrReplace$ = StrReplace$ + MID$(sourceString, i, 1)
            END IF
        ELSE
            StrReplace$ = StrReplace$ + MID$(sourceString, i)
            EXIT FUNCTION
        END IF
    NEXT

END FUNCTION



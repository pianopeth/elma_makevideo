TYPE TestRecord
    Headerr AS STRING * 20
    Levname AS STRING * 16
END TYPE
DIM MyClass AS TestRecord

recdir$ = _STARTDIR$ + "\REC\"
levdir$ = _STARTDIR$ + "\LEV\"

file$ = DIR$(recdir$ + "*.rec") 'use a file spec ONCE to find the last file name listed
REM PRINT file$ 'function can return the file count using SHARED variable

OPEN "___RECLEV.CSV" FOR OUTPUT AS #99
OPEN "__STAT_EXCEL2.TXT" FOR INPUT AS #98
OPEN "__RECLEV.RPT" FOR OUTPUT AS #97
PRINT #99, "level, time"


IF DIRCount% > 1 THEN
    DO

        OPEN recdir$ + file$ FOR RANDOM AS #1 LEN = LEN(MyClass)
        GET #1, 1, MyClass
        posi = INSTR(MyClass.Levname, ".lev") - 1
        levnameinrecfile$ = LEFT$(MyClass.Levname, posi) + ".lev"
        PRINT file$, levnameinrecfile$;
        LINE INPUT #98, ido$
        PRINT #99, LEFT$(MyClass.Levname, posi) + ", " + ido$
        IF NOT _FILEEXISTS(levdir$ + levnameinrecfile$) THEN
            COLOR 12
            PRINT " missing"
            PRINT #97, file$, levnameinrecfile$;
            PRINT #97, " missing"
            COLOR 7
        ELSE
            COLOR 10
            PRINT " OK"
            COLOR 7
        END IF
        CLOSE #1

        file$ = DIR$("") 'use an empty string parameter to return a list of files!

    LOOP UNTIL LEN(file$) = 0 'file list ends with an empty string
END IF

CLOSE #97
CLOSE #98
CLOSE #99


FUNCTION DIR$ (spec$)
    CONST TmpFile$ = "DIR$INF0.INF", ListMAX% = 99 'change maximum to suit your needs
    SHARED DIRCount% 'returns file count if desired
    STATIC Ready%, Index%, DirList$()
    IF NOT Ready% THEN REDIM DirList$(ListMAX%): Ready% = -1 'DIM array first use
    IF spec$ > "" THEN 'get file names when a spec is given
        SHELL _HIDE "DIR " + spec$ + " /b /o:-n > " + TmpFile$
        Index% = 0: DirList$(Index%) = "": ff% = FREEFILE
        OPEN TmpFile$ FOR APPEND AS #ff%
        size& = LOF(ff%)
        CLOSE #ff%
        IF size& = 0 THEN KILL TmpFile$: EXIT FUNCTION
        OPEN TmpFile$ FOR INPUT AS #ff%
        DO WHILE NOT EOF(ff%) AND Index% < ListMAX%
            Index% = Index% + 1
            LINE INPUT #ff%, DirList$(Index%)
        LOOP
        DIRCount% = Index% 'SHARED variable can return the file count
        CLOSE #ff%
        KILL TmpFile$
    ELSE IF Index% > 0 THEN Index% = Index% - 1 'no spec sends next file name
    END IF
    DIR$ = DirList$(Index%)
END FUNCTION


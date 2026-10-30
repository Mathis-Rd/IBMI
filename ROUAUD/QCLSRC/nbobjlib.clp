             PGM        PARM(&BIBLIO)

             DCLF       FILE(QADSPOBJ)
             DCL        VAR(&BIBLIO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBOBJ) TYPE(*DEC) LEN(10 0) VALUE(0)

             DSPOBJD    OBJ(&BIBLIO/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/NBOBJ)
             MONMSG     MSGID(CPF2110) EXEC(GOTO CMDLBL(NTROUVE))

             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/NBOBJ)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))

             CHGVAR     VAR(&NBOBJ) VALUE(&NBOBJ + 1)

             GOTO       CMDLBL(LOOP)

 END:        SNDPGMMSG  MSG('NB obj ' *CAT &BIBLIO *CAT ' : ' *CAT +
                          %CHAR(&NBOBJ))

 NTROUVE:    SNDPGMMSG  MSG('Bibliothèque non trouvée')

ENDPGM

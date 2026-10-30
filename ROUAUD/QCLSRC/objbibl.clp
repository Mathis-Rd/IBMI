 PGM

             DCLF       FILE(ROUAUD/ECRANBONB) OPNID(E)
             DCLF       FILE(QSYS/QADSPOBJ) OPNID(OBJ)

             DCL        VAR(&NBTOTAL) TYPE(*DEC) LEN(10 0)

 RETRY:      SNDRCVF    RCDFMT(FMTSAISIEB) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(END))

             DSPOBJD    OBJ(&E_BIBLIO/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LISTOBJBIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&E_IN80) VALUE('1')
             GOTO       CMDLBL(RETRY)
             ENDDO
             RTVMBRD    FILE(QTEMP/LISTOBJBIB) NBRCURRCD(&NBTOTAL)
             CHGVAR     VAR(&E_MAXOBJBIB) VALUE(&NBTOTAL)

             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/LISTOBJBIB)

             CHGVAR     VAR(&E_NOMBIBL) VALUE(&E_BIBLIO)

 LOOP:       RCVF       OPNID(OBJ)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&E_NUMOBJBIB) VALUE(&E_NUMOBJBIB + 1)
             CHGVAR     VAR(&E_NOMOBJBIB) VALUE(&OBJ_ODOBNM)
             CHGVAR     VAR(&E_TYPEOBJBIB) VALUE(&OBJ_ODOBTP)
             CHGVAR     VAR(&E_TAILLEOBJB) VALUE(&OBJ_ODOBSZ)

             IF         COND(&E_TAILLEOBJB *GE 100000) THEN(CHGVAR +
                          VAR(&E_IN90) VALUE('1'))
             ELSE       CMD(CHGVAR VAR(&E_IN90) VALUE('0'))

             SNDRCVF    RCDFMT(FMTBIBL) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(END))
             IF         COND(&E_IN12) THEN(DO)
             CLOF       OPNID(OBJ)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(RETRY)
             ENDDO

             GOTO       CMDLBL(LOOP)

 END:        ENDPGM

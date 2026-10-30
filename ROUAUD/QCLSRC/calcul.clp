PGM

             DCLF       FILE(ROUAUD/ECRAN)

             DCL        VAR(&NB1) TYPE(*DEC) LEN(12)
             DCL        VAR(&NB2) TYPE(*DEC) LEN(12)
             DCL        VAR(&OPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULTAT) TYPE(*DEC) LEN(15)


 LOOP:       SNDRCVF    RCDFMT(CALCULAT)
             IF         COND(&IN03) THEN(GOTO CMDLBL(END))


             IF         COND(&OPECALC *NE '+' *AND &OPECALC *NE +
                             '-' *AND &OPECALC *NE '*' *AND +
                             &OPECALC *NE '/') THEN(DO)
             CHGVAR     VAR(&IN91) VALUE('1')
             GOTO       CMDLBL(LOOP)
             ENDDO

             IF         COND(&NBCALC1 *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN90) VALUE('1')
             GOTO       CMDLBL(LOOP)
             ENDDO

             IF         COND(&NBCALC2 *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN92) VALUE('1')
             GOTO       CMDLBL(LOOP)
             ENDDO

             CHGVAR     VAR(&RESULTAT) VALUE(0)

             CHGVAR     VAR(&NB1) VALUE(&NBCALC1)
             CHGVAR     VAR(&OPE) VALUE(&OPECALC)
             CHGVAR     VAR(&NB2) VALUE(&NBCALC2)

             IF         COND(&OPE *EQ '+') THEN(CHGVAR +
                          VAR(&RESULTAT) VALUE(&NB1 + &NB2))
             IF         COND(&OPE *EQ '-') THEN(CHGVAR +
                          VAR(&RESULTAT) VALUE(&NB1 - &NB2))
             IF         COND(&OPE *EQ '*') THEN(CHGVAR +
                          VAR(&RESULTAT) VALUE(&NB1 * &NB2))
             IF         COND(&OPE *EQ '/') THEN(CHGVAR +
                          VAR(&RESULTAT) VALUE(&NB1 / &NB2))


             IF         COND(&RESULTAT *NE 0) THEN(SNDPGMMSG MSG('Le +
                          résultat est : ' *CAT %CHAR(&RESULTAT)))

             GOTO       CMDLBL(LOOP)






 END:        ENDPGM

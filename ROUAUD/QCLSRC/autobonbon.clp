             PGM

/*Déclaration des fichiers avec identifiant (car plus d'un) */
             DCLF       FILE(ROUAUD/ECRANBONB)
             DCLF       FILE(BONBON) OPNID(P)

             DCL        VAR(&FOUND) TYPE(*LGL) VALUE('0')

             DCL        VAR(&USRACT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRAUTOR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTORISE) TYPE(*LGL) VALUE('0')


             CALLSUBR   SUBR(CTLACCES)




/*On ferme le fichier si ouvert et on affiche le premier écran */
 RETRY:      CLOSE      OPNID(P)
             SNDRCVF    RCDFMT(FMT2)
/*On réinitialise la variable */
             CHGVAR     VAR(&FOUND) VALUE('0')
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))

/*Lit un enregistrement du PF - label LOOP pour boucler */
 LOOP:       RCVF       OPNID(P)
             MONMSG     MSGID(CPF0864) +
                        EXEC(DO)
                 /*Si aucun enreg correspondant, on recommence */
                          IF COND(&FOUND = '0') THEN(DO)
                            CHGVAR     VAR(&IN50) VALUE('1')
                            GOTO       CMDLBL(RETRY)
                          ENDDO
                 /*Si on a trouvé des enreg on sort */
                          IF COND(&FOUND = '1') +
                            THEN(GOTO CMDLBL(END))
                        ENDDO
/*Si le filtre est différent de la marque, on n'affiche pas */
             IF         COND(%UPPER(&SAISIE) *NE +
                          %UPPER(&P_MARQUE)) THEN(GOTO CMDLBL(LOOP))

/*Transfert des données du fichier aux variables d'écran */
             CHGVAR     VAR(&NOM) VALUE(&P_NOM)
             CHGVAR     VAR(&MARQUE) VALUE(&P_MARQUE)
             CHGVAR     VAR(&COULEUR) VALUE(&P_COULEUR)
             CHGVAR     VAR(&PRIX) VALUE(&P_PRIX)
             CHGVAR     VAR(&NUMBER) VALUE(&P_NUMBER)
             CHGVAR     VAR(&FOUND) VALUE('1')
/*Affichage de l'écran - Permet une interaction avec l'écran */
             SNDRCVF       RCDFMT(FMT1)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(RETRY))

             GOTO       CMDLBL(LOOP)

 END:        SNDRCVF    RCDFMT(FMTPOPUP)
             IF         COND(&IN03) THEN(GOTO CMDLBL(FINALEND))
             IF         COND(&IN12) THEN(GOTO CMDLBL(RETRY))


             SUBR       SUBR(CTLACCES)

             RTVJOBA    USER(&USRACT)
             RTVDTAARA  DTAARA(ROUAUD/ROUAUDDTAA (1 10)) +
                          RTNVAR(&USRAUTOR)

             IF         COND(&USRACT *NE &USRAUTOR) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('accès +
                          non autorisé') MSGTYPE(*ESCAPE)

             ENDDO

             ENDSUBR
 FINALEND:   ENDPGM

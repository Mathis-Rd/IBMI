PGM        PARM(&DIR &RC)
           DCL        VAR(&DIR) TYPE(*CHAR) LEN(50)
           DCL        VAR(&RC)  TYPE(*CHAR) LEN(1)

           /* PAR DEFAUT, LE REPERTOIRE EXISTE */
           CHGVAR     VAR(&RC) VALUE('0')

           /* UN CHEMIN A BLANC N'EXISTE PAS */
           IF         COND(&DIR *EQ ' ') THEN(DO)
              CHGVAR     VAR(&RC) VALUE('1')
              RETURN
           ENDDO

           /* ON ESSAIE DE S'Y POSITIONNER : UNE ERREUR = INTROUVABLE */
           CHGCURDIR  DIR(&DIR)
           MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RC) VALUE('1'))
ENDPGM

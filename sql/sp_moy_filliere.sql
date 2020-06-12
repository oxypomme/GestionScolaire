DROP PROCEDURE IF EXISTS sp_moy_filiere; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE sp_moy_filiere(IN f_code VARCHAR(10), OUT moy VARCHAR(5))
BEGIN
    DECLARE countEleves INT;                /*Servira à nous sortir de la boucle*/
    DECLARE i INT DEFAULT 0;                /*Iterateur de la boucle*/
    DECLARE tmpId INT;                      /*ID lu par le curseur*/
    DECLARE tmpMoy VARCHAR(5) DEFAULT 0;    /*Moyenne renvoyé par la procédure*/
    DECLARE curs1 CURSOR FOR (              /*Curseur des inscrits de la fillière*/
        SELECT e.id
        FROM ETUDIANT AS e
        JOIN FILIERE AS f
            ON (e.id_fil = f.id)
        WHERE code = f_code
    );

    /*On récupère le nombre d'élèves*/
    SELECT COUNT(*) INTO countEleves
    FROM ETUDIANT AS e
    JOIN FILIERE AS f
        ON (e.id_fil = f.id)
    WHERE code = f_code;

    OPEN curs1;

    /*On met à 0 la moyenne*/
    SET moy := 0;
    /*Tant qu'il y a des inscrits non lus*/
    WHILE (i <> countEleves) DO
        /*On lit la moyenne*/
        FETCH curs1 INTO tmpId;
        /*On fait la moyenne de l'inscrit*/
        CALL sp_moy_inscrit(tmpId, tmpMoy);
        /*On modifie la somme des moyennes*/
        SET moy := moy + tmpMoy ;
        /*On passe à l'inscrit suivant*/
        SET i := i + 1;
    END WHILE;

    CLOSE curs1;

    /*Si il n'y a pas eu de notes, où qu'elles sont toutes non notées*/
    IF(countEleves <> 0) THEN
        /*On calcule la moyenne*/
        SET moy := moy / countEleves;
    ELSE
        /*En cas de problème, la moyenne vaut -1*/
        SET moy := -1;
    END IF;
END;

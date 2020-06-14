DROP PROCEDURE IF EXISTS sp_moy_inscrit; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE sp_moy_inscrit(IN id INT, OUT moy VARCHAR(5))
BEGIN
    DECLARE countNotes INT;                 /*Servira à nous sortir de la boucle*/
    DECLARE i INT DEFAULT 0;                /*Iterateur de la boucle*/
    DECLARE tmpNote DECIMAL(4,2);           /*Note lue par le curseur*/
    DECLARE tmpCoef DECIMAL(4,2);           /*Coef lu par le curseur*/
    DECLARE sumCoef DECIMAL(4,2) DEFAULT 0; /*Somme des coefs*/
    DECLARE curs1 CURSOR FOR (              /*Curseur des notes de l'inscrit*/
        SELECT note, coef
        FROM vue_comprend_liste
        WHERE id_etud = id
    );

    /*On récupère le nombre de notes*/
    SELECT COUNT(*) INTO countNotes
    FROM vue_comprend_liste
    WHERE id_etud = id;

    OPEN curs1;

    /*On met à 0 la moyenne*/
    SET moy := 0;
    /*Tant qu'il y a des notes non lues*/
    WHILE (i <> countNotes) DO
        /*On lit la note*/
        FETCH curs1 INTO tmpNote, tmpCoef;
        /*Si elle est notée*/
        IF (tmpNote <> -1) THEN
            /*On met à jour nos différentes sommes*/
            SET moy := moy + (tmpNote * tmpCoef);
            SET sumCoef := sumCoef + tmpCoef;
        END IF;
        /*On passe à la note suivante*/
        SET i := i + 1;
    END WHILE;
    
    CLOSE curs1;
    
    /*Si il n'y a pas eu de notes, où qu'elles sont toutes non notées*/
    IF(sumCoef <> 0) THEN
        /*On calcule la moyenne*/
        SET moy := REPLACE(FORMAT(moy / sumCoef, 2),'.',',');
    ELSE
        /*En cas de problème, la moyenne vaut -1*/
        SET moy := -1;
    END IF;
END;

DROP PROCEDURE IF EXISTS sp_inscrit_liste_tous; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_inscrit_liste_tous`(out v_nom_table varchar(20))
BEGIN
    DROP TABLE IF EXISTS resultat;
    CREATE TABLE resultat AS
        SELECT * FROM vue_inscrit_liste;
    SET v_nom_table := 'resultat';
END

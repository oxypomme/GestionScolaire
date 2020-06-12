DROP PROCEDURE IF EXISTS sp_inscrit_liste_etu; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_inscrit_liste_etu`(in e_noetu varchar(4), e_nometu varchar(50), out e_nom_table varchar(20))
BEGIN
    DROP TABLE IF EXISTS resultat;
    CREATE TABLE resultat AS
        SELECT * FROM vue_inscrit_liste
        WHERE id LIKE CONCAT('%',e_noetu,'%') COLLATE latin1_general_cs
           OR identite LIKE CONCAT('%',e_nometu,'%') COLLATE latin1_general_cs
        ORDER BY identite, id;
    SET e_nom_table := 'resultat';
END

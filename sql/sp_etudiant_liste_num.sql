DROP PROCEDURE IF EXISTS sp_etudiant_liste_num; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_liste_num`(in e_id varchar(5), out e_nomtable varchar(20))
BEGIN
    DROP TABLE IF EXISTS resultat;
    CREATE TABLE resultat AS
        SELECT * FROM vue_inscrit_liste WHERE id = e_id;
    SET e_nomtable := 'resultat';
END

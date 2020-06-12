DROP PROCEDURE IF EXISTS sp_inscrit_num; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_inscrit_num`(in e_id varchar(5), out e_nomtable varchar(20))
BEGIN
    DROP TABLE IF EXISTS resultat;
    CREATE TABLE resultat AS
        SELECT *
        FROM vue_edtudiant
        WHERE id COLLATE latin1_general_ci = e_id;
    SET e_nomtable := 'resultat';
END

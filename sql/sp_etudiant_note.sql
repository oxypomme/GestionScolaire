DROP PROCEDURE IF EXISTS sp_etudiant_note; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_note`(IN e_id varchar(5), OUT e_nomtable varchar(20))
BEGIN
 DROP TABLE IF EXISTS resultat;
 CREATE TABLE resultat AS
    SELECT * 
    FROM vue_comprend_liste
    WHERE id = e_id;
 SET e_nomtable := 'resultat';
END

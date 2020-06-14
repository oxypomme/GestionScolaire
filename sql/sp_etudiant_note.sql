DROP PROCEDURE IF EXISTS sp_etudiant_note; 

CREATE
/*[DEFINER = { user | CURRENT_USER }]*/
PROCEDURE `sp_etudiant_note`(IN e_id varchar(5), OUT e_nomtable varchar(20))
BEGIN
 DROP TABLE IF EXISTS resultat;
 CREATE TABLE resultat AS
    SELECT lib_court, CONCAT("x ", REPLACE(coef,'.',',')), IF(note = -1 ,'Non noté', REPLACE(coef,'.',','))
    FROM vue_comprend_liste
    WHERE id_etud = e_id
    ORDER BY lib_court;
 SET e_nomtable := 'resultat';
END

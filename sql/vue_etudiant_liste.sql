CREATE
/* [DEFINER = { user | CURRENT_USER }]*/
VIEW vue_etudiant_liste
AS SELECT ETUDIANT.id AS id, civ, CONCAT(nom, ' ', prenom) AS identite, ville, CONCAT(code, ' ', lib_court) AS filiere
FROM ETUDIANT AS e
JOIN FILIERE AS f
    ON (e.id_fil = f.id)

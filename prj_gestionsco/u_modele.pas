unit u_modele;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, u_loaddataset;

type
Tmodele = class(TMySQL)
   private
   { private declarations }
   public
   { public declarations }
   procedure open;
   function  inscrit_liste_tous : TLoadDataSet;
   function  inscrit_liste_num   (num : string) : TLoadDataSet;
   function  inscrit_liste_periode (dt1, dt2 : string) : TLoadDataSet;
   function  inscrit_liste_cond  (no_permis, nom_cond : string) : TLoadDataSet;
   function  inscrit_liste_immat (no_immat : string) : TLoadDataSet;
   function  inscrit_liste_com   (no_com, nom_com : string) : TLoadDataSet;
   function  inscrit_num	   (num : string) : TLoadDataSet;
   function  inscrit_vehicule   (num : string) : string;
   function  inscrit_conducteur (num : string) : string;
   function  inscrit_commune	   (num : string) : string;
   function  vehicule_proprio	   (num : string) : string;
   function  inscrit_notes	(num : string) : TLoadDataSet;
   function  inscrit_delit_tous  : TLoadDataSet;

   procedure inscrit_delete	(id_inf : string);
   procedure inscrit_insert	(id_inf, date_inf, no_immat, no_permis, no_com : string);
   procedure inscrit_update	(id_inf, date_inf, no_immat, no_permis, no_com : string);
   procedure inscrit_notes_delete	(id_inf : string);
   procedure inscrit_notes_insert	(id_inf, id_delit : string);

   procedure close;
end;

var
     modele: Tmodele;

implementation

procedure Tmodele.open;
begin
    Bd_open ('5.48.191.192', 0, 'vie_scolaire', 'dut_projects', 'Htjl7rJEhAbduqYh', 'mysqld-5', 'libmysql64.dll');
end;

procedure Tmodele.close;
begin
      Bd_close;
end;

// toutes les inscrits
function Tmodele.inscrit_liste_tous : TLoadDataSet;
begin
     result := load('sp_inscrit_liste_tous',[]);
end;

// inscrit id_inf=num
function Tmodele.inscrit_liste_num (num : string) : TLoadDataSet;
begin
     result := load('sp_inscrit_liste_num',[num]);
end;

// inscrits qui se sont passées entre dt1 et dt2
function Tmodele.inscrit_liste_periode (dt1, dt2 : string) : TLoadDataSet;
begin
     result := load('sp_inscrit_liste_periode',[dt1, dt2]);
end;

// inscrits qui concernent les conducteurs dont le n° permis contient la valeur contenue dans no_permis
// ou le nom du conducteur contient la valeur contenue dans nom
function Tmodele.inscrit_liste_cond (no_permis, nom_cond : string) : TLoadDataSet;
begin
      result := load('sp_inscrit_liste_cond',[no_permis, nom_cond]);
end;

// inscrits qui concernent l'immatriculation no_immat
function Tmodele.inscrit_liste_immat (no_immat : string) : TLoadDataSet;
begin
      result := load('sp_inscrit_liste_immat',[no_immat]);
end;

// inscrits commises dans les communes dont le n° INSEE contient la valeur contenue dans no_com
// ou  le nom contient la valeur contenue dans nom_com
function Tmodele.inscrit_liste_com (no_com, nom_com : string) : TLoadDataSet;
begin
      result := load('sp_inscrit_liste_com',[no_com, nom_com]);
end;

function Tmodele.inscrit_num (num : string) : TLoadDataSet;
begin
     result := load('sp_inscrit_num',[num]);
end;
function Tmodele.inscrit_vehicule (num : string) : string;
begin
     load('sp_inscrit_vehicule',[num], result);
end;
function Tmodele.inscrit_conducteur (num : string) : string;
begin
     load('sp_inscrit_conducteur',[num], result);
end;
function Tmodele.inscrit_commune (num : string) : string;
begin
     load('sp_inscrit_commune',[num], result);
end;
function Tmodele.vehicule_proprio (num : string) : string;
begin
     load('sp_vehicule_proprio',[num], result);
end;

function Tmodele.inscrit_notes (num : string) : TLoadDataSet;
begin
     result := load('sp_inscrit_notes',[num]);
end;

function Tmodele.inscrit_delit_tous : TLoadDataSet;
begin
     result := load('sp_delit_tous',[]);
end;

procedure Tmodele.inscrit_delete (id_inf : string);
begin
     exec('sp_inscrit_delete',[id_inf]);
end;

procedure Tmodele.inscrit_insert (id_inf, date_inf, no_immat, no_permis, no_com : string);
begin
     exec('sp_inscrit_insert',[id_inf, date_inf, no_immat, no_permis, no_com]);
end;

procedure Tmodele.inscrit_update (id_inf, date_inf, no_immat, no_permis, no_com : string);
begin
     exec('sp_inscrit_update',[id_inf], [date_inf, no_immat,no_permis, no_com]);
end;

procedure Tmodele.inscrit_notes_delete (id_inf : string);
begin
     exec('sp_inscrit_notes_delete',[id_inf]);
end;

procedure Tmodele.inscrit_notes_insert (id_inf, id_delit : string);
begin
     exec('sp_inscrit_notes_insert',[id_inf, id_delit]);
end;

begin
     modele := TModele.Create;
end.


end.


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
   function  inscrit_liste_fil   (code : string) : TLoadDataSet;
   function  inscrit_liste_etu   (no_etu, nom_etu : string) : TLoadDataSet;
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
     Bd_open ('devbdd.iutmetz.univ-lorraine.fr', 0
       	, 'ricatte3u_tpnote_ihm'
       	, 'ricatte3u_appli'
       	, '31901467'
       	, 'mysqld-5', 'libmysql64.dll');
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

function Tmodele.inscrit_liste_fil (code : string) : TLoadDataSet;
begin
     result := load('sp_inscrit_liste_fil',[code]);
end;

function Tmodele.inscrit_liste_etu (no_etu, nom_etu : string) : TLoadDataSet;
begin
      result := load('sp_inscrit_liste_etu',[no_etu, nom_etu]);
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


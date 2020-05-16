unit u_loaddataset;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, ZConnection, ZDataset, ZStoredProcedure;

type
  TElementTableauAssociatif = record
    Cle: string;
    Valeur: string;
  end;
  PElementTableauAssociatif = ^TElementTableauAssociatif;

  TTableauAssociatif = class
  private
    fElems: TList;
    function  getCount : integer;
    function  rechercheElem(Cle: string): PElementTableauAssociatif;
    procedure AjoutElement(Cle: string; Valeur: string);
    procedure AjoutElement (Index : integer; Valeur : string);
    function  obtenirValeur(Cle: string): string;
    function  obtenirValeur(Index : integer) : string;
    procedure RetirerElement(Cle: string);

  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Count : integer read getCount;
    property Valeur[cle: string]: string
            read obtenirValeur
            write AjoutElement; default;
    property Val[index : integer] : string
             read obtenirValeur
             write AjoutElement;
    function Key(index : integer) : string;
  end;


type
  TResultDataSet = array of TTableauAssociatif;

type
  TLoadDataSet = class

  private
    index    : integer;
    ligne    : TTableauAssociatif;
    resultat : TResultDataSet;
    function  AjouterEnreg (dataset : TDataset) : TTableauAssociatif;
    function  AjouterEnreg (dataset : TTableauAssociatif) : TTableauAssociatif;
    procedure DestroyLines;
    function  LoadDataSet (Dataset : TDataset) : TResultDataSet;

  public
    constructor Create; virtual;
    destructor Destroy; override;
    function  EndOf : boolean;
    function  Count : integer;
    function  Read : TTableauAssociatif;
    function  Get (cle : string) : string;
    function  Get (p : integer)  : string;
    function  Top : boolean;
    function  Position (p : integer)     : boolean;
    function  Position (cle, valeur      : string) : boolean;
    function  Column (cle : string)      : TStringList;
    function  Column (p : integer)       : TStringList;
    function  SumColumn (cle : string)   : real;
    function  SumColumn (p : integer)    : real;
    procedure AjouterDesLignes (flux_add : TLoadDataSet);
    procedure AjouterDesLignes (flux_add : TTableauAssociatif);
    procedure AjouterDesLignes (flux_add : array of string);
    procedure ModifierDesLignes (indice : integer; flux_edit : TLoadDataSet);
    procedure SupprimerUneLigne (indice : integer);
  end;


  type
    TMySQL    = class
    private
        bd      : TZConnection;
        query   : TZQuery;
        sp      : TZStoredProc;
        table   : TZTable;
        function Flux_LoadDataSet (Dataset : TDataset) : TLoadDataSet;
        function exec_query : TLoadDataSet;
        function exec_sp : TLoadDataSet ;

    public
        select  : string;
        from    : string;
        where   : string;
        groupby : string;
        orderby : string;

        procedure BD_open  (host      : string; port      : integer;
                            dbname    : string;
                            username  : string; password  : string;
                            protocole : string; librairie : string);
        procedure BD_close;
        procedure clear;
        function  load    : TLoadDataSet;
        function  load (nom : string; params : array of string) : TLoadDataSet;
        procedure load (nom : string; params : array of string; var chaine : String);
        procedure exec (nom : string; params : array of string);
        procedure exec (nom : string; critere : array of string; params : array of string);

        constructor create;
    end;

implementation

uses ZCompatibility;
// ----------------------------------------------------------------------------
// TMySQL
// ----------------------------------------------------------------------------
// procedure TMySQL.Bd_open (host      : string = 'localhost';  port      : integer = 3306;
//                            dbname    : string = 'db';
//                            username  : string = 'user';        password  : string ='password';
//                            protocole : string = 'mysqld-5';    librairie : string = 'libmysql.dll');
procedure TMySQL.Bd_open (host      : string;  port      : integer ;
                              dbname    : string;
                              username  : string;        password  : string;
                              protocole : string;    librairie : string);
// host      : 'infodb2.iutmetz.univ-lorraine.fr'  ou 'localhost'
// port      : '3306' par défaut
// protocole : 'mysqld-5'
// librairie : 'libmysql.dll'  doit être dans le même dossier que l'unité u_loaddataset
begin
    bd := TZConnection.Create(nil);
    bd.ControlsCodePage       := cCP_UTF8;
//    bd.UTF8StringsAsWideField := False;
    bd.AutoEncodeStrings      := False;
    bd.Properties.Clear;
    bd.Properties.Add('AutoEncodeStrings');
    bd.HostName               := host;
    bd.Port                   := port;
    bd.Database               := dbname;
    bd.User                   := username;
    bd.Password               := password;
    bd.Protocol               := protocole;
    bd.LibraryLocation        := librairie;

    query.connection := bd;
    sp.connection    := bd;
    table.Connection := bd;
    bd.connect;
end;
procedure TMySQL.Bd_close;
begin
   bd.disconnect;
end;

procedure TMySQL.Clear;
begin
  select  := '';
  from    := '';
  where   := '';
  groupby := '';
  orderby := '';
end;

function TMySQL.exec_query : TLoadDataSet ;
begin
   query.SQL.Clear;
   query.SQL.add('SELECT ' +select);
   query.SQL.add(' FROM  ' +from);
   if NOT (where='')
   then query.SQL.add(' WHERE ' +where);
   if NOT (groupby='')
   then query.SQL.add(' GROUP BY ' +groupby);
   if NOT (orderby='')
   then query.SQL.add(' ORDER BY ' +orderby);
   result     := Flux_LoadDataSet (query);    // result : mot_clé du langage désignant le résultat retourné par la fonction
end;

function TMySQL.exec_sp : TLoadDataSet ;
begin
   result := Flux_LoadDataSet (table);
end;

procedure TMySQL.exec (nom : string; params : array of string);
var
   i : integer;
begin
   sp.StoredProcName := nom;
   i := 0;
   while (i <= High(params))
   do begin
      sp.Params[i].AsString := params[i];
      i := i +1;
   end;
   sp.ExecProc;
end;

procedure TMySQL.exec (nom : string; critere : array of string; params : array of string);
var
   i, j : integer;
begin
   sp.StoredProcName := nom;
   i := 0;
   while (i <= High(critere))
   do begin
      sp.Params[i].AsString := critere[i];
      i := i +1;
   end;
   j := 0;
   while (j <= High(params))
   do begin
      sp.Params[i].AsString := params[j];
      j := j +1;
      i := i +1;
   end;
   sp.ExecProc;
end;

function TMySQL.load : TLoadDataSet;
begin
   result := exec_query;
end;

function TMySQL.load (nom : string; params : array of string) : TLoadDataSet;
var
   i : integer;
begin
   sp.StoredProcName := nom;
   i := 0;
   while (i <= High(params))
   do begin
      params[i] := trim(params[i]);
      if (params[i] = '') then params[i] := 'ÿÿ';  // contenu attribut jamais trouvé dans une table ?
      sp.Params[i].AsString := params[i];
      i := i +1;
   end;  ;
   sp.ExecProc;
   table.TableName := sp.Params[i].asString;
   result := exec_sp;
end;

procedure TMySQL.load (nom : string; params : array of string; var chaine : String);
var
   i : integer;
begin
   sp.StoredProcName := nom;
   i := 0;
   while (i <= High(params))
   do begin
      params[i] := trim(params[i]);
      if (params[i] = '') then params[i] := 'ÿÿ';  // contenu attribut jamais trouvé dans une table ?
      sp.Params[i].AsString := params[i];
      i := i +1;
   end;
   sp.ExecProc;
   chaine := sp.Params[i].asString;
end;

function TMySQL.Flux_LoadDataSet (dataset : TDataset) : TLoadDataSet;
var
   lds : TLoadDataSet;
begin
   lds := TLoadDataSet.create;
   lds.LoadDataSet(dataset);
   result:=lds;
end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------


constructor TTableauAssociatif.Create;
begin
  fElems := TList.Create;
end;

destructor TTableauAssociatif.Destroy;
var
  indx: integer;
begin
  for indx := 0 to fElems.Count - 1 do
    Dispose(PElementTableauAssociatif(fElems[indx]));
  fElems.Free;
  inherited;
end;

function TTableauAssociatif.getCount: integer;
begin
  Result := fElems.Count;
end;

function TTableauAssociatif.rechercheElem(Cle: string): PElementTableauAssociatif;
var
  indx: integer;
begin
  indx := 0;
  Result := nil;
  { recherche jusqu'à ce que Result soit modifié (clé trouvée) ou qu'il n'y ait plus aucun
    élément à trouver. Remarquez le choix du while bien préférable à un for. }
  while (indx < fElems.Count) and (Result = nil) do
    begin
      { remarquez que Items est une propriété tableau par défaut et que l'on
        pourrait écrire fElems[indx] à la place de fElems.Items[indx].
        Remarquez le transtypage et la comparaison dans la foulée... }
      if PElementTableauAssociatif(fElems.Items[indx])^.Cle = Cle then
        // ici, on exploite le coté "par défaut" de Items
        Result := fElems[indx];
      inc(indx);
    end;
end;

procedure TTableauAssociatif.AjoutElement(Cle, Valeur: string);
var
  Elem: PElementTableauAssociatif;
begin
  // recherche d'une entrée comportant la clé transmise
  Elem := rechercheElem(Cle);
  // si l'entrée existe
  if Elem <> nil then
    { mise à jour de la valeur (l'entrée sera toujours référencée dans la liste,
      il n'y a donc rien de plus à faire au niveau du pointeur puisque ce n'est
      pas lui qui change mais une des valeurs pointées. }
    Elem^.Valeur := Valeur
  else
    begin
      { Création d'un nouvel élément }
      new(Elem);
      Elem^.Cle := Cle;
      Elem^.Valeur := Valeur;
      { ajout d'une entrée dans la liste des pointeurs. Notez le transtypage implicite
        de Elem en type Pointer. Notez également qu'on ne DOIT PAS appeler Dispose
        sur Elem ici : ce sera fait lorsque l'élément sera plus tard retiré. }
      fElems.Add(Elem);
    end;
end;

procedure TTableauAssociatif.AjoutElement(Index : integer; Valeur: string);
begin
  AjoutElement(PElementTableauAssociatif(fElems.Items[index])^.cle, Valeur);
end;

function TTableauAssociatif.obtenirValeur(Cle: string): string;
var
  Elem: PElementTableauAssociatif;
begin
  // recherche d'une entrée comportant la clé transmise
  Elem := rechercheElem(Cle);
  if Elem <> nil then
    Result := Elem^.Valeur
  else
    Result := '';
end;

function  TTableauAssociatif.obtenirValeur(Index : integer) : string;
begin
    result := PElementTableauAssociatif(fElems.Items[index])^.Valeur;
end;

procedure TTableauAssociatif.RetirerElement(Cle: string);
var
  Elem: PElementTableauAssociatif;
begin
  // recherche d'une entrée comportant la clé transmise
  Elem := rechercheElem(Cle);
  if Elem <> nil then
    begin
      fElems.Extract(Elem);
      Dispose(Elem);
    end;
end;

function TTableauAssociatif.Key(index : integer) : string;
begin
   result :=PElementTableauAssociatif(fElems.Items[index])^.Cle;
end;

constructor TLoadDataSet.Create;
begin
// rien de particulier
end;

procedure TLoadDataSet.DestroyLines;
var
   i : integer;
begin
   i := high(resultat);
   while (i > 0)
   do begin
      resultat[i].destroy;
      i := i -1;
      end;
end;

destructor TLoadDataSet.Destroy;
begin
   DestroyLines;
end;

function TLoadDataSet.Count: integer;
begin
   result := high(resultat) +1;
end;

function TLoadDataSet.Top : boolean;
begin
     index := 1;
   result := not EndOf;
end;

function TLoadDataSet.Position (p : integer) : boolean;
begin
   index := p;
   result := not EndOf;
end;

function TLoadDataSet.Position (cle, valeur : string) : boolean;
var
   trouve : boolean;
   enreg  : TTableauAssociatif;
begin
   trouve := false;
   Top;
   if not EndOf
   then begin
        enreg := Read;
        if NOT (enreg.rechercheElem(cle) = nil)
        then begin
             Top;
             while not EndOf and not trouve
             do begin
                enreg  := Read;
                trouve := enreg.obtenirValeur(cle) = valeur;
             end;
             if trouve
             then Position(index -1);
        end;
   end;
   result := trouve;
end;

function TLoadDataSet.Column (cle : string) : TStringList;
var
   enreg  : TTableauAssociatif;
   Liste : TStringList;
begin
   Liste := TStringList.Create;
   Top;
   while NOT Endof
   do begin
      enreg := Read;
      Liste.Add(enreg.obtenirValeur(cle));
   end;
   result := Liste;
end;

function TLoadDataSet.Column (p : integer) : TStringList;
var
   enreg  : TTableauAssociatif;
   Liste : TStringList;
begin
   Liste := TStringList.Create;
   Top;
   while NOT Endof
   do begin
      enreg := Read;
      Liste.Add(enreg[p]);
   end;
   result := Liste;
end;

function Conversion(valeur : string) : real;
var
    nb : real;
begin
   if not TryStrToFloat(valeur,nb)
   then nb := 0;
   result := nb;
end;

function TLoadDataSet.SumColumn (cle : string) : real;
var
   total : real;
begin
   total := 0;
   Top;
   while NOT Endof
   do begin
      total := total +conversion(read.obtenirValeur(cle));
   end;
   result := total;
end;

function TLoadDataSet.SumColumn(p : integer) : real;
var
   total : real;
begin
   total := 0;
   Top;
   while NOT Endof
   do begin
     total := total +conversion(Read[p]);
   end;
   result := total;
end;

function TLoadDataSet.EndOf : boolean;
begin
   result := index > (high(resultat)+1);
end;

function TLoadDataSet.Read : TTableauAssociatif;
begin
   if not EndOf then
   begin
      ligne  := Resultat[index-1];
      result := ligne;
      index := index +1;
   end;
end;

function  TLoadDataSet.Get (cle : string) : string;
begin
   result := ligne.obtenirValeur(cle);
end;

function  TLoadDataSet.Get (p : integer)  : string;
begin
  result := ligne[p];
end;

function TLoadDataSet.AjouterEnreg (dataset : TDataset) : TTableauAssociatif;
var
   UnEnreg  : TTableauAssociatif;
   i : integer;
begin
   UnEnreg := TTableauAssociatif.Create;
   i := 0;
   while (i < dataset.FieldCount)
   do begin
      UnEnreg[dataset.Fields[i].fieldname] := dataset.Fields[i].AsString;
      i := i+1;
      end;
   result := UnEnreg;
end;

function TLoadDataSet.AjouterEnreg (dataset : TTableauAssociatif) : TTableauAssociatif;
var
   UnEnreg  : TTableauAssociatif;
   i : integer;
begin
   UnEnreg := TTableauAssociatif.Create;
   i := 0;
   while (i < dataset.Count)
   do begin
      UnEnreg.AjoutElement(dataset.Key(i), dataset.obtenirValeur(i));
      i := i+1;
      end;
   result := UnEnreg;
end;

procedure TLoadDataSet.AjouterDesLignes (flux_add : TLoadDataSet);
var
   i : integer;
begin
   i := high(resultat); // indice maxi tableau de longueur 20, indices de 0 à 19
   SetLength(resultat,count +flux_add.count);
   flux_add.top;
   while NOT flux_add.EndOf
   do begin
      i := i +1;
      resultat[i] := flux_add.Read;
      end;
end;
procedure TLoadDataSet.AjouterDesLignes (flux_add : TTableauAssociatif);
var
   i : integer;
   unenreg : TTableauAssociatif;
begin
   SetLength(resultat,count +1);
   resultat[high(resultat)] := AjouterEnreg(flux_add);
end;
procedure TLoadDataSet.AjouterDesLignes (flux_add : array of string);
// par pair (clé, valeur)
var
   i, j, nb_pair, valeur : integer;
   unenreg : TTableauAssociatif;
begin
   unenreg := TTableauAssociatif.Create;
   i       := 0;
   j       := 0;
   nb_pair := High(flux_add) DIV 2;
   for i := 0 to nb_pair
   do begin
      if TryStrToInt(flux_add[j],valeur)
      then unenreg.AjoutElement(valeur,flux_add[j+1])
      else unenreg.AjoutElement(flux_add[j],flux_add[j+1]);
      j := j +2;
   end;
   AjouterDesLignes(unenreg);
end;

procedure TLoadDataSet.ModifierDesLignes (indice : integer; flux_edit : TLoadDataSet);
var
   i : integer;
begin
   i := indice;
   Position(i);
   while NOT Endof and NOT flux_edit.EndOf
   do begin
      resultat[i-1] := flux_edit.Read;
      i := i +1;
   end;
end;

procedure TLoadDataSet.SupprimerUneLigne (indice : integer);
var
   i : integer;
begin
   i := indice-1;
   position(indice+1);
   while NOT EndOf
   do begin
      resultat[i] := Read;
      i := i +1;
   end;
   SetLength(resultat,high(resultat));
end;

function TLoadDataSet.LoadDataSet (dataset : TDataset) : TResultDataSet;
var
   i : integer;
begin
   destroyLines;

   index := 0;
   dataset.Open;
   SetLength(resultat,dataset.RecordCount);
   i := 0;
   while not dataset.eof
   do begin
      resultat[i] := AjouterEnreg(dataset);
      i := i +1;
      dataset.Next;
      end;
   dataset.close;
   index := 1;
   result := resultat;
end;



constructor TMySQL.Create;
begin
  bd    := TZConnection.Create(nil);
  query := TZQuery.Create(nil);
  sp    := TZStoredProc.Create(nil);
  table := TZTable.Create(nil);
end;

end.



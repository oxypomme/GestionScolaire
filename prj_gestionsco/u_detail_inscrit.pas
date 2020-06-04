unit u_detail_inscrit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Grids, Buttons;

type

  { Tf_detail_inscri }

  Tf_detail_inscrit = class(TForm)
    btn_valider: TButton;
    btn_annuler: TButton;
    edt_dt: TDateTimePicker;
    lbl_nocom_erreur: TLabel;
    lbl_amende_erreur: TLabel;
    lbl_permis_erreur: TLabel;
    lbl_num_erreur: TLabel;
    lbl_amende: TLabel;
    lbl_immat_erreur: TLabel;
    lbl_nocom: TLabel;
    pnl_amende_ajout: TPanel;
    pnl_amende_list: TPanel;
    pnl_amende: TPanel;
    lbl_commune: TLabel;
    pnl_amende_titre: TPanel;
    pnl_commune: TPanel;
    edt_nocom: TEdit;
    lbl_ident: TLabel;
    mmo_commune: TMemo;
    pnl_ident: TPanel;
    pnl_vehicule: TPanel;
    edt_immat: TEdit;
    edt_num: TEdit;
    lbl_date: TLabel;
    lbl_num: TLabel;
    lbl_vehicule: TLabel;
    lbl_immat: TLabel;
    lbl_proprio: TLabel;
    mmo_proprio: TMemo;
    mmo_vehicule: TMemo;
    pnl_conducteur: TPanel;
    btn_retour: TButton;
    edt_permis: TEdit;
    lbl_conducteur: TLabel;
    lbl_permis: TLabel;
    mmo_conducteur: TMemo;
    pnl_detail: TPanel;
    pnl_btn: TPanel;
    pnl_titre: TPanel;
    procedure btn_retourClick(Sender: TObject);
    procedure btn_validerClick(Sender: TObject);
    procedure edt_immatExit(Sender: TObject);
    procedure edt_nocomExit(Sender: TObject);
    procedure edt_numExit(Sender: TObject);
    procedure edt_permisExit(Sender: TObject);
    procedure init   ( idinf : string; affi : boolean);
    procedure detail ( idinf : string);
    procedure edit   ( idinf : string);
    procedure add;
    procedure delete ( idinf : string);
    procedure edt_Enter (Sender : TObject );

  private
    procedure affi_page;
    procedure affi_vehicule      (num : string);
    procedure affi_conducteur    (num : string);
    procedure affi_commune       (num  : string);
    function  affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;

    { private declarations }
  public
    { public declarations }
  end;

var
  f_detail_inscri: Tf_detail_inscrit;

implementation


{$R *.lfm}

uses	u_feuille_style, u_list_inscrit, u_amende_list, u_amende_ajout, u_modele, u_loaddataset;

{ Tf_detail_inscrit }

var
   oldvaleur : string;	// utilisée dans la modification pour comparer l’ancienne valeur avec la saisie
   id  : string;	// variable active dans toute l'unité, contenant l'id inscrit affichée

procedure Tf_detail_inscrit.Init   ( idinf : string;	affi : boolean);
//  ajout nouvelle inscrit : id est vide
// affichage détail d'une inscrit : affi est vrai sinon affi est faux
begin
   style.panel_travail (pnl_titre);
   style.panel_travail (pnl_btn);
   style.panel_travail (pnl_detail);
   style.panel_travail (pnl_ident);
	style.label_titre  (lbl_ident);
        style.label_erreur (lbl_num_erreur);     lbl_num_erreur.caption := ' ';
   style.panel_travail (pnl_vehicule);
	style.label_titre  (lbl_vehicule);       style.memo_info(mmo_vehicule);
	style.label_erreur (lbl_immat_erreur);   lbl_immat_erreur.caption := ' ';
        style.memo_info    (mmo_proprio);
   style.panel_travail (pnl_conducteur);
	style.label_titre  (lbl_conducteur);     style.memo_info (mmo_conducteur);
	style.label_erreur (lbl_permis_erreur);  lbl_permis_erreur.caption := ' ';
   style.panel_travail (pnl_commune);
	style.label_titre  (lbl_commune);        style.memo_info(mmo_commune);
	style.label_erreur (lbl_nocom_erreur);   lbl_nocom_erreur.caption := ' ';
   style.panel_travail (pnl_amende);
	style.panel_travail (pnl_amende_titre);
		style.label_titre  (lbl_amende);
		style.label_erreur (lbl_amende_erreur);     lbl_amende_erreur.caption := ' ';
	style.panel_travail (pnl_amende_list);
	style.panel_travail (pnl_amende_ajout);
   edt_num.ReadOnly	:=affi;
   edt_dt.NullInputAllowed	:=false;   // valeur nulle interdite : zone obligatoirement renseignée
   edt_dt.DateMode	:=dmComboBox;   //mode liste déroulante
   edt_dt.ReadOnly	:=affi;
// initialisation véhicule
   lbl_immat_erreur.caption	:='';
   edt_immat.clear;
   edt_immat.ReadOnly	:=affi;
   mmo_vehicule.clear;
   mmo_vehicule.ReadOnly	:=true;
   lbl_proprio.visible	:=false;   // invisible par défaut
   mmo_proprio.clear;
   mmo_proprio.ReadOnly	:=true;
// initialisation conducteur
   lbl_permis_erreur.caption	:='';
   edt_permis.clear;
   edt_permis.ReadOnly		:=affi;
   mmo_conducteur.clear;
   mmo_conducteur.ReadOnly :=true;
// initialisation commune
   lbl_nocom_erreur.caption	:='';
   edt_nocom.clear;
   edt_nocom.ReadOnly		:=affi;
   mmo_commune.clear;
   mmo_commune.ReadOnly	:=true;
   btn_retour.visible	:=affi;  // visible quand affichage détail
   btn_valider.visible	:=NOT  affi;    // visible quand ajout/modification inscrit
   btn_annuler.visible	:=NOT  affi;    // visible quand ajout/modification inscrit

// initialisation amende
   lbl_amende_erreur.Caption  :='';

   f_amende_list.borderstyle  := bsNone;
   f_amende_list.parent	      := pnl_amende_list;
   f_amende_list.align	      := alClient;
   f_amende_list.init(affi);
   f_amende_list.show;
   f_amende_list.affi_data(modele.inscrit_amende(idinf));
   f_amende_list.affi_total;

   f_amende_ajout.borderstyle := bsNone;
   f_amende_ajout.parent      := pnl_amende_ajout;
   f_amende_ajout.align	      := alClient;

   show;

   id  := idinf;
   IF  NOT  ( id = '')   // affichage/modification inscrit
   THEN  affi_page;

end;

procedure Tf_detail_inscrit.affi_vehicule (num : string);
var
   ch : string;
begin
   mmo_vehicule.clear;
   mmo_proprio.clear;
   lbl_proprio.visible := false;
   if  num = ''
   then  mmo_vehicule.lines.add('véhicule non identifié.')
   else  begin
         ch := modele.inscrit_vehicule(num);
         if  ch = ''	then mmo_vehicule.lines.add('immatriculation inconnue.')
         else begin
                mmo_vehicule.lines.text := ch;
                ch := modele.vehicule_proprio(num);
                if  ch =''
                then  mmo_vehicule.lines.add('propriétaire inconnu.')
                else begin
                        lbl_proprio.visible := true;
                        mmo_proprio.lines.text := ch;
                     end;
              end;
   end;
end;

procedure Tf_detail_inscrit.affi_conducteur (num : string);
var
   ch : string;
begin
   mmo_conducteur.clear;
   if  num = ''
   then  mmo_conducteur.lines.add('conducteur non identifié.')
   else  begin
         ch := modele.inscrit_conducteur(num);
         if  ch = ''	then mmo_conducteur.lines.add('conducteur  inconnu.')
         else  mmo_conducteur.lines.text := ch;
   end;
end;

procedure Tf_detail_inscrit.affi_commune (num : string);
var
   ch : string;
begin
   mmo_commune.clear;
   if  num = ''
   then mmo_commune.lines.add('lieu non identifié.')
   else  begin
         ch := modele.inscrit_commune(num);
         if  ch = ''	then mmo_commune.lines.add('commune  inconnue.')
         else  mmo_commune.lines.text := ch;   end;
end;

function  Tf_detail_inscrit.affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;
begin
   lbl.caption := erreur;
   if  NOT (erreur = '')
   then begin
	edt.setFocus;
	result := false;
   end
   else result := true;
end;

procedure Tf_detail_inscrit.affi_page;
var
   flux : Tloaddataset;
begin
   flux   := modele.inscrit_num(id);
   flux.read;
   edt_num.text	:= flux.Get('id_inf');
   edt_dt.date	:= strtodate(flux.Get('date_inf'));
   edt_immat.text	:= flux.Get('no_immat');
   edt_permis.text	:= flux.Get('no_permis');
   edt_nocom.text	:= flux.Get('no_com');
   flux.destroy;

   affi_vehicule	(edt_immat.text);
   affi_conducteur	(edt_permis.text);
   affi_commune	(edt_nocom.text);
end;

procedure Tf_detail_inscrit.detail (idinf : string);
begin
   init (idinf, true);    // mode affichage
   pnl_titre.caption	:= 'Détail d''une inscrit';
   edt_dt.DateMode	:= dmNone;	// zone date sans liste déroulante
   btn_retour.setFocus;
end;

procedure Tf_detail_inscrit.edit (idinf : string);
begin
   init (idinf, false);
   pnl_titre.caption	:= 'Modification d''une inscrit';
   edt_num.ReadOnly	 := true;
   edt_dt.setFocus;
end;

procedure Tf_detail_inscrit.add;
begin
   init ('',false);   // pas de numéro d'inscrit
   pnl_titre.caption   := 'Nouvelle inscrit';
   edt_dt.Date	           := date;   // initialisation à la date du jour
   edt_num.setFocus;
end;

procedure Tf_detail_inscrit.delete (idinf : string);
begin
   IF   messagedlg ('Demande de confirmation'
	,'Confirmez-vous la suppression de l''inscrit n°' +idinf
	,mtConfirmation, [mbYes,mbNo], 0, mbNo) = mrYes
   THEN BEGIN
	modele.inscrit_amende_delete (idinf);
	modele.inscrit_delete (idinf);

        f_list_inscrit.line_delete;
   END;
end;

procedure Tf_detail_inscrit.btn_retourClick(Sender: TObject);
begin
   close;
end;

procedure Tf_detail_inscrit.btn_validerClick(Sender: TObject);
var
    flux : TLoadDataSet;
    saisie, erreur, ch	 : string;
    i 	     : integer;
    valide  : boolean;
begin
    valide := true;

    erreur := '';
    if  f_amende_list.sg_liste.RowCount = 0
    then  begin
          erreur := 'L''amende doit être renseignée.';
          valide := false;
    end;
    lbl_amende_erreur.caption := erreur;

    erreur := '';
    saisie := edt_nocom.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_commune(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_nocom_erreur, edt_nocom)  AND  valide;

    erreur := '';
    saisie := edt_permis.text;
    if  NOT (saisie = '')
    then  begin
             ch  := modele.inscrit_conducteur(saisie);
             if  ch = ''  then  erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_permis_erreur, edt_permis)  AND  valide;
       erreur := '';
    saisie := edt_immat.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_vehicule(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_immat_erreur, edt_immat)  AND  valide;

    erreur := '';
    saisie := edt_immat.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_vehicule(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_immat_erreur, edt_immat)  AND  valide;

    if  id = ''
    then begin
	 erreur := '';
	 saisie := edt_num.text;
	 if  saisie = ''   then  erreur := 'Le numéro doit être rempli.'
	 else begin
	      flux := modele.inscrit_liste_num(saisie);
	      if  NOT  flux.endOf
	      then  erreur := 'Le numéro existe déjà';
	 end;
	 valide := affi_erreur_saisie (erreur, lbl_num_erreur, edt_num)  AND  valide;
    end;
       if  NOT  valide
    then  messagedlg ('Erreur enregistrement inscrit', 'La saisie est incorrecte.' +#13 +'Corrigez la saisie et validez à nouveau.', mtWarning, [mbOk], 0)
    else  begin
          if  id =''
	  then  modele.inscrit_insert(edt_num.text, datetostr(edt_dt.date), edt_immat.text, edt_permis.text, edt_nocom.text)
	  else  begin
		modele.inscrit_update(id, datetostr(edt_dt.date), edt_immat.text, edt_permis.text, edt_nocom.text);
	     // suppression de la composition de l'amende
		modele.inscrit_amende_delete (edt_num.text);
	  end;

          i := 1;   // commence à 1 pour passer la ligne de titres des colonnes en ligne 0
   	  while  ( i  <  f_amende_list.sg_liste.RowCount )
   	  do  begin
              modele.inscrit_amende_insert (edt_num.text, f_amende_list.sg_liste.Cells[0,i]);
              i := i +1;
          end;
   	  if id='' then f_list_inscrit.line_add(modele.inscrit_liste_num(edt_num.text))
   	  else f_list_inscrit.line_edit(modele.inscrit_liste_num(id));
   	  close;
    end;
end;

procedure Tf_detail_inscrit.edt_immatExit(Sender: TObject);
begin
   edt_immat.text := TRIM(edt_immat.text);
   IF   NOT  ( edt_immat.text = oldvaleur )
   THEN	affi_vehicule (edt_immat.text);
end;

procedure Tf_detail_inscrit.edt_nocomExit(Sender: TObject);
begin
   edt_nocom.text := TRIM(edt_nocom.text);
   IF   NOT  ( edt_nocom.text = oldvaleur )
   THEN	affi_commune (edt_nocom.text);
end;

procedure Tf_detail_inscrit.edt_numExit(Sender: TObject);
begin
   edt_num.text := TRIM(edt_num.text);
end;

procedure Tf_detail_inscrit.edt_permisExit(Sender: TObject);
begin
   edt_permis.text := TRIM(edt_permis.text);
   IF   NOT  ( edt_permis.text = oldvaleur )
   THEN	affi_conducteur (edt_permis.text);
end;

procedure Tf_detail_inscrit.edt_Enter(Sender : TObject);
begin
   oldvaleur := TEdit(Sender).text;
end;

end.


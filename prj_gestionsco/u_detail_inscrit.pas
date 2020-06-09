unit u_detail_inscrit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Grids, Buttons;

type

  { Tf_detail_inscrit }

  Tf_detail_inscrit = class(TForm)
    btn_valider: TButton;
    btn_annuler: TButton;
    cbo_civilite: TComboBox;
    cbo_filiere: TComboBox;
    edt_mel: TEdit;
    edt_portable: TEdit;
    edt_codepostal: TEdit;
    edt_commune: TEdit;
    edt_prenom: TEdit;
    edt_nom: TEdit;
    lbl_fillib_court: TLabel;
    lbl_fillib_milong: TLabel;
    lbl_portable_erreur: TLabel;
    lbl_mel_erreur: TLabel;
    lbl_mel: TLabel;
    lbl_portable: TLabel;
    lbl_codepostal_erreur: TLabel;
    lbl_commune_erreur: TLabel;
    lbl_prenom_erreur: TLabel;
    lbl_nom_erreur: TLabel;
    lbl_prenom: TLabel;
    lbl_nom: TLabel;
    lbl_filiere_erreur: TLabel;
    lbl_notes_erreur: TLabel;
    lbl_telephone_erreur: TLabel;
    lbl_num_erreur: TLabel;
    lbl_notes: TLabel;
    lbl_adresse_erreur: TLabel;
    pnl_notes_ajout: TPanel;
    pnl_notes_list: TPanel;
    pnl_notes: TPanel;
    lbl_filiere: TLabel;
    pnl_notes_titre: TPanel;
    pnl_filiere: TPanel;
    lbl_ident: TLabel;
    pnl_ident: TPanel;
    pnl_adresse: TPanel;
    edt_adresse: TEdit;
    edt_num: TEdit;
    lbl_num: TLabel;
    lbl_adresse: TLabel;
    pnl_contact: TPanel;
    btn_retour: TButton;
    edt_telephone: TEdit;
    lbl_contact: TLabel;
    lbl_telephone: TLabel;
    pnl_detail: TPanel;
    pnl_btn: TPanel;
    pnl_titre: TPanel;
    procedure btn_retourClick(Sender: TObject);
    procedure btn_validerClick(Sender: TObject);
    procedure edt_adresseExit(Sender: TObject);
    procedure edt_nofiliereExit(Sender: TObject);
    procedure edt_numExit(Sender: TObject);
    procedure edt_telephoneExit(Sender: TObject);
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
  f_detail_inscrit: Tf_detail_inscrit;

implementation


{$R *.lfm}

uses	u_feuille_style, u_list_inscrit, u_notes_list, u_notes_ajout, u_modele, u_loaddataset;

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
        style.label_erreur (lbl_num_erreur);     lbl_num_erreur.caption := '';
        style.label_erreur (lbl_nom_erreur);     lbl_nom_erreur.caption := '';
        style.label_erreur (lbl_prenom_erreur);  lbl_prenom_erreur.caption := '';
   style.panel_travail (pnl_adresse);
	style.label_titre  (lbl_adresse);
	style.label_erreur (lbl_adresse_erreur);      lbl_adresse_erreur.caption := '';
        style.label_erreur (lbl_codepostal_erreur);   lbl_codepostal_erreur.caption := '';
        style.label_erreur (lbl_commune_erreur);      lbl_commune_erreur.caption := '';
   style.panel_travail (pnl_contact);
	style.label_titre  (lbl_contact);
	style.label_erreur (lbl_telephone_erreur);  lbl_telephone_erreur.caption := '';
        style.label_erreur (lbl_portable_erreur);   lbl_portable_erreur.caption := '';
        style.label_erreur (lbl_mel_erreur);        lbl_mel_erreur.caption := '';
   style.panel_travail (pnl_filiere);
	style.label_titre  (lbl_filiere);
	style.label_erreur (lbl_filiere_erreur);   lbl_filiere_erreur.caption := '';
        lbl_fillib_court.caption := ' ';
        lbl_fillib_milong.caption := ' ';
   style.panel_travail (pnl_notes);
	style.panel_travail (pnl_notes_titre);
		style.label_titre  (lbl_notes);
		style.label_erreur (lbl_notes_erreur);     lbl_notes_erreur.caption := '';
	style.panel_travail (pnl_notes_list);
	style.panel_travail (pnl_notes_ajout);
   edt_num.ReadOnly	:=affi;

// initialisation véhicule
//   lbl_adresse_erreur.caption	:='';
//   edt_adresse.clear;
//   edt_adresse.ReadOnly	:=affi;
   //mmo_vehicule.clear;
   //mmo_vehicule.ReadOnly	:=true;
//   lbl_contact.visible	:=false;   // invisible par défaut
   //mmo_proprio.clear;
   //mmo_proprio.ReadOnly	:=true;
// initialisation conducteur
 //  lbl_telephone_erreur.caption	:='';
  // edt_telephone.clear;
//   edt_telephone.ReadOnly		:=affi;
   //mmo_conducteur.clear;
   //mmo_conducteur.ReadOnly :=true;
// initialisation commune
//   lbl_filiere_erreur.caption	:='';
   //edt_nofiliere.clear;
   //edt_nofiliere.ReadOnly		:=affi;
   //mmo_commune.clear;
   //mmo_commune.ReadOnly	:=true;

   btn_retour.visible	:=affi;  // visible quand affichage détail
   btn_valider.visible	:=NOT  affi;    // visible quand ajout/modification inscrit
   btn_annuler.visible	:=NOT  affi;    // visible quand ajout/modification inscrit

// initialisation notes
//   lbl_notes_erreur.Caption  :='';

//   f_notes_list.borderstyle  := bsNone;
//   f_notes_list.parent	      := pnl_notes_list;
 //  f_notes_list.align	      := alClient;
//   f_notes_list.init(affi);
//   f_notes_list.show;
//   f_notes_list.affi_data(modele.inscrit_notes(idinf));
//   f_notes_list.affi_total;

//   f_notes_ajout.borderstyle := bsNone;
//   f_notes_ajout.parent      := pnl_notes_ajout;
//   f_notes_ajout.align	      := alClient;

   show;

   id  := idinf;
   IF  NOT  ( id = '')   // affichage/modification inscrit
   THEN  affi_page;

end;

procedure Tf_detail_inscrit.affi_vehicule (num : string);
var
   ch : string;
begin
   //mmo_vehicule.clear;
   //mmo_proprio.clear;
   lbl_contact.visible := false;
   //if  num = ''
   //then  mmo_vehicule.lines.add('véhicule non identifié.')
   //else  begin
         ch := modele.inscrit_vehicule(num);
         //if  ch = ''	then mmo_vehicule.lines.add('immatriculation inconnue.')
         //else begin
                //mmo_vehicule.lines.text := ch;
                ch := modele.vehicule_proprio(num);
                //if  ch =''
                //then  mmo_vehicule.lines.add('propriétaire inconnu.')
                //else begin
                        lbl_contact.visible := true;
                        //mmo_proprio.lines.text := ch;
                     //end;
              //end;
   //end;
end;

procedure Tf_detail_inscrit.affi_conducteur (num : string);
var
   ch : string;
begin
   //mmo_conducteur.clear;
   //if  num = ''
   //then  mmo_conducteur.lines.add('conducteur non identifié.')
   //else  begin
         ch := modele.inscrit_conducteur(num);
         //if  ch = ''	then mmo_conducteur.lines.add('conducteur  inconnu.')
         //else  mmo_conducteur.lines.text := ch;
   //end;
end;

procedure Tf_detail_inscrit.affi_commune (num : string);
var
   ch : string;
begin
   //mmo_commune.clear;
   //if  num = ''
   //then mmo_commune.lines.add('lieu non identifié.')
   //else  begin
         ch := modele.inscrit_commune(num);
         //if  ch = ''	then mmo_commune.lines.add('commune  inconnue.')
         //else  mmo_commune.lines.text := ch;   end;
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
   edt_num.text	:= flux.Get('id');
   edt_nom.text	:= flux.Get('nom');
   if (flux.Get('civ')='M') then
      cbo_civilite.itemindex := 0
   else
      cbo_civilite.itemindex := 1;
   edt_prenom.text	:= flux.Get('prenom');
   edt_adresse.text	:= flux.Get('adresse');
   edt_codepostal.text	:= flux.Get('cp');
   edt_commune.text	:= flux.Get('ville');
   edt_telephone.text	:= flux.Get('telephone');
   edt_portable.text	:= flux.Get('portable');
   edt_mel.text	:= flux.Get('mel');

   flux.destroy;

   //affi_vehicule	(edt_adresse.text);
   //affi_conducteur	(edt_telephone.text);
   //affi_commune	(edt_nofiliere.text);
end;

procedure Tf_detail_inscrit.detail (idinf : string);
begin
   init (idinf, true);    // mode affichage
   pnl_titre.caption	:= 'Détail d''une inscrit';
   //edt_dt.DateMode	:= dmNone;	// zone date sans liste déroulante
   btn_retour.setFocus;
end;

procedure Tf_detail_inscrit.edit (idinf : string);
begin
   init (idinf, false);
   pnl_titre.caption	:= 'Modification d''une inscrit';
   edt_num.ReadOnly	 := true;
   //edt_dt.setFocus;
end;

procedure Tf_detail_inscrit.add;
begin
   init ('',false);   // pas de numéro d'inscrit
   pnl_titre.caption   := 'Nouvelle inscrit';
   edt_num.setFocus;
end;

procedure Tf_detail_inscrit.delete (idinf : string);
begin
   IF   messagedlg ('Demande de confirmation'
	,'Confirmez-vous la suppression de l''inscrit n°' +idinf
	,mtConfirmation, [mbYes,mbNo], 0, mbNo) = mrYes
   THEN BEGIN
	modele.inscrit_notes_delete (idinf);
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
    if  f_notes_list.sg_liste.RowCount = 0
    then  begin
          erreur := 'L''notes doit être renseignée.';
          valide := false;
    end;
    lbl_notes_erreur.caption := erreur;

    erreur := '';
    //saisie := edt_nofiliere.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_commune(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    //valide := affi_erreur_saisie (erreur, lbl_filiere_erreur, edt_nofiliere)  AND  valide;

    erreur := '';
    saisie := edt_telephone.text;
    if  NOT (saisie = '')
    then  begin
             ch  := modele.inscrit_conducteur(saisie);
             if  ch = ''  then  erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_telephone_erreur, edt_telephone)  AND  valide;
       erreur := '';
    saisie := edt_adresse.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_vehicule(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_adresse_erreur, edt_adresse)  AND  valide;

    erreur := '';
    saisie := edt_adresse.text;
    if  saisie = ''  then  erreur := 'Le numéro doit être rempli.'
    else  begin
             ch := modele.inscrit_vehicule(saisie);
	  if  ch = ''  then erreur := 'numéro inexistant.';
    end;
    valide := affi_erreur_saisie (erreur, lbl_adresse_erreur, edt_adresse)  AND  valide;

    if  id = ''
    then begin
	 erreur := '';
	 saisie := edt_num.text;
	 if  saisie = ''   then  erreur := 'Le numéro doit être rempli.'
	 else begin
	      //flux := modele.inscrit_liste_num(saisie);
	      //if  NOT  flux.endOf
	      //then  erreur := 'Le numéro existe déjà';
	 end;
	 valide := affi_erreur_saisie (erreur, lbl_num_erreur, edt_num)  AND  valide;
    end;
       if  NOT  valide
    then  messagedlg ('Erreur enregistrement inscrit', 'La saisie est incorrecte.' +#13 +'Corrigez la saisie et validez à nouveau.', mtWarning, [mbOk], 0)
    else  begin
          //if  id =''
	  //then  modele.inscrit_insert(edt_num.text, datetostr(edt_dt.date), edt_adresse.text, edt_telephone.text, edt_nofiliere.text)
	  //else  begin
	//	modele.inscrit_update(id, datetostr(edt_dt.date), edt_adresse.text, edt_telephone.text, edt_nofiliere.text);
	     // suppression de la composition de l'notes
		modele.inscrit_notes_delete (edt_num.text);
	  //end;

          i := 1;   // commence à 1 pour passer la ligne de titres des colonnes en ligne 0
   	  while  ( i  <  f_notes_list.sg_liste.RowCount )
   	  do  begin
              modele.inscrit_notes_insert (edt_num.text, f_notes_list.sg_liste.Cells[0,i]);
              i := i +1;
          end;
   	  //if id='' then f_list_inscrit.line_add(modele.inscrit_liste_num(edt_num.text))
   	  //else f_list_inscrit.line_edit(modele.inscrit_liste_num(id));
   	  close;
    end;
end;

procedure Tf_detail_inscrit.edt_adresseExit(Sender: TObject);
begin
   edt_adresse.text := TRIM(edt_adresse.text);
   IF   NOT  ( edt_adresse.text = oldvaleur )
   THEN	affi_vehicule (edt_adresse.text);
end;

procedure Tf_detail_inscrit.edt_nofiliereExit(Sender: TObject);
begin
   //edt_nofiliere.text := TRIM(edt_nofiliere.text);
   //IF   NOT  ( edt_nofiliere.text = oldvaleur )
   //THEN	affi_commune (edt_nofiliere.text);
end;

procedure Tf_detail_inscrit.edt_numExit(Sender: TObject);
begin
   edt_num.text := TRIM(edt_num.text);
end;

procedure Tf_detail_inscrit.edt_telephoneExit(Sender: TObject);
begin
   edt_telephone.text := TRIM(edt_telephone.text);
   IF   NOT  ( edt_telephone.text = oldvaleur )
   THEN	affi_conducteur (edt_telephone.text);
end;

procedure Tf_detail_inscrit.edt_Enter(Sender : TObject);
begin
   oldvaleur := TEdit(Sender).text;
end;


end.


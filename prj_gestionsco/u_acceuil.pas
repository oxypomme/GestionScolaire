unit u_acceuil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls,
  u_select_inscrit, u_liste, u_feuille_style;

type

  { Tf_accueil }

  Tf_accueil = class(TForm)
    item_inscrit: TMenuItem;
    item_statistiques: TMenuItem;
    item_accueil: TMenuItem;
    item_quitter: TMenuItem;
    item_filiere: TMenuItem;
    item_archive: TMenuItem;
    item_archive_n1: TMenuItem;
    item_inscrit_liste: TMenuItem;
    item_archive_n2: TMenuItem;
    item_liste: TMenuItem;
    lbl_info: TLabel;
    pnl_ariane: TPanel;
    pnl_center: TPanel;
    pnl_left: TPanel;
    procedure FormShow(Sender: TObject);
    procedure mnu_item_Click(Sender: TObject);
    procedure item_inscrit_listeClick(Sender: TObject);
    procedure item_quitterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_accueil: Tf_accueil;

implementation

{$R *.lfm}

{ Tf_accueil }

procedure Tf_accueil.FormShow(Sender: TObject);
begin
     with TLabel.Create(self) do
     begin
          Parent := pnl_center;
          Name := 'lbl_welcome';
          Caption := 'Bienvenue dans l''application de gestion de la scolarité';
          Align := alClient;
          Alignment := taCenter;
          Layout := tlCenter;
          Font.Size := 24;
          // Other label setup code
     end;
end;

procedure Tf_accueil.mnu_item_Click(Sender: TObject);
var
   item : TMenuItem;
begin
   pnl_left.show;

   pnl_ariane.Caption := '';
   item := TMenuItem(Sender);
   repeat
         pnl_ariane.Caption := ' >' + item.caption +pnl_ariane.Caption;
         item := item.parent;
   until item.parent = nil;
end;

procedure Tf_accueil.item_inscrit_listeClick(Sender: TObject);
begin
     f_select_inscrit.borderstyle := bsNone;
     f_select_inscrit.parent := pnl_left;
     f_select_inscrit.align := alClient;
     //f_select_inscrit.init;
     f_select_inscrit.show;

     f_liste_inscrits.borderstyle := bsNone;
     f_liste_inscrits.parent := pnl_center;
     f_liste_inscrits.align := alClient;
     f_liste_inscrits.init;
     f_liste_inscrits.show ;
end;

procedure Tf_accueil.item_quitterClick(Sender: TObject);
begin
     Close;
end;

end.


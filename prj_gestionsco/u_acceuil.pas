unit u_acceuil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls;

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
    lbl_ariane: TLabel;
    mnu_main: TMainMenu;
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

end.


unit u_liste_inscrits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, Spin, u_liste;

type

  { Tf_liste_inscrits }

  Tf_liste_inscrits = class(TF_liste)
    lbl_lignes: TLabel;
    pnl_nombre: TPanel;
    se_lignes: TSpinEdit;
    procedure Init;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_liste_inscrits: Tf_liste_inscrits;

implementation

{$R *.lfm}

procedure Tf_liste_inscrits.Init;
begin

end;

end.


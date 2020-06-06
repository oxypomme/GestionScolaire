unit u_accueil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tf_accueil }

  Tf_accueil = class(TForm)
    lbl_2: TLabel;
    lbl_1: TLabel;
    procedure FormCreate(Sender: TObject);
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

procedure Tf_accueil.FormCreate(Sender: TObject);
begin

end;

end.


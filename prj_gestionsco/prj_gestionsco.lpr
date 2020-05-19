program prj_gestionsco;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, u_select_inscrit, u_liste
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tf_select_inscrit, f_select_inscrit);
  Application.CreateForm(Tf_liste, f_liste);
  Application.Run;
end.


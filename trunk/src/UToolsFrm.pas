unit UToolsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TToolsFrm = class(TForm)
    pnlBackGround: TPanel;
    lblXY: TLabel;
    sbAlLeft: TSpeedButton;
    sbAlRight: TSpeedButton;
    sbAlTop: TSpeedButton;
    sbAlBottom: TSpeedButton;
    sbAnchor: TSpeedButton;
    btnSep2: TBevel;
    btnSep1: TBevel;
    procedure sbAnchorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAnchorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAnchorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    FCurX : integer;
    FCurY : integer;
    FMoving : boolean;
  public
    { Déclarations publiques }
  end;

var
  ToolsFrm: TToolsFrm;

implementation

{$R *.dfm}

procedure TToolsFrm.sbAnchorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMoving := True;
  FCurX := X;
  FCurY := Y;
end;

procedure TToolsFrm.sbAnchorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMoving := False;
end;

procedure TToolsFrm.sbAnchorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 if not FMoving then Exit;
 if X <> FCurX then
 begin
   Left := Left + (X - FCurX);
 end;
 if Y <> FCurY then
 begin
   Top := Top + (Y - FCurY);
 end;
end;

procedure TToolsFrm.FormCreate(Sender: TObject);
var
  hFrm : HRGN;
begin
  hFrm := CreateRoundRectRgn(0, 0, ClientWidth, ClientHeight, 10, 10);
  SetWindowRgn(Handle, hFrm, True);
end;

end.


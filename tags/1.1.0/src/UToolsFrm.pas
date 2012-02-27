unit UToolsFrm;

interface
{-----------------------------------------------------------------------------------
movControl component properties editor
Copyright (C) 2009  Abdelhamid MEDDEB, abdelhamid@meddeb.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------------
------------------------- Current file revision ------------------------------------
------------------------------------------------------------------------------------
$Id$
$Rev$
-------------------------------------------------------------------------------------}

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

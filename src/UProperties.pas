unit UProperties;

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

{$I UDelphiVersions.inc}

uses Classes, Forms,
     {$ifdef D6_ORHIGHER} DesignIntf, DesignEditors
     {$else} DsgnIntf
     {$endif}
      ;

type
  TMovControlProperty = class(TComponentEditor)
  private
  public
    function GetVerbCount : integer; override;
    function GetVerb(index : integer): string; override;
    procedure ExecuteVerb(index : integer); override;
  end;

  TCtrlTypesProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses UMovControl,
     UAboutFrm,
     UCtrlTypesFrm,
     Controls,
     UTextRessources,
     UCtrlTypes,
     SysUtils,
     StdCtrls;

procedure Register;
begin
  RegisterComponents('AMComponents', [TMovControl]);
  RegisterComponentEditor(TMovControl, TMovControlProperty);
  RegisterPropertyEditor(TypeInfo(TControlTypes), nil, '', TCtrlTypesProperty);
end;

{ TMovControlProperty }

procedure TMovControlProperty.ExecuteVerb(index: integer);
begin
  inherited;
  AboutFrm := TAboutFrm.Create(nil);
  AboutFrm.ShowModal;
end;

function TMovControlProperty.GetVerb(index: integer): string;
begin
  if index = 0 then Result := rsCopyrightAM
               else Result := rsMovControlAboutTitle;
end;

function TMovControlProperty.GetVerbCount: integer;
begin
  Result := 2;
end;

{ TCtrlTypesProperty }

procedure TCtrlTypesProperty.Edit;
var
  CtrlTypes : TControlTypes;
  CtrlTypeEditor : TCtrlTypeFrm;
  i, idx : integer;
begin
  inherited;
  CtrlTypes := TControlTypes(GetOrdValue);
  CtrlTypeEditor := TCtrlTypeFrm.Create(nil);
  try
    CtrlTypes.Availables(CtrlTypeEditor.lstBoxUnselected.Items);
    CtrlTypeEditor.lstBoxSelected.Clear;
    for i:=0 to CtrlTypes.Count - 1 do
    begin
      idx := CtrlTypeEditor.lstBoxUnselected.Items.IndexOf(CtrlTypes.Names[i]);
      if idx >= 0 then CtrlTypeEditor.lstBoxUnselected.Items.Delete(idx);
      CtrlTypeEditor.lstBoxSelected.Items.Add(CtrlTypes.Names[i]);
    end;
    if CtrlTypeEditor.ShowModal = mrOk then
    begin
      CtrlTypes.Clear;
      for i:=0 to CtrlTypeEditor.lstBoxSelected.Items.Count - 1 do
      begin
        CtrlTypes.Add(CtrlTypeEditor.lstBoxSelected.Items[i]);
      end;
    end;
  finally
    CtrlTypeEditor.Free;
  end;
end;

function TCtrlTypesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paSubProperties];
end;


end.
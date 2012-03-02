unit UProperties;

{$ifdef fpc}
{$MODE Delphi}
{$endif}

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
{$ifndef fpc}
{$I UDelphiVersions.inc}
{$endif}

uses Forms,
     {$ifdef fpc}
     PropEdits,
     ComponentEditors,
     {$else}
       {$ifdef D6_ORHIGHER}
       DesignIntf,
       DesignEditors,
       {$else}
       DsgnIntf,
       {$endif}
     {$endif}
     Classes;

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

  TCtrlNamesProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses UMovControl,
     UAboutFrm,
     UControlsEditFrm,
     Controls,
     UTextRessources,
     UCtrlTypes,
     UCtrlNames,
     SysUtils,
     StdCtrls;

procedure Register;
begin
  RegisterComponents('AMComponents', [TMovControl]);
  RegisterComponentEditor(TMovControl, TMovControlProperty);
  RegisterPropertyEditor(TypeInfo(TControlTypes), TMovControl, 'ControlTypes', TCtrlTypesProperty);
  RegisterPropertyEditor(TypeInfo(TControlNames), TMovControl, 'ControlNames', TCtrlNamesProperty);
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
  CtrlTypeEditor : TControlsEditFrm;
  i, idx : integer;
begin
  inherited;
  CtrlTypes := TControlTypes(GetOrdValue);
  CtrlTypeEditor := TControlsEditFrm.Create(nil);
  CtrlTypeEditor.EditType(ctedType);
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
  Result := [paDialog];
end;

{ TCtrlNamesProperty }

procedure TCtrlNamesProperty.Edit;
var
  CtrlNames : TControlNames;
  CtrlNameEditor : TControlsEditFrm;
  i, idx : integer;
begin
  inherited;
  CtrlNames := TControlNames(GetOrdValue);
  CtrlNameEditor := TControlsEditFrm.Create(nil);
  CtrlNameEditor.EditType(ctedName);
  try
    CtrlNames.Availables(CtrlNameEditor.lstBoxUnselected.Items);
    CtrlNameEditor.lstBoxSelected.Clear;
    for i:=0 to CtrlNames.Count - 1 do
    begin
      idx := CtrlNameEditor.lstBoxUnselected.Items.IndexOf(CtrlNames.Names[i]);
      if idx >= 0 then CtrlNameEditor.lstBoxUnselected.Items.Delete(idx);
      CtrlNameEditor.lstBoxSelected.Items.Add(CtrlNames.Names[i]);
    end;
    if CtrlNameEditor.ShowModal = mrOk then
    begin
      CtrlNames.Clear;
      for i:=0 to CtrlNameEditor.lstBoxSelected.Items.Count - 1 do
      begin
        CtrlNames.Add(CtrlNameEditor.lstBoxSelected.Items[i]);
      end;
    end;
  finally
    CtrlNameEditor.Free;
  end;
end;

function TCtrlNamesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

end.

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

uses Classes,
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

procedure Register;

implementation

uses UMovControl, UAboutFrm, UTextRessources;

procedure Register;
begin
  RegisterComponentEditor(TMovControl, TMovControlProperty);
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

end.
unit UAboutFrm;

interface
{-----------------------------------------------------------------------------------
About box
Copyright (C) 2003  Abdelhamid MEDDEB, abdelhamid@meddeb.net

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  TAboutFrm = class(TForm)
    btnClose: TButton;
    pnlLeft: TPanel;
    lblAbout1: TLabel;
    lblAbout2: TLabel;
    lblAbout3: TLabel;
    lblAbout4: TLabel;
    lblAbout5: TLabel;
    lblAbout6: TLabel;
    lblTitle: TLabel;
    Image1: TImage;
    lblSubTitle: TLabel;
    lblVersion: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  AboutFrm: TAboutFrm;

implementation

uses UTextRessources, UVersionInfo;

{$R *.DFM}

procedure TAboutFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAboutFrm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutFrm.FormCreate(Sender: TObject);
var
  VersionInfo : TFileVersion;
begin
  VersionInfo := TFileVersion.create;
  try
    lblAbout1.Caption := rsMovControlAboutTxt1;
    lblAbout2.Caption := rsMovControlAboutTxt2;
    lblAbout3.Caption := rsMovControlAboutTxt3;
    lblAbout4.Caption := rsCopyrightAM;
    lblAbout5.Caption := rsMovControlAboutTxt4;
    lblAbout6.Caption := rsMovControlAboutTxt5;
    if VersionInfo.GetFileVersion(Application.ExeName) then
    begin
      lblVersion.Caption := 'Version ' + VersionInfo.ReleaseVersion;
    end;  
    {$ifdef FRENCH}
    btnClose.Caption := rsBtnClose;
    {$endif}
  finally
    VersionInfo.Free;
  end;
end;

end.
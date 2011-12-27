unit UAboutFrm;

interface

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
    { Déclarations privées }
  public
    { Déclarations publiques }
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

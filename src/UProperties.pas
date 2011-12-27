unit UProperties;

interface

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

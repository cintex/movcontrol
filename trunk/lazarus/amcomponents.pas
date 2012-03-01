{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

Unit Amcomponents; 

Interface

uses
    UAboutFrm, UControlsEditFrm, UCtrlNames, UCtrlSelector, UCtrlTypes, 
  UMovControl, UProperties, UTextRessources, UToolsFrm, UVersionInfo, 
  LazarusPackageIntf;

Implementation

Procedure Register; 
Begin
  Registerunit('UProperties', @Uproperties.Register); 
End; 

Initialization
  Registerpackage('AMComponents', @Register); 
End.

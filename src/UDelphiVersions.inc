{$IFNDEF VER80} { If not Delphi 1 }
  {$DEFINE D2_ORHIGHER}
  {$IFNDEF VER90} { If not Delphi 2 }
    {$DEFINE D3_ORHIGHER}
    {$IFNDEF VER100} { If not Delphi 3 }
      {$DEFINE D4_ORHIGHER}
      {$IFNDEF VER120} { If not Delphi 4 }
        {$DEFINE D5_ORHIGHER}
        {$IFNDEF VER130} { If not Delphi 5 }
          {$DEFINE D6_ORHIGHER}
          {$IFNDEF VER140} { If not Delphi 6 }
            {$DEFINE D7_ORHIGHER}
            {$IFNDEF VER150} { If not Delphi 7 }
              {$DEFINE D8_ORHIGHER}
              {$IFNDEF VER160} { If not Delphi 8 }
                {$DEFINE D2005_ORHIGHER}
                {$IFNDEF VER170} { If not Delphi 2005 }
                  {$DEFINE D2006_ORHIGHER}
                  {$IFNDEF VER180} { If not Delphi 2006 }
                    {$DEFINE D2007_ORHIGHER}
                    {$IFNDEF VER185}
                      {$DEFINE D2007_ORHIGHER}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
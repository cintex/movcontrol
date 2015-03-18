# Version  1.0 #
## Release date ##
March 2011
## Features ##
movControl provides the ability to move and resize any window components that inherit from TWinControl. It is possibe for the programer:
  * To set the keyboard to enable or disable the customization mode.
  * To enable or disable the component.
## Published properties. ##
5 properties.
  1. **Active**: Boolean. Allows enable (True) or disable (False) customizing components of the form at runtime.
  1. **KeyControl1**, **KeyControl2** and **KeyControl3**: Enumeration (kcCtrl..kc\_Z).
  1. **MiltiSelect**: Boolean. Allows (True) several controls selection at design time, or disable it (False).

This three properties allow keys control selection for enabling/disabling design mode at runtime by final user. it allows selection of up to three buttons. Those keys can Ctrl, Shift, Alt and  A to Z.

For example, When kc\_Ctrl is selected for KeyControl1 and kc\_D selected for KeyControl2, final user can hit CTRL-D for enabling design mode and start customizing the form, or disable it when customizing is done.

## Published events. ##

Nothing, no events defined for this component.
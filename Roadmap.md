# Introduction #

The goal of movControl is to provide capability to customize the GUI at run-time, by final user. The programer needs only placing on form who needs be customized, the movControl component. After that, some movControl parameters, must be set. Those parameters are published properties of the component.

Gradually as the versions of movControl increment, new capabilities will be added to this component and necessarily new properties would be published or added. This document is the roadmap of movControl project evolution. You will find the features offered by this component in the current version (marked **"current"**), past or future.


# Version  1.0.x (Current) #
movControl provides the ability to move and resize any window components that inherit from TWinControl. It is possibe for the programmer:

- To set the keyboard to enable or disable the customization mode.

- To enable or disable the component.

**Published properties.**

4 properties.

1) **Active**: Boolean

Allows enable (True) or disable (False) customizing components of the form at runtime.

2) **KeyControl1**, **KeyControl2** and **KeyControl3**: Enumeration [kc\_Ctrl..kc\_Z].

This three properties allow keys control selection for enabling/disabling design mode at runtime by final user. it allows selection of up to three buttons. Those keys can Ctrl, Shift, Alt and  A to Z.

For example, When kc\_Ctrl is selected for KeyControl1 and kc\_D selected for KeyControl2, final user can hit CTRL-D for enabling design mode and start customizing the form, or disable it when customizing is done.

**Published events.**

Nothing, no events defined for this component.

# Version  1.1.x (about mid febrary 2012) #
Allows the programmer to set the type of components to customize and / or very specific components (selected by name).
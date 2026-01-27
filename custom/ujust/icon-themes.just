# vim: set ft=make :

[group('Appearance')]
set-icon-papirus:
    #!/usr/bin/env bash
    mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

    printf '%s\n' '[Settings]' \
    'gtk-application-prefer-dark-theme=true' \
    'gtk-cursor-theme-name=breeze_cursors' \
    'gtk-cursor-theme-size=24' \
    'gtk-decoration-layout=icon:minimize,maximize,close' \
    'gtk-enable-animations=true' \
    'gtk-font-name=Noto Sans,  10' \
    'gtk-icon-theme-name=Papirus-Dark' \
    'gtk-primary-button-warps-slider=true' \
    'gtk-xft-dpi=167116' > ~/.config/gtk-3.0/settings.ini

    printf '%s\n' '[Settings]' \
    'gtk-application-prefer-dark-theme=true' \
    'gtk-cursor-theme-name=breeze_cursors' \
    'gtk-cursor-theme-size=24' \
    'gtk-decoration-layout=icon:minimize,maximize,close' \
    'gtk-enable-animations=true' \
    'gtk-font-name=Noto Sans,  10' \
    'gtk-icon-theme-name=Papirus-Dark' \
    'gtk-primary-button-warps-slider=true' \
    'gtk-xft-dpi=167116' > ~/.config/gtk-4.0/settings.ini

    echo "Icon theme set to Papirus-Dark. Restart any GTK applications to see the changes."

[group('Appearance')]
set-icon-adwaita:
    #!/usr/bin/env bash
    mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

    printf '%s\n' '[Settings]' \
    'gtk-application-prefer-dark-theme=true' \
    'gtk-cursor-theme-name=breeze_cursors' \
    'gtk-cursor-theme-size=24' \
    'gtk-decoration-layout=icon:minimize,maximize,close' \
    'gtk-enable-animations=true' \
    'gtk-font-name=Noto Sans,  10' \
    'gtk-icon-theme-name=Adwaita' \
    'gtk-primary-button-warps-slider=true' \
    'gtk-xft-dpi=167116' > ~/.config/gtk-3.0/settings.ini

    printf '%s\n' '[Settings]' \
    'gtk-application-prefer-dark-theme=true' \
    'gtk-cursor-theme-name=breeze_cursors' \
    'gtk-cursor-theme-size=24' \
    'gtk-decoration-layout=icon:minimize,maximize,close' \
    'gtk-enable-animations=true' \
    'gtk-font-name=Noto Sans,  10' \
    'gtk-icon-theme-name=Adwaita' \
    'gtk-primary-button-warps-slider=true' \
    'gtk-xft-dpi=167116' > ~/.config/gtk-4.0/settings.ini

    echo "Icon theme set to Adwaita. Restart any GTK applications to see the changes."

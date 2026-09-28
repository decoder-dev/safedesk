Name:       safedesk
Version:    1.1.9
Release:    0
Summary:    RPM package
License:    GPL-3.0
Requires:   gtk3 libxcb1 libXfixes3 alsa-utils libXtst6 libva2 gstreamer-plugins-base gstreamer-plugin-pipewire
Recommends: libayatana-appindicator3-1 xdotool

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

%global __python %{__python3}

%install
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/usr/share/safedesk/
mkdir -p %{buildroot}/usr/share/safedesk/files/
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps/
mkdir -p %{buildroot}/usr/share/icons/hicolor/scalable/apps/
install -m 755 $HBB/target/release/safedesk %{buildroot}/usr/bin/safedesk
install $HBB/libsciter-gtk.so %{buildroot}/usr/share/safedesk/libsciter-gtk.so
install $HBB/res/safedesk.service %{buildroot}/usr/share/safedesk/files/
install $HBB/res/128x128@2x.png %{buildroot}/usr/share/icons/hicolor/256x256/apps/safedesk.png
install $HBB/res/scalable.svg %{buildroot}/usr/share/icons/hicolor/scalable/apps/safedesk.svg
install $HBB/res/safedesk.desktop %{buildroot}/usr/share/safedesk/files/
install $HBB/res/safedesk-link.desktop %{buildroot}/usr/share/safedesk/files/

%files
/usr/bin/safedesk
/usr/share/safedesk/libsciter-gtk.so
/usr/share/safedesk/files/safedesk.service
/usr/share/icons/hicolor/256x256/apps/safedesk.png
/usr/share/icons/hicolor/scalable/apps/safedesk.svg
/usr/share/safedesk/files/safedesk.desktop
/usr/share/safedesk/files/safedesk-link.desktop

%changelog
# let's skip this for now

%pre
# can do something for centos7
case "$1" in
  1)
    # for install
  ;;
  2)
    # for upgrade
    systemctl stop safedesk || true
  ;;
esac

%post
cp /usr/share/safedesk/files/safedesk.service /etc/systemd/system/safedesk.service
cp /usr/share/safedesk/files/safedesk.desktop /usr/share/applications/
cp /usr/share/safedesk/files/safedesk-link.desktop /usr/share/applications/
systemctl daemon-reload
systemctl enable safedesk
systemctl start safedesk
update-desktop-database

%preun
case "$1" in
  0)
    # for uninstall
    systemctl stop safedesk || true
    systemctl disable safedesk || true
    rm /etc/systemd/system/safedesk.service || true
  ;;
  1)
    # for upgrade
  ;;
esac

%postun
case "$1" in
  0)
    # for uninstall
    rm /usr/share/applications/safedesk.desktop || true
    rm /usr/share/applications/safedesk-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
  ;;
esac

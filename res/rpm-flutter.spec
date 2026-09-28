Name:       safedesk
Version:    1.5.0
Release:    0
Summary:    RPM package
License:    GPL-3.0
URL:        https://safedesk.com
Vendor:     safedesk <info@safedesk.com>
Requires:   gtk3 libxcb libXfixes alsa-lib libva gstreamer1-plugins-base
Recommends: libayatana-appindicator-gtk3 libxdo
Provides:   libdesktop_drop_plugin.so()(64bit), libdesktop_multi_window_plugin.so()(64bit), libfile_selector_linux_plugin.so()(64bit), libflutter_custom_cursor_plugin.so()(64bit), libflutter_linux_gtk.so()(64bit), libscreen_retriever_plugin.so()(64bit), libtray_manager_plugin.so()(64bit), liburl_launcher_linux_plugin.so()(64bit), libwindow_manager_plugin.so()(64bit), libwindow_size_plugin.so()(64bit), libtexture_rgba_renderer_plugin.so()(64bit)

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

# %global __python %{__python3}

%install

mkdir -p "%{buildroot}/usr/share/safedesk" && cp -r ${HBB}/flutter/build/linux/x64/release/bundle/* -t "%{buildroot}/usr/share/safedesk"
mkdir -p "%{buildroot}/usr/bin"
install -Dm 644 $HBB/res/safedesk.service -t "%{buildroot}/usr/share/safedesk/files"
install -Dm 644 $HBB/res/safedesk.desktop -t "%{buildroot}/usr/share/safedesk/files"
install -Dm 644 $HBB/res/safedesk-link.desktop -t "%{buildroot}/usr/share/safedesk/files"
install -Dm 644 $HBB/res/128x128@2x.png "%{buildroot}/usr/share/icons/hicolor/256x256/apps/safedesk.png"
install -Dm 644 $HBB/res/scalable.svg "%{buildroot}/usr/share/icons/hicolor/scalable/apps/safedesk.svg"

%files
/usr/share/safedesk/*
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
ln -sf /usr/share/safedesk/safedesk /usr/bin/safedesk
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
    rm /usr/bin/safedesk || true
    rmdir /usr/lib/safedesk || true
    rmdir /usr/local/safedesk || true
    rmdir /usr/share/safedesk || true
    rm /usr/share/applications/safedesk.desktop || true
    rm /usr/share/applications/safedesk-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
    rmdir /usr/lib/safedesk || true
    rmdir /usr/local/safedesk || true
  ;;
esac

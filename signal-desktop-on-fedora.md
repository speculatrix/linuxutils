
# version

example
```
export signal_version="7.84.0"
```

# pre-requisites

you need the debian/ubuntu package manager, so install install alien/dpkg

e.g.
```
sudo dnf install dpkg
```



# getting package

```
wget https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${signal_version}_amd64.deb
```

# remove package

before uninstalling or upgrading, remove the postrm script:
```
sudo rm /var/lib/dpkg/info/signal-desktop.postrm
```

to remove the package entirely
```
dpkg -r signal-desktop
```

# install or upgrade package

to install, or upgrade package (once the postrm is deleted as above)
```
sudo dpkg -i signal-desktop_${signal_version}_amd64.deb
```

ignore missing package errors like those below, try and run signal-desktop
at the command line then use "dnf" to install the equivalent packages for
Fedora.
```
dpkg: dependency problems prevent configuration of signal-desktop:
 signal-desktop depends on libnotify4; however:
  Package libnotify4 is not installed.
 signal-desktop depends on libxtst6; however:
  Package libxtst6 is not installed.
 signal-desktop depends on libnss3; however:
  Package libnss3 is not installed.
 signal-desktop depends on libasound2; however:
  Package libasound2 is not installed.
 signal-desktop depends on libpulse0; however:
  Package libpulse0 is not installed.
 signal-desktop depends on libxss1; however:
  Package libxss1 is not installed.
 signal-desktop depends on libc6 (>= 2.31); however:
  Package libc6 is not installed.
 signal-desktop depends on libgtk-3-0; however:
  Package libgtk-3-0 is not installed.
 signal-desktop depends on libgbm1; however:
  Package libgbm1 is not installed.
 signal-desktop depends on libx11-xcb1; however:
  Package libx11-xcb1 is not installed.
```

if signal won't start, try running it at the command line with "/opt/Signal/signal-desktop", then install the Fedora packages using "dnf" to get the libraries it needs.




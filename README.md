# Keyboard lighting service

Just a personal service for my setup.

To use with g810-led installed

## Setup

1. Install g810-led 

```
pamac install g810-led-git
```

2. Authorize input access non sudo users

Add these lines in `/etc/udev/rules.d/g810-led.rules` (file created by g810-led install)

```
ACTION=="add", KERNEL=="hidraw*", ATTRS{idVendor}=="046d", GOTO="logitech"
GOTO="end"

LABEL="logitech"
ATTRS{bInterfaceProtocol}=="00", TAG+="uaccess"

LABEL="end"
```

3. Run script

```
./kblt.sh
```

Looking for a practical way to install this as a daemon, depending on `dbus-monitor`
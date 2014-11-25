EasySIMBL![EasySIMBL](https://github.com/norio-nomura/EasySIMBL/raw/master/icon.iconset/icon_32x32@2x.png)
====================================
Changes from [original SIMBL](http://www.culater.net/software/SIMBL/SIMBL.php)
---------------------------
- **OS X 10.7, 10.8, 10.9, 10.10**
- **Reads plugins from `~/Library/Application Support/SIMBL/Plugins` only.**
- **Never reads plugins from `/Library/Application Support/SIMBL/Plugins`.**
- Support sandboxed application.
- Support resumed on login application.
- Drag and Drop install to `/Applications` or `~/Applications` folder, no uninstaller required.
- Change injection method.
- Install plugins(.bundle) from Finder.
- Support injecting plugins into background process `LSBackgroundOnly=1` and agent process `LSUIElement=1`, if plugin has explicitly targeting application bundle identifier (not `*`. e.g. `com.apple.appkit.xpc.openAndSavePanelService`, `com.apple.dock` or `com.apple.security.pboxd`).
- **New** `CFBundleIdentifier` of `EasySIMBL.osax` has been changed from `com.github.norio-nomura.EasySIMBL.osax` to `net.culater.SIMBL`. This trick will make Google Chrome allow loading plugins. See [#12](https://github.com/norio-nomura/EasySIMBL/issues/12)

How to install
--------------
1. Download [EasySIMBL-1.7.zip](http://github.com/norio-nomura/EasySIMBL/releases/download/EasySIMBL-1.7/EasySIMBL-1.7.zip) (2014/11/25 updated)
2. Extract and move `EasySIMBL.app` into `/Applications` or `~/Applications`.
3. Launch `EasySIMBL.app` and check `Use SIMBL`, then quit `EasySIMBL.app`.

How to upgrade
--------------
1. Move older `EasySIMBL.app` into Trash.
2. Move newer `EasySIMBL.app` into `/Applications` or `~/Applications`.
3. Launch `EasySIMBL.app` and check `Use SIMBL`, then quit `EasySIMBL.app`.

How to uninstall
----------------
1. Launch `EasySIMBL.app` then uncheck `Use SIMBL`, then quit `EasySIMBL.app`.
2. Move `EasySIMBL.app` into Trash.

Tested combinations of OS X and applications
--------------------------------------------
**If you want to provide another plugin's information, please use a [wiki](https://github.com/norio-nomura/EasySIMBL/wiki/Reports-by-users). Thanks.**

*This list includes combinations which I tested on my Mac.*

- OS X 10.10.1 (14B25)
    - Maps 2.0 & [CopyLatLngOnMaps 0.1](https://github.com/norio-nomura/CopyLatLngOnMaps)
    - Safari 8.0 & [SafariStand 8.0.208](https://github.com/hetima/SafariStand)
    - Google Chrome 38.0.2125.122(32-bit) & [NoFavicons 1.2](https://github.com/michaelphines/NoFavicons)
    - [Twitter for Mac 3.1.0](https://itunes.apple.com/jp/app/twitter/id409789998?mt=12) & [SimblPluginsForTwitter 1.5](https://github.com/norio-nomura/SimblPluginsForTwitter)
- OS X 10.9.5 (13F34)
    - Dock & [BlackDock 0.8.0](http://cooviewerzoom.web.fc2.com/blackdock.html) (without InjectIntoDock.scpt)
	- Finder & [ColorfulSidebar 1.1.2](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 7.0.1 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
    - [Twitter for Mac 3.1.0](https://itunes.apple.com/jp/app/twitter/id409789998?mt=12) & [SimblPluginsForTwitter 1.5](https://github.com/norio-nomura/SimblPluginsForTwitter)
- OS X 10.8.5 (12F45)
	- Finder & [ColorfulSidebar 1.1.2](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 6.1 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
- OS X 10.7.5 (11G63)
	- Finder & [ColorfulSidebar 1.1.2](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)

_PowerboxInjector is not compatible with EasySIMBL. Sorry, the reason exists on EasySIMBL side._

License
-------
	Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
	SIMBL is released under the GNU General Public License v2.
	http://www.opensource.org/licenses/gpl-2.0.php
	
	Copyright 2012, hetima
	EasySIMBL is released under the GNU General Public License v2.
	http://www.opensource.org/licenses/gpl-2.0.php
	
	Copyright 2012, Norio Nomura
	EasySIMBL is released under the GNU General Public License v2.
	http://www.opensource.org/licenses/gpl-2.0.php

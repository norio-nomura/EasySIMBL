EasySIMBL![EasySIMBL](https://github.com/norio-nomura/EasySIMBL/raw/master/icon.iconset/icon_32x32@2x.png)
====================================
Changes from [original SIMBL](http://www.culater.net/software/SIMBL/SIMBL.php)
---------------------------
- **OS X 10.7, 10.8, 10.9**
- **Reads plugins from `~/Library/Application Support/SIMBL/Plugins` only.**
- **Never reads plugins from `/Library/Application Support/SIMBL/Plugins`.**
- Support sandboxed application.
- Support resumed on login application.
- Drag and Drop install to `/Applications` or `~/Applications` folder, no uninstaller required.
- Change injection method.
- Install plugins(.bundle) from Finder.
- **NEW** Support injecting plugins into background process `LSBackgroundOnly=1` and agent process `LSUIElement=1`, if plugin has explicitly targeting application bundle identifier (not `*`. e.g. `com.apple.appkit.xpc.openAndSavePanelService`, `com.apple.dock` or `com.apple.security.pboxd`).

How to install
--------------
1. Download [EasySIMBL-1.6.zip](http://github.com/norio-nomura/EasySIMBL/releases/download/EasySIMBL-1.6/EasySIMBL-1.6.zip) (2013/11/25 updated)
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
- OS X 10.9.1 (13B42)
	- Finder & [ColorfulSidebar 1.1.2](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 7.0.1 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
	- Dock & [BlackDock 0.8.0](http://cooviewerzoom.web.fc2.com/blackdock.html) (without InjectIntoDock.scpt)
	- [Tweetbot for Mac 1.4(14001)](https://itunes.apple.com/jp/app/tweetbot-for-twitter/id557168941?mt=12) & [Twitter for Mac 3.0.1(3.0.1)](https://itunes.apple.com/jp/app/twitter/id409789998?mt=12) & [SyncTwitterClient 0.2](https://github.com/norio-nomura/SyncTwitterClient)
- OS X 10.8.5 (12F45)
	- Finder & [ColorfulSidebar 1.1.1](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 6.1 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
	- [Echofon for Mac 1.8.0](https://itunes.apple.com/jp/app/echofon-for-twitter/id403830270?mt=12) & [SimblPluginsForEchofon-1.4](https://github.com/norio-nomura/SimblPluginsForEchofon)  (Some plugins are outdated.)
- OS X 10.7.5 (11G63)
	- Finder & [ColorfulSidebar 1.1.1](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- [Echofon for Mac 1.8.0](https://itunes.apple.com/jp/app/echofon-for-twitter/id403830270?mt=12) & [SimblPluginsForEchofon-1.4](https://github.com/norio-nomura/SimblPluginsForEchofon)  (Some plugins are outdated.)

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

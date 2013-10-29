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

How to install
--------------
1. Download [EasySIMBL-1.5.1.zip](http://github.com/norio-nomura/EasySIMBL/releases/download/EasySIMBL-1.5.1/EasySIMBL-1.5.1.zip) (2013/10/29 updated)
2. Extract and move `EasySIMBL.app` into `/Applications` or `~/Applications`.
3. Launch `EasySIMBL.app` and make check `Use SIMBL`, then quit `EasySIMBL.app`.

How to upgrade
--------------
1. Move older `EasySIMBL.app` into Trash.
2. Move newer `EasySIMBL.app` into `/Applications` or `~/Applications`.
3. Launch `EasySIMBL.app` and make check `Use SIMBL`, then quit `EasySIMBL.app`.

How to uninstall
----------------
1. Launch `EasySIMBL.app` then clear check `Use SIMBL`, then quit `EasySIMBL.app`.
2. Move `EasySIMBL.app` into Trash.

Tested combinations of OS X and applications
--------------------------------------------
- OS X 10.7.5 (11G63)
	- Finder & [ColorfulSidebar 1.1.1](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- [Echofon for Mac 1.8.0](https://itunes.apple.com/jp/app/echofon-for-twitter/id403830270?mt=12) & [SimblPluginsForEchofon-1.4](https://github.com/norio-nomura/SimblPluginsForEchofon)
- OS X 10.8.5 (12F45)
	- Finder & [ColorfulSidebar 1.1.1](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 6.1 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
	- [Echofon for Mac 1.8.0](https://itunes.apple.com/jp/app/echofon-for-twitter/id403830270?mt=12) & [SimblPluginsForEchofon-1.4](https://github.com/norio-nomura/SimblPluginsForEchofon),
- OS X 10.9 (13A603)
	- Finder & [ColorfulSidebar 1.1.1](http://cooviewerzoom.web.fc2.com/colorfulsidebar.html) (without PowerboxInjector)
	- Safari 7.0 & [SafariStand 6.0.200](https://github.com/hetima/SafariStand)
	- [Echofon for Mac 1.8.0](https://itunes.apple.com/jp/app/echofon-for-twitter/id403830270?mt=12) & [SimblPluginsForEchofon-1.4](https://github.com/norio-nomura/SimblPluginsForEchofon)

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

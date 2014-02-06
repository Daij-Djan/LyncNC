LyncNC
======

SIMBL based plugin that integrates MS lync for mac 2011 with the Notification Center

Compiled version 0.6 (first public release):<br/>
https://github.com/Daij-Djan/LyncNC/raw/master/Binary-LyNC-0.6%2BEasySIMBL.zip

####Requirements
- OSX 10.8 or 10.9
- Microsoft Lync For Mac 2011<br/>
 (version 14. tested 14.0.5 but should work with any 14 and maybe with others too)
- SIMBL 0.9.9 or if you like 'EasySIMBL 1.6' </br>
 (others should work too but I only tested it with those two)

####Credits
- Mike Solomon for the SIMBL framework that enables patches like these.

####install/uninstall

- an **installer is included** in the binary package

- to uninstall LyncNC: 

	just delete the one file it copies AT:

     	~/Library/Application Support/SIMBL/Plugins/LyncNC.bundle
         (you can do it with the finder, ~ = your home folder)

	Then restart Lync and there is NO trace of the plugin 

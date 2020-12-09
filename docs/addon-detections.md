<!-- leave the empty title here... the image below displays the info BUT the platform requires something here -->
### 

## <span style="color:#185000">evil-maid</span>

**Website:** http://doc.limacharlie.io

**Owner:** ops@limacharlie.io

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Simple check for sensors becoming online from hosts that should not be running. This is well suited to detecting "evil maid" attacks (https://goo.gl/Uis8BP). Tag sensors that should not be online with "check-evil-maid". To avoid duplication of alerts, the response should tag with "is-evil-maid" which will make this detection ignore further alerts as long as the tag is present: Example:
>
>action: add tag tag: is-evil-maid ttl: 864000
>action: report name: evil-maid


## <span style="color:#185000">powershell-encoded-command
</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

> Detects usage of Powershell using an encoded command line.

## <span style="color:#185000">win-acl-tampering
</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects tampering of Windows filesystem Access Control List using the Windows built in utility.

## <span style="color:#185000">win-document-exe-payload</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects Windows common productivity software dropping executables.

## <span style="color:#185000">win-document-exploit
</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects Windows exploits from common document formats.

## <span style="color:#185000">win-password-dump</span>

Website: https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects the loading of password dumping related modules.

## <span style="color:#185000">win-recon</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects Windows automated reconnaissance.

## <span style="color:#185000">win-shadow-volume-tampering</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects tampering of Windows Shadow Volumes.

## <span style="color:#185000">win-suspicious-command-line
</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects Windows execution with suspicious command lines.

## <span style="color:#185000">win-suspicious-exec-location</span>

Website: https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects Windows execution from suspicious locations.

## <span style="color:#185000">win-suspicious-exec-name</span>

**Website:** https://github.com/refractionPOINT/rules

**Cost:** FREE

**Platforms:** Windows

>Detects suspicious Windows executable names.

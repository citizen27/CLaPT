# CLaPT - Collect Logs and Parse Them

Mind numbing parts of this documentation and code commenting have been written by AI, particularly ChatGPT and Bard. All PowerShell scripts are written, tested and developed by me, or me and other humans (credit will be given, or code will be linked).  

PowerShell is not the fastest, most efficent, easiest...scripting language. This is done in PowerShell for native Windows support, and the author loves hash tables and arrays.

## Overview

**This code repository contains numerous scripts intended for parsing Windows logs and databases.** Its purpose is to facilitate the monitoring and analysis of Windows system events, offering insights into system activities and potential security incidents or visibility gaps. The ultimate objective of this "toolkit" is to encompass a substantial range of automated triage functionalities, with a focus on efficient responses to security incidents from an Incident Response (IR) perspective. ***This tool is not intended to be used for any form of preservation or forensic imaging.***

It is important to note that all scripts within this repository operate under the assumption of default configurations for log and resource locations. In cases where the target item for parsing is different from defaults, the scripts may either execute and produce an empty CSV file or encounter an operational failure without providing a detailed explanation. This design decision acknowledges that the majority of Windows systems typically adhere to default settings. **It is important to understand that if this risk is unacceptable for your specific requirements, the utility of this toolkit in your context may be limited or completely no good.**

**Currently, this toolkit prioritizes rapid response capabilities over digital forensics considerations.** This approach is deliberate, considering the challenges associated with achieving "zero" forensic impact while collecting critical information. As long as risks and deviations from standard practices are thoroughly documented, any forensic impact associated with this toolkit should not be a significant concern. The core process guiding this toolkit is oriented toward incident response, the acquisition of actionable insights rather than preservation. In essence, this toolkit is optimized for expedited triage.

It's worth noting that specific portions of the code, especially those pertaining to parsing files under "C:\Windows\Panther" an native Registry parsers, may present complexities in pure .NET environments. While potential solutions are being explored, the current approach involves initiating a subprocess within an administrative Command Prompt session to invoke "tracerpt.exe" when parsing certain ETL files under the Panther directory. It's important to clarify that this is a standard Windows feature and is not associated with any malicious intent. The decision to use Command Prompt, rather than PowerShell, was made to maintain code clarity, with plans for future enhancements in mind.

These scripts operate with elevated privileges, including Sytesm administrative execution, desktop folder creation and management, and the ability to bypass Group Policy Object (GPO) and other execution policy barriers. It is ***strongly*** recommended to review and modify the scripts to align them with your *specific use case requirements*, as each scenario may need distinct configurations. This toolkit offers flexibility, and results may vary based on your individual needs, and the toolkit can be customized accordingly.

## Usage ## 

1. Download the ZIP or clone through GitHub CLI or HTTPS.
2. Move zipped "CLaPT-main" to the local desktop.
4. Extract the zip folder to the local desktop.
5. Rename the folder after extraction to "CLaPT".
6. Move CLaPT_Controller.ps1 from "CLaPT", to an alternate location.
7. Open an administrative PowerShell session
8. Navigate from system32 to Desktop (cd $home\Desktop\)
9. Run CLaPT_Controller.ps1. (.\CLaPT_Controller.ps1)
10. Review Deprecated.md for additional information on most detailed and up to date modules and scripts.

| Emoji | Meaning|
| --- | --- |
| 🔥 | New and currently being developed! |
| 🔒 | Involves actions on the Security Event Log |
| 🖥️ | Involves actions on the System Event Log |
| 🐆 | Involves the Panther directory. |
| 🧅 | Mutliple Event IDs handled. |
| 🤡 | Has major issues, run at own risk. |


| **Script** | **Parsing Purpose** |
| --- | --- |
| 🔥 **InternetArtifactCollector.ps1** | *Collects root folders for web browsers. **Firefox and Chrome currently supported.*** |
| 🔒 🖥️**EventLogTamper.ps1**| *Security and System Events for common Event Log tampering indicators.*  |
| 🐆 **PantherETLParse.ps1** | *.ETL files found in _C:\Windows\Panther_ directory.* |
| 🐆 **PantherSetupActLog.ps1** | *.LOG file found in C:\Windows\Panther\SetupAct.log.* |
| 🔒 **AccountNameChange.ps1** | *Security Event Log for account name change events.* |
| 🔒 **FailedLogon.ps1** | *Security Event Log for failed logon events.* |
| 🔒 **LogonTypes.ps1** | *Security Event Log for successful logons, and displays logon type.* |
| 🔒 **ObjectAccess.ps1** | *Security Event Log for user attempts to access an object (obscure).* |
| 🔒🧅 **SecurityGroups.ps1** | *Security Event Log for actions on security enabled groups.* |
| 🔒 **SystemTimeChange.ps1** | *Security Event Log for system time change events.* |
| 🔒 **UserLockout.ps1** | *Security Event Log for user lockout events.* |
| 🔒 **WinLogoff.ps1** | *Security Event Log for logoff events.* |
| 🔒 **WinLogon.ps1** | *Security Event Log for logon events*. |
| 🖥️ **ShutdownLog.ps1** | *System Event Log for shutdown events.* |
| 🤡🔥 **NTUSER_Parse.ps1** | *NTUSER.dat for useful forensic goodies*. |
   
## Features

- **Log / Database Parsing:** The code parses various Windows Event logs, including Application, Security, System, and more, depending on your configuration. This tool can also parse "databases" that matter (SRUM, SQL, etc.).

- **Log Parsing:** The code parses collected logs and databases, extracting relevant information and organizing it for rapid analysis. This toolkit does NOT collect! If you want to forensically collect the logs, use KAPE or some other tool meant for that. This is for quick intel to figure out the stuff that matters.

- **Customization:** You can customize which logs to collect and how to parse them based on your specific requirements. Literally, just run the scripts you want.

- **Output Formats:** Right now, everything exports to the default of .CSV. Eventually the tool will support multiple output formats, making it easy to export parsed logs for further analysis, reporting, or integration with other tools.

- **Odd Artifact Parsing:** Some of these logs and artifacts are weird (Panther, obscure event IDs, etc.). Only collect what you need, or treat it like Pokemon. Panther logs are useful to determine issues with rollbacks, upgrades, or system failures. Particularly useful after updates on Windows systems. Collect if needed; this is of pretty low importance in most use cases. Panther logs get really granular and annoying, so forgive the lack of full support.

- **Error Handling:** The code includes error-handling mechanisms to deal with most issues that may arise during log collection or parsing. Some issues will be based on GPO and other environmentally-based factors. Please adjust as you need to.

## Prerequisites

Before using any part of this tool kit, ensure you have the following prerequisites:

- Windows operating system (required to collect Windows Event Logs)
- PowerShell 3.x or later  
- Administrative privileges on system and in PowerShell and CMD terminals (required for accessing event logs, makes troubleshooting easier)
- Understanding of Windows Event Log IDs
- Patience

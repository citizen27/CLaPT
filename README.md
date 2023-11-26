# CLaPT - Collect Logs and Parse Them 📁

Mind numbing parts of this documentation and code commenting have been written by AI/ML, particularly ChatGPT and Bard (this ReadMe is almost entirely AI/ML generated because it does a way better job than I can). **All PowerShell scripts are written, tested and developed by me, or me and other humans** (credit will be given, or code will be linked).  

## Overview

**This code repository encompasses a collection of scripts designed for the purpose of parsing Windows logs and databases.** 

Its primary objective is to streamline the monitoring and analysis of Windows system events, providing valuable insights into system activities, potential security incidents, or areas of visibility deficiency. The overarching goal of this **"toolkit"** is to encompass a comprehensive array of automated triage functionalities, with a particular emphasis on efficient responses to security incidents from an Incident Response (IR) perspective. It is important to emphasize that this tool is not intended for utilization in preservation or forensic imaging procedures.

It is crucial to acknowledge that all scripts contained within this repository are configured to operate under the assumption of default settings for log and resource locations. In cases where the parsing target deviates from these defaults, the scripts may either execute and generate an empty CSV file or encounter operational failures without providing exhaustive error explanations. This design choice stems from the recognition that the majority of Windows systems typically adhere to default configurations. However, it is imperative to recognize that if this level of risk is deemed unacceptable within the context of your specific requirements, the utility of this toolkit may be limited or unsuitable.

At present, this toolkit prioritizes expeditious response capabilities over considerations of digital forensics. This strategic approach is deliberate, given the challenges associated with achieving a **"zero" forensic footprint** while gathering crucial information. Provided that risks and deviations from standard practices are meticulously documented, any potential forensic impact associated with this toolkit should not be of significant concern. The core operational philosophy guiding this toolkit is oriented towards incident response, with an emphasis on acquiring actionable insights rather than preservation. In essence, this toolkit is optimized for swift triage.

It is noteworthy that specific segments of the code, particularly those related to parsing files within the **"C:\Windows\Panther"** directory and native Registry parsers, may introduce issues when employed within pure .NET environments. While ongoing efforts are being made to explore potential solutions, the current approach involves initiating a subprocess within an administrative **Command Prompt session** to invoke **"tracerpt.exe"** for parsing certain ETL files situated under the Panther directory. It is important to emphasize that this is a standard Windows feature and is devoid of any malicious intent. The choice to employ Command Prompt, as opposed to PowerShell, was motivated by a desire to maintain code clarity, with future enhancements in mind.

These scripts operate with elevated privileges, including **System-level administrative execution**, desktop folder creation and management, and the capability to bypass **Group Policy Object (GPO)** and other execution policy constraints. It is strongly advised to thoroughly review and customize the scripts to align them with the specific requirements of your use case, as each scenario may necessitate distinct configurations. This toolkit offers a high degree of flexibility, and outcomes may vary depending on your individual needs; therefore, the toolkit can be tailored accordingly to meet those needs.


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
| 👻 | Random Windows logs, DBs or artifacts. |



| **Script** | **Parsing Purpose** |
| --- | --- |
| 🔥 **InternetArtifactCollector.ps1** | *Collects default root folders for web browsers. **Firefox and Chrome currently supported.*** |
| 🔒 🖥️**EventLogTamper.ps1**| *Security and System Events for common Event Log tampering indicators.*  |
| 🐆 **PantherETLParse.ps1** | *.ETL files found in C:\Windows\Panther_ directory.* |
| 🐆 **PantherSetupActLog.ps1** | *.LOG file found in C:\Windows\Panther\SetupAct*.log.* |
| 🔒 **AccountNameChange.ps1** | *Security Event Log for account name change events*.* |
| 🔒 **FailedLogon.ps1** | *Security Event Log for failed logon events.* |
| 🔒 **LogonTypes.ps1** | *Security Event Log for successful logons, and displays logon type.* |
| 🔒 **ObjectAccess.ps1** | *Security Event Log for user attempts to access an object (obscure).* |
| 🔒🧅 **SecurityGroups.ps1** | *Security Event Log for actions on security enabled groups.* |
| 🔒 **SystemTimeChange.ps1** | *Security Event Log for system time change events.* |
| 🔒 **UserLockout.ps1** | *Security Event Log for user lockout events.* |
| 🔒 **WinLogoff.ps1** | *Security Event Log for logoff events.* |
| 🔒 **WinLogon.ps1** | *Security Event Log for logon events*. |
| 🖥️ **ShutdownLog.ps1** | *System Event Log for shutdown events.* |
| 🔥 **NTUSER_Parse.ps1** | *NTUSER.dat for useful forensic goodies*. |
| 🔥🖥️ **Relation-To-Logon-Off.ps1** | *Parses dozens of event IDs relating to logon and logoff activity. More comprehensive than previous scripts*.  |
| 😴 **SleepStudy.ps1** | *Parses .ETl files found in C:\Windows\System32\SleepStudy* |
| 👻 **CrashDMP.ps1** | *Collects default memory dump post BSOD*. |
| 👻 **CloudFilesETL.ps1** | *Parses CloudFiles logs under System32*. |
   
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

# CLaPT - Collect Logs and Parse Them

Mind numbing parts of this documentation and code commenting have been written by AI, particularly ChatGPT and Bard. All PowerShell scripts are written, tested and developed by me, or me and other humans (credit will be given, or code will be linked).  

## Overview

This code repository contains many scripts for parsing Windows logs and databases. It is designed to assist in the monitoring and analysis of Windows system events, enabling you to gain insights into system activities and potential security incidents or visibility gaps. This "toolkit" eventually plans to encompass a massive amount of automated triage. I am focusing less on the digital forensic side of things and more on rapid response to security incidents from an IR perspective.

Also, ALL scripts assume default locations for logs and other things. If the item to be parsed is not in the default location, the scripts will either run and return an empty CSV file, or will just fail with no explanation. I would argue that an overwhelming majority of logs on a Windows system are going to be in the default location, so this is a risk that I am OK with. If this risk is not acceptable, this toolkit will be of little to no use to you. This toolkit is also written with little regard to forensic impact at the moment. This is not an oversight; it is just incredibly hard to collect anything with "no" forensic impact. As long as risks and changes are documented, this should be of little to no concern. Incident response is different from digital forensics, and this toolkit is meant for getting answers, not preserving them. Quick and dirty triage is the name of the game.

Certain parts of this code, particularly parsing files under "C:\Windows\Panther\", become incredibly difficult to parse in true .NET environments. I am sure there is a way around this, but for the time being, any script parsing an ETL file under Panther will spawn a subprocess in an administrative Command Prompt session to call "tracerpt.exe". This is built into Windows and is not malicious, but the code was going to get messy if I made that call from PowerShell. I will fix it eventually. I promise. If I am being honest, ETL file logs are pretty low on the totem pole for an incident responder, so... YMMV. These scripts also assume ALOT of privilege. Running locally, creating and saving folders to the desktop, bypassing the GPO and other execution policy barriers... Please edit the scripts to collect them in the way that YOU need to. Each use case will be different.

## Usage ## 

1. Download the ZIP or clone through GitHub CLI or HTTPS.
2. Move zipped "CLaPT-main" to the local desktop.
4. Extract the zip folder to the local desktop.
5. Rename the folder after extraction to "CLaPT".
6. Move CLaPT_Controller.ps1 from "CLaPT", to an alternate location.
7. Open an administrative PowerShell session
8. Navigate from system32 to Desktop (cd $home.\Desktop\)
9. Run CLaPT_Controller.ps1. (.\CLaPT_Controller.ps1)
10. Review Deprecated.md for additional information on most detailed and up to date modules and scripts.
   
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

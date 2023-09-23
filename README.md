# CLaPT - Collect Logs and Parse Them

Mind numbing parts of this documentation and code commenting have been written by AI, particularly ChatGPT and Bard. All PowerShell scripts are written, tested and developed by me, or me and other humans. 

## Overview

This code repository contains many scripts for collecting and parsing Windows Logs and databases. It is designed to assist in the monitoring and analysis of Windows system events, enabling you to gain insights into system activities and potential security incidents or visibility gaps. This "toolkit" eventually plans encompass a massive amount of automated triage. I am focusing less on the digital forensic side of things, and more on rapid repsonse to security incidents from an IR perspective. 

Also, ALL scripts assume default locations for logs and other things. If the item to be parsed/collected is not in the default location, the scripts will either run and return an empty .CSV, or will just fail with no explanation. I would argue that an overwhelming majority of logs on a Windows system are going to be in the default location, so this is a risk that I am OK with. If this risk is not acceptable, this toolkit will be of little to no use to you. This toolkit is also written with little regard to forensic impact at the moment. This is not an oversight, it is just incredibly hard to collect anything with "no" forensic impact. As long as risk/changes is documented, this should be of little to no concern. Incident response is different to digital forensics, and this toolkit is meant for getting answers, not preserving them. Enjoy.

## Features

- **Log / Database Collection**: The code collects various Windows Event Logs, including Application, Security, System, and more, depending on your configuration. Also can collect databases that matter (SRUM, others...)

- **Log Parsing**: It parses collected logs and databases, extracting relevant information and organizing it for rapid analysis.

- **Customization**: You can customize which event logs to collect and how to parse them based on your specific requirements.

- **Output Formats**: The tool supports multiple output formats, making it easy to export parsed logs for further analysis, reporting, or integration with other tools. Supported are Windows native (.txt, .csv, .xlsx...you know the drill by now). 

- **Scheduled Execution**: You can set up scheduled tasks to automate log collection and parsing, ensuring you have up-to-date information. 

- **Error Handling**: The code includes error handling mechanisms to deal with any issues that may arise during log collection or parsing.

## Prerequisites

Before using this tool, ensure you have the following prerequisites:

- Windows operating system (compatible with Windows Event Logs)
- PowerShell (Seems obvious)
- Administrative privileges (required for accessing event logs)
- Python 3.x (FUTURE possibly)

## Usage

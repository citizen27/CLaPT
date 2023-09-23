# CLaPT - Collect Logs and Parse Them

Mind numbing parts of this documentation have been written by AI, particularly ChatGPT and Bard. All PowerShell scripts are written, tested and developed by me, or me and other humans. 

## Overview

This code repository contains many scripts for collecting and parsing Windows Logs and databases. It is designed to assist in the monitoring and analysis of Windows system events, enabling you to gain insights into system activities and potential security incidents or visibility gaps. This "toolkit" eventually plans encompass a massive amount of automated triage. I am focusing less on the digital forensic side of things, and more on rapid repsonse to security incidents from an IR perspective.

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

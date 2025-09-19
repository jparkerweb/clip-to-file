# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Windows PowerShell utility that saves clipboard content (images and text) to timestamped files. The repository contains a single PowerShell script with INI-based configuration.

## Key Commands

```powershell
# Run the main script
.\clip-to-file.ps1

# Set execution policy if needed (one-time setup)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Architecture

**Single Script Design**: The entire functionality is contained in `clip-to-file.ps1` with a functional programming approach using PowerShell functions.

**Core Components**:
- **Configuration Management**: INI file reading/writing functions (`Read-IniFile`, `Write-IniFile`, `Get-Config`)
- **Clipboard Processing**: Separate handlers for images (`Save-ClipboardImage`) and text (`Save-ClipboardText`)
- **File Management**: Timestamp generation and conflict resolution (`Get-Timestamp`, `Get-UniqueFileName`)
- **Main Execution Flow**: Sequential clipboard detection (images first, then text) with comprehensive error handling

**Dependencies**: Uses Windows .NET assemblies (`System.Windows.Forms`, `System.Drawing`) for clipboard access and image processing.

**Configuration**: Auto-creates `clip-to-file.ini` with `[Settings]` section, defaults to user's Downloads folder.

**File Naming**: Uses `YYYYMMDD_HHMMSS` format with automatic conflict resolution via numeric suffixes.

## Key Design Decisions

- **Images always saved as JPEG** regardless of source format for consistency
- **UTF-8 encoding** for all text files
- **Defensive programming** with permission checks before file operations
- **Priority order**: Images detected before text to handle mixed clipboard content
- **Graceful degradation** with user-friendly error messages and proper exit codes
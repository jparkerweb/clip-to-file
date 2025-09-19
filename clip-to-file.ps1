# clip-to-file.ps1
# PowerShell script to save clipboard content to files

# Function to read INI file
function Read-IniFile {
    param (
        [string]$FilePath
    )

    $config = @{}

    if (Test-Path $FilePath) {
        $currentSection = ""
        Get-Content $FilePath | ForEach-Object {
            $line = $_.Trim()
            if ($line -match '^\[(.+)\]$') {
                $currentSection = $matches[1]
                $config[$currentSection] = @{}
            }
            elseif ($line -match '^(.+?)=(.*)$' -and $currentSection) {
                $config[$currentSection][$matches[1]] = $matches[2]
            }
        }
    }

    return $config
}

# Function to write INI file
function Write-IniFile {
    param (
        [string]$FilePath,
        [hashtable]$Config
    )

    $content = @()
    foreach ($section in $Config.Keys) {
        $content += "[$section]"
        foreach ($key in $Config[$section].Keys) {
            $content += "$key=$($Config[$section][$key])"
        }
        $content += ""
    }

    $content | Out-File -FilePath $FilePath -Encoding UTF8
}

# Function to get or create config
function Get-Config {
    param (
        [string]$ConfigPath
    )

    $config = Read-IniFile -FilePath $ConfigPath

    if (-not $config.ContainsKey("Settings") -or -not $config["Settings"].ContainsKey("SavePath")) {
        $userProfile = [Environment]::GetFolderPath("UserProfile")
        $downloadsPath = Join-Path $userProfile "Downloads"
        $config = @{
            "Settings" = @{
                "SavePath" = $downloadsPath
            }
        }
        Write-IniFile -FilePath $ConfigPath -Config $config
    }

    return $config
}

# Function to generate timestamp
function Get-Timestamp {
    return Get-Date -Format "yyyyMMdd_HHmmss"
}

# Function to get unique filename
function Get-UniqueFileName {
    param (
        [string]$Directory,
        [string]$BaseName,
        [string]$Extension
    )

    $counter = 0
    $fileName = "$BaseName.$Extension"
    $fullPath = Join-Path $Directory $fileName

    while (Test-Path $fullPath) {
        $counter++
        $fileName = "${BaseName}_$counter.$Extension"
        $fullPath = Join-Path $Directory $fileName
    }

    return $fullPath
}

# Function to save image from clipboard
function Save-ClipboardImage {
    param (
        [string]$SavePath,
        [string]$Timestamp
    )

    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $image = [System.Windows.Forms.Clipboard]::GetImage()
        if ($image -eq $null) {
            return $false
        }

        $fileName = Get-UniqueFileName -Directory $SavePath -BaseName $Timestamp -Extension "jpg"
        $image.Save($fileName, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        $image.Dispose()

        Write-Host "Image saved to: $fileName" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error saving image: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to save text from clipboard
function Save-ClipboardText {
    param (
        [string]$SavePath,
        [string]$Timestamp
    )

    try {
        Add-Type -AssemblyName System.Windows.Forms

        $text = [System.Windows.Forms.Clipboard]::GetText()
        if ([string]::IsNullOrEmpty($text)) {
            return $false
        }

        $fileName = Get-UniqueFileName -Directory $SavePath -BaseName $Timestamp -Extension "txt"
        $text | Out-File -FilePath $fileName -Encoding UTF8

        Write-Host "Text saved to: $fileName" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error saving text: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main script execution
try {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $configPath = Join-Path $scriptDir "clip-to-file.ini"

    # Get configuration
    $config = Get-Config -ConfigPath $configPath
    $savePath = $config["Settings"]["SavePath"]

    # Validate save directory
    if (-not (Test-Path $savePath)) {
        try {
            New-Item -ItemType Directory -Path $savePath -Force | Out-Null
        }
        catch {
            Write-Host "Error: Cannot create save directory '$savePath'. Please check permissions." -ForegroundColor Red
            exit 1
        }
    }

    # Check if directory is writable
    $testFile = Join-Path $savePath "test_write_permissions.tmp"
    try {
        New-Item -ItemType File -Path $testFile -Force | Out-Null
        Remove-Item $testFile -Force
    }
    catch {
        Write-Host "Error: Cannot write to save directory '$savePath'. Please check permissions." -ForegroundColor Red
        exit 1
    }

    # Generate timestamp
    $timestamp = Get-Timestamp

    # Check clipboard contents and save accordingly
    Add-Type -AssemblyName System.Windows.Forms

    $imageSaved = Save-ClipboardImage -SavePath $savePath -Timestamp $timestamp
    if ($imageSaved) {
        exit 0
    }

    $textSaved = Save-ClipboardText -SavePath $savePath -Timestamp $timestamp
    if ($textSaved) {
        exit 0
    }

    # If we get here, clipboard is empty or contains unsupported content
    Write-Host "Error: Clipboard is empty or contains unsupported content. Only images and text are supported." -ForegroundColor Red
    exit 1
}
catch {
    Write-Host "Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
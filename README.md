# 📋 Clip-to-File

A lightning-fast PowerShell utility that instantly saves your clipboard content to organized files with timestamped names.

## ✨ Features

- **Smart Detection**: Automatically detects images and text in your clipboard
- **Instant Save**: One command saves clipboard content with zero configuration
- **Organized Output**: Files saved with clean timestamps (`YYYYMMDD_HHMMSS` format)
- **Conflict Resolution**: Automatically handles duplicate filenames by appending numbers
- **Configurable**: Simple INI-based configuration with sensible defaults
- **Error Handling**: Friendly error messages guide you through any issues

## 🚀 Quick Start

1. **Download**: Clone or download `clip-to-file.ps1`
2. **Run**: Execute the script from PowerShell
   ```powershell
   .\clip-to-file.ps1
   ```
3. **Done**: Your clipboard content is now saved!

## 📁 How It Works

### Image Content
- **Input**: Any image copied to clipboard (screenshots, copied images from web, etc.)
- **Output**: `20250118_143025.jpg` (saved as high-quality JPEG)

### Text Content
- **Input**: Any text copied to clipboard
- **Output**: `20250118_143025.txt` (saved as UTF-8 text file)

### File Conflicts
If a file with the same timestamp exists, the script automatically appends a number:
- `20250118_143025.jpg`
- `20250118_143025_1.jpg`
- `20250118_143025_2.jpg`

## ⚙️ Configuration

The script creates a `clip-to-file.ini` configuration file on first run:

```ini
[Settings]
SavePath=C:\Users\YourName\Downloads
```

**Default Location**: Your Downloads folder
**Customization**: Edit the INI file to change the save directory

## 🔥 Pro Tip: Keyboard Shortcuts

Transform this into a super-powered clipboard tool by mapping it to a keyboard shortcut!

### Option 1: AutoHotkey (Recommended)

1. **Install [AutoHotkey](https://www.autohotkey.com/)**
2. **Create a script file** (e.g., `clipboard-hotkey.ahk`):
   ```autohotkey
   ; Ctrl+Alt+V to save clipboard
   ^!v::Run, powershell.exe -WindowStyle Hidden -File "C:\git\img-clip-to-jpg\clip-to-file.ps1"
   ```
3. **Run the AutoHotkey script**
4. **Enjoy**: Press `Ctrl+Alt+V` to instantly save clipboard content!

### Option 2: Windows Shortcut

1. **Right-click** `clip-to-file.ps1` → "Create shortcut"
2. **Right-click** the shortcut → "Properties"
3. **Click** in the "Shortcut key" field
4. **Press** your desired key combination (e.g., `Ctrl+Alt+V`)
5. **Click** "OK"

### Option 3: PowerToys

If you have [Microsoft PowerToys](https://github.com/microsoft/PowerToys) installed:

1. **Open** PowerToys Settings
2. **Navigate** to "Keyboard Manager"
3. **Add** a new shortcut mapping to run your script

## 🛠️ Requirements

- **Windows** (PowerShell 5.1 or later)
- **.NET Framework** (included with Windows)

## 📝 Usage Examples

```powershell
# Basic usage
.\clip-to-file.ps1

# Copy an image, then run
.\clip-to-file.ps1
# Output: Image saved to: C:\Users\You\Downloads\20250118_143025.jpg

# Copy some text, then run
.\clip-to-file.ps1
# Output: Text saved to: C:\Users\You\Downloads\20250118_143025.txt
```

## 🔧 Troubleshooting

### "Execution Policy" Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Cannot create save directory" Error
- Check that the configured save path exists and you have write permissions
- The script will attempt to create the directory if it doesn't exist

### "Clipboard is empty" Error
- Ensure you have content copied to your clipboard before running the script
- Only images and text content are supported

## 🎯 Perfect For

- **Screenshots**: Instantly save screenshots with organized naming
- **Code Snippets**: Quickly save copied code to timestamped files
- **Research**: Save copied text and images during web browsing
- **Documentation**: Organize clipboard content for later reference

## 📄 License

Free to use, modify, and distribute. No attribution required.

---

**Made for productivity enthusiasts who love organized file systems** 🚀
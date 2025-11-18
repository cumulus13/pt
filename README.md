# PT - Production-hardened Clipboard to File Tool

[![Rust](https://img.shields.io/badge/rust-1.70%2B-orange.svg)](https://www.rust-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.22-blue.svg)](https://github.com/cumulus13/pt)

A robust command-line tool for managing clipboard content with intelligent file versioning, backup management, and recursive search capabilities.

## 🚀 Features

### Core Functionality
- ✅ **Clipboard to File** - Save clipboard content to files instantly
- ✅ **Smart Backup System** - Automatic versioning with timestamps and comments
- ✅ **Recursive File Search** - Find files anywhere in subdirectories
- ✅ **Check Mode** - Skip writes when content is identical (save disk space)
- ✅ **Append Mode** - Add clipboard content to existing files
- ✅ **Comment Support** - Add descriptive comments to all operations

### Advanced Features
- 🌳 **Directory Tree View** - Visualize directory structure with gitignore support
- 📦 **Backup Management** - List, restore, and compare backup versions
- 🔍 **Delta Integration** - Beautiful side-by-side diffs using delta CLI
- 🗑️ **Safe Deletion** - Backup files before deletion with empty placeholder
- ⚙️ **Configuration System** - Customize behavior via YAML config
- 📊 **Metadata Storage** - Track backup comments, timestamps, and origins

### Security & Validation
- 🔒 Path traversal protection
- 🔒 System directory write protection
- 🔒 File size limits (configurable, default 100MB)
- 🔒 Filename length validation
- 🔒 Disk space checking

## 📦 Installation

### From Source

```bash
# Clone repository
git clone https://github.com/cumulus13/pt.git
cd pt

# Build release binary
cargo build --release

# Binary will be at: target/release/pt

# Optional: Install to system
cargo install --path .
```

### From Crates.io (when published)

```bash
cargo install pt
```

## 🎯 Quick Start

```bash
# Write clipboard to file
pt notes.txt

# Write with check mode (skip if identical)
pt notes.txt -c

# Write with comment
pt notes.txt -m "Initial draft"

# Append clipboard to file
pt append log.txt
pt append log.txt -m "New entry"

# List all backups
pt list notes.txt

# Restore from backup (interactive)
pt restore notes.txt

# Restore last backup
pt restore notes.txt --last

# Compare with backup using delta
pt diff notes.txt
pt diff notes.txt --last

# Show directory tree
pt tree
pt tree /path/to/dir
pt tree -e node_modules,.git

# Configuration
pt config init          # Create sample config
pt config show          # View current settings
pt config path          # Show config location

# Version info
pt -V
pt --version-info
```

## 📖 Command Reference

### Write Operations

```bash
# Basic write
pt <filename>                    # Write clipboard to file
pt <filename> -c                 # Check mode (skip if identical)
pt <filename> -m "comment"       # With comment
pt <filename> -c -m "comment"    # Check mode with comment
```

### Append Mode

```bash
pt append <filename>             # Append clipboard
pt append <filename> -m "msg"    # Append with comment
```

### Backup Management

```bash
pt list <filename>               # List all backups
pt restore <filename>            # Interactive restore
pt restore <filename> --last     # Restore last backup
pt restore <filename> -m "msg"   # Restore with comment
pt diff <filename>               # Interactive diff
pt diff <filename> --last        # Diff with last backup
```

### File Operations

```bash
pt remove <filename>             # Delete file (with backup)
pt remove <filename> -m "msg"    # Delete with comment
```

### Directory Tree

```bash
pt tree [path]                   # Show tree (default: .)
pt tree -e file1,file2           # Exclude files/dirs
```

### Configuration

```bash
pt config init [path]            # Create config (default: pt.yml)
pt config show                   # Display current config
pt config path                   # Show config file location
```

## ⚙️ Configuration

Create a `pt.yml` file in one of these locations:
- `./pt.yml` (current directory)
- `~/.config/pt/pt.yml`
- `~/pt.yml`

### Sample Configuration

```yaml
# PT Configuration File

# Maximum clipboard content size in bytes (default: 104857600 = 100MB)
max_clipboard_size: 104857600

# Maximum number of backups to keep (default: 100)
max_backup_count: 100

# Maximum filename length (default: 200)
max_filename_length: 200

# Backup directory name (default: "backup")
backup_dir_name: backup

# Maximum directory depth for recursive search (default: 10)
max_search_depth: 10
```

Generate sample config:
```bash
pt config init
```

## 📂 Backup System

### Backup Location
All backups are stored in the `./backup/` directory (configurable).

### Backup Naming
Format: `{filename}_{ext}.{timestamp}.{pid}_{random}`

Example: `notes_txt.20241115_143022123456.12345_a3f4`

### Backup Metadata
Each backup includes a `.meta.json` file containing:
```json
{
  "comment": "User-provided comment",
  "timestamp": "2024-11-15T14:30:22+07:00",
  "size": 1234,
  "original_file": "/path/to/original.txt"
}
```

## 🔍 Recursive Search

When a file is not found in the current directory, PT automatically searches subdirectories (up to configured depth).

```bash
# File in subdirectory
pt src/main.rs

# If multiple files found, interactive selection:
🔍 Found 3 file(s):

1. ./src/main.rs - 2024-11-15 14:30:22 - 15.2 KB
2. ./backup/main.rs - 2024-11-14 10:20:15 - 14.8 KB
3. ./old/main.rs - 2024-11-10 09:15:30 - 13.5 KB

Enter file number to use (1-3) or 0 to cancel: 
```

## 🎨 Delta Integration

PT supports [delta](https://github.com/dandavison/delta) for beautiful diffs:

```bash
# Install delta
cargo install git-delta

# Use with PT
pt diff notes.txt
```

Features:
- Syntax highlighting
- Line numbers
- Side-by-side or unified diff
- Customizable themes

## 🌳 Tree View

Display directory structure with file sizes:

```bash
pt tree

myproject
├── src/
│   ├── main.rs (15.2 KB)
│   └── lib.rs (8.5 KB)
├── Cargo.toml (245 B)
└── README.md (3.1 KB)

2 directories, 4 files, 27.0 KB total
```

### Gitignore Support
Tree view respects `.gitignore` patterns automatically.

### Exceptions
Exclude specific files/directories:
```bash
pt tree -e node_modules,.git,target
```

## 🔒 Security Features

1. **Path Validation**
   - Blocks path traversal (`..`)
   - Prevents system directory writes
   - Filename length limits

2. **Size Limits**
   - Configurable max clipboard size
   - File size validation before operations

3. **Backup Limits**
   - Automatic cleanup of old backups
   - Configurable retention count

## 🚦 Exit Codes

- `0` - Success
- `1` - Error (with descriptive message)

## 🐛 Troubleshooting

### Clipboard Access Issues

**Linux**: Install xclip or xsel
```bash
sudo apt-get install xclip
# or
sudo apt-get install xsel
```

**macOS**: Should work out of the box

**Windows**: Should work out of the box

### Delta Not Found

Install delta for diff functionality:
```bash
cargo install git-delta
```

### Permission Denied

Check write permissions:
```bash
ls -la .
chmod u+w filename.txt
```

## 📊 Examples

### Daily Workflow

```bash
# Morning: Start notes
pt notes.txt -m "Daily standup notes"

# Throughout day: Append updates
pt append notes.txt -m "Meeting outcome"
pt append notes.txt -m "Action items"

# Review changes
pt diff notes.txt --last

# If needed, restore previous version
pt list notes.txt
pt restore notes.txt

# End of day: Archive
mv notes.txt archive/notes_$(date +%Y%m%d).txt
```

### Code Snippets

```bash
# Quick code snippet storage
pt snippets/query.sql -m "User analytics query"
pt snippets/script.sh -m "Deployment script v1"

# Later: Review and compare
pt list snippets/query.sql
pt diff snippets/query.sql
```

### Project Documentation

```bash
# Save clipboard content to docs
pt docs/api.md -c -m "API documentation update"

# Tree view of docs
pt tree docs

# Restore if needed
pt restore docs/api.md --last
```

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Hadi Cahyadi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 💻 Author

[**Hadi Cahyadi**](mailto:cumulus13@gmail.com)

- GitHub: [@cumulus13](https://github.com/cumulus13)
- Email: cumulus13@gmail.com

**Made with ❤️ by Hadi Cahyadi**

*Your complete file version management system with contextual history in a single command.* ⚡

If you find PT useful, consider supporting its development and please consider giving it a star on GitHub! ⭐:

[![Buy Me a Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/cumulus13)

[![Donate via Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/cumulus13)
 
[Support me on Patreon](https://www.patreon.com/cumulus13)


## 🙏 Acknowledgments

- [clipboard](https://github.com/quininer/clipboard) - Clipboard access
- [clap](https://github.com/clap-rs/clap) - CLI argument parsing
- [delta](https://github.com/dandavison/delta) - Beautiful diffs
- [walkdir](https://github.com/BurntSushi/walkdir) - Directory traversal

## 📞 Support

- Issues: [GitHub Issues](https://github.com/cumulus13/pt/issues)
- Discussions: [GitHub Discussions](https://github.com/cumulus13/pt/discussions)


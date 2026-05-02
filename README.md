# shellscript-lib

## Installation

You can install shellscript-lib using various methods:

### Git Clone

Clone the repository using Git:
```bash
git clone https://github.com/tiagofrancafernandes/shellscript-lib.git
```

### curl

Use curl to download the script directly:
```bash
curl -O https://raw.githubusercontent.com/tiagofrancafernandes/shellscript-lib/main/shellscript-lib.sh
```

### wget

If you prefer wget, you can download it using:
```bash
wget https://raw.githubusercontent.com/tiagofrancafernandes/shellscript-lib/main/shellscript-lib.sh
```

## Usage Examples

Once you have installed shellscript-lib, you can use the functions as follows:

```bash
# Example 1: function_name
function_name arg1 arg2

# Example 2: another_function
another_function
```

## Function Categories

The functions in this library are organized into the following categories:

- **Network Utilities**
- **File Management**
- **System Monitoring**
- **Text Processing**

### Network Utilities
Example function: `ping_server`
```bash
ping_server example.com
```

### File Management
Example function: `backup_file`
```bash
backup_file /path/to/file
```

### System Monitoring
Example function: `check_cpu`
```bash
check_cpu
```

### Text Processing
Example function: `word_count`
```bash
word_count /path/to/textfile.txt
```

## Setup Instructions for Shell Configuration Files

To make the functions available in your terminal sessions, add the following line to your shell configuration files depending on your shell:

### .bashrc

Add the following line to your `~/.bashrc`:
```bash
source /path/to/shellscript-lib.sh
```

### .zshrc

For Zsh users, add this line to your `~/.zshrc`:
```bash
source /path/to/shellscript-lib.sh
```

### .bash_aliases

If you use a `~/.bash_aliases` file, add:
```bash
source /path/to/shellscript-lib.sh
```
```

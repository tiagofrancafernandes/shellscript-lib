# Shell Script Library (lib.sh)

A comprehensive collection of reusable shell functions with VSCode snippets for professional shell scripting. All functions are prefixed with `fn__` to avoid conflicts with native shell commands.

## Features

- **Variable Validation** - Check if variables are set, empty, or have values
- **Type Checking** - Validate integers, floats, numeric values, and strings
- **String Operations** - 20+ string manipulation functions
- **Boolean Conversion** - Convert any value to boolean (t/f, 0/1, true/false, or custom)
- **File/Path Operations** - Check files, directories, get paths
- **Logging Functions** - Info, warning, error, debug, and success logging
- **Date/Time Functions** - Multiple format options (ISO 8601, Brazil, USA, Unix timestamp)
- **Utility Functions** - Color output, separators, script metadata

## Compatibility

- **Bash** versions 3.2+
- **POSIX sh** (most functions with `-safe` or `-posix` suffix)
- **Zsh** (with Bash emulation)
- **macOS** and **Linux**

## Installation

### Option 1: Clone the Repository

```bash
git clone https://github.com/tiagofrancafernandes/shellscript-lib.git
cd shellscript-lib
source ./lib.sh
```

### Option 2: Download with cURL

```bash
curl -fsSL https://raw.githubusercontent.com/tiagofrancafernandes/shellscript-lib/main/lib.sh -o lib.sh
chmod +x lib.sh
source ./lib.sh
```

### Option 3: Download with wget

```bash
wget https://raw.githubusercontent.com/tiagofrancafernandes/shellscript-lib/main/lib.sh
chmod +x lib.sh
source ./lib.sh
```

## Quick Setup in Shell Configuration Files

### For Bash (.bashrc)

Add this line to your `~/.bashrc`:

```bash
source /path/to/lib.sh
```

Then reload your shell:

```bash
source ~/.bashrc
```

### For Zsh (.zshrc)

Add this line to your `~/.zshrc`:

```bash
source /path/to/lib.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

### For Bash Aliases (.bash_aliases)

Create or edit `~/.bash_aliases`:

```bash
# Source the shell script library
if [ -f /path/to/lib.sh ]; then
    source /path/to/lib.sh
fi
```

Then add to your `.bashrc`:

```bash
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

### Example: Global Installation

If you want to use the library globally:

```bash
# Download the library
mkdir -p ~/.local/lib
wget https://raw.githubusercontent.com/tiagofrancafernandes/shellscript-lib/main/lib.sh -O ~/.local/lib/lib.sh
chmod +x ~/.local/lib/lib.sh

# Add to ~/.bashrc or ~/.zshrc
echo 'source ~/.local/lib/lib.sh' >> ~/.bashrc
source ~/.bashrc
```

## Usage Examples

### Variable Validation

```bash
#!/bin/bash
source ./lib.sh

# Check if variable is set
if fn__is_set MY_VAR; then
    fn__log_info "MY_VAR is set"
fi

# Require variable or fail
fn__require_var MY_VAR

# Get variable with default
value=$(fn__get_var_default MY_VAR "default_value")
```

### Type Checking

```bash
# Check if value is integer
if fn__is_int "123"; then
    fn__log_info "Value is an integer"
fi

# Check if value is numeric (int or float)
if fn__is_numeric "3.14"; then
    fn__log_success "Value is numeric"
fi

# Check if value is string (not numeric)
if fn__is_string_strict "hello"; then
    fn__log_info "Value is a string"
fi
```

### String Operations

```bash
# String length
len=$(fn__strlen "hello world")
echo "Length: $len"

# Check if string contains substring
if fn__str_includes "hello world" "world"; then
    fn__log_info "String contains 'world'"
fi

# Check if string starts with prefix
if fn__str_starts_with "hello" "hel"; then
    fn__log_info "Starts with 'hel'"
fi

# Replace text
result=$(fn__str_replace "hello world" "world" "universe")
echo "$result"  # hello universe

# Convert to uppercase
upper=$(fn__str_to_upper "hello")
echo "$upper"  # HELLO

# Trim whitespace
trimmed=$(fn__str_trim "  hello  ")
echo "'$trimmed'"  # 'hello'

# Split string into array
fn__str_split "apple,banana,orange" "," fruits
for fruit in "${fruits[@]}"; do
    echo "- $fruit"
done
```

### Boolean Conversion

```bash
# Convert any value to boolean (t/f)
result=$(fn__to_bool "yes")
echo "$result"  # t

result=$(fn__to_bool "no")
echo "$result"  # f

# Convert to boolean integer (1/0)
result=$(fn__to_bool_int "true")
echo "$result"  # 1

# Convert to boolean string
result=$(fn__to_bool_str "1")
echo "$result"  # true

# Custom boolean representation
result=$(fn__to_bool_as "yes" "enabled" "disabled")
echo "$result"  # enabled

# Check if true/false
if fn__is_true "yes"; then
    fn__log_info "Value is true"
fi
```

### File Operations

```bash
# Check if file exists
if fn__is_file "/etc/passwd"; then
    fn__log_info "File exists"
fi

# Check if directory exists
if fn__is_dir "/home"; then
    fn__log_info "Directory exists"
fi

# Get absolute path
abs=$(fn__abs_path "./config.sh")
echo "$abs"

# Source file with error handling
fn__source_if_exists "/path/to/config.sh" "true"
```

### Logging

```bash
# Different log levels
fn__log_info "This is an info message"
fn__log_warn "This is a warning"
fn__log_error "This is an error"
fn__log_success "Operation completed successfully"

# Debug logging (only if DEBUG=true)
DEBUG=true fn__log_debug "Debug information"
```

### Date/Time Operations

```bash
# ISO 8601 formats
iso=$(fn__date_iso)              # 2026-05-02T10:30:45
iso_tz=$(fn__date_iso_tz)        # 2026-05-02T10:30:45-03:00

# Brazil format (DD/MM/YYYY HH:mm)
br=$(fn__date_fmt_brazil)        # 02/05/2026 10:30
br_date=$(fn__date_fmt_brazil_date)  # 02/05/2026
br_time=$(fn__date_fmt_brazil_time)  # 10:30

# USA format (MM/DD/YYYY HH:mm AM/PM)
usa=$(fn__date_fmt_eua)          # 05/02/2026 10:30 AM
usa_date=$(fn__date_fmt_eua_date)  # 05/02/2026
usa_time=$(fn__date_fmt_eua_time)  # 10:30 AM

# Unix timestamp
unix=$(fn__date_unix_time)       # 1746086445

# Convert Unix timestamp
iso=$(fn__date_unix_to_iso "1746086445")
br=$(fn__date_unix_to_brazil "1746086445")
```

### Custom Boolean Representations

```bash
# Check command output as boolean
RESULT=$(some_command)

if fn__is_true "$RESULT" "success" "failure"; then
    fn__log_success "Command succeeded"
fi

# Convert between representations
# 0=false, 1=true (common in scripts)
enabled=$(fn__to_bool_as "yes" "1" "0")

# yes/no representation
answer=$(fn__to_bool_as "true" "yes" "no")

# On/Off representation
status=$(fn__to_bool_as "1" "On" "Off")
```

## Function Categories

### Variable Validation
- `fn__is_set` - Check if variable is set
- `fn__is_empty` - Check if variable is empty
- `fn__is_not_empty` - Check if variable has value
- `fn__require_var` - Require variable or fail
- `fn__get_var_default` - Get variable with default value
- `fn__set_var_default` - Set default value if empty
- `fn__set_var_if_unset` - Set value only if unset

### Type Checking
- `fn__is_int` / `fn__is_int_safe` - Check if integer
- `fn__is_numeric` / `fn__is_numeric_safe` - Check if numeric (int or float)
- `fn__is_float` / `fn__is_float_safe` - Check if float
- `fn__is_string` / `fn__is_string_strict` - Check if string

### File/Path Operations
- `fn__is_file` - Check if file exists
- `fn__is_dir` - Check if directory exists
- `fn__path_exists` - Check if path exists
- `fn__abs_path` - Get absolute path
- `fn__dir_path` - Get directory path
- `fn__base_name` - Get base filename
- `fn__source_if_exists` - Source file with error handling

### String Operations
- `fn__strlen` - Get string length
- `fn__str_includes` - Check if contains substring
- `fn__str_starts_with` - Check if starts with prefix
- `fn__str_ends_with` - Check if ends with suffix
- `fn__str_replace` - Replace all occurrences
- `fn__str_replace_first` - Replace first occurrence
- `fn__str_to_lower` - Convert to lowercase
- `fn__str_to_upper` - Convert to uppercase
- `fn__substr` - Extract substring
- `fn__str_pad` / `fn__str_pad_left` - Pad string
- `fn__str_trim` - Trim whitespace
- `fn__str_repeat` - Repeat string
- `fn__str_split` - Split string into array
- `fn__str_join` - Join array with delimiter
- `fn__str_reverse` - Reverse string

### Boolean Functions
- `fn__to_bool` - Convert to boolean (t/f)
- `fn__to_bool_int` - Convert to boolean (1/0)
- `fn__to_bool_str` - Convert to boolean (true/false)
- `fn__to_bool_as` - Convert to custom boolean
- `fn__is_true` - Check if true
- `fn__is_false` - Check if false

### Logging
- `fn__log_info` - Log info message
- `fn__log_warn` - Log warning message
- `fn__log_error` - Log error message
- `fn__log_debug` - Log debug message
- `fn__log_success` - Log success message

### Date/Time
- `fn__date_fmt` - Format date
- `fn__date_iso` - ISO 8601 format
- `fn__date_iso_tz` - ISO 8601 with timezone
- `fn__date_fmt_brazil` - Brazil format
- `fn__date_fmt_eua` - USA format
- `fn__date_unix_time` - Unix timestamp
- `fn__date_microtime` - Timestamp with milliseconds
- `fn__date_unix_to_iso` - Convert Unix to ISO
- `fn__date_unix_to_brazil` - Convert Unix to Brazil format

### Utility
- `fn__print_separator` - Print separator line
- `fn__print_color` - Print colored text
- `fn__script_dir` - Get script directory
- `fn__script_name` - Get script name
- `fn__is_interactive` - Check if interactive shell
- `fn__is_tty` - Check if TTY

## VSCode Snippets

The repository includes [`bash-and-shellscript-snippets.code-snippets`](./bash-and-shellscript-snippets.code-snippets) with snippets for some functions. Import these snippets into VSCode for quick access.

### Installation in VSCode

1. Open VSCode
2. Go to `File → Preferences → Configure Snippets` or `CTRL+SHIFT+P → Snippets: Configure Snippets`
3. Type `global` and select your shellscript snippets (if exists) or create a new selecting `New Global Snippets File...`
4. Copy the contents of [`bash-and-shellscript-snippets.code-snippets`](./bash-and-shellscript-snippets.code-snippets) into the file
5. Start typing `bash:` or function names to see suggestions

### Usage

Type `bash:isset`, `str_includes`, `is_int`, etc., and VSCode will auto-complete with the full function call.

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new functions
- Improve documentation
- Optimize existing functions

## License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

## Author

Created by [tiagofrancafernandes](https://github.com/tiagofrancafernandes)

## Version History

- **v1.0.0** (2026-05-02) - Initial release
  - 70+ utility functions
  - Full POSIX-safe versions
  - Comprehensive documentation
  - VSCode snippets included

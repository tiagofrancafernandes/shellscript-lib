# Shell Script Library

## Utility Functions

### Variable Validation

fn__is_empty() {
    # Check if a variable is empty
    [ -z "$1" ]
}

fn__is_not_empty() {
    # Check if a variable is not empty
    [ -n "$1" ]
}

### Type Checking

fn__is_string() {
    # Check if a variable is a string
    [ "$1" = "$1" ]
}

fn__is_integer() {
    # Check if a variable is an integer
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

fn__is_array() {
    # Check if a variable is an array
    [ "$1" = "" ]
}

### File Operations

fn__file_exists() {
    # Check if a file exists
    [ -e "$1" ]
}

fn__is_readable() {
    # Check if a file is readable
    [ -r "$1" ]
}

fn__is_writable() {
    # Check if a file is writable
    [ -w "$1" ]
}

### String Manipulation

fn__string_contains() {
    # Check if string contains a substring
    [[ "$1" == *"$2"* ]]
}

fn__string_length() {
    # Get the length of a string
    echo -n "$1" | wc -c
}

fn__string_replace() {
    # Replace a substring in a string
    echo "$1" | sed "s/$2/$3/g"
}

### Boolean Conversion

fn__to_bool() {
    # Convert a string to a boolean value
    [[ "$1" =~ ^(yes|true|1)$ ]]
}

### Logging

fn__log_info() {
    # Log information messages
    echo "[INFO] [$0] [$1] $(date 'UTC')"
}

fn__log_error() {
    # Log error messages
    echo "[ERROR] [$0] [$1] $(date 'UTC')"
}

### Date/Time Functions

fn__current_datetime() {
    # Get the current date and time in UTC
    date -u '+%Y-%m-%d %H:%M:%S'
}
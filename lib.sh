#!/bin/bash
################################################################################
## Shell Script Function Library (lib.sh)
## A comprehensive collection of utility functions with fn__ prefix
#
## Usage:
##   source ./lib.sh
#   fn__is_int "123"
##   fn__str_includes "hello world" "world"
#
## Author: Your Name
# Version: 1.0.0
################################################################################

## Strict mode
SHELL_SCRIPT_LIBRARY_STRICT_MODE_ON="${SHELL_SCRIPT_LIBRARY_STRICT_MODE_ON:-true}"

if [[ "$SHELL_SCRIPT_LIBRARY_STRICT_MODE_ON" =~ ^(yes|true|1|on|t|y|1|enabled|enable)$ ]]; then
set -euo pipefail
fi

IFS=$'\n\t'

################################################################################
#### [BEGIN OF] WIP FUNCTIONS
### Type Checking

## [WIP] Check if a variable is an integer
fn__is_integer() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

### File Operations

## [WIP] Check if a file exists
fn__file_exists() {
    [ -e "$1" ]
}

## [WIP] Check if a file is readable
fn__is_readable() {
    [ -r "$1" ]
}

## [WIP] Check if a file is writable
fn__is_writable() {
    [ -w "$1" ]
}

### String Manipulation

## [WIP] Check if string contains a substring
fn__string_contains() {
    [[ "$1" == *"$2"* ]]
}

## [WIP] Get the length of a string
fn__string_length() {
    echo -n "$1" | wc -c
}

## [WIP] Replace a substring in a string
fn__string_replace() {
    echo "$1" | sed "s/$2/$3/g"
}

## Check if command exists
fn__command_exists() {
    command -v "$1" > /dev/null 2>&1
}

### Usage
# if fn__command_exists code; then
#     code --locate-shell-integration-path zsh
# fi

#### [END OF] WIP FUNCTIONS
################################################################################

################################################################################
## VARIABLE VALIDATION FUNCTIONS
################################################################################

## Check if variable exists
fn__is_set() {
    local var="${1:?Variable name required}"
    [ -n "${!var+x}" ] 2>/dev/null || return 1
}

## Check if variable exists (Bash only, uses -v)
fn__isset_bash() {
    local var="${1:?Variable name required}"
    [ -v "$var" ] 2>/dev/null || return 1
}

## Check if variable is empty or unset
fn__is_empty() {
    local var="${1:?Variable name required}"
    [ -z "${!var:-}" ]
}

## Check if variable has value
fn__is_not_empty() {
    local var="${1:?Variable name required}"
    [ -n "${!var:-}" ]
}

## Require variable (fail if unset or empty)
fn__require_var() {
    local var="${1:?Variable name required}"
    [ -n "${!var:-}" ] || {
        echo "[ERROR] Variable '$var' is required" >&2
        return 1
    }
}

## Get variable with default value
fn__get_var_default() {
    local var="${1:?Variable name required}"
    local default="${2:-}"
    echo "${!var:-$default}"
}

## Assign default if unset or empty
fn__set_var_default() {
    local var="${1:?Variable name required}"
    local default="${2:-}"
    eval "$var=\"\${!var:-$default}\""
}

## Assign only if unset
fn__set_var_if_unset() {
    local var="${1:?Variable name required}"
    local default="${2:-}"
    eval "$var=\"\${!var-$default}\""
}

################################################################################
## TYPE CHECKING FUNCTIONS
################################################################################

## Check if variable is integer
fn__is_int() {
    local value="${1:?Value required}"
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

## Check if variable is integer (POSIX-safe)
fn__is_int_safe() {
    local value="${1:?Value required}"
    echo "$value" | grep -Eq '^-?[0-9]+$'
}

## Alias for POSIX version
fn__is_int_posix() {
    fn__is_int_safe "$@"
}

## Check if variable is numeric (int or float)
fn__is_numeric() {
    local value="${1:?Value required}"
    [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

## Check if variable is numeric (POSIX-safe)
fn__is_numeric_safe() {
    local value="${1:?Value required}"
    echo "$value" | grep -Eq '^-?[0-9]+(\.[0-9]+)?$'
}

## Alias for POSIX version
fn__is_numeric_posix() {
    fn__is_numeric_safe "$@"
}

## Check if variable is float
fn__is_float() {
    local value="${1:?Value required}"
    [[ "$value" =~ ^-?[0-9]+\.[0-9]+$ ]]
}

## Check if variable is float (POSIX-safe)
fn__is_float_safe() {
    local value="${1:?Value required}"
    echo "$value" | grep -Eq '^-?[0-9]+\.[0-9]+$'
}

## Alias for POSIX version
fn__is_float_posix() {
    fn__is_float_safe "$@"
}

## Check if variable is non-empty string
fn__is_string() {
    local value="${1:?Value required}"
    [ -n "$value" ]
}

## Check if variable is non-empty and not numeric
fn__is_string_strict() {
    local value="${1:?Value required}"
    [ -n "$value" ] && ! echo "$value" | grep -Eq '^-?[0-9]+(\.[0-9]+)?$'
}

################################################################################
## FILE/PATH FUNCTIONS
################################################################################

## Check if file exists
fn__is_file() {
    local path="${1:?Path required}"
    [ -f "$path" ]
}

## Check if directory exists
fn__is_dir() {
    local path="${1:?Path required}"
    [ -d "$path" ]
}

## Check if path exists (file or directory)
fn__path_exists() {
    local path="${1:?Path required}"
    [ -e "$path" ]
}

## Get absolute path
fn__abs_path() {
    local path="${1:?Path required}"
    cd "$(dirname "$path")" || return 1
    echo "$(pwd)/$(basename "$path")"
}

## Get directory path
fn__dir_path() {
    local path="${1:?Path required}"
    cd "$(dirname "$path")" || return 1
    pwd
}

## Get base filename
fn__base_name() {
    local path="${1:?Path required}"
    basename "$path"
}

## Source file if exists
fn__source_if_exists() {
    local file="${1:?File path required}"
    local throw_if_fail="${2:-false}"

    if [ -f "$file" ]; then
        source "$file" || {
            local exit_code=$?
            if fn__to_bool "$throw_if_fail" > /dev/null 2>&1; then
                echo "[ERROR] Failed to source file: $file" >&2
                return $exit_code
            fi
            return 1
        }
        return 0
    else
        if fn__to_bool "$throw_if_fail" > /dev/null 2>&1; then
            echo "[ERROR] File not found: $file" >&2
            return 1
        fi
        return 1
    fi
}

################################################################################
## STRING FUNCTIONS
################################################################################

## Get string length
fn__strlen() {
    local str="${1:?String required}"
    echo ${#str}
}

## Check if string contains substring
fn__str_includes() {
    local haystack="${1:?Haystack required}"
    local needle="${2:?Needle required}"
    [[ "$haystack" == *"$needle"* ]]
}

## Check if string contains substring (POSIX-safe)
fn__str_includes_safe() {
    local haystack="${1:?Haystack required}"
    local needle="${2:?Needle required}"
    echo "$haystack" | grep -q "$needle"
}

## Alias for POSIX version
fn__str_includes_posix() {
    fn__str_includes_safe "$@"
}

## Check if string contains substring (case-insensitive)
fn__str_includes_i() {
    local haystack="${1:?Haystack required}"
    local needle="${2:?Needle required}"
    [[ "${haystack,,}" == *"${needle,,}"* ]]
}

## Check if string starts with prefix
fn__str_starts_with() {
    local haystack="${1:?Haystack required}"
    local prefix="${2:?Prefix required}"
    [[ "$haystack" == "$prefix"* ]]
}

## Check if string starts with prefix (POSIX-safe)
fn__str_starts_with_safe() {
    local haystack="${1:?Haystack required}"
    local prefix="${2:?Prefix required}"
    echo "$haystack" | grep -q "^$(printf '%s\n' "$prefix" | sed 's/[[\.*^$/]/\\&/g')"
}

## Alias for POSIX version
fn__str_starts_with_posix() {
    fn__str_starts_with_safe "$@"
}

## Check if string ends with suffix
fn__str_ends_with() {
    local haystack="${1:?Haystack required}"
    local suffix="${2:?Suffix required}"
    [[ "$haystack" == *"$suffix" ]]
}

## Check if string ends with suffix (POSIX-safe)
fn__str_ends_with_safe() {
    local haystack="${1:?Haystack required}"
    local suffix="${2:?Suffix required}"
    echo "$haystack" | grep -q "$(printf '%s\n' "$suffix" | sed 's/[[\.*^$/]/\\&/g')$"
}

## Alias for POSIX version
fn__str_ends_with_posix() {
    fn__str_ends_with_safe "$@"
}

## Replace all occurrences (Bash only)
fn__str_replace() {
    local haystack="${1:?Haystack required}"
    local search="${2:?Search string required}"
    local replace="${3:-}"
    echo "${haystack//${search}/${replace}}"
}

## Replace all occurrences (POSIX-safe)
fn__str_replace_safe() {
    local haystack="${1:?Haystack required}"
    local search="${2:?Search string required}"
    local replace="${3:-}"
    echo "$haystack" | sed "s|$(printf '%s\n' "$search" | sed 's/[&/\]/\\&/g')|$(printf '%s\n' "$replace" | sed 's/[&/\]/\\&/g')|g"
}

## Alias for POSIX version
fn__str_replace_posix() {
    fn__str_replace_safe "$@"
}

## Replace first occurrence (Bash only)
fn__str_replace_first() {
    local haystack="${1:?Haystack required}"
    local search="${2:?Search string required}"
    local replace="${3:-}"
    echo "${haystack/${search}/${replace}}"
}

## Replace first occurrence (POSIX-safe)
fn__str_replace_first_safe() {
    local haystack="${1:?Haystack required}"
    local search="${2:?Search string required}"
    local replace="${3:-}"
    echo "$haystack" | sed "s|$(printf '%s\n' "$search" | sed 's/[&/\]/\\&/g')|$(printf '%s\n' "$replace" | sed 's/[&/\]/\\&/g')|"
}

## Alias for POSIX version
fn__str_replace_first_posix() {
    fn__str_replace_first_safe "$@"
}

## Convert string to lowercase (Bash 4+)
fn__str_to_lower() {
    local str="${1:?String required}"
    echo "${str,,}"
}

## Convert string to lowercase (POSIX-safe)
fn__str_to_lower_safe() {
    local str="${1:?String required}"
    echo "$str" | tr '[:upper:]' '[:lower:]'
}

## Alias for POSIX version
fn__str_to_lower_posix() {
    fn__str_to_lower_safe "$@"
}

## Convert string to uppercase (Bash 4+)
fn__str_to_upper() {
    local str="${1:?String required}"
    echo "${str^^}"
}

## Convert string to uppercase (POSIX-safe)
fn__str_to_upper_safe() {
    local str="${1:?String required}"
    echo "$str" | tr '[:lower:]' '[:upper:]'
}

## Alias for POSIX version
fn__str_to_upper_posix() {
    fn__str_to_upper_safe "$@"
}

## Extract substring
fn__substr() {
    local str="${1:?String required}"
    local start="${2:?Start position required}"
    local length="${3:-}"
    if [ -z "$length" ]; then
        echo "${str:$start}"
    else
        echo "${str:$start:$length}"
    fi
}

## Extract substring (POSIX-safe)
fn__substr_safe() {
    local str="${1:?String required}"
    local start="${2:?Start position required}"
    local length="${3:-}"

    if [ -z "$length" ]; then
        echo "$str" | cut -c$((start + 1))-
    else
        echo "$str" | cut -c$((start + 1))-$((start + length))
    fi
}

## Pad string (left-aligned)
fn__str_pad() {
    local str="${1:?String required}"
    local width="${2:?Width required}"
    printf "%-${width}s" "$str"
}

## Pad string (right-aligned)
fn__str_pad_left() {
    local str="${1:?String required}"
    local width="${2:?Width required}"
    printf "%${width}s" "$str"
}

## Trim whitespace from both ends
fn__str_trim() {
    local str="${1:?String required}"
    echo -n "$str" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

## Trim whitespace from start
fn__str_trim_start() {
    local str="${1:?String required}"
    echo -n "$str" | sed 's/^[[:space:]]*//'
}

## Trim whitespace from end
fn__str_trim_end() {
    local str="${1:?String required}"
    echo -n "$str" | sed 's/[[:space:]]*$//'
}

## Repeat string n times
fn__str_repeat() {
    local str="${1:?String required}"
    local count="${2:?Count required}"
    printf '%*s\n' $((count * ${#str})) | tr ' ' "$str" | head -c $((count * ${#str}))
}

## Split string into array
fn__str_split() {
    local str="${1:?String required}"
    local delimiter="${2:?Delimiter required}"
    local -n array_ref="${3:?Array name required}"

    IFS="$delimiter" read -ra array_ref <<< "$str"
}

## Join array with delimiter
fn__str_join() {
    local delimiter="${1:?Delimiter required}"
    local -n array_ref="${2:?Array name required}"
    local IFS="$delimiter"
    echo "${array_ref[*]}"
}

## Reverse string
fn__str_reverse() {
    local str="${1:?String required}"
    echo "$str" | rev
}

################################################################################
## BOOLEAN/EVALUATION FUNCTIONS
################################################################################

## Convert value to boolean (returns 't' or 'f')
## Recognizes: true, yes, on, 1, t, y (any positive number) as TRUE
# Recognizes: false, no, off, 0, f, n, null, undefined, NaN as FALSE

fn__check_common_true() {
    [[ "$1" =~ ^(yes|true|1|on|t|y|1|enabled|enable)$ ]]
}

fn__to_bool() {
    local value="${1:-false}"
    local value_lower

    value_lower=$(fn__str_to_lower_safe "$value")

    case "$value_lower" in
        'true'|'yes'|'on'|'t'|'y'|'1'|'enabled'|'enable')
            echo 't'
            return 0
            ;;
        'false'|'no'|'off'|'f'|'n'|'0'|'null'|'undefined'|'nan'|'disabled'|'disable'|'')
            echo 'f'
            return 0
            ;;
        *)
            # Check if it's a number
            if fn__is_numeric_safe "$value" 2>/dev/null; then
                # Non-zero numbers are true
                [ "$value" -ne 0 ] 2>/dev/null && echo 't' || echo 'f'
            else
                # Non-recognized values are true
                echo 't'
            fi
            ;;
    esac
}

## Convert value to boolean integer (returns 1 or 0)
fn__to_bool_int() {
    local value="${1:-false}"
    case "$(fn__to_bool "$value")" in
        't') echo 1 ;;
        'f') echo 0 ;;
    esac
}

## Convert value to boolean string (returns 'true' or 'false')
fn__to_bool_str() {
    local value="${1:-false}"
    case "$(fn__to_bool "$value")" in
        't') echo 'true' ;;
        'f') echo 'false' ;;
    esac
}

## Convert value to custom boolean representation
# fn__to_bool_as "value" "true_representation" "false_representation"
fn__to_bool_as() {
    local value="${1:-false}"
    local true_repr="${2:-true}"
    local false_repr="${3:-false}"

    case "$(fn__to_bool "$value")" in
        't') echo "$true_repr" ;;
        'f') echo "$false_repr" ;;
    esac
}

## Check if value is true
# fn__is_true "value" [true_repr] [false_repr]
fn__is_true() {
    local value="${1:?Value required}"
    local true_repr="${2:-t}"
    local false_repr="${3:-f}"

    result=$(fn__to_bool_as "$value" "$true_repr" "$false_repr")
    [ "$result" = "$true_repr" ]
}

## Check if value is false
# fn__is_false "value" [true_repr] [false_repr]
fn__is_false() {
    local value="${1:?Value required}"
    local true_repr="${2:-t}"
    local false_repr="${3:-f}"

    result=$(fn__to_bool_as "$value" "$true_repr" "$false_repr")
    [ "$result" = "$false_repr" ]
}

## Alias
fn__is_true_value() {
    fn__is_true "$@"
}

## Alias
fn__is_false_value() {
    fn__is_false "$@"
}

################################################################################
## LOGGING FUNCTIONS
################################################################################

## Log info message to stdout (each param in a new line)
fn__log_info() {
    printf "[INFO] %s\n" $@
}

## Log info message to stdout (all args in same line)
fn__log_info_one_line() {
    fn__log_info "$*"
}

## Log warning message to stdout (each param in a new line)
fn__log_warn() {
    printf "[WARN] %s\n" $@ >&2
}

## Log warning message to stdout (all args in same line)
fn__log_warn_one_line() {
    fn__log_warn "$*"
}

## Log error message to stderr (each param in a new line)
fn__log_error() {
    printf "[ERROR] %s\n" $@ >&2
}

## Log error message to stderr (all args in same line)
fn__log_error_one_line() {
    fn__log_error "$*"
}

## Log success message (each param in a new line)
fn__log_success() {
    printf "[SUCCESS] %s\n" $@
}

## Log success message (all args in same line)
fn__log_success_one_line() {
    fn__log_success "$*"
}

## Log debug message (each param in a new line) (only if DEBUG is true)
fn__log_debug() {
    if fn__is_true "${DEBUG:-false}"; then
        printf "[DEBUG] %s\n" $@ >&2
    fi
}

## Log debug message (only if DEBUG is true) (all args in same line)
fn__log_debug_one_line() {
    fn__log_debug "$*"
}

################################################################################
## DATE/TIME FUNCTIONS
################################################################################

## Format date using date command format
fn__date_fmt() {
    local fmt="${1:?Format required}"
    date +"$fmt"
}

## Get date in ISO 8601 format (YYYY-MM-DDTHH:MM:SS)
fn__date_fmt_iso() {
    date +'%Y-%m-%dT%H:%M:%S'
}

## Alias
fn__date_iso() {
    fn__date_fmt_iso
}

## Get date in ISO 8601 format with timezone (YYYY-MM-DDTHH:mm:ss±hh:mm)
fn__date_fmt_iso_tz() {
    date +'%Y-%m-%dT%H:%M:%S%z' | sed 's/\([+-]\)\([0-9]{2}\)\([0-9]{2}\)/\1\2:\3/'
}

## Alias
fn__date_iso_tz() {
    fn__date_fmt_iso_tz
}

## Alias
fn__date_iso_full() {
    fn__date_fmt_iso_tz
}

## Alias
fn__date_with_tz() {
    fn__date_fmt_iso_tz
}

## Brazil format: DD/MM/YYYY HH:mm (24h)
fn__date_fmt_brazil() {
    date +'%d/%m/%Y %H:%M'
}

## Brazil date only: DD/MM/YYYY
fn__date_fmt_brazil_date() {
    date +'%d/%m/%Y'
}

## Brazil time only: HH:mm (24h)
fn__date_fmt_brazil_time() {
    date +'%H:%M'
}

## Brazil time full: HH:mm:ss (24h)
fn__date_fmt_brazil_time_full() {
    date +'%H:%M:%S'
}

## Brazil full: DD/MM/YYYY HH:mm:ss Z (24h with timezone)
fn__date_fmt_brazil_full() {
    date +'%d/%m/%Y %H:%M:%S %Z'
}

## USA format: MM/DD/YYYY HH:mm (12h with AM/PM)
fn__date_fmt_eua() {
    date +'%m/%d/%Y %I:%M %p'
}

## USA date only: MM/DD/YYYY
fn__date_fmt_eua_date() {
    date +'%m/%d/%Y'
}

## USA time only: HH:mm (12h with AM/PM)
fn__date_fmt_eua_time() {
    date +'%I:%M %p'
}

## USA time full: HH:mm:ss (12h with AM/PM)
fn__date_fmt_eua_time_full() {
    date +'%I:%M:%S %p'
}

## USA full: MM/DD/YYYY HH:mm:ss Z (12h with AM/PM and timezone)
fn__date_fmt_eua_full() {
    date +'%m/%d/%Y %I:%M:%S %p %Z'
}

## Get Unix timestamp (seconds since epoch)
fn__date_unix_time() {
    date +'%s'
}

## Alias
fn__date_unix() {
    fn__date_unix_time
}

## Alias
fn__date_time() {
    fn__date_unix_time
}

## Get current time with milliseconds (Unix timestamp in milliseconds)
fn__date_microtime() {
    local unix_time
    unix_time=$(date +'%s')
    local millis
    millis=$(date +'%N' | cut -c1-3)
    echo "${unix_time}${millis}"
}

## Convert Unix timestamp to ISO 8601 format
fn__date_unix_to_iso() {
    local timestamp="${1:?Timestamp required}"
    date -d "@$timestamp" +'%Y-%m-%dT%H:%M:%S' 2>/dev/null || date -r "$timestamp" +'%Y-%m-%dT%H:%M:%S'
}

## Convert Unix timestamp to Brazil format
fn__date_unix_to_brazil() {
    local timestamp="${1:?Timestamp required}"
    date -d "@$timestamp" +'%d/%m/%Y %H:%M:%S' 2>/dev/null || date -r "$timestamp" +'%d/%m/%Y %H:%M:%S'
}

## [WIP] Get the current date and time in UTC
fn__current_datetime() {
    date -u '+%Y-%m-%d %H:%M:%S'
}

################################################################################
## UTILITY FUNCTIONS
################################################################################

## Print separator line
fn__print_separator() {
    local char="${1:--}"
    local width="${2:-80}"
    printf "%${width}s\n" | tr ' ' "$char"
}

## Print colored text (requires terminal support)
fn__print_color() {
    local color="${1:?Color name required}"
    local text="${2:?Text required}"

    case "$color" in
        'red')    echo -e "\033[31m$text\033[0m" ;;
        'green')  echo -e "\033[32m$text\033[0m" ;;
        'yellow') echo -e "\033[33m$text\033[0m" ;;
        'blue')   echo -e "\033[34m$text\033[0m" ;;
        'purple') echo -e "\033[35m$text\033[0m" ;;
        'cyan')   echo -e "\033[36m$text\033[0m" ;;
        'white')  echo -e "\033[37m$text\033[0m" ;;
        *)        echo "$text" ;;
    esac
}

## Get script directory
fn__script_dir() {
    cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

## Get script name without extension
fn__script_name() {
    basename "${BASH_SOURCE[0]}" | sed 's/\.[^.]*$//'
}

## Check if running in interactive shell
fn__is_interactive() {
    [ -t 0 ]
}

## Check if running in TTY
fn__is_tty() {
    [ -t 1 ]
}

## Export all functions

export -f fn__is_integer
export -f fn__file_exists
export -f fn__is_readable
export -f fn__is_writable
export -f fn__string_contains
export -f fn__string_length
export -f fn__string_replace
export -f fn__check_common_true

export -f fn__is_set
export -f fn__isset_bash
export -f fn__is_empty
export -f fn__is_not_empty
export -f fn__require_var
export -f fn__get_var_default
export -f fn__set_var_default
export -f fn__set_var_if_unset
export -f fn__is_int
export -f fn__is_int_safe
export -f fn__is_int_posix
export -f fn__is_numeric
export -f fn__is_numeric_safe
export -f fn__is_numeric_posix
export -f fn__is_float
export -f fn__is_float_safe
export -f fn__is_float_posix
export -f fn__is_string
export -f fn__is_string_strict
export -f fn__is_file
export -f fn__is_dir
export -f fn__path_exists
export -f fn__abs_path
export -f fn__dir_path
export -f fn__base_name
export -f fn__source_if_exists
export -f fn__strlen
export -f fn__str_includes
export -f fn__str_includes_safe
export -f fn__str_includes_posix
export -f fn__str_includes_i
export -f fn__str_starts_with
export -f fn__str_starts_with_safe
export -f fn__str_starts_with_posix
export -f fn__str_ends_with
export -f fn__str_ends_with_safe
export -f fn__str_ends_with_posix
export -f fn__str_replace
export -f fn__str_replace_safe
export -f fn__str_replace_posix
export -f fn__str_replace_first
export -f fn__str_replace_first_safe
export -f fn__str_replace_first_posix
export -f fn__str_to_lower
export -f fn__str_to_lower_safe
export -f fn__str_to_lower_posix
export -f fn__str_to_upper
export -f fn__str_to_upper_safe
export -f fn__str_to_upper_posix
export -f fn__substr
export -f fn__substr_safe
export -f fn__str_pad
export -f fn__str_pad_left
export -f fn__str_trim
export -f fn__str_trim_start
export -f fn__str_trim_end
export -f fn__str_repeat
export -f fn__str_split
export -f fn__str_join
export -f fn__str_reverse
export -f fn__to_bool
export -f fn__to_bool_int
export -f fn__to_bool_str
export -f fn__to_bool_as
export -f fn__is_true
export -f fn__is_false
export -f fn__is_true_value
export -f fn__is_false_value
export -f fn__log_info
export -f fn__log_warn
export -f fn__log_error
export -f fn__log_debug
export -f fn__log_info_one_line
export -f fn__log_warn_one_line
export -f fn__log_error_one_line
export -f fn__log_success_one_line
export -f fn__log_debug_one_line
export -f fn__log_success
export -f fn__date_fmt
export -f fn__date_fmt_iso
export -f fn__date_iso
export -f fn__date_fmt_iso_tz
export -f fn__date_iso_tz
export -f fn__date_iso_full
export -f fn__date_with_tz
export -f fn__date_fmt_brazil
export -f fn__date_fmt_brazil_date
export -f fn__date_fmt_brazil_time
export -f fn__date_fmt_brazil_time_full
export -f fn__date_fmt_brazil_full
export -f fn__date_fmt_eua
export -f fn__date_fmt_eua_date
export -f fn__date_fmt_eua_time
export -f fn__date_fmt_eua_time_full
export -f fn__date_fmt_eua_full
export -f fn__date_unix_time
export -f fn__date_unix
export -f fn__date_time
export -f fn__date_microtime
export -f fn__date_unix_to_iso
export -f fn__date_unix_to_brazil
export -f fn__print_separator
export -f fn__print_color
export -f fn__script_dir
export -f fn__script_name
export -f fn__is_interactive
export -f fn__is_tty

################################################################################
## END OF lib.sh
################################################################################

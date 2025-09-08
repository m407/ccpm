# Comprehensive Guide to Using ast-grep

## Table of Contents
1. [Introduction to ast-grep](#introduction-to-ast-grep)
2. [Basic Usage](#basic-usage)
3. [Pattern Syntax Reference](#pattern-syntax-reference)
4. [Common Use Cases](#common-use-cases)
5. [CLI Reference](#cli-reference)
6. [Practical Examples](#practical-examples)
7. [Advanced Features](#advanced-features)
8. [Integration with Other Tools](#integration-with-other-tools)
9. [Troubleshooting and Common Issues](#troubleshooting-and-common-issues)
10. [Advanced Techniques](#advanced-techniques)
11. [Quick Reference Guide](#quick-reference-guide)
12. [Supported Languages](#supported-languages)

## Introduction to ast-grep

ast-grep is a powerful tool for searching, linting, and rewriting code across multiple programming languages. It uses Abstract Syntax Trees (AST) to provide precise, language-aware code analysis and transformation.

### Key Features
- **Multi-language support**: Works with a wide range of languages including JavaScript, TypeScript, Python, Ruby, Go, Rust, Java, C, C++, C#, CSS, HTML, Kotlin, Swift, and more. See the [languages list](#supported-languages) for complete details.
- **Structural search**: Finds code patterns based on syntax, not just text
- **Refactoring**: Safely rewrite code across entire codebases
- **Linting**: Create custom linting rules with flexible patterns

## Basic Usage

### Simple Search

Search for a pattern in your codebase:

```bash
ast-grep --pattern 'console.log($$)' --lang javascript .
```

### Code Rewriting

Rewrite code patterns interactively:

```bash
ast-grep --pattern 'var $VAR = $ --rewrite 'const $VAR = $ --lang javascript . --interactive
```

### Scan with Configuration

Use YAML configuration files for complex rules:

```bash
ast-grep scan --config sgconfig.yml .
```

## Pattern Syntax Reference

ast-grep uses a simple yet powerful pattern syntax:

- **Literal code**: Matches exact code structures
- **Meta variables**: `$META_VARIABLE` matches any single AST node
- **Wildcards**: `$ matches zero or more nodes
- **Capturing**: Same named variables capture matching patterns
- **Unnamed nodes**: `$VAR` captures unnamed AST nodes

### Examples

```javascript
// Pattern: console.log($MESSAGE)
console.log("Hello world")
console.log(error.message)

// Pattern: function $NAME($$) { $$ }
function add(a, b) {
  return a + b;
}
```

## Common Use Cases

### Find Function Calls

```bash
ast-grep --pattern 'fetch($$)' --lang typescript .
```

### Find Class Definitions

```bash
ast-grep --pattern 'class $NAME { $$ }' --lang javascript .
```

### Find Variable Assignments

```bash
ast-grep --pattern '$VAR = $ --lang python .
```

### Find Import Statements

```bash
ast-grep --pattern 'import { $$ } from "$MODULE"' --lang javascript .
```

### Find Method Calls on Objects

```bash
ast-grep --pattern '$OBJ.$METHOD($$)' --lang typescript .
```

### Find React Hooks

```bash
ast-grep --pattern 'const [$STATE, $SETTER] = useState($$)' --lang typescript .
```

## CLI Reference

### Basic Commands

ast-grep has several commands for different operations:

- **`ast-grep run`**: Run one-time search or rewrite in command line. This is the default command when you run the CLI, so `ast-grep -p 'foo()'` uses the default command.
- **`ast-grep scan`**: Scan and rewrite code by configuration.
- **`ast-grep test`**: Test ast-grep rules.
- **`ast-grep new`**: Create new ast-grep project or items like rules/tests.
- **`ast-grep lsp`**: Start a language server to report diagnostics in your project. This is useful for editor integration.
- **`ast-grep completions`**: Generate shell completion script.
- **`ast-grep help`**: Print help message or the help of the given subcommand(s).

### Common Options for `ast-grep run`

- `-p, --pattern <PATTERN>`: AST pattern to match.
- `-r, --rewrite <REWRITE>`: String to replace the matched AST node.
- `-l, --lang <LANG>`: The language of the pattern query. ast-grep will infer the language based on file extension if this option is omitted.
- `-i, --interactive`: Start interactive edit session. Code rewrite only happens inside a session.
- `--json[=<STYLE>]`: Output matches in structured JSON [possible values: pretty, stream, compact]
- `-j, --threads <NUM>`: Set the approximate number of threads to use [default: heuristic]
- `--debug-query[=<format>]`: Print query pattern's tree-sitter AST. Requires lang be set explicitly.
- `--strictness <STRICTNESS>`: The strictness of the pattern [possible values: cst, smart, ast, relaxed, signature]
- `--follow`: Follow symbolic links
- `--no-ignore <NO_IGNORE>`: Do not respect hidden file system or ignore files (.gitignore, .ignore, etc.) [possible values: hidden, dot, exclude, global, parent, vcs]
- `--selector <KIND>`: AST kind to extract sub-part of pattern to match.
- `--stdin`: Enable search code from StdIn.
- `--globs <GLOBS>`: Include or exclude file paths
- `-U, --update-all`: Apply all rewrite without confirmation
- `--color <WHEN>`: Controls output color [default: auto]
- `--inspect <GRANULARITY>`: Inspect information for file/rule discovery and scanning [default: nothing] [possible values: nothing, summary, entity]
- `--heading <WHEN>`: Controls whether to print the file name as heading [default: auto] [possible values: auto, always, never]
- `-A, --after <NUM>`: Show NUM lines after each match [default: 0]
- `-B, --before <NUM>`: Show NUM lines before each match [default: 0]
- `-C, --context <NUM>`: Show NUM lines around each match [default: 0]

### Common Options for `ast-grep scan`

- `-c, --config <CONFIG_FILE>`: Path to ast-grep root config, default is `sgconfig.yml`
- `-r, --rule <RULE_FILE>`: Scan the codebase with the single rule located at the path `RULE_FILE`
- `--inline-rules <RULE_TEXT>`: Scan the codebase with a rule defined by the provided `RULE_TEXT`
- `--filter <REGEX>`: Scan the codebase with rules with ids matching `REGEX`
- `-j, --threads <NUM>`: Set the approximate number of threads to use [default: heuristic]
- `-i, --interactive`: Start interactive edit session
- `-U, --update-all`: Apply all rewrite without confirmation
- `--color <WHEN>`: Controls output color [default: auto]
- `--format <FORMAT>`: Output warning/error messages in GitHub Action format [possible values: github]
- `--report-style <REPORT_STYLE>`: [default: rich] [possible values: rich, medium, short]
- `--follow`: Follow symbolic links
- `--no-ignore <NO_IGNORE>`: Do not respect ignore files (.gitignore, .ignore, etc.) [possible values: hidden, dot, exclude, global, parent, vcs]
- `--stdin`: Enable search code from StdIn
- `--globs <GLOBS>`: Include or exclude file paths
- `--inspect <GRANULARITY>`: Inspect information for file/rule discovery and scanning [default: nothing] [possible values: nothing, summary, entity]
- `--error[=<RULE_ID>...]`: Set rule severity to error
- `--warning[=<RULE_ID>...]`: Set rule severity to warning
- `--info[=<RULE_ID>...]`: Set rule severity to info
- `--hint[=<RULE_ID>...]`: Set rule severity to hint
- `--off[=<RULE_ID>...]`: Turn off the rule
- `--after <NUM>`: Show NUM lines after each match [default: 0]
- `--before <NUM>`: Show NUM lines before each match [default: 0]
- `--context <NUM>`: Show NUM lines around each match [default: 0]

## Practical Examples

### Example 1: Migrate to Optional Chaining

**Pattern**: Find defensive null checks
```javascript
obj && obj.method()
```

**Rewrite**: Convert to optional chaining
```javascript
obj?.method()
```

### Example 2: Find Console Logs (except in catch blocks)

**YAML Rule**:
```yaml
id: no-console-except-error
language: typescript
rule:
  any:
    - pattern: console.error($$)
      not:
        inside:
          kind: catch_clause
          stopBy: end
    - pattern: console.$METHOD($$)
      constraints:
        METHOD:
          regex: 'log|debug|warn'
```

### Example 3: Speed Up Barrel Imports

**Pattern**: Find barrel imports that can be optimized
```typescript
import { $IDENTS } from './barrel'
```

**YAML Rule with Rewriter**:
```yaml
id: speed-up-barrel-import
language: typescript
rule:
  pattern: import {$$IDENTS} from './barrel'
rewriters:
- id: rewrite-identifier
  rule:
    pattern: $IDENT
    kind: identifier
  transform:
    LIB: { convert: { source: $IDENT, toCase: lowerCase } }
  fix: import $IDENT from './module/$LIB'
transform:
  IMPORTS:
    rewrite:
      rewriters: [rewrite-identifier]
      source: $$IDENTS
      joinBy: "\n"
fix: $IMPORTS
```

## Advanced Features

### Rule Configuration

Create comprehensive rules in YAML format:

```yaml
id: prefer-const
language: javascript
rule:
  all:
    - pattern: var $VAR = $VALUE
    - not:
        pattern: $VAR = $$
```

### Rule Types

ast-grep supports several types of rules for matching code patterns:

- **Atomic rules**: Match individual AST nodes based on their properties
  - `pattern`: Match code structure (e.g., `console.log($ARG)`)
  - `kind`: Match AST node by type (e.g., `kind: if_statement`)
  - `regex`: Match node text with regular expressions
  - `nthChild`: Find nodes based on their indexes in the parent node's children list
- **Relational rules**: Define relationships between nodes
  - `inside`: Target node must appear inside another node
  - `has`: Target node must contain another node
  - `precedes`: Target node must appear before another node
  - `follows`: Target node must appear after another node
- **Composite rules**: Combine multiple rules with logic operations
  - `all`: All sub-rules must match
  - `any`: At least one sub-rule must match
  - `not`: The sub-rule must not match
  - `matches`: Match a utility rule

### Advanced Rule Examples

Using relational constraints to refine matches:

```yaml
id: find-console-outside-tests
language: javascript
rule:
  pattern: console.log($$)
  not:
    inside:
      kind: call_expression
      has:
        field: function
        regex: '^(describe|it|test)
```

Using field constraints to target specific parts of nodes:

```yaml
id: find-function-parameters
language: javascript
rule:
  kind: formal_parameters
  has:
    kind: identifier
    field: name
    pattern: $PARAM
```

### Patching: fix, transform, rewriters

ast-grep provides powerful code transformation capabilities through fix, transform, and rewriters.

#### Fix

Fix can be a string (pattern) or a structured FixConfig. You can reference matched meta-variables:

```yaml
fix: logger.log($$ARGS)
# empty string deletes the match
# fix: ""
```

For more complex fixes, use FixConfig with expandStart/expandEnd:

```yaml
rule:
  kind: pair
  has:
    field: key
    regex: Remove
# remove the key-value pair and its comma
fix:
  template: ''
  expandEnd: { regex: ',' } # expand the range to the comma
```

#### Transform

Compute derived meta-vars for use in fix. A map from new meta-var name to a transformation:

```yaml
transform:
  NEW_VAR: replace($ARGS, replace='^.+', by=', ')
```

Common transformations: replace, substring, convert, rewrite (delegates to rewriters), etc.

#### Rewriters

Local mini-rules used within `rewrite(...)` transformations.

```yaml
rewriters:
  - id: stringify
    rule: { pattern: "'' + $A" }
    fix: "String($A)"
```

Combine with transform:

```yaml
transform:
  AS_STRING: rewrite($EXPR, rewriters=[stringify])
fix: console.log($AS_STRING)
```

### Project Scanning and Configuration (sgconfig)

Create sgconfig.yml at repo root to configure defaults:

```yaml
# sgconfig.yml
ruleDirs:
  - rules
testConfigs:
  - testDir: test
    snapshotDir: __snapshots__
languageGlobs:
  html: ['*.vue', '*.svelte', '*.astro']
  json: ['.eslintrc']
  cpp: ['*.c']
  tsx: ['*.ts']
```

Run scan using the config:

```bash
ast-grep scan --config sgconfig.yml
```

You can also embed rules inline inside sgconfig.yml or reference multiple rule files. See the reference for all options (e.g., language overrides, reporter formats, severity defaults).

### Linting, Severity and Reporting

- severity: error | warning | info | hint
- Customize severity per rule or globally in sgconfig
- Formats: default stylish, or `--format json` for machine-readable output
- Use `--fix` to apply autofixes when a rule has `fix`

Example lint rule with fix and severity:

```yaml
id: no-console
language: js
rule: { pattern: console.log($$ARGS) }
message: Avoid console.log; use logger instead.
severity: error
fix: logger.log($$ARGS)
```

### JSON Output

Get structured output for programmatic processing:

```bash
ast-grep --pattern 'fetch($$)' --lang typescript . --json
```

### Interactive Mode

Review and apply changes interactively:

```bash
ast-grep --pattern 'var $VAR = $ --rewrite 'const $VAR = $ --interactive
```

## Integration with Other Tools

ast-grep works well with other tools in your development workflow:

### Combining with grep and regex

Use ast-grep for structural patterns and grep/regex for simple text searches:

```bash
# First use ast-grep for structural search
ast-grep --pattern 'fetch($$)' --lang typescript .

# Then use grep for text patterns in the results
grep -n "error handling" results.txt
```

### Using with Standard Input

Process code from standard input:

```bash
echo "console.log('Hello World')" | ast-grep --pattern 'console.log($$)' --lang javascript --stdin
```

## Troubleshooting and Common Issues

### Pattern Not Matching

If your pattern isn't matching as expected:

1. **Check language**: Ensure you're using the correct `--lang` flag
2. **Use debug mode**: Run with `--debug-query` to see the AST structure
3. **Simplify pattern**: Start with a simpler pattern and gradually add complexity
4. **Check for comments/strings**: Remember that patterns match actual AST nodes, not comments or string literals

### Performance Issues

For large codebases:

1. **Use threads**: Increase performance with `-j 4` or higher
2. **Limit scope**: Use file globs to limit search scope
3. **Use ignore files**: Respect `.gitignore` patterns with `--no-ignore`

### Common Errors

- **`Invalid pattern`**: Ensure your pattern is valid syntax for the target language
- **`Language not supported`**: Check the [supported languages list](#supported-languages)

## Advanced Techniques

### Debugging Patterns

Use the debug query feature to understand AST structure:

```bash
ast-grep --pattern 'console.log($$)' --lang javascript --debug-query
```

### Complex Rules

For advanced matching, use YAML rules with relational operators:

```yaml
id: complex-rule
language: javascript
rule:
  all:
    - pattern: $META_VAR = $EXPR
    - inside:
        kind: function_declaration
    - not:
        pattern: $META_VAR = null
```

## Quick Reference Guide

### Basic Commands

```bash
# Search for a pattern
ast-grep --pattern 'console.log($$)' --lang javascript .

# Rewrite patterns interactively
ast-grep --pattern 'var $VAR = $ --rewrite 'const $VAR = $ --interactive

# Scan with configuration
ast-grep scan --config sgconfig.yml .

# Test rules
ast-grep test

# Create new rule
ast-grep new rule my-rule

# Generate shell completions
ast-grep completions
```

### Pattern Syntax

- `$META_VARIABLE`: Single AST node (meta variable)
- `$: Zero or more AST nodes (wildcard)
- Literal code: Exact code structure

### Common Options

```bash
-p, --pattern <PATTERN>    # Pattern to match
-r, --rewrite <REWRITE>    # Replacement string
-l, --lang <LANG>          # Language (inferred if omitted)
-i, --interactive          # Interactive mode
-j NUM, --threads <NUM>    # Number of threads [default: heuristic]
--debug-query[=<format>]   # Show AST structure
--json[=<STYLE>]           # JSON output (pretty, stream, compact)
--no-ignore <NO_IGNORE>    # Respect ignore files [possible values: hidden, dot, exclude, global, parent, vcs]
--follow                   # Follow symbolic links
--color <WHEN>             # Controls output color [default: auto]
--inspect <GRANULARITY>    # Inspect information for file/rule discovery [default: nothing]
--heading <WHEN>           # Controls file name heading [default: auto]
-A NUM, --after <NUM>      # Show NUM lines after match [default: 0]
-B NUM, --before <NUM>     # Show NUM lines before match [default: 0]
-C NUM, --context <NUM>    # Show NUM lines around match [default: 0]
```

### YAML Rule Example

```yaml
id: prefer-const
language: javascript
rule:
  all:
    - pattern: var $VAR = $VALUE
    - not:
        pattern: $VAR = $$
```

## Supported Languages

ast-grep supports a wide range of programming languages. Here is the complete list of supported languages with their aliases and file extensions:

- **Bash**: Alias `bash`, File Extensions: `bash`, `bats`, `cgi`, `command`, `env`, `fcgi`, `ksh`, `sh`, `sh.in`, `tmux`, `tool`, `zsh`
- **C**: Alias `c`, File Extensions: `c`, `h`
- **Cpp**: Alias `cc`, `c++`, `cpp`, `cxx`, File Extensions: `cc`, `hpp`, `cpp`, `c++`, `hh`, `cxx`, `cu`, `ino`
- **CSharp**: Alias `cs`, `csharp`, File Extensions: `cs`
- **Css**: Alias `css`, File Extensions: `css`
- **Elixir**: Alias `ex`, `elixir`, File Extensions: `ex`, `exs`
- **Go**: Alias `go`, `golang`, File Extensions: `go`
- **Haskell**: Alias `hs`, `haskell`, File Extensions: `hs`
- **Html**: Alias `html`, File Extensions: `html`, `htm`, `xhtml`
- **Java**: Alias `java`, File Extensions: `java`
- **JavaScript**: Alias `javascript`, `js`, `jsx`, File Extensions: `cjs`, `js`, `mjs`, `jsx`
- **Json**: Alias `json`, File Extensions: `json`
- **Kotlin**: Alias `kotlin`, `kt`, File Extensions: `kt`, `ktm`, `kts`
- **Lua**: Alias `lua`, File Extensions: `lua`
- **Nix**: Alias `nix`, File Extensions: `nix`
- **Php**: Alias `php`, File Extensions: `php`
- **Python**: Alias `py`, `python`, File Extensions: `py`, `py3`, `pyi`, `bzl`
- **Ruby**: Alias `rb`, `ruby`, File Extensions: `rb`, `rbw`, `gemspec`
- **Rust**: Alias `rs`, `rust`, File Extensions: `rs`
- **Scala**: Alias `scala`, File Extensions: `scala`, `sc`, `sbt`
- **Solidity**: Alias `solidity`, `sol`, File Extensions: `sol`
- **Swift**: Alias `swift`, File Extensions: `swift`
- **TypeScript**: Alias `ts`, `typescript`, File Extensions: `ts`, `cts`, `mts`
- **Tsx**: Alias `tsx`, File Extensions: `tsx`
- **Yaml**: Alias `yml`, File Extensions: `yml`, `yaml`

## Decision Matrix: When to Use `ast-grep`
- **Find code structures**: Syntax-aware search
- **Structural refactoring**: Structure + precision 

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'diffsitter' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'diffsitter'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'diffsitter' {
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Manually set the file type for the given files')
            [CompletionResult]::new('--file-type', '--file-type', [CompletionResultType]::ParameterName, 'Manually set the file type for the given files')
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Use the config provided at the given path')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Use the config provided at the given path')
            [CompletionResult]::new('--color', '--color', [CompletionResultType]::ParameterName, 'Set the color output policy. Valid values are: "auto", "on", "off"')
            [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Specify which renderer tag to use')
            [CompletionResult]::new('--renderer', '--renderer', [CompletionResultType]::ParameterName, 'Specify which renderer tag to use')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Print debug output')
            [CompletionResult]::new('--debug', '--debug', [CompletionResultType]::ParameterName, 'Print debug output')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Ignore any config files and use the default config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Ignore any config files and use the default config')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List the languages that this program was compiled for')
            [CompletionResult]::new('dump-default-config', 'dump-default-config', [CompletionResultType]::ParameterValue, 'Dump the default config to stdout')
            [CompletionResult]::new('gen-completion', 'gen-completion', [CompletionResultType]::ParameterValue, 'Generate shell completion scripts for diffsitter')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'diffsitter;list' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'diffsitter;dump-default-config' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'diffsitter;gen-completion' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'diffsitter;help' {
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List the languages that this program was compiled for')
            [CompletionResult]::new('dump-default-config', 'dump-default-config', [CompletionResultType]::ParameterValue, 'Dump the default config to stdout')
            [CompletionResult]::new('gen-completion', 'gen-completion', [CompletionResultType]::ParameterValue, 'Generate shell completion scripts for diffsitter')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'diffsitter;help;list' {
            break
        }
        'diffsitter;help;dump-default-config' {
            break
        }
        'diffsitter;help;gen-completion' {
            break
        }
        'diffsitter;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}

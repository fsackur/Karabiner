function Invoke-Karabiner
{
    param
    (
        [ValidateSet(
            'select-profile',
            'show-current-profile-name',
            'list-profile-names',
            'set-variables',
            'copy-current-profile-to-system-default-profile',
            'remove-system-default-profile',
            'lint-complex-modifications',
            'version',
            'version-number',
            'help'
        )]
        [string]$Command,

        [Parameter(ValueFromRemainingArguments)]
        $ArgumentList
    )

    & (Get-KarabinerCommand) "--$Command" $ArgumentList
}

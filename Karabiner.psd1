@{
    Description          = 'Remap keys on MacOS with Karabiner-Elements.'
    ModuleVersion        = '0.1.5'
    HelpInfoURI          = 'https://pages.github.com/fsackur/Karabiner'

    # Only for MacOS
    CompatiblePSEditions = @('Core')
    PowerShellVersion    = '7.1'

    GUID                 = '36ccc2ae-a266-43b7-8fed-da48ff570483'

    Author               = 'Freddie Sackur'
    CompanyName          = 'DustyFox'
    Copyright            = '(c) 2022 Freddie Sackur. All rights reserved.'

    RootModule           = 'Karabiner.psm1'

    AliasesToExport      = @()
    FunctionsToExport    = @(
        'Get-KarabinerConfig',
        'Get-KarabinerProfile',
        'Get-KarabinerRule',
        'Set-KarabinerConfig',
        'Set-KarabinerProfile',
        'Set-KarabinerRule',
        'Switch-KarabinerProfile'
    )

    FormatsToProcess     = @()

    PrivateData          = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/Karabiner/main/LICENSE'
            ProjectUri = 'https://github.com/fsackur/Karabiner'
            Tags       = @(
                'KeyBinding',
                'Keyboard',
                'KeyMap',
                'KeyMapping',
                'Shortcut',
                'HotKey',
                'Karabiner',
                'Karabiner-Elements'
            )
        }
    }
}



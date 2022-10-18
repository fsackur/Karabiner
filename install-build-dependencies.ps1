$Dependencies = (
    @{
        Name = 'Pester'
        MinimumVersion = '5.3.1'
    },
    @{
        Name = 'PowerShellGet'
        MinimumVersion = '3.0.16'
    },
    @{
        Name = 'InvokeBuild'
        MinimumVersion = '5.9.12'
    }
)

$Dependencies | % {
    if (-not (Get-Module $_.Name -ListAvailable -ErrorAction Ignore | ? Version -ge $_.MinimumVersion))
    {
        $Params = @{
            Force              = $true
            AllowClobber       = $true
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
            AllowPrerelease    = $_.Name -eq 'PowerShellGet'
        }
        Write-Verbose "Installing $($_.Name)..."
        Install-Module @Params @_
    }
}

$HomebrewPackages = @(
    'karabiner-elements'
)

$Casks = brew list --cask

$HomebrewPackages | % {
    if ($_ -notin $Casks)
    {
        $env:HOMEBREW_NO_AUTO_UPDATE = 1
        brew install --cask $_
    }
}

#requires -Modules @{ModuleName = 'InvokeBuild'; ModuleVersion = '5.9.12'}, @{ModuleName = 'PowerShellGet'; ModuleVersion = '3.0.16'}

param
(
    [version]$NewVersion,

    [string]$PSGalleryApiKey
)

# Synopsis: Update manifest version
task UpdateVersion {
    $ManifestPath = "Karabiner.psd1"
    $ManifestContent = Get-Content $ManifestPath -Raw
    $Manifest = Invoke-Expression "DATA {$ManifestContent}"

    if ($NewVersion -le [version]$Manifest.ModuleVersion)
    {
        throw "Can't go backwards: $NewVersion =\=> $($Manifest.ModuleVersion)"
    }

    $ModuleVersionPattern = "(?<=\n\s*ModuleVersion\s*=\s*(['`"]))(\d+\.)+\d+"

    $ManifestContent = $ManifestContent -replace $ModuleVersionPattern, $NewVersion
    $ManifestContent | Out-File $ManifestPath -Encoding utf8
}

# Synopsis: Run PSSA, excluding Tests folder and *.build.ps1
task PSSA {
    $Files = Get-ChildItem -File -Recurse -Filter *.ps*1 | Where-Object FullName -notmatch '\bTests\b|\.build\.ps1$|install-build-dependencies\.ps1'
    $Files | ForEach-Object {
        Invoke-ScriptAnalyzer -Path $_.FullName -Recurse -Settings .\.vscode\PSScriptAnalyzerSettings.psd1
    }
}

# Synopsis: Clean build folder
task Clean {
    remove Build
}

# Synopsis: Build module at manifest version
task Build Clean, {
    $ManifestPath = "Karabiner.psd1"
    $ManifestContent = Get-Content $ManifestPath -Raw
    $Manifest = Invoke-Expression "DATA {$ManifestContent}"

    $Version = $Manifest.ModuleVersion
    $BuildFolder = New-Item "Build/Karabiner/$Version" -ItemType Directory -Force
    $BuiltManifestPath = Join-Path $BuildFolder $ManifestPath
    $BuiltRootModulePath = Join-Path $BuildFolder $Manifest.RootModule

    Copy-Item $ManifestPath $BuildFolder
    Copy-Item "README.md" $BuildFolder
    Copy-Item "LICENSE" $BuildFolder

    'Private', 'Public' | ForEach-Object {
        "",
        "#region $_",
        ($_ | Get-ChildItem | Get-Content),
        "#endregion $_",
        ""
    } |
        Write-Output |
        Out-File $BuiltRootModulePath -Encoding utf8NoBOM
}

# Synopsis: Import latest version of module from build folder
task Import Build, {
    Import-Module "$BuildRoot/Build/Karabiner" -Force -Global -ErrorAction Stop
}

task Test Import, {
    Invoke-Pester
}

task Publish Build, {
    $UnversionedBase = "Build/Karabiner"
    $VersionedBase = Get-Module $UnversionedBase -ListAvailable | ForEach-Object ModuleBase
    Get-ChildItem $VersionedBase | Copy-Item -Destination $UnversionedBase
    remove $VersionedBase
    Publish-PSResource -Verbose -Path $UnversionedBase -DestinationPath Build -Repository PSGallery -ApiKey $PSGalleryApiKey
}

task . PSSA, Test

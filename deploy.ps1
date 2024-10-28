# Define the environment variable name and desired value
$TS_UPLOAD_AUTHOR_NAME = "Krumpac"
$BEPINEX_NAME = "BepInEx"
$PLUGINS_FOLDER_NAME = "plugins"
$CONFIG_FOLDER_NAME = "config"

# Extract the mod name from manifest.json file
$jsonFilePath = Join-Path -Path $PSScriptRoot -ChildPath "manifest.json"
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
$modName = $jsonContent.name
Write-Output "------------"
Write-Output "running replacement for this mod '$modName'"

$tsHome = "C:\Users\$env:USERNAME\AppData\Roaming\Thunderstore Mod Manager\DataFolder\Valheim\profiles"
Write-Output "using $tsHome as thunderstore profiles folder" 
$localConfig = Get-ChildItem -Path $PSScriptRoot -Directory -Filter $CONFIG_FOLDER_NAME
if(-not [string]::IsNullOrEmpty($localConfig)){
    Write-Output "using $localConfig as local config to copy to all profiles"
}
else {
    Write-Output "no configs to replace"
} 
$localPlugins = Get-ChildItem -Path $PSScriptRoot -Directory -Filter $PLUGINS_FOLDER_NAME
if(-not [string]::IsNullOrEmpty($localPlugins)){
    Write-Output "using $localPlugins as local plugins to copy to all profiles"
}
else {
    Write-Output "no plugins to replace"
} 
Write-Output "------------"

$profileFolders = Get-ChildItem -Path $tsHome -Directory

foreach ($profileFolder in $profileFolders) {
    $profileBepInExFolder = Join-Path -Path $profileFolder -ChildPath $BEPINEX_NAME
    $profileModFolder = Join-Path -Path $profileBepInExFolder -ChildPath $(Join-Path -Path $PLUGINS_FOLDER_NAME -ChildPath "${TS_UPLOAD_AUTHOR_NAME}-${modName}" )
    if (Test-Path -Path $profileModFolder) {
        Write-Output "found $modName in profile $(Split-Path -Path $profileFolder -Leaf)" 
        if(-not [string]::IsNullOrEmpty($localConfig)){
            $configTargetFolder = Join-Path -Path $profileBepInExFolder -ChildPath $CONFIG_FOLDER_NAME
            Copy-Item -Path $localConfig\* -Destination $configTargetFolder -Recurse -Force -verbose
        }
        if(-not [string]::IsNullOrEmpty($localPlugins)){
            $pluginsTargetFolder = Join-Path -Path $profileBepInExFolder -ChildPath $(Join-Path -Path $PLUGINS_FOLDER_NAME -ChildPath "${TS_UPLOAD_AUTHOR_NAME}-${modName}" )
            Copy-Item -Path $localPlugins\* -Destination $pluginsTargetFolder -Recurse -Force -verbose
        }
    } else {
        Write-Debug "skipping profile $profileFolder as it does not contain this mod at $profileModFolder"
    }
    Write-Output ""
    Write-Output "############"
    Write-Output ""
}


$PluginsFolder = "plugins"
$FilePrefixesAndFolders = @{
  "Datys_Professions" = "Krumpac-Datys_Professions";
  "Krumpac_Armors" = "Krumpac-Krumpac_Armors";
  "Krumpac_Building_Pieces" = "Krumpac-Krumpac_Building_Pieces";
  "Krumpac_Reforge_Core" = "Krumpac-Krumpac_Reforge_Core"; 
  "Krumpac_Sacrificing_Altars" = "Krumpac-Krumpac_Sacrificing_Altars";
  "Krumpac_Tribe_Ornaments" = "Krumpac-Krumpac_Tribe_Ornaments";
  "Krumpac_Weapon_Arsenal" = "Krumpac-Krumpac_Weapon_Arsenal";
  "Krump_Monsters_Pack_1" = "Krumpac-Krump_Monsters_Pack_1";
  "Krumpac_Dungeon_Meadows" = "Krumpac-Krumpac_Dungeon_Meadows";
  "Krumpac_Location_01" = "Krumpac-Krumpac_Location_01";
}
$TranslationsSubFolder = "translations"
$SourceLanguage = "English"
$FileSuffix = "yml"

foreach ($kv in $FilePrefixesAndFolders.GetEnumerator()){
  $CurrentFolder = "$PluginsFolder\" + $kv.Value + "\$TranslationsSubFolder"
  $CurrentInputFile = $kv.Name + ".$SourceLanguage.$FileSuffix"
  $CurrentInputFileRelative = "$CurrentFolder\$CurrentInputFile"
  $CurrentInputFileAbsolute = "$PSScriptRoot\$CurrentInputFileRelative"
  Write-Output($CurrentInputFileAbsolute)

  Get-Content $CurrentInputFileAbsolute | Where-Object { ! $_.StartsWith("#") } | Sort-Object | Get-Unique | Set-Content $CurrentInputFileAbsolute
}

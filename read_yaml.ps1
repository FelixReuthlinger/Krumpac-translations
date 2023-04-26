

$FilePrefixesAndFolders = @{
  "Datys_Professions" = "Krumpac-Datys_Professions";
  "Krumpac_Armors" = "Krumpac-Krumpac_Armors";
  "Krumpac_Building_Pieces" = "Krumpac-Krumpac_Building_Pieces";
  "Krumpac_Dungeon_Meadows" = "Krumpac-Krumpac_Dungeon_Meadows"; 
  "Krumpac_Reforge_Core" = "Krumpac-Krumpac_Reforge_Core"; 
  "Krumpac_Sacrificing_Altars" = "Krumpac-Krumpac_Sacrificing_Altars";
  "Krumpac_Tribe_Ornaments" = "Krumpac-Krumpac_Sacrificing_Altars";
  "Krumpac_Weapon_Arsenal" = "Krumpac-Krumpac_Weapon_Arsenal"
}
$SourceLanguage = "English"
$TargetLanguage = "TEST"

function FileToMap {
  param ($filePath)
  $result = @{}
  if(Test-Path -Path $filePath -PathType Leaf) {
    Get-Content "$filePath" | Where-Object { ! $_.StartsWith("#") } | Where-Object { $_.trim() -ne "" } | ForEach-Object { $kv = $_ -split ":"; $result[$kv[0]] = $kv[1].Replace("`"","") }
  } 
  return $result
}

foreach ($kv in $FilePrefixesAndFolders.GetEnumerator()){
  $CurrentInputFileAbsolute = "${PSScriptRoot}\plugins\" + $kv.Value + "\translations\" + $kv.Name + ".$SourceLanguage.yml"
  Write-Output($CurrentInputFileAbsolute)

  $CurrentOutputFileAbsolute = "${PSScriptRoot}\plugins\" + $kv.Value + "\translations\" + $kv.Name + ".$TargetLanguage.yml"
  Write-Output($CurrentOutputFileAbsolute)
  
  $inputMap = FileToMap($CurrentInputFileAbsolute)
  $outputMap = FileToMap($CurrentOutputFileAbsolute)

  foreach($tuple in $inputMap.GetEnumerator()){
    if(! $outputMap.containsKey($tuple.Name)){
      $outputMap[$tuple.Name] = "--TODO fill value-- " + $tuple.Value
    }
  }

  $output = @()
  foreach($kv in $outputMap.GetEnumerator()){
    $output += $kv.Name + ": `"" + $kv.Value + "`""
  } 
  $output | Sort-Object | Out-File($CurrentOutputFileAbsolute)
}

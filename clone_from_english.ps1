

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
$SourceLanguage = "English"
$TargetLanguages = "Chinese", "French", "German", "Korean", "Polish", "Russian", "Spanish", "Ukrainian", "Turkish"

function FileToMap {
  param ($filePath)
  $result = @{}
  if(Test-Path -Path $filePath -PathType Leaf) {
    Get-Content "$filePath" | Where-Object { ! $_.StartsWith("#") } | Where-Object { $_.trim() -ne "" } | ForEach-Object { $kv = $_ -split ":"; $result[$kv[0]] = $kv[1].Replace("`"","") }
  } 
  return $result
}

foreach ($kv in $FilePrefixesAndFolders.GetEnumerator()) {
  $CurrentInputFileAbsolute = "${PSScriptRoot}\plugins\" + $kv.Value + "\translations\" + $kv.Name + ".$SourceLanguage.yml"
  Write-Output($CurrentInputFileAbsolute)

  foreach ($TargetLanguage in $TargetLanguages) {
    $CurrentOutputFileAbsolute = "${PSScriptRoot}\plugins\" + $kv.Value + "\translations\" + $kv.Name + ".$TargetLanguage.yml"
    Write-Output($CurrentOutputFileAbsolute)
    
    # load files
    $inputMap = FileToMap($CurrentInputFileAbsolute)
    $outputMap = FileToMap($CurrentOutputFileAbsolute)
  
    # add new keys from english to output
    foreach($inKey in $inputMap.Keys){
      if(! $outputMap.containsKey($inKey)){
        $outputMap[$inKey] = $inputMap.Item($inKey)
      }
    }

    # clean up the output from deprecated keys
    $keyToDropFromOutput=@()
    foreach($outKey in $outputMap.Keys){
      if(! $inputMap.ContainsKey($outKey)){
        $keyToDropFromOutput += $outKey
      }
    }
    foreach($dropKey in $keyToDropFromOutput){
      $outputMap.Remove($dropKey)
    }
  
    # write output back
    $output = @()
    foreach($outKey in $outputMap.Keys){
      $output += $outKey + ": `"" + $outputMap.Item($outKey).Trim() + "`""
    } 
    $output | Sort-Object | Set-Content($CurrentOutputFileAbsolute)
  }
}

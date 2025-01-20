$rootDir = "videos_musics"

$subDirs = Get-ChildItem -Path $rootDir -Directory

foreach ($subDir in $subDirs) {

    Write-Host "Processing subdirectory $($subDir.FullName)..."

    $videoPath = Join-Path -Path $subDir.FullName -ChildPath "video.mp4"
    
    if (Test-Path -Path $videoPath) {
        $newVideoName = "$($subDir.Name).mp4"
        $newVideoPath = Join-Path -Path $rootDir -ChildPath $newVideoName
        Move-Item -Path $videoPath -Destination $newVideoPath
    }
    else {
        Write-Host "Video file not found in $($subDir.FullName)"
    } 
    $soundPath = Join-Path -Path $subDir.FullName -ChildPath "sound.wav"
    if (Test-Path -Path $soundPath) {
        $newSoundName = "$($subDir.Name).wav"
        $newSoundPath = Join-Path -Path $rootDir -ChildPath $newSoundName
        Move-Item -Path $soundPath -Destination $newSoundPath
    }
    else {
        Write-Host "Sound file not found in $($subDir.FullName)"
    }

}

# to copy to target dir using rclone (once rclone configured for the remote); remove --dry-run for actually transferring files
# rclone sync videos_musics  ovhpublicstorage:explore2enmusique --progress --dry-run
# rclone sync videos_musics_processed ovhpublicstorage:explore2enmusique --progress --dry-run
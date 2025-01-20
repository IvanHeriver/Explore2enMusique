
# Set paths
$overlay_image = "overlay.png"
$input_folder = "videos_musics"
$output_folder = "videos_musics_processed"

# Set metadata to add (unused for now)
# $author = "Ivan Horner"
# $copyright = "© 2024 Ivan Horner"
# $licence = "CC BY 4.0: https://creativecommons.org/licenses/by/4.0/"

# Create the output folder if it doesn't exist
if (-Not (Test-Path $output_folder)) {
    New-Item -ItemType Directory -Path $output_folder
}

# Get all MP4 files in the input folder
$video_files = Get-ChildItem -Path $input_folder -Filter *.mp4

# Function to add overlay to a single video
function Format-Video {
    param (
        [string]$video_file,
        [string]$overlay_image,
        [string]$output_folder
    )

    # Get the filename without extension
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($video_file)

    # Define the output file path
    $output_file = Join-Path $output_folder "$filename`.mp4"

    # Build the FFmpeg command
    # ffmpeg -i input.mp4 -metadata title="Titre de la Vidéo" -metadata author="Nom de l'Auteur" -metadata copyright="© 2024 Votre Nom"  -metadata license="CC BY 4.0: https://creativecommons.org/licenses/by/4.0/"  -c copy output.mp4
    # ffmpeg -i input.mp4 -i overlay.png -filter_complex overlay=0:0 -codec:a copy output.mp4
    $command = "ffmpeg"
    $cmd_args = @(
        "-i", "`"$video_file`"",
        # "-i", "`"$overlay_image`"",
        # "-filter_complex", "overlay=0:0",
        # "-metadata", "title=`"Test title`"",
        "-metadata", "author=`"Ivan Horner`"",
        # "-metadata", "copyright=`"© 2024 Ivan Horner`"",
        # "-metadata", "license=`"CC BY 4.0: https://creativecommons.org/licenses/by/4.0/`"",
        # "-codec:a", "copy",
        "-c", "copy",
        "`"$output_file`""
    )

    # Run the command
    Write-Output "Processing $video_file..."
    & $command $cmd_args
}

# Process each video file
foreach ($video_file in $video_files) {
    Format-Video -video_file $video_file.FullName -overlay_image $overlay_image -output_folder $output_folder
}

Write-Output "All videos processed successfully!"

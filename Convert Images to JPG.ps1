Set-StrictMode -Version 3.0
Get-ChildItem -File | Rename-Item -NewName { $_.name -replace "\.(jfif|jpeg)$", ".jpg" }
# mogrify.exe will throw an error for any file types not found in the directory. As far as I can tell, these errors are benign.
if(-not (Test-Path -Path $PSScriptRoot\ImageMagick\magick.exe -Pathtype Leaf)){
	New-Item $PSScriptRoot\ImageMagick -ItemType Directory | Out-Null
	winget install -e --id ImageMagick.ImageMagick --location $PSScriptRoot\ImageMagick
}
if(-not (Test-Path -Path $PSScriptRoot\Input -Pathtype Leaf)){
	New-Item $PSScriptRoot\Input -ItemType Directory | Out-Null
	"Input Folder Created! Place your images inside."
	Read-Host "Press enter to continue..."
}
If ($Null -eq (Get-ChildItem -Force .\Input)) {
	"No images to convert!"
	Read-Host "Press enter to exit"
	Exit
}
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Input'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Output'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Originals'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	.\ImageMagick\magick mogrify -path .\Output -format jpg Input\*.webp Input\*.png Input\*.heic Input\*.tiff
	move-item -Force Input\*.webp, Input\*.png, Input\*.heic, Input\*.tiff -Destination .\Originals\
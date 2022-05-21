Set-StrictMode -Version 3.0
Get-ChildItem -File | Rename-Item -NewName { $_.name -replace "\.(jfif|jpeg)$", ".jpg" }
# mogrify.exe will throw an error for any file types not found in the directory. As far as I can tell, these errors are benign.
if (Test-Path -Path .\ImageMagick\mogrify.exe -Pathtype Leaf) {
	If ($Null -eq (Get-ChildItem -Force .\Input)) {
		"No images to convert!"
		Read-Host "Press enter to continue..."
	}
	else {
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Input'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Output'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	$Path=[System.IO.Path]::Combine($PWD.Path, 'Originals'); [System.IO.Directory]::CreateDirectory($Path) | Out-Null
	.\ImageMagick\mogrify.exe -path .\Output -format jpg Input\*.webp Input\*.png Input\*.heic Input\*.tiff
	move-item -Force Input\*.webp, Input\*.png, Input\*.heic, Input\*.tiff -Destination .\Originals\
	}
}

else {
	Write-Host "mogrify.exe not found!"
	Read-Host "Press enter to continue..."
}
# Build and Copy APK Script

Write-Host "Cleaning project..."
flutter clean

Write-Host "Building Release APK..."
flutter build apk --release

if ($?) {
    Write-Host "Build Successful. Copying to releases folder..."
    
    # Define paths
    $source = "build\app\outputs\flutter-apk\app-release.apk"
    $destDir = "releases"
    $destFile = "$destDir\TractorKhata_Latest.apk"

    # Create directory if it doesn't exist
    if (!(Test-Path -Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }

    # Remove old APKs in the releases folder
    Remove-Item "$destDir\*.apk" -ErrorAction SilentlyContinue

    # Copy new APK
    Copy-Item -Path $source -Destination $destFile

    Write-Host "✅ APK copied to: $destFile"
} else {
    Write-Host "❌ Build Failed."
}

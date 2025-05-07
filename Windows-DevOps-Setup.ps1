# Set Execution Policy and Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Function to Install a Package and Wait
function Install-PackageAndWait {
    param (
        [string]$packageName
    )
    Write-Host "Installing $packageName..."
    choco install $packageName -y
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$packageName installation failed!"
        exit 1
    }
}

# Install Git
Install-PackageAndWait -packageName "git"

# Install Azure CLI
Install-PackageAndWait -packageName "azure-cli"

# Install Terraform
Install-PackageAndWait -packageName "terraform"

Write-Host "Installation completed successfully!"
pause
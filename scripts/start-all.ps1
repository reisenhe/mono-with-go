# ===========================================
# start-all.ps1 - 启动完整开发环境
# ===========================================
# 用途: 检查 Docker Desktop 是否运行，启动后端容器 + 前端 dev server

param(
    [switch]$SkipDockerCheck
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Mono With Go - Starting Dev Env" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# Step 1: Check Docker Desktop
# ------------------------------------------
function Test-DockerRunning {
    try {
        $result = docker info 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

function Start-DockerDesktop {
    Write-Host "[1/4] Checking Docker Desktop..." -ForegroundColor Yellow

    if (Test-DockerRunning) {
        Write-Host "  -> Docker Desktop is running." -ForegroundColor Green
        return
    }

    Write-Host "  -> Docker Desktop is not running. Attempting to start..." -ForegroundColor Yellow

    # Try common install paths
    $dockerPaths = @(
        "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe",
        "$env:LOCALAPPDATA\Docker\Docker Desktop.exe"
    )

    $dockerExe = $null
    foreach ($path in $dockerPaths) {
        if (Test-Path $path) {
            $dockerExe = $path
            break
        }
    }

    if (-not $dockerExe) {
        Write-Host "  -> ERROR: Docker Desktop not found. Please install Docker Desktop." -ForegroundColor Red
        exit 1
    }

    Start-Process $dockerExe
    Write-Host "  -> Waiting for Docker to be ready..." -ForegroundColor Yellow

    $maxRetries = 30
    $retryCount = 0
    while (-not (Test-DockerRunning)) {
        Start-Sleep -Seconds 2
        $retryCount++
        if ($retryCount -ge $maxRetries) {
            Write-Host "  -> ERROR: Docker Desktop failed to start within 60s." -ForegroundColor Red
            exit 1
        }
        Write-Host "  -> Waiting... ($retryCount/$maxRetries)" -ForegroundColor Gray
    }

    Write-Host "  -> Docker Desktop is ready!" -ForegroundColor Green
}

if (-not $SkipDockerCheck) {
    Start-DockerDesktop
} else {
    Write-Host "[1/4] Skipping Docker check (flag set)" -ForegroundColor Gray
}

# ------------------------------------------
# Step 2: Build & Start API container
# ------------------------------------------
Write-Host ""
Write-Host "[2/4] Starting Go API container (docker compose)..." -ForegroundColor Yellow

Set-Location $ProjectRoot
docker compose up -d --build api-go

if ($LASTEXITCODE -ne 0) {
    Write-Host "  -> ERROR: Failed to start API container." -ForegroundColor Red
    exit 1
}

Write-Host "  -> API container started: http://localhost:8080" -ForegroundColor Green

# ------------------------------------------
# Step 3: Wait for API to be healthy
# ------------------------------------------
Write-Host ""
Write-Host "[3/4] Waiting for API health check..." -ForegroundColor Yellow

$maxRetries = 15
$retryCount = 0
$apiReady = $false

while (-not $apiReady -and $retryCount -lt $maxRetries) {
    Start-Sleep -Seconds 2
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/health" -Method Get -ErrorAction SilentlyContinue
        if ($response.status -eq "ok") {
            $apiReady = $true
        }
    } catch {
        $retryCount++
        Write-Host "  -> Waiting for API... ($retryCount/$maxRetries)" -ForegroundColor Gray
    }
}

if ($apiReady) {
    Write-Host "  -> API is healthy!" -ForegroundColor Green
} else {
    Write-Host "  -> WARNING: API health check timed out. Container may still be building." -ForegroundColor Yellow
    Write-Host "  -> Check logs with: docker compose logs -f api-go" -ForegroundColor Yellow
}

# ------------------------------------------
# Step 4: Start Frontend dev server
# ------------------------------------------
Write-Host ""
Write-Host "[4/4] Starting frontend dev server..." -ForegroundColor Yellow

Set-Location $ProjectRoot
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c", "pnpm dev:web"

Write-Host "  -> Frontend starting: http://localhost:3000" -ForegroundColor Green

# ------------------------------------------
# Done
# ------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All services started!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Frontend:  http://localhost:3000" -ForegroundColor White
Write-Host "  Backend:   http://localhost:8080" -ForegroundColor White
Write-Host "  API Docs:  http://localhost:8080/api/health" -ForegroundColor White
Write-Host ""
Write-Host "  Stop all:  pnpm stop:all" -ForegroundColor Gray
Write-Host "  Logs:      docker compose logs -f api-go" -ForegroundColor Gray
Write-Host ""

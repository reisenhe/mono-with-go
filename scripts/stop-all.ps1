# ===========================================
# stop-all.ps1 - 停止完整开发环境
# ===========================================
# 用途: 停止前端 dev server + 停止并清理后端 Docker 容器

$ErrorActionPreference = "SilentlyContinue"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Mono With Go - Stopping Dev Env" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# Step 1: Stop Frontend dev server (node/vite)
# ------------------------------------------
Write-Host "[1/2] Stopping frontend dev server..." -ForegroundColor Yellow

# Kill any node processes running vite on port 3000
$viteProcesses = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty OwningProcess -Unique

if ($viteProcesses) {
    foreach ($pid in $viteProcesses) {
        try {
            Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
            Write-Host "  -> Killed process PID: $pid" -ForegroundColor Gray
        } catch {}
    }
    Write-Host "  -> Frontend server stopped." -ForegroundColor Green
} else {
    Write-Host "  -> No frontend server found on port 3000." -ForegroundColor Gray
}

# ------------------------------------------
# Step 2: Stop Docker containers
# ------------------------------------------
Write-Host ""
Write-Host "[2/2] Stopping Docker containers..." -ForegroundColor Yellow

Set-Location $ProjectRoot

# Check if Docker is available
$dockerRunning = $false
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { $dockerRunning = $true }
} catch {}

if ($dockerRunning) {
    docker compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  -> Docker containers stopped." -ForegroundColor Green
    } else {
        Write-Host "  -> WARNING: docker compose down had issues." -ForegroundColor Yellow
    }
} else {
    Write-Host "  -> Docker is not running, skipping." -ForegroundColor Gray
}

# ------------------------------------------
# Done
# ------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All services stopped!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

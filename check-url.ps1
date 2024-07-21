param(
    [string]$url
)

# Путь к файлу лога
$logFile = "google_check.log"

# Функция для записи в лог
function Write-Log {
    param([string]$message)
    Add-Content -Path $logFile -Value "$(Get-Date): $message"
}

# Функция проверки сайта
function WebRequest {
    param([string]$url)

    if (-not $url) {
        $errMsg = "URL параметр отсутсвует."
        Write-Host $errMsg
        Write-Log $errMsg
        return
    }

    $ports = 80, 443
    $results = @()

    foreach ($port in $ports) {
        for ($i = 1; $i -lt 4; $i++) {
            try {
                $uri = "http://${url}:$port"
                $stopwatch = New-Object System.Diagnostics.Stopwatch
                $stopwatch.Start()
                $response = Invoke-WebRequest -Uri $uri -TimeoutSec 10 -Method Head -ErrorAction SilentlyContinue
                $stopwatch.Stop()
                $success = $?
                $statusCode = $response.StatusCode
                $statusDescription = $response.StatusDescription
                $timeTaken = $stopwatch.ElapsedMilliseconds
                $message = "Порт $port Попытка ${i}: код ответа $statusCode - $statusDescription, Время ответа: $timeTaken ms"
                Write-Host $message
                Write-Log $message

                $results += [PSCustomObject]@{
                    TimeTaken = $timeTaken
                    ContentLength = $response.RawContentLength
                }

                if ($statusCode -ne 200) {
                    throw "Response code is not 200."
                }
            } catch {
                $errorMessage = "Проблема подклчения $url по порту $port при попытке ${i}: $_"
                Write-Host $errorMessage
                Write-Log $errorMessage
                continue
            }
        }
    }

    # Если все итерации были успешны, вызов функций подсчета
    if ($results) {
       calcTime $results
       calcWeight $results
    }
}

# Функция подсчета среднего времени ответа
function calcTime {
    param($results)
    $averageTime = ($results.TimeTaken | Measure-Object -Average).Average
    $message = "Среднее время отклика: ${averageTime} ms"
    Write-Host $message
    Write-Log $message
}

# Функция подсчета среднего размера ответа
function calcWeight {
    param($results)
    $averageSize = ($results.ContentLength | Measure-Object -Average).Average
    $message = "Средний размер: ${averageSize} bytes"
    Write-Host $message
    Write-Log $message
}

# Запуск основной функции с проверкой URL
WebRequest -url $url
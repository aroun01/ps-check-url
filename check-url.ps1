$url="https://google.com"
# Пока переменную с урлом просто объявляем, вставить функцию выборки ее из параметра $1


Function request # Функция с запросом, ее поочередно вызываем по три раза, сначала с http, потом с https
        {
        Invoke-WebRequest -Uri $url -UseDefaultCredentials -UseBasicParsing -Method Head -TimeoutSec 5 -ErrorAction Stop
        $resultcode=$?
        $statuscode = [int]$validation.StatusCode
        }

Function WebRequest
        {
                
                request #Делаем запрос, получаем коды состояния и ответа вебсервера
                Write-Output $resultcode
                Write-Output $statuscode
                
                # Вот тут надо разобраться как правильно парсить коды, они неправильно сейчас педеаются 

                #$validationresult = (Invoke-WebRequest -Uri $url -UseDefaultCredentials -UseBasicParsing -Method Head -TimeoutSec 5 -ErrorAction Stop)
                #$status = [int]$validation.StatusCode
                #if ($validationresult="True")
                #    {
                 #   Write-Host "Сайт доступен"
                 #   Write-Host $status
                  #  }
                    
 
                
                
                
       }

WebRequest

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# HTML vars
#$head = ""
#$scripts = ""
$body = ""

# Delimiter char
$delimit = "|"

# Write to the Azure Functions log stream.
Write-Host "'Average D3' function processed a request."

# Interact with query parameters or the body of the request, based on method type
$isQueryVars = $Request.Method -eq "GET"

if ($isQueryVars) {
    $incomingCollection = $Request.Query
    Write-Host "Using query variables via GET/POST (query variables override body)."
    Write-Host $incomingCollection.value
} else {
    $incomingCollection = $Request.Body
    Write-Host "Using body via POST."
    Write-Host $incomingCollection.value
}


# Setting values from request collection
$name = $incomingCollection.Name
$id = $incomingCollection.id

if ($isQueryVars) {
    $valueArray = $incomingCollection.value.Split($delimit)
} else {
    $valueArray = $incomingCollection.value
    Write-Host $valueArray
}

# For future service scaling idea
$processingArray = $valueArray

# Properties to return
if ($isQueryVars -eq $true) {
    Write-Host $processingArray
}

$numDays = $processingArray.length
$avg = ($processingArray | Measure-Object -Average).Average.ToString("#.##")
$consoleOutput = $incomingCollection.verbose

#TODO: include these values in future release
#$includeName =  $false #$incomingCollection.includeName
$outputCSV = $false #$incomingCollection.outputCSV

$body = "" #"<html><head>$head</head><body><div>"

if ($consoleOutput) {
    $body += "Hello, '$name', ID: $id . Your average D3 levels are: $avg IU over the last $numDays days"
} else {
    #$body +="'$name',"
    
    # Create CSV output
    if ($outputCSV) { 
        $body += "$id,$avg,$numDays;" 
    }
    
    # Create JSON output
    else {        
        $body = @{id=$id;value=$avg;count=$numDays;} | ConvertTo-Json
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

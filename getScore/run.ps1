using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

#Parsing name of measurement for GET or POST, respectively
#Parsing weight value for GET or POST, respectively
[string]$name = $Request.Query.name
# if ($name.Length -eq 0) {
if (-not $name) {
    $name = $Request.Body.name
}

Write-Host "Processing value for $name."

#Parsing weight value for GET or POST, respectively
[double]$weight = $Request.Query.weight
if (-not $weight) {
    $weight = $Request.Body.weight
}


#Parsing value quantity for GET or POST, respectively
[double]$value = 0.0 
$value = $Request.Query.value

if (-not $value) {
    [double]$value = $Request.Body.value.value
    if ((-not $value) -or ($value -le 0)) {
        [double]$value = $Request.Body.value
    }
}

$body = $weight * $value


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "'ionScore' trigger function processed a request."

# Interact with query parameters or the body of the request.
[double]$weight = $Request.Query.weight
if (-not $weight) {
    $weight = $Request.Body.weight
}

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

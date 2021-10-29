using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "'getWeights' HTTP trigger function processed a request."

# TODO: Externalize
$weights = @{}
$weights.add("VitaminD3" , 0.75)
$weights.add("Zinc" , 0.70)
$weights.add("Quercetin" , 0.50)

$weights.add("AntibodiesPresent", 0.92)
$weights.add("mRNA_Vac", 0.92)
$weights.add("adeno_Vac", 0.79)
$weights.add("other_Vac", 0.75)

$weights.add("bmi", 0.2)
$weights.add("septu", 0.3)
$weights.add("immunoComp", 0.15)

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$toJson = $Request.Query.toJson
if (-not $toJson) {
    $toJson = $Request.Body.toJson
}

# Return data set as a JSON object
if ($name.ToUpperInvariant() -eq "ALL") {
    $reqVal = $weights | ConvertTo-Json
}
else {
    # Return a JSON object if requested
    if ($toJson -ge 1) {
        $reqVal = @{$name = $weights[$name]}  | ConvertTo-Json
    }
    else {
        $reqVal = $weights[$name];
    }
}

#Return zero of key name is not in Dictionary
if (-not $reqVal) {
    $reqVal = 0;
}

#Write-Host $reqVal

#$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "$reqVal"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

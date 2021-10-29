using namespace System.Net

# Input bindings are passed in via param block.
param($Documents, $TriggerMetadata)

Write-Host "Start Trigger." 
Write-Host "Doc count: $($Documents.Count)"
#Write-Host "Doc1 count: $($Documents1.Count)"

if ($Documents.Count -gt 0) {
    
    $body = $Documents[0] | ConvertTo-Json

    Write-Host "Body: Name:$($Documents[0].name)" 
    Write-Host "Value: $($Documents[0].value)"

    #$body = $body | ConvertFrom-Json
    #$body | Add-Member -MemberType NoteProperty -Name "RowKey" -Value $Documents[0].id
    #$body | Add-Member -MemberType NoteProperty -Name "PartitionKey" -Value $Documents[0].id
    #$body.add("RowKey", $Documents[0].id)
    #$body.RowKey = $Documents[0].id

    Write-Host "Body type: $($Documents[0].value.GetType())"
    Write-Host "Converted output: $($body)"



    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name weightsTable -Value ($body) # | ConvertTo-Json)


    $res = [HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        #ContentType= "application/json"
        #Body = ($body.ToString())
    }
    #Write-Host "Response: $($res.body)"    
    #Push-OutputBinding -Name Response -Value [HttpResponseContext]$res
    #Push-OutputBinding -Name res1 -Value $res

    # Associate values to output bindings by calling 'Push-OutputBinding'.
   # Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
   #     StatusCode = [HttpStatusCode]::OK
   #     Body = "Processed"
   # }) -Clobber
} else {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::ACCEPTED
        Body = "No payload"
    })
}

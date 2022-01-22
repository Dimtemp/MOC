function Invoke-AzureCustomVisionPrediction {
    <#
    .SYNOPSIS
    This command uses the Azure Custom Vision service to perform predictions on pictures.
    .DESCRIPTION
    You need an existing Azure Custom Vision service to use this resource. Open the Custom Vision service here: www.customvision.ai. Select your project. Publish it and use the publish details when running this command.
    .EXAMPLE
    Invoke-AzureCustomVisionPrediction -Key 'pasteyourkeyhere' -ServiceUri 'https://vis1-prediction.cognitiveservices.azure.com/customvision/v3.0/Prediction/adaabac8-9b76-4784-9d3c-4931c802a25f/classify/iterations/Iteration1/url' -PictureUrl 'https://www.rtlnieuws.nl/sites/default/files/content/images/2019/12/07/ANP-402894008.jpg'
    This command displays a prediction on the specified URL.
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$ServiceUri,

        [Parameter(Mandatory)]
        [string]$PictureUrl,

        [switch]$RawOutput
    )

    $params = @{
        Uri     = $ServiceUri
        Headers = @{'Content-Type' = 'application/json'; 'Prediction-Key' = $Key}
        Body    = '{"Url": "' + $PictureUrl + '"}'
        Method  = 'Post'
    }
    Write-Verbose ($params | Out-String)

    $r = Invoke-WebRequest  @params 
    if ($RawOutput) {
        $r
    } else {
        ($r.Content | ConvertFrom-Json).Predictions
    }
}

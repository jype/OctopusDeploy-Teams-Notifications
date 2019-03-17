## Specify a title for the notification. Use template/parameter for more flexibility
$messageTitle = "Deploy Failed!"
## Use the URI you got when creating a connector for your Teams channel.
$webhookUri = "https://outlook.office.com/webhook/123@123/IncomingWebhook/123/123..."

$projectName = "#{Octopus.Project.Name}"
$environment = "#{Octopus.Environment.Name}"
$channel = "#{Octopus.Release.Channel.Name}"
$release = "#{Octopus.Release.Number}"

## It's recommended to specify your own base URI.
$baseUrl = "#{Octopus.Web.BaseUrl}"
$deploymentUri = "$baseUrl#{Octopus.Web.DeploymentLink}"

$body = 
@"
{
	"@type": "MessageCard",
	"@context": "https://schema.org/extensions",
	"summary": "Octopus Deploy Notification",
	"themeColor": "0078D7",
	"title": "[$projectName] $messageTitle",
	"sections": [
		{
			"facts": [
				{
					"name": "Environment",
					"value": "$environment"
				},
				{
					"name": "Channel",
					"value": "$channel"
				},
                {
                    "name": "Release",
                    "value": "$release"
                }
			],
			"text": ""
		}
	],
	"potentialAction": [
		{
			"@type": "OpenUri",
			"name": "View deploy in Octopus Deploy",
			"targets": [
				{
					"os": "default",
					"uri": "$deploymentUri"
				}
			]
		}
	]
}
"@

Invoke-WebRequest -Uri $webhookUri -Method POST -ContentType Application/Json -Body $body -UseBasicParsing
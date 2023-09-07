{
	"type": "message",
	"attachments": [
		{
			"contentType": "application/vnd.microsoft.card.adaptive",
			"contentUrl": null,
			"content": {
				"type": "AdaptiveCard",
				"body": [
					{
						"type": "Container",
						"items": [
							{
								"type": "TextBlock",
								"text": $title,
								"wrap": true,
								"size": "Large",
								"weight": "Bolder"
							}
						],
						"style": $style
					},
					{
						"type": "TextBlock",
						"text": $text,
						"wrap": true
					}
				],
				"actions": [
					{
						"type": "Action.OpenUrl",
						"title": $actionName,
						"url": $actionTarget
					}
				],
				"msteams": {
					"width": "Full"
				},
				"$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
				"version": "1.5"
			}
		}
	]
}
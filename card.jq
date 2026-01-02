{
	"type": "message",
	"attachments": [
		{
			"contentType": "application/vnd.microsoft.card.adaptive",
			"contentUrl": null,
			"content": {
				"$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
				"type": "AdaptiveCard",
				"version": "1.2",
				"actions": [
					(if ($BUTTON_URL | length) > 0 then {
						"type": "Action.OpenUrl",
						"title": (if ($BUTTON_TEXT | length) > 0 then $BUTTON_TEXT else "URL" end),
						"url": $BUTTON_URL
					} else empty end),
					(if ($EXPANDABLE_TEXT | length) > 0 then {
						"type": "Action.ShowCard",
						"title": (if ($EXPANDABLE_TITLE | length) > 0 then $EXPANDABLE_TITLE else "View more" end),
						"iconUrl": (if ($EXPANDABLE_LOGO | length) > 0 then $EXPANDABLE_LOGO else null end),
						"card": {
							"type": "AdaptiveCard",
							"body": [
								{
									"type": "TextBlock",
									"text": $EXPANDABLE_TEXT,
									"size": "small",
									"wrap": true
								}
							]
						}
					} else empty end)
				],
				"body": (if ($IMAGE_URL | length) > 0
					then [
						{
							"type": "ColumnSet",
							"columns": [
								{
									"type": "Column",
									"items": [
										{
											"type": "TextBlock",
											"text": $TITLE,
											"color": $COLOR,
											"eight": "bolder",
											"size": "large",
											"wrap": true
										},
										{
											"type": "TextBlock",
											"text": $TEXT,
											"color": $COLOR,
											"size": "small",
											"wrap": true
										}
									]
								},
								{
									"type": "Column",
									"width": "auto",
									"verticalContentAlignment": "center",
									"items": [
										{
											"type": "Image",
											"url": $IMAGE_URL
										}
									]
								}
							]
						}
					]
					else [
						{
							"type": "TextBlock",
							"text": $TITLE,
							"color": $COLOR,
							"eight": "bolder",
							"size": "large",
							"wrap": true
						},
						{
							"type": "TextBlock",
							"text": $TEXT,
							"color": $COLOR,
							"size": "small",
							"wrap": true
						}
					] end)
			}
		}
	]
}
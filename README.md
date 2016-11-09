based on the cloudfoundry slack resource https://github.com/cloudfoundry-community/slack-notification-resource

# Teams notification sending resource 

Sends messages to [Teams](https://teams.microsoft.com).

## Source Configuration

* `url`: *Required.* The webhook URL as provided by Teams. Usually in the form: `https://outlook.office365.com/webhook/XXX`

## Behavior

### `out`: Sends message to Teams. 

Send message to Teams, with the configured parameters.

#### Parameters

* `text`: *Required.* Text of the message to send. Can contain links in form `<http://example.com>` or `<http://example.com|Click here!>`


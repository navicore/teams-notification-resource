# Teams notification sending resource 

Sends messages to [Teams](https://teams.microsoft.com).

## Source Configuration

* `url`: *Required.* The webhook URL as provided by Teams when you add a
connection for "Generic Webhook". Usually in the
form: `https://outlook.office365.com/webhook/XXX`

## Behavior

### `out`: Sends message to Teams 

Send message to Teams, with the configured parameters on a channel specified
at the time the url was created. 

#### Parameters

* `text`: *Required.* Text of the message to send.
* `TextFormat`: *Optional.* default is `markdown`


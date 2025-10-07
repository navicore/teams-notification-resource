# Concourse CI Teams Workflow Resource

Send messages to [Microsoft Teams](https://teams.microsoft.com) from [Concourse CI](https://concourse-ci.org/) pipelines using the Microsoft Teams Workflow: “Post to a chat when a webhook request is received.”  
Legacy Office 365 Connectors are deprecated; this resource now targets the new workflow format (Adaptive Cards via workflow webhook).

![Teams Adaptive Card](images/teams2.png)

## Runtime Variable Expansion

Concourse environment variables in params are resolved at runtime, e.g.:

```
$BUILD_ID
$BUILD_NAME
$BUILD_JOB_NAME
$BUILD_PIPELINE_NAME
$BUILD_TEAM_NAME
$ATC_EXTERNAL_URL
```

## Status

* Actively maintained (updated for Teams Workflow replacement of deprecated connectors)
* Works with current Adaptive Card workflow webhooks

## Setup (Get a Workflow Webhook URL)

1. In Teams, open the target channel (or chat).
2. Choose “Workflows” (or “Apps” -> search “Workflows”) and add the template “Post to a chat when a webhook request is received.”
3. Finish the template; copy the generated webhook URL.
4. Use that URL as `source.url` in the resource definition.

## Resource Type Definition

```yaml
resource_types:
  - name: teams-notification
    type: docker-image
    source:
      repository: navicore/teams-notification-resource
      tag: v0.x.x   # use the desired version
```

## Resource Configuration (Source)

```yaml
resources:
  - name: alert
    type: teams-notification
    source:
      url: ((teams_webhook_url))          # required (workflow webhook)
      proxy_url: https://proxy.example    # optional
      proxy_port: 3128                    # optional
      proxy_username: myuser              # optional
      proxy_password: ((proxy_pass))      # optional
      skip_cert_verification: true        # optional
      verbose: true                       # optional
      silent: true                        # optional (overrides verbose output)
```

Fields:

* url: Required. Teams workflow webhook URL.
* proxy_*: Optional HTTP proxy support (basic auth).
* skip_cert_verification: Optional; adds curl -k.
* verbose: Optional; adds curl -v.
* silent: Optional; adds curl -s (suppresses progress/log noise).

## Params (put)

Exactly one of text or text_file must be provided.

| Param | Required | Description |
|-------|----------|-------------|
| text | one of | Inline message body (markdown supported). Overrides text_file if both given. |
| text_file | one of | Path (within input dir) to file containing message body (markdown). |
| title | optional | Card title. Default: Concourse CI. |
| color | optional | Adaptive Card TextBlock color: default, dark, light, accent, good, warning, attention. Default: default. |
| button_url | optional | URL for main action button (not shown if empty). |
| button_text | optional | Text for button. Default: URL. |
| image_url | optional | Image displayed in a side column. |
| expandable_text | optional | Adds an Action.ShowCard button if provided. |
| expandable_title | optional | Title for expand button. Default: View more. |
| expandable_logo | optional | iconUrl for expand button (optional). |
| Legacy fallback (still accepted): actionName -> button_text, actionTarget -> button_url, style -> color (if valid). |
| Deprecated / Removed: Previous connector-specific style heuristics; direct connector formatting. |

Behavior notes:

* If text_file path does not exist: _(NO MSG FILE)_.
* If file exists but blank: _(EMPTY MSG FILE)_.
* If neither provided: _(NO MSG)_ (generally you should supply one).

## Example Pipeline Usage

```yaml
jobs:
  - name: test-pull-request
    plan:
      - get: pr-repo
        trigger: true
      - task: run-tests
        file: pr-repo/ci/test.yml
        on_success:
          put: alert
          params:
            title: PR Tests Passed
            color: good
            text: |
              Pull request tested: success
              Build: $BUILD_NAME
            button_text: View Build
            button_url: $ATC_EXTERNAL_URL/teams/$BUILD_TEAM_NAME/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME
            expandable_text: |
              Detailed environment:
              * Pipeline: $BUILD_PIPELINE_NAME
              * Team: $BUILD_TEAM_NAME
              * Job: $BUILD_JOB_NAME
        on_failure:
          put: alert
          params:
            title: PR Tests Failed
            color: attention
            text_file: pr-repo/output/test-summary.txt
            button_text: View Failing Build
            button_url: $ATC_EXTERNAL_URL/teams/$BUILD_TEAM_NAME/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME
            image_url: https://example.com/failure-icon.png
```

## Backward Compatibility

Older params actionName / actionTarget and style are mapped internally:

* actionName -> button_text
* actionTarget -> button_url
* style -> color (if a valid color token)
You should migrate to the new names.

## Development

Scripts:

* out: Builds Adaptive Card JSON via jq and posts to workflow webhook.
* card.jq: Template used by out script (pure jq).

Local testing (proxy example):

```
sudo service squid start
# adjust /etc/squid/squid.conf as needed
sudo service squid restart
```

We welcome PRs for additional proxy auth mechanisms (e.g., NTLM/kerberos variants).

## Testing

Add a temporary job using the resource and vary params (color, button_url, image_url, expandable_text) to verify rendering in Teams.

## Troubleshooting

| Issue | Cause | Resolution |
|-------|-------|-----------|
| 400 Bad Request | Malformed JSON | Enable verbose: set verbose: true in source, inspect output. |
| Missing button | button_url empty | Supply button_url. |
| Expand section missing | expandable_text empty | Provide expandable_text. |
| Color not applied | Invalid color value | Use allowed list. |

## License

MIT (see repository root).

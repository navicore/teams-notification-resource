# Concourse CI Teams Resource

Sends messages to [Microsoft Teams](https://teams.microsoft.com) from within Concourse CI
pipelines.

Implements the Microsoft Teams [Connector](https://dev.outlook.com/Connectors/Reference) protocols and
the Concourse CI [resource](https://concourse.ci/implementing-resources.html) protocols.

Resolves at runtime Concourse CI environment variables referenced in your Teams
connector messages such as:

```
$BUILD_ID
$BUILD_NAME
$BUILD_JOB_NAME
$BUILD_PIPELINE_NAME
$BUILD_TEAM_NAME
$ATC_EXTERNAL_URL
```

## STATUS

* Alpha Quality
* But it works - meets my needs

*Limitations*:

* *Message payload is limited to markdown.*
* *Assumes every message should be presented with a link/button.*
* *does not ensure ssl cert at the office.com end is corret (uses -k on curl)*
* *naive encoding - it may be that user data containing special chars will outbound messaging - though passing links with markdown works fine for me so far*

## TODO

* document examples of passing along PR numbers and git user info
* make `potentialAction` button/link optional

## Source Configuration

```
resources:

  - name: alert
    type: teams-notification
    source:
      url: https://outlook.office365.com/webhook/blah-blah-blah
```
* `url`: *Required.* The webhook URL as provided by Teams when you add a
connection for "Generic Webhook". Usually in the
form: `https://outlook.office365.com/webhook/XXX`

don't forget to define the non-built-in type:

```
resource_types:

- name: teams-notification
  type: docker-image
  source:
    repository: navicore/teams-notification-resource
    tag: latest
```

## Param Configuration

example of an alert in a pull-request job
```
- name: Test-Pull-Request
  plan:
  - get: {{mypipeline}}-pull-request
    trigger: true
  - task: test-pr
    file: {{mypipeline}}-pull-request/pipeline/test-pr.yml
    on_success:
      put: alert
      params:
        text: |
          pull request tested: with no errors
        title: {{mypipeline}} Pull Request Tested
        actionName: {{mypipeline}} Pipeline
        actionTarget: $ATC_EXTERNAL_URL/teams/$BUILD_TEAM_NAME/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME
    on_failure:
      put: alert
      params:
        color: EA4300
        text: |
          pull request tested: **WITH ERRORS**
        title: {{mypipeline}} Pull Request Tested
        actionName: {{mypipeline}} Pipeline
        actionTarget: $ATC_EXTERNAL_URL/teams/$BUILD_TEAM_NAME/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME
```

* `text`: *Required.* Text of the message to send - markdown supported
* `title`: *Optional.*
* `actionName`: *Optional.* Text on the button/link
* `actionTarget`: *Optional.* URL to connect to the button/link


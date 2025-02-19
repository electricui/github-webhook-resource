Github Webhook Resource
===================================

A concourse resource to automatically configure Github webhooks to trigger resource polls. 

This is a fork of the [original](https://github.com/homedepot/github-webhook-resource) with additional APIs to allow cross-pipeline mutation of webhooks and some other cleanup.

Resource Type Configuration
---------------------------

```yaml
resource_types:
- name: github-webhook-resource
  type: docker-image
  source:
    repository: electricui/github-webhook-resource
    tag: latest
```
Source Configuration
--------------------

```yaml
resources:
- name: github-webhook
  type: github-webhook-resource
  source:
    github_token: ((github-token))
```

-	`github_api`: The Github API URL for your repo, default is `https://api.github.com`.
- `github_token`: *Required.* [A Github token with the `admin:repo_hook` scope.](https://github.com/settings/tokens/new?scopes=admin:repo_hook) Additionally, the token's account must [be an administrator of your repo](https://help.github.com/en/articles/managing-an-individuals-access-to-an-organization-repository) to manage the repo's webhooks.

Behavior
--------

### `out`: Manipulate a Github webhook

Create or delete a webhook using the configured parameters.

#### Parameters

```yaml
- put: create-webhook
  resource: github-webhook
  params:
    org: github-org-name
    repo: github-repo-name
    resource_name: your-resource-name
    webhook_token: your-token
    operation: create
    events: [push, pull_request]
```

-	`org`: *Required.* Your github organization.
-	`repo`: *Required.* Your github repository.
-	`resource_name`: *Required.* Name of the resource to be associated with your webhook.
-	`webhook_token`: *Required.* Arbitrary string to identify your webhook. Must match the `webhook_token` property of the resource your webhook points to.
-	`operation`: *Required.*
    -   `create` to create a new webhook. Updates existing webhook if your configuration differs from remote.
    -   `delete` to delete an existing webhook. Outputs current timestamp on non-existing webhooks.
-   `events`: *Optional*. An array of [events](https://developer.github.com/webhooks/#events) which will trigger your webhook. Default: `push`
-	`team_name`: The concourse team name of the pipeline receiving the webhook, by default is the team name of the pipeline executing this put.
-	`pipeline_name`: The name of the pipeline receiving the webhook, by default is the pipeline executing this put.

## Development
### Prerequisites
- [Node.js](https://nodejs.org/)
- [Docker](https://www.docker.com/)

### Making changes
The Concourse entrypoints are in `bin/check`, `bin/in`, and `bin/out`. You can add functionality to these files directly, or you can `require` additional supporing files.

See the [Reference](#Reference) section for some helpful information related to this project's implementation.

### Running the tests
```shell
npm install
npm test
```
Before submitting your changes for review, ensure all tests are passing.

### Building your changes
```shell
docker build -t github-webhook-resource .
```

To use the newly built image, push it to a Docker repository which your Concourse pipeline can access and configure your pipeline to use it:

```shell
docker build ./ -t electricui/github-webhook-resource
docker push electricui/github-webhook-resource
```

```yaml
resource_types:
- name: github-webhook-resource
  type: docker-image
  source:
    repository: electricui/github-webhook-resource
    tag: latest

resources:
- name: github-webhook
  type: github-webhook-resource
  ...
```

### Contributing
Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file to learn the process for submitting changes to this repo.

## License
This project is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) - see the [LICENSE](LICENSE) file for details.

## Reference
- [Implementing a Concourse Resource](https://concourse-ci.org/implementing-resource-types.html)
- [What is a Webhook?](https://help.github.com/articles/about-webhooks/)
- [GitHub's Webhook REST API](https://developer.github.com/v3/repos/hooks/)
- [Concourse Community Resources](https://github.com/concourse/concourse/wiki/Resource-Types)

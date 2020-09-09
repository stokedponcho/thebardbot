# TheBardBot

A Slack bot to declare your flame to your friends, inspired from [Shakespeare Insult Generator](https://www.worldofbooks.com/en-gb/books/barry-kraft/shakespeare-insult-generator/9781452127750).

A first project using [Elixir] and a first foray into a functional language.

## Overview

Simple API using [cowboy], [plug] and [jason].

Releases are built into a container using [podman].

Deployments are made with Ansible.

## Deployment process

### First time setup

Creates a dedidcated user to run the Podman image on the remote server and a new service.

```bash
./release.sh setup
```

### Building an image for a release

```bash
./release.sh build
```

### Deploying the image

```bash
./release.sh deploy
```

Initial attempts to load the image into Podman on the server via Ansible failed. Used [script](https://git.snopyta.org/mournfulfrog/thebardbot/src/branch/master/rel/ansible/templates/service.j2) to load it when starting the service instead.

## Thoughts

- The project/files organisation feels a bit all over the place, felt I kept thinking with an OOP mindset. If a functional programming enthusiasts stubbles upon this, your thoughts are welcome!
- BotInterpreter to use is defined by configuration but middleware reference for Slack authentication and challenge is hard coded - probably never going to be an issue but it would be nice to figure out how to Plug conditional... plugs.
- Considering all Slack interactions are driven by the body of the request, maybe having a classic controller approach does not feel adequate. Maybe a pipeline of Plugs would be more suited? This would mean calling Plug.Conn.halt() everytime, not sure this is a correct way to use it.
- Tests are a bit of a mess, with a mix of unit and integration ones in the same files.
- Replace `requests.sh` with proper integration tests.
- Use system configuration/container environment variables for Slack production API host, Authorization header and request authentication token.
- Handling errors from request with [mint] properly.
- Replace token verification - <https://api.slack.com/authentication/verifying-requests-from-slack>.

[Elixir]:<https://elixir-lang.org/>
[cowboy]:<https://hex.pm/packages/cowboy>
[plug]:<https://hex.pm/packages/plug>
[jason]:<https://hex.pm/packages/jason>
[podman]:<https://podman.io/>
[mint]:<https://hex.pm/packages/mint>

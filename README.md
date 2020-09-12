# TheBardBot

A Slack bot to declare your flame to your friends, inspired from [Shakespeare Insult Generator](https://www.worldofbooks.com/en-gb/books/barry-kraft/shakespeare-insult-generator/9781452127750).

A first project using [Elixir] and a first foray into a functional language.

## Overview

Simple API using [cowboy], [plug] and [jason].

Releases are built into a rootless container using [podman].

Deployments are made manually with Ansible.

## Deployment process

<https://git.snopyta.org/mournfulfrog/thebardbot/src/branch/master/rel>

### First time setup

Creates a dedidcated user to run the Podman image on the remote server and a new service.

```bash
./release.sh setup
```

### Build an image for a release

```bash
./release.sh build
```

### Deploy the image

```bash
./release.sh deploy
```

Initial attempts to load the image into Podman on the server via Ansible failed. Used [script](https://git.snopyta.org/mournfulfrog/thebardbot/src/branch/master/rel/ansible/templates/service.j2) to load it when starting the service instead.

## Thoughts and improvements

- The project/files organisation feels a bit all over the place, felt I kept thinking with an OOP mindset. If a functional programming enthusiasts stubbles upon this, your thoughts are welcome!
- BotInterpreter to use is defined by configuration but middleware reference for Slack authentication and url verification is hard coded - probably never going to be an issue but it would be nice to figure out how to Plug conditional... plugs.
- Considering all Slack interactions are driven by the body of the request, maybe having a classic controller with routes approach is not adequate. Maybe a pipeline of Plugs would be more suited? This would mean calling Plug.Conn.halt() everytime though, not sure there is any drawback to that.
- The "authed_users" notion of Slack is leaking into the `Core.Bard` module's logic.
- The `Core.Bard` module could be split into smaller ones.
- Tests are a bit of a mess, with a mix of unit and integration ones in the same files.
- Replace `requests.sh` with proper integration tests.
- Use system configuration/container environment variables for Slack production API host, Authorization header and request authentication token.
- Improve handling of responses and errors from requests made with [mint] - probably move it to a dedicated module as well.
- Replace token verification with signed secrets - <https://api.slack.com/authentication/verifying-requests-from-slack>.

[Elixir]:<https://elixir-lang.org/>
[cowboy]:<https://hex.pm/packages/cowboy>
[plug]:<https://hex.pm/packages/plug>
[jason]:<https://hex.pm/packages/jason>
[podman]:<https://podman.io/>
[mint]:<https://hex.pm/packages/mint>

## References

Articles that helped me during the work on this project.

- [Mocks and explicit contracts](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)
- [Create a Custom Plug ](https://dev.to/codemy/create-a-custom-plug-l91)
- [Deploying Elixir (1 of 3): Building Releases With Mix ](https://dev.to/jonlunsford/deploying-elixir-1-of-3-building-releases-with-mix-1o4a)
- [Deploying Elixir (3 of 3): Provisioning EC2 With Ansible](https://dev.to/jonlunsford/deploying-elixir-3-of-3-provisioning-ec2-with-ansible-10o4)
- [Multi-stage Docker and Elixir releases](https://dev.to/shmink/multi-stage-docker-and-elixir-releases-1ce2)

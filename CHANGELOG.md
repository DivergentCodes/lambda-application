# CHANGELOG

<!-- version list -->

## v0.3.0-dev.1 (2025-08-24)

### Bug Fixes

- **release**: Remove unneeded arg
  ([#24](https://github.com/DivergentCodes/lambda-application/pull/24),
  [`af712a3`](https://github.com/DivergentCodes/lambda-application/commit/af712a30e2ab89d78519a241bd94bacaf3927135))

- **release**: Update release env name
  ([#23](https://github.com/DivergentCodes/lambda-application/pull/23),
  [`9b4e18d`](https://github.com/DivergentCodes/lambda-application/commit/9b4e18dbc9bff7fe86d4623d15ff5eb87fd6ba78))

### Features

- **gha**: Set workflow permissions for OIDC
  ([#27](https://github.com/DivergentCodes/lambda-application/pull/27),
  [`a5f8398`](https://github.com/DivergentCodes/lambda-application/commit/a5f8398c3b0daea38aec4ffa9f05137bb087ebe7))

- **release**: Id-token write permissions
  ([#26](https://github.com/DivergentCodes/lambda-application/pull/26),
  [`638c750`](https://github.com/DivergentCodes/lambda-application/commit/638c75001f8d4f13cc32aecb17e7f20d410009e0))

- **release**: Release Docker images to ECR
  ([#22](https://github.com/DivergentCodes/lambda-application/pull/22),
  [`9790089`](https://github.com/DivergentCodes/lambda-application/commit/9790089d5ac8c97438cccacce9c60b71008b2182))

- **release**: Release with AWS OIDC
  ([#25](https://github.com/DivergentCodes/lambda-application/pull/25),
  [`80c569d`](https://github.com/DivergentCodes/lambda-application/commit/80c569d583a79cc8a2b76322cd74dfef757523de))


## v0.2.0 (2025-08-24)

### Features

- **build**: Build Docker images instead of zip archive
  ([#21](https://github.com/DivergentCodes/lambda-application/pull/21),
  [`5948cf2`](https://github.com/DivergentCodes/lambda-application/commit/5948cf23a0bd7a438f8012aa5a6c7520288e503e))


## v0.1.0 (2025-08-11)

### Bug Fixes

- **gha**: No more detatched head via merge queue
  ([`4f4ae25`](https://github.com/DivergentCodes/lambda-application/commit/4f4ae2550ea8c7e730ee42b7cc2fbc790f873e0c))

- **gha**: Trigger PSR publish
  ([`4c5f673`](https://github.com/DivergentCodes/lambda-application/commit/4c5f673d54ac5ebcc759af6cae73ace8c733926f))

- **gha**: Trigger PSR publish
  ([`ae40225`](https://github.com/DivergentCodes/lambda-application/commit/ae40225fdc8d219e4497610e61adec8b3b562f50))

### Chores

- **gha**: Refactor
  ([`d8c1cd9`](https://github.com/DivergentCodes/lambda-application/commit/d8c1cd989c43694282670da1e884f2d7307dec9c))

### Features

- Bootstrap tag for semantic release
  ([`c411824`](https://github.com/DivergentCodes/lambda-application/commit/c41182485f04538d259d8a67eadabc933b9296b2))

- Conventional commit script and workflow
  ([`5be074f`](https://github.com/DivergentCodes/lambda-application/commit/5be074f117c65c0563d1ddf208428f6c1a41b38c))

- Publish sets identity when in CI
  ([`97f1122`](https://github.com/DivergentCodes/lambda-application/commit/97f112213f04692ad56820dfb34356e4d671829b))

- **dev**: Add python-semantic-release package
  ([`5d2918a`](https://github.com/DivergentCodes/lambda-application/commit/5d2918a1bdfdf3a65634c70c72ea50ae90ddc849))

- **dev**: Add setuptools-scm package to dev deps
  ([`3a24790`](https://github.com/DivergentCodes/lambda-application/commit/3a2479061f51d039fd0d834351b58261f26eb017))

- **gha**: Add publish script
  ([`ebc125e`](https://github.com/DivergentCodes/lambda-application/commit/ebc125e25b75672007850cb1bd1a77abaf375058))

- **gha**: Add publish workflow
  ([`947c429`](https://github.com/DivergentCodes/lambda-application/commit/947c42930024e6f2b2b412df4d2172b65f457607))

- **gha**: Add version tag scripts
  ([`2c5fc3f`](https://github.com/DivergentCodes/lambda-application/commit/2c5fc3f68e944f1cf9a8aa13d047afa4bcd8ba80))

- **gha**: Always push bootstrap tags
  ([#18](https://github.com/DivergentCodes/lambda-application/pull/18),
  [`72eb939`](https://github.com/DivergentCodes/lambda-application/commit/72eb9393002b89b658927a2ca50b68cca0e24d31))

- **gha**: Debug semantic release
  ([#15](https://github.com/DivergentCodes/lambda-application/pull/15),
  [`f550f68`](https://github.com/DivergentCodes/lambda-application/commit/f550f68747c815765f3a2f0253eac84d193a6e07))

- **gha**: Enable pushing bootstrapped tag
  ([`6d5f123`](https://github.com/DivergentCodes/lambda-application/commit/6d5f123876e1282b7c448db159aed9bc6a77e2e3))

- **gha**: Publish workflow uses version tag scripts
  ([`196d567`](https://github.com/DivergentCodes/lambda-application/commit/196d567912e1720d4d926c090d2ae263ae800633))

- **gha**: Refine semantic release
  ([#16](https://github.com/DivergentCodes/lambda-application/pull/16),
  [`ba0f1e6`](https://github.com/DivergentCodes/lambda-application/commit/ba0f1e685e71df0454af7e2eca4d43d1563d26a0))

- **gha**: Semantic release 4 ([#17](https://github.com/DivergentCodes/lambda-application/pull/17),
  [`c582932`](https://github.com/DivergentCodes/lambda-application/commit/c582932390ec605be2928b09838d94af0b2db883))

- **gha**: Show S3 publish path
  ([#20](https://github.com/DivergentCodes/lambda-application/pull/20),
  [`13b264f`](https://github.com/DivergentCodes/lambda-application/commit/13b264f1d6432efa4386aa72ed7d157b186b3d3a))

- **gha**: Tag argument on publish
  ([#14](https://github.com/DivergentCodes/lambda-application/pull/14),
  [`9463435`](https://github.com/DivergentCodes/lambda-application/commit/946343504dd369587e5c83523c9d5e1406d9b5bc))

- **gha**: Tag first command with v0.0.0 bootstrap
  ([`46ddd51`](https://github.com/DivergentCodes/lambda-application/commit/46ddd518ab8f327b8ee42d408f2311968ffca1f6))

- **gha**: Use --skip-build --no-commit in PSR version
  ([#19](https://github.com/DivergentCodes/lambda-application/pull/19),
  [`0acd245`](https://github.com/DivergentCodes/lambda-application/commit/0acd245a40b16d243ea98bd708eeb1133fc5649a))

- **gha**: Use explicit ref_name during checkout
  ([`c28b3a7`](https://github.com/DivergentCodes/lambda-application/commit/c28b3a70658c21c5be2999151f8d58c5e5e2ae13))

- **gha**: Use setuptools-scm for tag-based publishing
  ([`cdc4fdf`](https://github.com/DivergentCodes/lambda-application/commit/cdc4fdf891e452a437d34611a10ebf119eaa367c))


## v0.0.0 (2025-08-11)

- Initial Release

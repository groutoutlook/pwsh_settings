# Changelog

## [1.1.0](https://github.com/groutoutlook/pwsh_settings/compare/v1.0.0...v1.1.0) (2025-04-18)


### Features

* add :m for better experience with writing config. ([5ffe244](https://github.com/groutoutlook/pwsh_settings/commit/5ffe24495517e73c37507a6f913719fcab9a704f))
* add `ccb`, wrap over `code --goto` to open files quicker in vscode. ([cd74511](https://github.com/groutoutlook/pwsh_settings/commit/cd745118472be8b054fd6909affbc5237f64b2e9))
* add `rgo` as grep only things not on Journal ([aa5e3eb](https://github.com/groutoutlook/pwsh_settings/commit/aa5e3eb7a82c840844ab7430049a9191ad4b67c0))
* add default WindowsPowerShell_profile for developer profile. ([93c112a](https://github.com/groutoutlook/pwsh_settings/commit/93c112ac4bc018405d89f8398443fdd25dd2f652))
* add jjmp ([6137460](https://github.com/groutoutlook/pwsh_settings/commit/6137460a06257be62dacdc1f96111175af61ba90))
* add Restart-Job and alias rstjb ([3df9b96](https://github.com/groutoutlook/pwsh_settings/commit/3df9b9679bc6fd1510261b12e459b559c13ed091))
* add shim files search and Extract-Path on string/files ([43e0c06](https://github.com/groutoutlook/pwsh_settings/commit/43e0c06f5642b0a663642d5e7e95d90bcdfaba6e))
* add some more alias as `btm` to `top` and `numbat` to `bc` ([51564ff](https://github.com/groutoutlook/pwsh_settings/commit/51564ff5af756fca1a06201fd5d9e29d3eb9c4b4))
* alias `r` to `just` instead of default `Invoke-History` ([52efef2](https://github.com/groutoutlook/pwsh_settings/commit/52efef28a4ec53ff8976cb51ba2c231c2d52bd26))
* build-fromkeil ([4162eaf](https://github.com/groutoutlook/pwsh_settings/commit/4162eaff4baf90906625d388f317c73b970faaeb))
* enhanced symlink experience ([0170d84](https://github.com/groutoutlook/pwsh_settings/commit/0170d84cfa853e45385c56e29d768ed1f8de1302))
* jmpv now filter end=999 ([9336c3f](https://github.com/groutoutlook/pwsh_settings/commit/9336c3fc870e5f4eb139bd50f6041fff96d1c535))
* **mpv:** better playlist adjusting ([b8da5cb](https://github.com/groutoutlook/pwsh_settings/commit/b8da5cb74f6e771e7ff8b9dc35a243bb59546252))
* **mpv:** now add background music mode ([76d7da8](https://github.com/groutoutlook/pwsh_settings/commit/76d7da8193239048c52c4cc971aa0836452c71c6))
* Now send-keys across process ([ad4cf18](https://github.com/groutoutlook/pwsh_settings/commit/ad4cf186933cdcf25decd1ab22e029666a5b2614))
* now we add `alt+m` as bc expression, for scripting indeed. ([3131cf6](https://github.com/groutoutlook/pwsh_settings/commit/3131cf6104993c31033d3c37d4df988e6d1fa047))
* zoxide query as `zo` ([3bc5ce5](https://github.com/groutoutlook/pwsh_settings/commit/3bc5ce5c8d6d71770fc70d052268b30aae9ef683))


### Bug Fixes

* add `xcb` and delete more nonsense on the code. ([8213643](https://github.com/groutoutlook/pwsh_settings/commit/8213643089e39a8778a7c55f1b46bb3e2d13d94d))
* also change default EDITOR to hx if ever switch to minimal ([c8f798a](https://github.com/groutoutlook/pwsh_settings/commit/c8f798a81e0f0bb7e8e7196c1ed03f81d22d94d5))
* better get-pathfromfiles, but overall still very hacky ([a5b5ac4](https://github.com/groutoutlook/pwsh_settings/commit/a5b5ac431b80b5da151349631b0133360afe5d26))
* change new nvim app to viniv ([5151f51](https://github.com/groutoutlook/pwsh_settings/commit/5151f5198a861ffc58316fa0138b80620f99cf1d))
* helix requires me to put a valid number behind colon ([ee5fbe6](https://github.com/groutoutlook/pwsh_settings/commit/ee5fbe68075de9873919bd9599383c6350116ea1))
* **jrnl:** utils function get correct value. ([d044050](https://github.com/groutoutlook/pwsh_settings/commit/d0440500ac1b5bb5c62993ea75d917ac0955e7d9))
* **mpv:** now it have a correct quick dirty function to play ([c81d18f](https://github.com/groutoutlook/pwsh_settings/commit/c81d18f823c222163ef298b22117fd4eafe71069))
* now we can add flag into my wrapper, normally ([95ff730](https://github.com/groutoutlook/pwsh_settings/commit/95ff73025580f31d2a2fa3ca041b7e1d85c380cd))
* **rg:** CLI-Basic.psm1 now do rgj inbound check. ([9a56d1e](https://github.com/groutoutlook/pwsh_settings/commit/9a56d1eb0f6a883c9224f11c62dbe5517516dddd))
* **utils:** now use `Get-Content` instead of `cat` ([f70a7d2](https://github.com/groutoutlook/pwsh_settings/commit/f70a7d286553161e8811be85f9a1cfa491e1c00b))

## [1.1.0](https://github.com/groutoutlook/pwsh_settings/compare/v1.0.0...v1.1.0) (2024-10-01)


### Features

* **utils:** add fallback to the `rgj` commands ([b965e8b](https://github.com/groutoutlook/pwsh_settings/commit/b965e8be265755d69a99ee01ac69714302274bb1))


### Bug Fixes

* **utils:** mousemaster manually reset. ([6e4a948](https://github.com/groutoutlook/pwsh_settings/commit/6e4a9485965d5417fb740ae1cfdf00a4821e2f8c))

## 1.0.0 (2024-10-01)


### Bug Fixes

* **rg:** CLI-Basic.psm1 now do rgj inbound check. ([9a56d1e](https://github.com/groutoutlook/pwsh_settings/commit/9a56d1eb0f6a883c9224f11c62dbe5517516dddd))
* **utils:** now use `Get-Content` instead of `cat` ([f70a7d2](https://github.com/groutoutlook/pwsh_settings/commit/f70a7d286553161e8811be85f9a1cfa491e1c00b))

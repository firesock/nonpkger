# nonpkger

Need a way to manage all the `curl https://example.com/install.sh | bash`
invocations? `nonpkger` is a package unwrapper, to just pull out the final
executable(s) you need into a folder in your path.

Requirements: Docker (new enough to include buildx) and bash.

## Usage

- Create a folder for your resulting binaries e.g. "~/nonpkger-bin".
- Add the full path to an exported variable called `NONPKGER_DIR`.
- Arrange to have the path also added to `$PATH`.
- Clone the repo into wherever code lives.
- Add all `curl | bash` invocations to `invoke.bash` in the cloned repo
(`.gitignore`d). Include a corresponding cp from installed location to
`/nonpkger` at the end.
- Run `nonpkger.bash` whenever you want to install/update all the files.

## Notes

- Runs installation script inside an Ubuntu LTS docker container.
- All scripts are run inside bash with `set -euo pipefail`.
- Intended mainly for single-executable setups that do not need to be isolated
such as dev tooling.
- **Purely a convenience setup, no docker security features are enabled.**

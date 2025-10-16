# nonpkger

Need a way to manage all the `curl https://example.com/install.sh | sh`
invocations? `nonpkger` is a package unwrapper, to just pull out the final
executable(s) you need into a folder in your path.

Requirements: Docker (new enough to include buildx) and bash.

## Usage

- Create a folder for your resulting binaries e.g. "~/nonpkger".
- Add the full path to an exported variable called `NONPKGER_DIR`.
- Arrange to have the path also added to `$PATH`.
- Clone the repo into wherever code lives.
- Add all `curl | bash` invocations to `invoke.bash` in the cloned repo
(`.gitignore`d).
- Add a list of all paths to copy out to `paths.txt` (also `.gitignore`d).
- Run `nonpkger.bash` whenever you want to install/update all the files.

## Example config

`invoke.bash`:
```bash
# Vendor-hosted installer script that puts file in a known location
curl https://example.com/install.sh | sh
```

`paths.txt`:
```
/usr/local/bin/example-executable
```

## Notes

- Runs installation script inside an Ubuntu LTS docker container.
- All scripts are run inside bash with `set -euo pipefail`.
- `paths.txt` is passed directly to `cp` and can accept shell expansions.
- Intended mainly for setups that do not need to be isolated such as dev
tooling.
- You'll need to know details about your package, like the final files.
- **Purely a convenience setup, no docker security features are enabled.**
- Don't forget to prune docker images every so often! Some caching happens
by way of building an image.
- Works best with Docker in rootless mode to avoid hitting permissions
issues.

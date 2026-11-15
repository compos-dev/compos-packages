# compos-packages

The standard packages of [compos](https://github.com/compos-dev): chat, agents, todo, git, code, help and the rest of the everyday set. One directory for each package, its tests beside it.

Core loads this repo at boot; you do not install it. `compos-packages.scm` puts every package directory on `load-path` and loads the stock set in order. `recipes.scm` has one recipe for each package.

A release bundles the commit that core pins in `priv/standard.lock`, so the first boot works offline. A checkout without the clone clones it at that pin.

To work on a package, edit it in `<compos-home>/repos/compos-packages`; a save reloads it. `M-x packages-pr` sends the change upstream as a pull request.

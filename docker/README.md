# Dev Container
This directory contains all recipes to create and run the `devcontainer`. The  `devcontainer.Dockerfile` is the build instruction for the the corresponding Docker image. Have a look at it and modify it according to your needs!
## Enable Github Copilot
Inside the devcontainer, open neovim and type `:LazyExtras`, then add `ai.copilot` (also add `ai.copilot-chat` for also enabling the interactive ai chat). Now, install the added plugins through `:Lazy`. Restart neovim, type `:Copilot auth` to authenticate yourself. 

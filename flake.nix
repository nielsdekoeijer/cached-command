{
    description = "Provides functions for caching arbitrary commands";
    inputs.systems.url = "github:nix-systems/default";
    outputs = {self, systems }: {
        templates = {
            default = self.templates.cached-command;
            cached-command = {
                path = "examples/cached-command";
                description = "An example using cached-command";
            };
        };
    };
}

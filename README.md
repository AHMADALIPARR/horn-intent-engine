# Horn Intent Engine

Pure GDScript (Godot 4) Horn-clause resolver and declarative intent engine, with an interactive web demo.

**License:** AGPL-3.0-only

## Quick Demo

Open [`web/index.html`](web/index.html) in a browser. No build step required.

The web front end is a self-contained JavaScript reimplementation of the same unification and backward-chaining logic. It lets you:

- Add facts and Horn rules
- Run queries (e.g. `in_warehouse ?X`)
- See substitutions and results
- Test intent matching against registered patterns

## Godot Project

```
nlp/
├── horn_engine.gd       # facts, rules, unify, freshen, solve/query
├── intent_engine.gd     # regex registry + dynamic dispatch
├── intent_registry.gd   # declarative intent definitions
└── action_handlers.gd   # handler implementations
```

Open the project folder in Godot 4.3+ and run the main scene. Output appears in the Output panel.

## Design

Language maps to predicates. Horn clauses connect the predicates. Unification propagates bindings. Indexed facts (future) supply evidence.

The current implementation is depth-first backward chaining with a depth limit. It is not complete for all recursive Horn programs; tabling or SLG resolution would be required for robust recursion.

## Repository Layout

```
horn_intent_engine/
├── LICENSE
├── README.md
├── project.godot
├── main.gd / main.tscn
├── nlp/                  # GDScript source
└── web/                  # interactive demo (HTML/JS)
```

## Authors

SnapKitty Research Lab  
Researchers: Ahmad Ali Parr, Jessica Westerhoff  
Research owner: Bel esprit D'accord Trust

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

See the [LICENSE](LICENSE) file for the full text.

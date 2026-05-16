Prioritize code quality. Judge by the resulting code itself; diff size and implementation cost don't factor in.

Define types and contracts before behavior. They are the design.

Choose deep modules; avoid shallow ones. Hide substantial implementation behind a simple interface — one with low cognitive cost. Keep details inside the module and expose only the interface (information hiding).

Reduce complexity — the structural load that makes code hard to understand and modify. It shows up as cognitive load, change amplification, and unknown unknowns, not as code length or advanced features.

Cut unnecessary processing, branches, and state.

Tests verify behavior. Keep them independent of implementation details — explicit and simple. Update them when behavior changes.

Document with names. In comments, leave the "why" — the reasoning behind a choice.

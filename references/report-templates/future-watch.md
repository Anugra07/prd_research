# Future Watch

Chat-output layout - render as a section in the chat response, not a saved file. Where the field is heading and what to track without acting on yet. The recommendations earlier in the report are about now; this section is about next.

## Time horizon

- **Now (0-6 months):** {{user can adopt today}} - lives in the main recommendations, not here.
- **Near (6-18 months):** {{maturing, worth piloting}} - bulk of this doc.
- **Far (18-36 months):** {{emerging, worth tracking}} - second half of this doc.
- **Past:** {{deprecated / sunsetting}} - end of this doc.

## Near horizon (6-18 months) - worth piloting

For each item: what it is, why it matters to this project, what would need to be true to adopt, source.

### {{technology / technique 1}}
- **What:** {{one-line}}
- **Why it matters here:** {{tie to a specific subsystem or weakness}}
- **Adoption signal:** {{what needs to be true - e.g. "stable 1.0 release", "managed offering available on our cloud", "team has Rust experience"}}
- **Source (tier):** {{URL}} ({{S/A/B/C/D}})
- **Tracking suggestion:** {{e.g. "watch repo X release notes, revisit in Q3 2026"}}

### {{technology / technique 2}}
{{...}}

## Far horizon (18-36 months) - worth tracking

Things the team should be aware of but not plan around yet. Lower bar - speculative is fine here, but still cite.

- **{{name}}** - {{one-line}}. Why we care: {{...}}. Source ({{tier}}): {{URL}}.
- {{...}}

## Deprecation watch

Tech the project depends on (or might rely on) that is fading or officially sunsetting. Maintenance / migration risk lives here.

| Tech | Status | Sunset / EoL | Migration path | Source (tier) |
|---|---|---|---|---|
| {{name}} | {{deprecated / soft-EoL / hard-EoL / unmaintained}} | {{date or "no date set"}} | {{migration option, or "no clear path - flag as risk"}} | {{URL}} ({{tier}}) |
| {{...}} | | | | |

## Predictions to revisit

A short list of "in 12 months we will look back and check whether this was right". Forces honesty and calibration over time.

- **{{prediction}}** - {{e.g. "WASM-on-the-server will be a credible alternative to containers for this workload"}}. Revisit: {{date}}. Source ({{tier}}): {{URL}}.
- {{...}}

## What we deliberately ignored

Buzzword-of-the-month items we evaluated and declined to include, with one-line reasons. Saves the next pass from re-litigating.

- {{name}} - {{e.g. "too early, no production users at our scale"}} / {{"hype cycle, no technical advantage over $current"}}.
- {{...}}

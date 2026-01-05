Bas's initial draft Builds to here:

https://build.fhir.org/ig/bvdh/jwg-api/en/


Feedback:

- Producer PUSH needs to be added
- It seems like he's mapping the same functionality into "Import/export data" as an admin. I don't think that UI interaction needs to be specified here.
- I don't understand why we need the consistent time profile (ITI-1). Can't we assume this, feels like overkill.
- I don't like that he's got all these use cases as different API's on this page. I would see them as deployment use cases of the same core API.
- Why is auth optional?







# Structure

  Directory Structure

  ├── input/
  │   ├── fsh/                      # FHIR Shorthand definitions
  │   │   ├── Actors.fsh            # Actor definitions
  │   │   ├── T2.fsh, T5-*.fsh      # Transaction definitions
  │   │   ├── mhd/                  # Mobile Health Document profiles
  │   │   └── priorityareas/        # Priority area specific profiles
  │   └── pagecontent/              # Markdown documentation
  │       ├── index.md              # Homepage
  │       ├── api-specification.md  # API specs
  │       └── transaction-T*.md     # Transaction details
  ├── images/                       # SVG diagrams
  ├── ig-template/                  # Custom IG template
  ├── sushi-config.yaml             # Main configuration
  ├── ig.ini                        # IG Publisher config
  └── README.md                     # Project documentation
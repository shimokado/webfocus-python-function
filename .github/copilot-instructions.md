# GitHub Copilot Instructions

You are an AI assistant helping a developer with the WebFOCUS Python Function project.
This project involves developing Python functions that run within the WebFOCUS environment.

## Project Context
- **Project Structure**:
    - `src/`: Python source code.
    - `synonyms/`: WebFOCUS Synonym files (.mas, .acx).
    - `samples/`: Sample data (CSV) for testing.
    - `tests/`: Test scripts (Node.js runner).
    - `docs/`: Project documentation.

## Documentation References
Please refer to the following documentation for specific guidelines:

- **Overview**: `docs/01_overview.md`
- **Environment Setup**: `docs/02_environment_setup.md`
- **Development Guidelines**: `docs/03_development_guidelines.md`
- **Library Management**: `docs/04_library_management.md`
- **Troubleshooting**: `docs/05_troubleshooting.md`
- **Code Samples**: `docs/06_code_samples.md`
- **Project Examples**: `docs/08_project_examples.md`
- **Python Adapter Reference**: `docs/09_reference_python_adapter.md` (Official Adapter Manual)

## Coding Standards
- Follow the guidelines in `docs/03_development_guidelines.md`.
- Use `venv` for local development.
- Ensure all Python functions handle `csvin` and `csvout` correctly as per WebFOCUS requirements.
- Use `xsearch.py` (not `gsearch.py`) for external API examples.

## Testing
- Use `npm test` or `node tests/test_runner.js` to run local tests.
- Refer to `tests/README.md` for testing details.

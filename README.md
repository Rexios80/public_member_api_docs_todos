Enabling the `public_member_api_docs` lint rule after writing a ton of code can be daunting. This utility lets you fix all of the issues with `TODO` comments so you can deal with them in smaller chunks later.

## Use as an executable

### Installation
```console
$ dart pub global activate public_member_api_docs_todos
```

### Usage
```console
$ pmad
$ pmad -c "comment contents"
```

## Notes
- This tool doesn't insert the comments with proper formatting, so make sure to run `dart format .` after

- This tool also doesn't handle multi-line declarations properly, so the code might need some manual tweaking
---
allowed-tools: Bash(swift outdated), Bash(tuist:*)
title: Upgrade Swift Dependencies
description: Update all Swift dependencies to their latest versions.
---

a. Run the command to check for outdated Swift dependencies:

```bash
swift outdated
```

b. Manually set the Swift dependencies in @Package.swift to their latest versions, including breaking changes.
Note: No need to verify if the project builds successfully after the update, and do definitely not try to search for latest versions using any method other than the `swift outdated` command.

c. After updating the dependencies, run the following command to update the package:

```bash
swift package update
```

d. Display a list of updated dependencies, with ⚠️ in front of the dependencies that were updated to a breaking change.

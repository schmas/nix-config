# New request command

Setup a template to define a new request.

- do not start planning, and do not start implentation
- create a new file (named based on the request) in `.tasks/requests`
- Read `.tasks/.sequence` to get the last sequence ID (4 hex chars)
- Increment the hex value by 1 and update `.tasks/.sequence` with the new value
- Prefix the filename with the new sequence ID followed by a dash (e.g., `0001-feature-name.md`)
- Use the following as a template for the new file
- Add a reasonable description (based on the request) as an initial starting point
- The filename should be prefixed with sequence ID, then `fix-` or `feature-` or `refactor-` or `chore-`, ask if it is not clear

--- Template below this line ---

# Overview

**Add description here**

## Plan

-

## Success metrics

-

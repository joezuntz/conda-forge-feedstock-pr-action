import github
import sys

token=sys.argv[1]
origin=sys.argv[2]
fork_owner=sys.argv[3]
version=sys.argv[4]
if len(sys.argv) == 6:
    comment = sys.argv[5]
else:
    comment = None

g = github.Github(token)
repo = g.get_repo(origin)

body = f'''
Auto-update version number to {version}
'''
title = f"[bot] Update to version {version}"


pr = repo.create_pull(title, body, "main", f'{fork_owner}:{version}', True)

if comment is not None:
    pr.as_issue().create_comment(comment)

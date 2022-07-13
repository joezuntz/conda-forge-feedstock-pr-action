import github
import sys

token=sys.argv[1]
origin=sys.argv[2]
fork_owner=sys.argv[3]
version=sys.argv[4]
target_branch=sys.argv[5]

if len(sys.argv) == 7:
    comment = sys.argv[6]
else:
    comment = None

g = github.Github(token)
repo = g.get_repo(origin)

body = f'''
Auto-update version number to {version}
'''
title = f"[bot] Update to version {version}"


pr = repo.create_pull(title, body, target_branch, f'{fork_owner}:{version}', True)
issue = pr.as_issue()
issue.set_labels("automerge")
if comment is not None:
    issue.create_comment(comment)

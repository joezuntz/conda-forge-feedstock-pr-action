import github
import sys

token=sys.argv[1]
origin=sys.argv[2]
fork_owner=sys.argv[3]
version=sys.argv[4]
target_branch=sys.argv[5]
automerge_str = sys.argv[6].lower()

# Be flexible about what t
if automerge_str in ["true", "yes", "t", "y", "1"]:
    automerge = True
elif automerge_str in ["false", "no", "f", "n", "0"]:
    automerge = False
else:
    raise ValueError(f"Unrecognised automerge parameter {automerge_str}. Use true or false.")

if len(sys.argv) == 8:
    comment = sys.argv[7]
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

if automerge:
    issue.set_labels("automerge")

if comment is not None:
    issue.create_comment(comment)

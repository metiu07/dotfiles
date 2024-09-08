#!/bin/sh

fd -e md . $HOME/Documents/notes/ --changed-within 1day -x grep -m 1 '\[~\]' | head -1 | sed 's/^\s*- \[.\] //'

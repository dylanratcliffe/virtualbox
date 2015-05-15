#!/bin/sh

git stash -q --keep-index

# Test prospective commit
rake spec

git stash pop -q
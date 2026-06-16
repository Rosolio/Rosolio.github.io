#!/usr/bin/env bash
#
# Publish the site

help() {
  echo "Publish the site to GitHub"
  echo
  echo "Usage:"
  echo
  echo "   bash $0 [options]"
  echo
  echo "Options:"
  echo "     -m, --message MSG   Commit message (default: current date)"
  echo "     -h, --help          Print this help information."
}

MESSAGE=$(date +%Y-%m-%d)

while (($#)); do
  opt="$1"
  case $opt in
  -m | --message)
    MESSAGE="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    echo -e "> Unknown option: '$opt'\n"
    help
    exit 1
    ;;
  esac
done

echo "> Committing changes..."
git add -A
git commit -m "$MESSAGE"

echo "> Pushing to remote..."
git push

echo "> Done!"
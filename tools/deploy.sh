#!/usr/bin/env bash
#
# Build and publish the site

help() {
  echo "Build and publish the site to GitHub"
  echo
  echo "Usage:"
  echo
  echo "   bash $0 [options]"
  echo
  echo "Options:"
  echo "     -m, --message MSG   Commit message (default: 'new post')"
  echo "     -h, --help          Print this help information."
}

MESSAGE="new post"

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

echo "> Building site..."
JEKYLL_ENV=production bundle exec jekyll b

echo "> Committing changes..."
git add -A
git commit -m "$MESSAGE"

echo "> Pushing to remote..."
git push

echo "> Done!"
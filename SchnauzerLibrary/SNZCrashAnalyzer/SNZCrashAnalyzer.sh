#!/bin/sh

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
from="${scripts}/SNZCrashAnalyzer.plist"
to="${CODESIGNING_FOLDER_PATH}/Info.plist"

echo "/usr/libexec/PlistBuddy -x -c \"Merge ${from}\" ${to}"
/usr/libexec/PlistBuddy -x -c "Merge ${from}" "${to}"

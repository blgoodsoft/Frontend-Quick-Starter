set scriptPath to path to me as string
set scriptFolderPath to (do shell script "dirname " & quoted form of POSIX path of scriptPath)

set filePath to scriptFolderPath & "/start.sh"

set fileInfo to do shell script "ls -l " & quoted form of filePath
if fileInfo does not begin with "-rwx" then
    do shell script "chmod +x " & filePath
end if

tell application "Terminal"
    activate
    do script "cd " & scriptFolderPath & " && ./start.sh"
end tell
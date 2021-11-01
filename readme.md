# Concatenate Apache Logs

![Banner](./banner.svg)

> Read all apache logs and create a new file with only lines matching a given regex pattern

## Description

The objective of this Powershell script is to scan a given folder, get the list of Apache log files from there and process all files, one by one.

Run a regular expression on the file content so any lines matching a given search string (like part of an URL f.i.) will be outputted in a result file.

At the end, you'll get a resulting file where all matches lines will be there.

## Example

Imagine you've create a few APIs and all APIs are accessible by using an URL where the word `api` is part of the URL. For instance: `.*\/api\/.*` (search for all lines where the pattern `/api/` appears).

Running this Powershell script with `.*\/api\/.*` will thus extract any calls to an API URL to the result file.

## Use

1. Download all your Apache log file into a folder like in `c:\logs\`;
2. Copy the `concat.ps1` script from this repository in that folder;
3. With an editor, edit `concat.ps1` and update the value of two variables in the `initialize` function
   1. `$global:outFile`: choose the name of your result file; you can of course keep the current one;
   2. `$global:searchRegex`: make sure to type here a valid regex *(if you're not familiar with regular expressions, use the [https://regex101.com/](https://regex101.com/) website, very nice.)*
4. From the DOS prompt, go to the `c:\logs\` folder and run the `Powershell .\concat.ps1` command. The script will start and you'll get your result file once all Apache log files have been processed.

Note: once the result file has been created, Apache log files are probably no longer useful. You can ask to the script to delete log files once processed. There is a constant called `KILL_LOG` at the top of the script. Just type `$TRUE` if you want to delete logs and `$FALSE` if you want to keep them.

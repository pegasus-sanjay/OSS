
Param(
 [string]$directory = $env:BUILD_SOURCESDIRECTORY
 #This is to create a variable that picks the environment variable for the working directory for the build agent
 )
 
 $append = "\MyTestProject\MyTestProject\bin\Debug\app.publish\*"
 #This is to create the variable that represents the organization structure for where the clickonce files go
 #MyTestProject is my solution name and hence this path
 
 $finaldirectory = $directory + $append
 #Getting the file location of where the ClickOnce files are present on the build server

 $WebURL = "https://armdcs.sharepoint.com/sites/cARMa"
 $docLibraryName = "Documents"
 $docLibraryUrlName = "Shared%20Documents"

 #Open web and library 
 $web = Get-SPWeb $webUrl
 $docLibrary = $web.Lists[$docLibraryName]
 $files = ([System.IO.DirectoryInfo] (Get-Item $finaldirectory)).GetFiles()

ForEach($file in $files)
{
 
    #Open file
    $fileStream = ([System.IO.FileInfo] (Get-Item $file.FullName)).OpenRead()
 
    #Add file
    $folder =  $web.getfolder($docLibraryUrlName)
 
    write-host "Copying file " $file.Name " to " $folder.ServerRelativeUrl "..."
    $spFile = $folder.Files.Add($folder.Url + "/" + $file.Name, [System.IO.Stream]$fileStream, $true)
    write-host "Success"
 
    #Close file stream
    $fileStream.Close();
}
 
#Dispose web
 
$web.Dispose()

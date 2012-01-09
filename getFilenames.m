function fileNames = getFilenames(folderPath)

tempListing = ls(folderPath, '-x');
fileNames = regexp(tempListing, '\s*','split');
fileNames = fileNames(1:end - 1);


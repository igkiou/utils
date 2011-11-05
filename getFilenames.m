function fileNames = getFilenames(folderPath)

tempListing = ls(folderPath);
fileNames = regexp(tempListing, '\s*','split');
fileNames = fileNames(1:end - 1);


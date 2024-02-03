import os
import argparse

supportExtensions = ['.dart']
notSupportGenFiles = ['.freezed', '.g.dart', '.p.dart']

def scanFolders(folder):
    folderPath = os.path.dirname(folder)
    folderName = os.path.basename(folder)
    print(f'Dir: {folderName}')
    arraySubDir = []
    arraySubFiles = []
    for entry in os.scandir(folder):
        if entry.is_file():
            baseName, ext = os.path.splitext(entry.name)
            isValidExtFile = True
            for fileExtension in notSupportGenFiles:
                if (entry.name.endswith(fileExtension)):
                    isValidExtFile = False
            if (isValidExtFile
                and (ext in supportExtensions)
                and baseName != folderName
                and baseName != ''):
                print(f'File: {baseName} -- {ext}')
                arraySubFiles.append(f'export \'{baseName}.dart\';')
        if (entry.is_dir()):
            arraySubDir.append(f'export \'{entry.name}/{entry.name}.dart\';')
            scanFolders(entry)
    writeFiles(folderPath, folderName, arraySubDir + arraySubFiles)

def writeFiles(folderPath, folderName, arrayExportFileNames):
    exportFilesLength = len(arrayExportFileNames)
    currentFolderPath = f'{folderPath}/{folderName}'
    filePath = f'{currentFolderPath}/{folderName}.dart'
   
    with open(filePath, 'w') as f:
        print(f'Export files: {arrayExportFileNames}')
        if (exportFilesLength == 0):
            return
        f.writelines('\n'.join(arrayExportFileNames))
        print(f'Write {folderName} at {currentFolderPath} successfully!')
        os.system(f'dart format {filePath}')

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('exportFilesPath', help='A required argument')
    args = parser.parse_args()
    pathFormatted = args.exportFilesPath
    if (pathFormatted.endswith('/')):
        pathFormatted = pathFormatted[:len(pathFormatted) - 1]
    scanFolders(pathFormatted)
main()

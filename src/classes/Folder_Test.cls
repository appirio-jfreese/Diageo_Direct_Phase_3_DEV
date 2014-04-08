@isTest(seeAllData = false)
public class Folder_Test{
    static testmethod void testFolder() {
        String folderName = 'folderName', folderId = 'folderId';
        Folder f1 = new Folder(folderId, folderName);
        System.AssertEquals(f1.allowFileUpload, false);
        System.AssertEquals(f1.allowAddComment, false);
        Folder f2 = new Folder(folderId, folderName, true, true);
        System.AssertEquals(f2.allowFileUpload, true);
        System.AssertEquals(f2.allowAddComment, true);
        Folder f3 = new Folder(folderId, folderName, true, true, true, true);
        System.AssertEquals(f3.filterByBrand, true);
        System.AssertEquals(f3.filterByTime, true);
        
        System.AssertNotEquals(f1.dirs, null);
        System.AssertNotEquals(f1.files, null);
        System.AssertEquals(f1.dirs.size(), 0);
        System.AssertEquals(f1.files.size(), 0);
        f1.addToFolder(f2);
        f1.addToFolder(f3);
        f1.addToFolder(new List<File>());
    }
}
@isTest(SeeAllData=false)
public class File_Test{
	static testmethod void testFile() {
        File f = new File('ID', 'Name', 'Size', 'Type');
        File v = new File('ID', 'Name', 'Size', 'Type', 'Vid');
    }
}
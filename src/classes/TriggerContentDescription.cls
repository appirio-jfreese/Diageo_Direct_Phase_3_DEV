public with sharing class TriggerContentDescription {
    public static boolean disabled = false;
    public static void onBeforeUpdate(boolean isUpdate, map<id, Content_Description__c> newContentDescriptionMap, map<id, Content_Description__c> oldContentDescriptionMap) {
        if (TriggerContentDescription.disabled) {
            return;
        }
        list<ContentVersion> cvs = new list<ContentVersion>();
        for(String key : newContentDescriptionMap.keySet()) {
            Content_Description__c cd = newContentDescriptionMap.get(key);
            string name = cd.title__c;
            if(name.length()>80) {
                name = name.substring(0, 79);
            }
            cd.name = name;
	        if (isUpdate) {
	        	boolean changed = false;
	        	ContentVersion cv = new ContentVersion(Id=cd.Content_Version_Id__c);
                if( cd.Title__c != oldContentDescriptionMap.get(key).Title__c) {
                    cv.Title = cd.Title__c;
                    changed = true;
                }
                if( cd.Classification__c != oldContentDescriptionMap.get(key).Classification__c) {
                    cv.Classification__c = cd.Classification__c;
                    changed = true;
                }
                if( cd.Portfolio__c != oldContentDescriptionMap.get(key).Portfolio__c) {
                    cv.Portfolio__c = cd.Portfolio__c;
                    changed = true;
                }
                if( cd.RTS__c != oldContentDescriptionMap.get(key).RTS__c) {
                    cv.RTS__c = cd.RTS__c;
                    changed = true;
                }
                if( cd.Description__c != oldContentDescriptionMap.get(key).Description__c) {
                    cv.Description = cd.Description__c;
                    changed = true;
                }
                if( cd.TBA__c != oldContentDescriptionMap.get(key).TBA__c) {
                    cv.TBA__c = cd.TBA__c;
                    changed = true;
                }
                if( cd.Image_Resolution__c != oldContentDescriptionMap.get(key).Image_Resolution__c) {
                    cv.Image_Resolution__c = cd.Image_Resolution__c;
                    changed = true;
                }
                if( cd.Matrix_type__c != oldContentDescriptionMap.get(key).Matrix_type__c) {
                    cv.Matrix_type__c = cd.Matrix_type__c;
                    changed = true;
                }
                if (changed) {
                    cvs.add(cv);
                }
	        }
	    }
	    if (cvs.size()>0) {
	        TriggerContentVersion.disabled = true;
	        update cvs;
	        TriggerContentVersion.disabled = false;
	    }
    }
	
	//Description	:	Method for creating document same as content version and populates its id in content description
	//Created By 	:	Siddharth (Appirio JDC)
	//Date		 	:	12/20/13
	public static void onAfterInsert(Map<ID, Content_Description__c> newRecordsMap){
		map<string,string> mapCVCDId =new map<string,string>();

		for(String cdId : newRecordsMap.keySet()){
	        if(newRecordsMap.get(cdId).Content_Version_Id__c != null && newRecordsMap.get(cdId).Content_Version_Id__c != '' 
	        	&& (newRecordsMap.get(cdId).filetype__c == 'PNG' || newRecordsMap.get(cdId).filetype__c == 'GIF' || newRecordsMap.get(cdId).filetype__c == 'JPG' || newRecordsMap.get(cdId).filetype__c == 'JPEG') && newRecordsMap.get(cdId).Name.toUpperCase().contains('LOGO') ){
	            	mapCVCDId.put(newRecordsMap.get(cdId).Content_Version_Id__c,cdId);
	        }
        }
        
        map<Id,ContentVersion> mapCV =new map<Id,ContentVersion>([SELECT c.Id, c.VersionData, c.FileType FROM ContentVersion c WHERE c.Id in : mapCVCDId.keySet()]);
        map<Id,Content_Description__c> mapCD = new  map<Id,Content_Description__c>([SELECT ID,Name,Document_Id__c,Content_Version_Id__c FROM Content_Description__c WHERE id in : mapCVCDId.values()]);
        map<Id,Document> mapCDIdDoc = new map<Id,Document>();
        
        String folderId = '';
        if(Settings__c.getValues('PublicDocFolderId') != null){
    		folderId = Settings__c.getValues('PublicDocFolderId').value__c;
        }
        
        Document d;
        for(ContentVersion c : mapCV.values()){
        	d= new Document(); 
			d.body= c.VersionData;            // body field in document object which holds the file. 
			d.ContentType = 'image/png';
			d.name= c.Id + 'png';
			d.type = 'png';
			if(folderId != null && folderId != ''){
				d.folderId = folderId;
			}
			d.IsPublic = true;
			mapCDIdDoc.put(mapCVCDId.get(c.Id),d);
        }
        if(!Test.isRunningTest()){
        	insert mapCDIdDoc.values();
        }
        for(Id CDId : mapCDIdDoc.keySet()){
        	if(mapCD.containsKey(CDId)){
        		mapCD.get(CDId).Document_Id__c = mapCDIdDoc.get(CDId).Id;
        	}
        }
		if(!Test.isRunningTest()){
        	update mapCD.values();
		}
    }
}
public with sharing class Controller_AccountBrandRelationEdit {
    
    public Controller_AccountBrandRelationEdit(ApexPages.StandardController controller) {
    }
    
    public PageReference redirect() {
    	string recId = ((string)Apexpages.currentpage().getparameters().get('retURL')).substring(1);
    	string id = recId.substring(0,3);
    	PageReference res = null;
    	if(id=='001')
    		res = Page.AccountBrand;
    		//res = Page.AccountBrandEdit;
    	else
    		res = Page.BrandAccount;
    		//res = Page.BrandAccountEdit;
    	for(string key : apexpages.currentpage().getparameters().keyset()){
    		res.getparameters().put(key, apexpages.currentpage().getparameters().get(key));
    	}
    	res.getparameters().put('isEdit', '1');
    	res.setRedirect(true);
    	return res;
    }
}
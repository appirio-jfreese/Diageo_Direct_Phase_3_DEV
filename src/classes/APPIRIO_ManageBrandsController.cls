public class APPIRIO_ManageBrandsController extends MM_RecipeBase {

	public Id cloneId {get; set;}
	public String whereClause {get; set;}
    public String queryString {get; set;}
    public String rQuery {get; set;}
    public string selectedAlphabet {get;set;}
    public integer PAGE_SIZE = 15;
    public string currentAlpha {get;set;}

	public String getUserAgent() {
	 	return ApexPages.currentPage().getHeaders().get('User-Agent');
	}

	//Getting all the Locale values User selected from the UI and adds them to a set.
    public String currentLocale {
    	get {
    		if(this.currentLocale == null)
    			this.currentlocale = getLocales()[0].getValue();
    		return this.currentlocale;
    	}
    	set	{
    		if (value != null){
				this.currentlocale = value;
			} else {
				this.currentlocale = getLocales()[0].getValue();
			}
	    	//Get filtered records
	    	filterResults();
    	}
    }

	public APPIRIO_ManageBrandsController() {
		rQuery = 'Select Name, Locale__c, Brand_Image__c From Diageo_Brand__c ';
	}

   	// instantiate the StandardSetController from a query locator
	public ApexPages.StandardSetController con {
		get {
			if(con == null) {
				whereClause = ' WHERE Name !=null ';
				//if(currentLocale != null && currentLocale != '' && currentLocale != 'All') {
				if(currentLocale != 'All') {
					whereClause += ' AND Locale__c = :currentLocale ';
				}
				whereClause += ' order By Name';
				queryString = rQuery + whereClause ;

				con = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
				// sets the number of records in each page set
				con.setPageSize(PAGE_SIZE);
			}
			return con;
		}
		set;
	}

   	public pageReference filterResults() {

		if(selectedAlphabet != null && selectedAlphabet.trim()!='') {
			currentAlpha = selectedAlphabet;
			whereClause = ' WHERE Name like\'';
   			whereClause += selectedAlphabet+'%\' ';
		} else {
			currentAlpha = '';
			whereClause = ' WHERE Name !=null ';
		}

		//if(currentLocale != null && currentLocale != '' && currentLocale != 'All') {
		if(currentLocale != 'All') {
			whereClause += ' AND Locale__c = :currentLocale ';
		}
		whereClause += ' order By Name';

		queryString = rquery+whereClause;
		con = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
		con.setPageSize(PAGE_SIZE);
		whereClause = null;
		return null;
    }

	public List<Diageo_Brand__c> getBrands() {
    	return (List<Diageo_Brand__c>)con.getRecords();
    }

    public PageReference cloneBrands() {
        PageReference pageRef = new PageReference('/apex/MM_RecipeBrand?isClone=true&Id='+cloneId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public list<SelectOption> getLocales(){
    	list<SelectOption> options = new list<SelectOption>();
   		if(getIsSuperAdmin()) {
   			options.add(new SelectOption('All','All'));
	   		for(String locale :getPickValues(new Diageo_Brand__c(), 'Locale__c')) {
	   			options.add(new SelectOption(locale,locale));
	   		}
   		}
   		if(getIsPublisher()) {
   			AggregateResult[] groupedResults = [SELECT Default_Locale__c FROM Digital_Published_Asset__c
				      								GROUP BY Default_Locale__c];

			for (AggregateResult ar : groupedResults)  {
			    options.add(new SelectOption(ar.get('Default_Locale__c')+'',ar.get('Default_Locale__c')+''));
			}
   		}
   		if(options.size() == 0) {
   			options.add(new SelectOption('None','None'));
   		}

   		return options;
   	}

	private List<String> getPickValues(Sobject object_name, String field_name) {

      	List<String> options = new List<String>(); //new list for holding all of the picklist options

      	Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
      	Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      	Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      	List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject

      	for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
         	options.add((String)a.getLabel()); //add the value and label to our final list
      	}

      	return options; //return the List
   }

    private list<string> alphaSet = new list<string>();
	public list<string> getAlphabets() {
		alphaSet.clear();
		alphaSet.add('A');
		alphaSet.add('B');
		alphaSet.add('C');
		alphaSet.add('D');
		alphaSet.add('E');
		alphaSet.add('F');
		alphaSet.add('G');
		alphaSet.add('H');
		alphaSet.add('I');
		alphaSet.add('J');
		alphaSet.add('K');
		alphaSet.add('L');
		alphaSet.add('M');
		alphaSet.add('N');
		alphaSet.add('O');
		alphaSet.add('P');
		alphaSet.add('Q');
		alphaSet.add('R');
		alphaSet.add('S');
		alphaSet.add('T');
		alphaSet.add('U');
		alphaSet.add('V');
		alphaSet.add('W');
		alphaSet.add('X');
		alphaSet.add('Y');
		alphaSet.add('Z');
		return alphaSet;
	}

	// indicates whether there are more records after the current page set.
	public Boolean hasNext {
		get {
			return con.getHasNext();
		}
		set;
	}

	// indicates whether there are more records before the current page set.
	public Boolean hasPrevious {
		get {
			return con.getHasPrevious();
		}
		set;
	}

	// returns the page number of the current page set
	public Integer pageNumber {
		get {
			return con.getPageNumber();
		}
		set;
	}

	// returns the first page of records
 	public void first() {
 		con.first();
 	}

 	// returns the last page of records
 	public void last() {
 		con.last();
 	}

 	// returns the previous page of records
 	public void previous() {
 		con.previous();
 	}

 	// returns the next page of records
 	public void next() {
 		con.next();
 	}

 	// returns the PageReference of the original page, if known, or the home page.
 	public void cancel() {
 		con.cancel();
 	}

 	public Integer totalRecords {
		get {
			return con.getResultSize();
		}
		set;
	}

	public Integer currentStartRecord {
		get {
			return (pageNumber*PAGE_SIZE)-14;
		}
		set;
	}

	public Integer currentEndRecord {
		get {
			if (hasNext)
				return currentStartRecord+(PAGE_SIZE-1);
			else{
				Integer tmp = Math.mod(totalRecords,PAGE_SIZE);
				if (tmp == 0)
					return (PAGE_SIZE-1)+currentStartRecord;
				else
					return (tmp-1)+currentStartRecord;

			}
		}
		set;
	}
}
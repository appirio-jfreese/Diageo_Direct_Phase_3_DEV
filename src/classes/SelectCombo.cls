/*------------------------------------------------------------------------------
Name                : SelectCombo.cls

Created By  : Basant Verma (Appirio JDC)   
Date        : 13th Jan, 2014
Story/Task  : US1020
Description : Controller class for SelectCombo componnet
------------------------------------------------------------------------------*/
public class SelectCombo {
    
    private Object targetField;
    public String labelField{ get; set; }
    public String valueField{ get; set; }
    public String sObjVal{get;set;}
    public String additionalParam { get; set; }
    public Integer randomJsIden{get;set;}
    
   
    public SelectCombo(){
        randomJsIden = getRandomNumber(1000000);
    }
    
    /*
    *Setter method to set the targetField
    ***/
    public void setTargetField(Object targetField){
        if(targetField == null){
            this.targetField = targetField;
        }
    }
    
    /*
    *Random number generator to change the js function name if multiple components us
    ***/
    private Integer getRandomNumber(Integer size){
        Double d = math.random() * size;
        return d.intValue();
    }
    
    /*
    *This method queries data according to the passed parameters
    ***/
    @RemoteAction
    public static List<SObject> getData(String sObjVal,String labelField,String valueField, String speclFld, String param, String extraSoql){
        System.debug('================ speclFld '+speclFld);
        param = String.escapeSingleQuotes(param);       
        String soql = 'select '+valueField+','+labelField
            +((speclFld != null && !speclFld.trim().equals('')) ? ','+speclFld : '' )
            +' from '+sObjVal+' where '+labelField+' like \'%'+param+'%\'';
        if(extraSoql != null && !extraSoql.trim().equals('')){
            soql += ' AND ' + extraSoql;
        }
        soql += ' ORDER BY '+labelField+' LIMIT 999';
        System.debug('================ SOQL '+soql);
        return Database.query(soql);
    }
    

}
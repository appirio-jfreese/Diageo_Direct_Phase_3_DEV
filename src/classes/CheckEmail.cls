/***************************************************************************
// (c) 2014 Appirio, Inc.
//
// Description    : Class that returns false if the daily email limit will  
//                : be exceeded by this request
//                  
// Jan 16, 2014   : Randy Wandell   Original  
//   
//***************************************************************************/
public abstract class CheckEmail {

    // Check to see if the number of emails you intend to send
    // will push you past the daily limit
    public static boolean isOverLimit(integer i) {
        try {
            Messaging.reserveSingleEmailCapacity(i);
            return false;
        } catch (Exception e) {
            return true;
        }
    }
    
    // Check a limit with a reserved amount (useful if you want to 
    // reserve a number of emails and not use your daily email limit) 
    public static boolean isOverLimit(integer i, integer reserveAmount) {
        return isOverLimit(i+reserveAmount);
    }     

}
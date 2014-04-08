global class SurveyEditorController {
	public SurveyEditorController(ApexPages.StandardController controller){}
	
	global class Survey{
		global Survey(){
			this.questions = new List<SurveyQuestion>();
		}
		global List<SurveyQuestion> questions{get;Set;}
		global String surveyName{get;Set;}
	}
	global class SurveyQuestion{
		public SurveyQuestion(DMS_Question__c sq){
			this.id = sq.Id;
			this.surveyId = sq.DMS_Survey__c;
			this.nextId = sq.NEXT_Question__c;
			this.parentId = sq.Parent_Question__c;
			this.name = sq.Name;
			this.conditionalAnswer = sq.Conditional_Answer__c;
			this.text = sq.Question_Text__c;
			this.type = sq.Question_Type__c;
			this.answers = sq.Answer_Options__c;
			this.commentsLabel = sq.Label_for_Add_l_Comments__c;
			this.createdBy = sq.CreatedBy.Alias+' '+ sq.CreatedDate;
			this.updatedBy = sq.LastModifiedBy.Alias+' '+ sq.LastModifiedDate;

			this.includeNone = sq.Include_None_of_the_Above__c;
			
			
		}
		public DMS_Question__c getSObject(){
			DMS_Question__c sq = new DMS_Question__c();
			sq.Id=this.id;
			if(sq.Id == null) sq.DMS_Survey__c= this.surveyId ;
			sq.NEXT_Question__c= this.nextId;
			sq.Parent_Question__c= this.parentId;
			sq.Conditional_Answer__c= this.conditionalAnswer;
			sq.Question_Text__c= this.text;
			sq.Question_Type__c= this.type;
			sq.Answer_Options__c= this.answers;
			sq.Label_for_Add_l_Comments__c = this.commentsLabel;
			
			system.debug('WOOT include none: '+this.includeNone);
			if(this.includeNone != null){
				sq.Include_None_of_the_Above__c = this.includeNone;
			}
			
			return sq;
		}
		
		public SurveyQuestion(){}
		global String id{get;set;}
		global String surveyId{get;set;}
		global String nextId{get;set;}
		global String parentId{get;set;}
		global String name{get;set;}
		global String conditionalAnswer{get;set;}
		global String text{get;set;}
		global String type{get;set;}
		global String answers{get;set;}
		global String commentsLabel{get;set;}
		global String createdBy{get;set;}
		global String updatedBy{get;set;}
		global Boolean includeNone{get;set;}
	}
	
	@RemoteAction
	global static Survey getSurvey(String id){
		Survey result = new Survey();
		if(String.isBlank(id)){
			throw new CustomException('Need a valid survey ID.');
		}
		try{
			
			//mapping response
			  //     id:                 'a4dK00000000JBX'                     Salesforce ID
			  //     surveyId:           'a2dK00000000JBW'                     DMS Survey
			  //     nextId:             'a5dK00000000JBS'                     NEXT Question
			  //     parentId:           'a3dK00000000JBR'                     Parent Question
			  //     name:               'Q-0027'                              DMS Question Name
			  //     conditionalAnswer:  'NO'                                  Conditional Answer
			  //     text:               Do you like?                          Question Text
			  //     type:               text/price/number/select/multiselect  Question Type
			  //     answers:            'Yes,No'                              Answer Options
			  //     commentsLabel:      'Comments'                            Label for Add'l Comments
			  //     createdBy:          'Matt Smith, 11/5/2013 1:55 PM'       Created By
			  //     updatedBy:          'Matt Smith, 11/5/2013 1:57 PM'       Last Modified By
			List<DMS_Survey__c> surveyList =  [Select Id, Name, First_Question__c, (Select Id, Name, Answer_Options__c, Conditional_Answer__c, DMS_Survey__c, Label_for_Add_l_Comments__c,
									NEXT_Question__c, Parent_Question__c, Question_Text__c, Question_Type__c, CreatedDate, CreatedBy.Alias, LastModifiedBy.Alias,
									LastModifiedDate, Include_None_of_the_Above__c From DMS_Question__r order by createddate) 
					From DMS_Survey__c Where Id = :id ];
			
			if(surveyList.size()==0) throw new CustomException('No survey found. Retry.');
			DMS_Survey__c s = surveyList[0];
			
			result.surveyName = s.Name;
			for(DMS_Question__c sq : s.DMS_Question__r){
				SurveyQuestion q = new SurveyQuestion(sq);
				result.questions.add(q);
				system.debug('Queried Question: '+q.text);
			}
			
			List<SurveyQuestion> questions = new List<SurveyQuestion>();
			//search for the first
			for(SurveyQuestion sq : result.questions){
				if(s.First_Question__c == sq.id){
					questions.add(sq);
					break;
				}
			}
			sortQuestions(result.questions, questions);
			result.questions = questions;
			
			for(SurveyQuestion sq : result.questions){
				system.debug('Sorted Question: '+sq.text);
			}
		}
		catch(Exception e){
			throw new CustomException('Unexpected error: '+e.getMessage());
		}
		return result;
	}
	
	private static void sortQuestions(List<SurveyQuestion> questions, List<SurveyQuestion> sorted){
		if(sorted.size()==0) return;
		SurveyQuestion firstQ = sorted[sorted.size()-1];
		if(firstQ == null) return;
		
		//search for children
		for(SurveyQuestion sq : questions){
			if(sq.parentId == firstQ.id && sq.conditionalAnswer != null){
				sorted.add(sq);
				sortQuestions(questions,sorted);
			}
		}
		
		//search for the next one
		for(SurveyQuestion sq : questions){
			if(sq.id == firstQ.nextId){
				//don't add the Q if its already in there!
				/*boolean foundQ = false;
				for(SurveyQuestion s : sorted){
					if(s.id == sq.id){
						foundQ = true;
					}
				}
				if(!foundQ){
				}*/
					sorted.add(sq);
				sortQuestions(questions,sorted);
			}
		}
	}
	
	@RemoteAction
	global static SurveyQuestion upsertQuestion(SurveyQuestion question){
		
		SurveyQuestion result = new SurveyQuestion();
		if(question == null){
			throw new CustomException('Need a valid question object.');
		}
		try{
			DMS_Question__c sq = question.getSObject();
			upsert sq;
			result = new SurveyQuestion(sq);
			result.surveyId = question.surveyId;
		} catch(DMLException e){
			throw new CustomException('Unexpected error: '+e.getDMLMessage(0));
		}
		return result;
	}
	
	@RemoteAction
	global static void setFirstQuestion(String questionID){
		
		if(String.isBlank(questionID)){
			throw new CustomException('Need a valid question ID.');
		}
		try{
			List<DMS_Question__c> qList = [Select Id, DMS_Survey__r.Id, DMS_Survey__r.First_Question__c From DMS_Question__c
											where Id = :questionID];
			if(qList.size()==0){
				throw new CustomException('Question not found.');
			}
			qList[0].DMS_Survey__r.First_Question__c= qList[0].Id;
			update qList[0].DMS_Survey__r;
		
		} catch(DMLException e){
			throw new CustomException('Unexpected error: '+e.getDMLMessage(0));
		} catch(Exception e){
			throw new CustomException('Unexpected error: '+e.getMessage());
		}
	}
	
	@RemoteAction
	global static void removeQuestion(String questionID){
		
		if(String.isBlank(questionID)){
			throw new CustomException('Need a valid question ID.');
		}
		try{  
			delete new DMS_Question__c(Id = questionID);
		} catch(DMLException e){
			throw new CustomException('Unexpected error: '+e.getDMLMessage(0));
		}
	}
	
	public class CustomException extends Exception{}
}
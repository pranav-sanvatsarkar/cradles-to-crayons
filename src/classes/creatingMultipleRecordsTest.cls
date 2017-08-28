@isTest
private class creatingMultipleRecordsTest
{
    
  public static testMethod void testing()
  {
     //creating an account
     Account thisacc=new Account();
     thisacc.Name='testAcc';
     insert thisacc;
     
     //creating a contact
     Contact thisContact=new Contact();
     thisContact.LastName='testContactFirst';
     thisContact.FirstName='testContactLast';
     
     insert thisContact;
     
     //creating a task
     Task testTask=new Task();
     
     //testTask.OwnerId=thisUser.Id;
     testTask.Subject='Call';
     
     insert testTask;
     
     //creating a volunteer visit
     Volunteer_visit__c volvisit=new Volunteer_visit__c();
     
     Date thisDate=Date.newInstance(2010,4,4);
     Time thisTime=Time.newInstance(06,00,00,00);
     volvisit.Org_Group__c=thisAcc.Id;
     volvisit.Scheduled_Start_Date_Time__c=DateTime.newInstance(thisDate,thisTime);
     volvisit.Main_Contact__c=thisContact.Id;
     volvisit.Status__c='Scheduled';
     volvisit.Volunteer_Type__c='Group';
     
     insert volvisit;
     
     //volvisit=[select Id from Volunteer_Visit__c where Scheduled_Start_Date_Time__c!=NULL limit 1];
     PageReference thispage=new PageReference('/apex/creatingMultipleRecords?id='+volvisit.Id);
     Test.setCurrentPage(thispage);
     
     //creating test controller obj one
     creatingMultipleRecordsController multRecOne=new creatingMultipleRecordsController();
     
     //multRecOne.ItemsRepeat = '';
     multRecOne.getItemsRepeat();     
     multRecOne.getItemsScheduleBy();
     multRecOne.getItemsPattern();
     multRecOne.getItemsDay();
     multRecOne.getCategoriesStart();
     //multRecOne.getCategoriesEnd();
     multRecOne.sethdnValue('Weekly');
     multRecOne.gethdnValue();
     multRecOne.sethdnValueForScheduler('occurences');
     multRecOne.gethdnValueForScheduler();
     multRecOne.setxvalue('3');
     multRecOne.getxvalue();
     multRecOne.setselectionScheduleBy(' ');
     multRecOne.getselectionScheduleBy();
     multRecOne.setOccurences('3');
     multRecOne.getOccurences();
     multRecOne.settempTaskStart(testTask);
     multRecOne.gettempTaskStart();
     multRecOne.settempTaskEnd(testTask);
     multRecOne.gettempTaskEnd();
     multRecOne.setstartDateFromSelection(' ');
     multRecOne.getstartDateFromSelection();
     multRecOne.setvolvisit(volvisit);
     multRecOne.getvolvisit();
     multRecOne.setselectionRepeat('');
     multRecOne.getselectionRepeat();
     multRecOne.setselectionDay(' ');
     multRecOne.getselectionDay();
     multRecOne.setstartTime(' ');
     multRecOne.getstartTime();
     multRecOne.setschStartDate(' ');
     multRecOne.getschStartDate();
     multRecOne.setendTime(' ');
     multRecOne.getendTime();
     multRecOne.setDuration(' ');
     multRecOne.getDuration();
     multRecOne.setselectionPattern(' '); 
     multRecOne.getselectionPattern();
     multRecOne.getrecurringVolVisitList();
     
     
     multRecOne.startTime='4:00 AM';
     multRecOne.duration='30';
     //multRecOne.xvalue='3';
     multRecOne.hdnValue='Weekly';
     //multRec.flag=1;
     
     multRecOne.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);

     multRecOne.hdnValueForScheduler='endDate';
     multRecOne.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecOne.send();
     
     //creating test controller obj two
     creatingMultipleRecordsController multRecTwo=new creatingMultipleRecordsController();
     
     multRecTwo.startTime='4:00 PM';
     multRecTwo.duration='30';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xvalue='3';
     multRecTwo.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecTwo.hdnValueForScheduler='occurences';
     multRecTwo.Occurences='3';
     multRecTwo.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecTwo.send();
     
     //creating test controller obj three
     creatingMultipleRecordsController multRecThree=new creatingMultipleRecordsController();
     
        
     multRecThree.startTime='4:00 PM';
     multRecThree.duration='30';
     multRecThree.hdnValue='Monthly';
     multRecThree.selectionPattern='3';
     multRecThree.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecThree.hdnValueForScheduler='occurences';
     multRecThree.occurences='3';
     multRecThree.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecThree.send();
     
     //creating test controller obj four
     creatingMultipleRecordsController multRecFour=new creatingMultipleRecordsController();
      
     multRecFour.startTime='9:00 AM';
     multRecFour.duration='30';
     multRecFour.hdnValue='Monthly';
     multRecFour.selectionPattern='5';
     multRecFour.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecFour.hdnValueForScheduler='endDate';
     //multRecFour.Occurences='3';
     multRecFour.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecFour.send();
     
    
     //creating test controller obj five
     creatingMultipleRecordsController multRecFive=new creatingMultipleRecordsController();
   
     multRecFive.startTime='4:00 PM';
     multRecFive.duration='30';
     multRecFive.hdnValue='everyXWeek';
     multRecFive.xvalue='3';
     //multRecFive.selectionPattern='4';
     multRecFive.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecFive.hdnValueForScheduler='endDate';
     //multRecFive.occurences='3';
     multRecFive.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecFive.send();
     
     //creating test controller obj six
     creatingMultipleRecordsController multRecSix=new creatingMultipleRecordsController();
   
     multRecSix.startTime='4:00 PM';
     multRecSix.duration='30';
     multRecSix.hdnValue='everyXWeek';
     multRecSix.xvalue='3';
     multRecSix.selectionPattern='4';
     multRecSix.tempTaskStart.ActivityDate=NULL;
     multRecSix.hdnValueForScheduler='endDate';
     //multRecFive.occurences='3';
     multRecSix.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     try
     {
       multRecSix.send();
     }
     catch(Exception e)
     {
       System.debug('Caught the exception');
     }
     
     //creating test controller obj seven
     creatingMultipleRecordsController multRecSeven=new creatingMultipleRecordsController();
   
     multRecSeven.startTime='4:00 PM';
     multRecSeven.duration='30';
     multRecSeven.hdnValue='everyXWeek';
     multRecSeven.xvalue='3';
     multRecSeven.selectionPattern='4';
     multRecSeven.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecSeven.hdnValueForScheduler='endDate';
     //multRecFive.occurences='3';
     multRecSeven.tempTaskEnd.ActivityDate=Date.newInstance(2010,1,1);
     try
     {
       multRecSeven.send();
     }
     catch(Exception e)
     {
       System.debug('Caught the exception');
     }
     
     //creating test controller obj eight
     creatingMultipleRecordsController multRecEight=new creatingMultipleRecordsController();
   
     multRecEight.startTime='4:00 PM';
     multRecEight.duration='c';
     multRecEight.hdnValue='everyXWeek';
     multRecEight.xvalue='3';
     multRecEight.selectionPattern='4';
     multRecEight.tempTaskStart.ActivityDate=Date.newInstance(2009,1,1);
     multRecEight.hdnValueForScheduler='endDate';
     //multRecFive.occurences='3';
     multRecEight.tempTaskEnd.ActivityDate=Date.newInstance(2011,6,6);
     try
     {
       multRecEight.send();
     }
     catch(Exception e)
     {
       System.debug('Caught the exception');
     }
     
     //creating test controller obj nine
     creatingMultipleRecordsController multRecNine=new creatingMultipleRecordsController();
   
     multRecNine.startTime='4:00 PM';
     multRecNine.duration='30';
     multRecNine.hdnValue='everyXWeek';
     multRecNine.xvalue='c';
     multRecNine.selectionPattern='4';
     multRecNine.tempTaskStart.ActivityDate=Date.newInstance(2009,1,1);
     multRecNine.hdnValueForScheduler='endDate';
     //multRecFive.occurences='3';
     multRecNine.tempTaskEnd.ActivityDate=Date.newInstance(2011,6,6);
     try
     {
       multRecNine.send();
     }
     catch(Exception e)
     {
       System.debug('Caught the exception');
     }
     
     //creating test controller obj ten
     creatingMultipleRecordsController multRecTen=new creatingMultipleRecordsController();
     
        
     multRecTen.startTime='4:00 PM';
     multRecTen.duration='30';
     multRecTen.hdnValue='Weekly';
     //multRecTen.selectionPattern='3';
     multRecTen.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecTen.hdnValueForScheduler='occurences';
     multRecTen.occurences='3';
     multRecTen.copy=true;
     multRecTen.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     //To improve coverage
     multRecTen.send();
     multRecTen.getDayOfDate('mon');
     multRecTen.getDayOfDate('tue');
     multRecTen.getDayOfDate('wed');
     multRecTen.getDayOfDate('thu');
     multRecTen.getDayOfDate('fri');
     multRecTen.getDayOfDate('sat');
     multRecTen.getDayOfDate('sun');
     multRecTen.setrecurringVolVisitList(new List<Volunteer_Visit__c>());
     multRecTen.bnCancel();
     
     
    
     
     multRecTwo.startTime='12:00 AM';
     multRecTwo.duration='30';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xvalue='3';
     multRecTwo.tempTaskStart.ActivityDate=Date.newInstance(2010,6,6);
     multRecTwo.hdnValueForScheduler='occurences';
     multRecTwo.Occurences='3';
     multRecTwo.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     
     multRecTwo.send();
     
     multRecTwo.tempTaskStart.ActivityDate= system.today();
     multRecTwo.hdnValueForScheduler ='endDate';
     multRecTwo.send();
     
     multRecTwo.hdnValueForScheduler =null;
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.startTime=null;
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.tempTaskEnd.ActivityDate=null;
     multRecTwo.occurences= null;
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.startTime='12:00 AM';
     multRecTwo.tempTaskStart.ActivityDate= system.today();
     multRecTwo.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     multRecTwo.hdnValueForScheduler ='occurences';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xValue= 'o';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.tempTaskStart.ActivityDate= system.today();
     multRecTwo.tempTaskEnd.ActivityDate=Date.newInstance(2011,12,12);
     multRecTwo.hdnValueForScheduler ='occurences';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xValue= '10';
     multRecTwo.occurences='o';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.tempTaskStart.ActivityDate= system.today();
     multRecTwo.hdnValueForScheduler ='occurences';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xValue= '10';
     multRecTwo.occurences='10';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.tempTaskStart.ActivityDate= Date.newInstance(2016,03,7);
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.selectionDay ='7';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     
     multRecTwo.hdnValue='Monthly';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.hdnValue='Weekly';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.tempTaskStart.ActivityDate= system.today();
     multRecTwo.tempTaskEnd.ActivityDate=system.today();
     multRecTwo.hdnValueForScheduler ='endDate';
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.xValue= '10';
     multRecTwo.occurences='10';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     
     multRecTwo.hdnValue='everyXWeek';
     multRecTwo.selectionDay ='7';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     
     multRecTwo.hdnValue='Monthly';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
     
     multRecTwo.hdnValue='Weekly';
     try{
         multRecTwo.send();
     }
     catch(Exception e){}
  }
}
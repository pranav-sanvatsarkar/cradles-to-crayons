public class creatingMultipleRecordsController 
{
 
  public String selectionDay,selectionStartDateTime,selectionOccurences,selectionPattern,selectionScheduleBy;
  public String selectionRepeat='1';
  public DateTime StDate;
  public String Occurences;
  public Task tempTaskStart;
  public Task tempTaskEnd;
  
  public String thistime;
  public String xvalue;
  public String hdnValue,hdnValueForScheduler;
  public String duration;
  public Volunteer_Visit__c volvisit=new Volunteer_Visit__C();
  public List<Volunteer_Visit__c> recurringVolVisitList=new List<Volunteer_Visit__c>();
  public Boolean renderPortionWeekly=FALSE;
  public Boolean renderPortionMonthly=FALSE;
  public Boolean renderPortionEveryWeek=FALSE;
  public String startTime;
  public String endTime,schStartDate;
  public String startDateFromSelection;  
  public Integer timeLapseFlag=0;
  public Boolean copy;
  public List<Volunteer_Registration__c> recVolRegList=new List<Volunteer_Registration__C>();
  List<Volunteer_Registration__c> volRegList=new List<Volunteer_Registration__c>();
  
  //constructor
  public creatingMultipleRecordsController()
  {
      tempTaskStart=new Task();
      tempTaskEnd=new Task();
      selectionDay='1';
      selectionPattern='1';
      hdnValue = 'Weekly';
      hdnValueForScheduler='endDate';
      xvalue=NULL;
      //volvisit=[Select student_volunteers__c,Volunteer_Visit_Duration__c, of_Toy_processing__c, of_Toy_Pre_packs__c, of_Towel_pre_packs__c, of_Shoes__c, of_Safety_packs__c, of_Raw_clothes__c, of_Potty_seats__c, of_Play_gyms_or_mats__c, of_Outfit_Pack__c, of_Orders__c, /*of_Impact_Bath_tubs__c,*/ of_Hats_gloves_Pack__c, of_Crib_mobiles__c, of_Coats__c, of_Bottle_packs__c, of_Book_Sort__c, of_Book_Bundles__c, of_Bedding_Pack__c, of_Bath_tubs__c, of_Baby_Equipment__c, /*middle_school_students__c, high_school_students__c, elementary_school_students__c,adult_volunteers__c, Volunteer_Work_Type__c,*/ Volunteer_Type__c, Visit_Count__c, View__c, /*Total_Impact__c,*/ Total_Est_volunteers__c, SystemModstamp, Status__c, Site__c, Scheduled_Start_Date_Time__c, /*Preferred_Dates__c,*/ Pre_registration_link_recipients__c, Org_Group__c, Name_of_the_Organization_Group_txt__c, Name, Main_Contact__c, Main_Contact_Volunteer__c, IsDeleted, /*Impact_Toy_processing__c, Impact_Toy_Pre_packs__c, Impact_Towel_pre_packs__c, Impact_Shoes__c, Impact_Safety_packs__c, Impact_Raw_clothes__c, Impact_Potty_seats__c, Impact_Play_gyms_or_mats__c, Impact_Outfit_Pack__c, Impact_Orders__c, Impact_Hats_gloves_Pack__c, Impact_Crib_mobiles__c, Impact_Coats__c, Impact_Bottle_packs__c, Impact_Book_Sort__c, Impact_Book_Bundles__c, Impact_Bedding_Pack__c, Impact_Bath_tubs__c, Impact_Baby_Equipment__c,*/ Id, /*First_time_volunteer_shift__c,*/ Family_wording__c, /*Email_list_of_registered_volunteer__c,*/ Eating_lunch__c, CreatedDate, CreatedById, Campaign__c, Anyone_under_18__c /*Actual_volunteers__c, Actual_hours__c*/ From Volunteer_Visit__c where Id =: ApexPages.currentPage().getParameters().get('id')];
      volvisit=[Select Volunteer_Visit_Duration__c,Volunteer_Type__c, Name, Status__c, Scheduled_Start_Date_Time__c, Org_Group__c, Name_of_the_Organization_Group_txt__c, Main_Contact__c From Volunteer_Visit__c where Id =: ApexPages.currentPage().getParameters().get('id')];
      //volvisit=[select Id,Main_Contact__c,Scheduled_Start_Date_Time__c,Name,Scheduled_End_Date_Time__c from volunteer_Visit__c limit 1];
      System.debug('>>>>volunteer visit'+volvisit);
    //thisevt=[select Id,StartDateTime from Event limit 1];
    
    if(volvisit.Scheduled_Start_Date_Time__c!=NULL)
      schStartDate=String.ValueOf(volvisit.Scheduled_Start_Date_Time__c.Date());
    else
      schStartDate=String.valueOf(System.today());
      
    duration = String.valueOF(volvisit.Volunteer_Visit_Duration__c) ;
    
  }
  
  public Boolean getCopy()
  {
    return copy;
  }
  
  public void setCopy(Boolean copy)
  {
    this.copy=copy;
  }
  
  public String gethdnValue()
  {
    return hdnValue;
  }
  
  public void sethdnValue(String hdnValue)
  {
    this.hdnValue=hdnValue;
  }
  
  public String gethdnValueForScheduler()
  {
    return hdnValueForScheduler;
  }
  
  public void sethdnValueForScheduler(String hdnValueForScheduler)
  {
    this.hdnValueForScheduler=hdnValueForScheduler;
  }
  
  
  
  public String getxvalue()
  {
    return xvalue;
  }
  
  public void setxValue(String xvalue)
  {
    this.xvalue=xvalue;
  }
  
  
  public String getselectionScheduleBy()
  {
    return selectionScheduleBy;
  }
  
  public void setselectionScheduleBy(String selectionScheduleBy)
  {
    this.selectionScheduleBy=selectionScheduleBy;
  }
  
  public String getOccurences()
  {
    return Occurences;
  }
  
  public void setOccurences(String Occurences)
  {
    this.Occurences=Occurences;
  }
  public Task gettempTaskStart()
  {
    if(volvisit.Scheduled_Start_Date_Time__c!=NULL)
    {
     // tempTaskStart.ActivityDate=volvisit.Scheduled_Start_Date_Time__c.Date();
    }
    
    return tempTaskStart;
  }
  
  
  public void settempTaskStart(Task tempTaskStart)
  {
    this.tempTaskStart=tempTaskStart;
  }
    
  public Task gettempTaskEnd()
  {
    if(volvisit.Scheduled_Start_Date_Time__c!=NULL)
    {
     // tempTaskEnd.ActivityDate=volvisit.Scheduled_Start_Date_Time__c.Date();
    }
    
    return tempTaskEnd;
  }
  
  
  public void settempTaskEnd(Task tempTaskEnd)
  {
    this.tempTaskEnd=tempTaskEnd;
  }
  
  public String getstartDateFromSelection()
  {
     //String hr=startTime.substring(0,2);
     //String min=startTime.subString(3,5);
     
     //Time thisTime=Time.newInstance(Integer.valueOf(hr),Integer.valueOf(min),00,00);
     //startDateFromSelection=DateTime.newInstance((volvisit.Scheduled_Start_Date_Time__c).Date(),thisTime);
    //return startDateFromSelection;
    startDateFromSelection=String.valueOf(volvisit.Scheduled_Start_Date_Time__c);
    return startDateFromSelection;
  }
  
  //getting and setting volunteer visit record
  public Volunteer_Visit__c getvolvisit()
  {
   return volvisit;
  }
  
  public void setvolVisit(Volunteer_Visit__c volvisit)
  {
    this.volvisit=volvisit;
  }
  
  public void setstartDateFromSelection(String startDateFromSelection)
  {
    this.startDateFromSelection=startDateFromSelection;
  }
  
   
  public String getselectionRepeat()
  {
    return selectionRepeat;
  }
  
  public void setselectionRepeat(String selectionRepeat)
  {
    this.selectionRepeat=selectionRepeat;
  }
  
  public String getselectionDay()
  {
    return selectionDay;
  }
  
  public void setselectionDay(String selectionDay)
  {
    this.selectionDay=selectionDay;
  }
  
  public String getstartTime()
  {
    //startTime='11:00 AM';
    return startTime;
  }
  
  public void setstartTime(String startTime)
  {
     this.startTime=startTime;
  }
  
  public void setschStartDate(String schStartDate)
  {
    this.schStartDate=schStartDate;
  }
  
  public String getschStartDate()
  {
   if(volvisit.Scheduled_Start_Date_Time__c!=NULL)
    schStartDate=String.ValueOf(volvisit.Scheduled_Start_Date_Time__c.Date());
   return schStartDate;
  }
  
 
  
  
  public String getendTime()
  {
    return endTime;
  }
  
  public void setendTime(String endTime)
  {
     this.endTime=endTime;
      
  }
  
   
  public List<SelectOption> getItemsRepeat() 
  {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Weekly'));
        options.add(new SelectOption('2','Every x weeks'));
        options.add(new SelectOption('3','Monthly'));
        return options;
  }
  
  public List<SelectOption> getItemsScheduleBy() 
  {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','End Date'));
        options.add(new SelectOption('2','Occurences'));
        return options;
  }
  
  public List<SelectOption> getItemsPattern() 
  {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','First'));
        options.add(new SelectOption('2','Second'));
        options.add(new SelectOption('3','Third'));
        options.add(new SelectOption('4','Fourth'));
        options.add(new SelectOption('5','Last'));
        return options;
  }
  
  public List<SelectOption> getItemsDay() 
  {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Monday'));
        options.add(new SelectOption('2','Tuesday'));
        options.add(new SelectOption('3','Wednesday'));
        options.add(new SelectOption('4','Thursday'));
        options.add(new SelectOption('5','Friday'));
        options.add(new SelectOption('6','Saturday'));
        options.add(new SelectOption('7','Sunday'));
          
        return options;
  }
  
  public List<SelectOption> getCategoriesStart() 
  {
      List<SelectOption> optionList = new List<SelectOption>();
      DateTime thisStart=System.now();
      if(volvisit.Scheduled_Start_Date_Time__c!=NULL)
        thisStart=volvisit.Scheduled_Start_Date_Time__c;
      
        
        Integer min=thisStart.minute();
        Integer hour=thisStart.hour();
        System.debug(hour);
        System.debug(min);
        System.debug('start datetime'+thisStart);
        if(min>30 && min<60)
        {
          thisStart=thisStart.addMinutes(-(min-30));
          min=thisStart.minute();
        } 
        else
        {
          thisStart=thisStart.addMinutes(-(min));
          min=thisStart.minute();
        }
        
       
                
        if(hour>=12)
        {
          if(hour!=12)
           hour=hour-12;
          if(min<10)
            optionList.add(new SelectOption(hour+':0'+min+' PM',hour+':0'+min+' PM'));
          else
            optionList.add(new SelectOption(hour+':'+min+' PM',hour+':'+min+' PM'));
        }
        
        else
        {
          if(min<10)
            optionList.add(new SelectOption(hour+':0'+min+' AM',hour+':0'+min+' AM'));
          else
            optionList.add(new SelectOption(hour+':'+min+' AM',hour+':'+min+' AM'));
        }
       
        optionList.add(new SelectOption('7:00 AM','7:00 AM'));
        optionList.add(new SelectOption('7:30 AM','7:30 AM'));
        optionList.add(new SelectOption('8:00 AM','8:00 AM'));
        optionList.add(new SelectOption('8:30 AM','8:30 AM'));
        optionList.add(new SelectOption('9:00 AM','9:00 AM'));
        optionList.add(new SelectOption('9:30 AM','9:30 AM'));
        optionList.add(new SelectOption('10:00 AM','10:00 AM'));
        optionList.add(new SelectOption('10:30 AM','10:30 AM'));
        optionList.add(new SelectOption('11:00 AM','11:00 AM'));
        optionList.add(new SelectOption('11:30 AM','11:30 AM'));
        optionList.add(new SelectOption('12:00 PM','12:00 PM'));
        optionList.add(new SelectOption('12:30 PM','12:30 PM'));
        optionList.add(new SelectOption('1:00 PM','1:00 PM'));
        optionList.add(new SelectOption('1:30 PM','1:30 PM'));
        optionList.add(new SelectOption('2:00 PM','2:00 PM'));
        optionList.add(new SelectOption('2:30 PM','2:30 PM'));
        optionList.add(new SelectOption('3:00 PM','3:00 PM'));
        optionList.add(new SelectOption('3:30 PM','3:30 PM'));
        optionList.add(new SelectOption('4:00 PM','4:00 PM'));
        optionList.add(new SelectOption('4:30 PM','4:30 PM'));
        optionList.add(new SelectOption('5:00 PM','5:00 PM'));
        optionList.add(new SelectOption('5:30 PM','5:30 PM'));
        optionList.add(new SelectOption('6:00 PM','6:00 PM'));
        optionList.add(new SelectOption('6:30 PM','6:30 PM'));
        optionList.add(new SelectOption('7:00 PM','7:00 PM'));
        optionList.add(new SelectOption('7:30 PM','7:30 PM'));
        optionList.add(new SelectOption('8:00 PM','8:00 PM'));
       
        
      return optionList;     
    }
    
    public String getDuration()
    {
       return duration;
    }
    
    public void setDuration(String duration)
    {
      this.duration=duration;
    }   
  
  public String getselectionPattern() 
  {
        return selectionPattern;
  }
  
  public void setselectionPattern(String selectionPattern)
  {
    this.selectionPattern=selectionPattern;
  }
  
  public List<Volunteer_Visit__c> getrecurringVolVisitList()
  {
    System.debug('recurring list>>>>'+recurringVolVisitList);
    return recurringVolVisitList;
  }
  
  public void setrecurringVolVisitList(List<Volunteer_Visit__c> recurringVolVisitList)
  {
     this.recurringVolVisitList=recurringVolVisitList;
  }
  
  
 public PageReference send()
  {
    try
    {
    
    
    Integer flag=0;
    Time starting;
    Integer hrStarting,hrEnding;
    
    /* ----------------------------------------- validation checks begin ----------------------------------- */
    recVolRegList=new List<Volunteer_Registration__c>();
    
    if(tempTaskStart.ActivityDate==NULL)
    {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Must enter a Start Date'));
       return NULL;
    }
    
    if(startTime!=NULL)
    {
        if(startTime.contains('AM'))
        {
          String[] split=(startTime.split(':',2));
          hrStarting=Integer.valueOf(split[0]);
          if(hrStarting==12)
            hrStarting=00;
          Integer min=Integer.valueOf((split[1].split(' ',2))[0]);
          starting=Time.newInstance(hrStarting,min,00,00);
        }
        else if(startTime.contains('PM'))
        {     
          String[] split=(startTime.split(':',2));
          hrStarting=Integer.valueOf(split[0]);
          if(hrStarting!=12)
            hrStarting=hrStarting+12;
          Integer min=Integer.valueOf((split[1].split(' ',2))[0]);
          starting=Time.newInstance(hrStarting,min,00,00); 
        }
    }
    else
    {
      
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Must enter a Start Time'));
      return NULL;
    }
    
    if(tempTaskEnd.ActivityDate==NULL && occurences==NULL)
    {
         
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Must enter either end date/Occurences'));
      return NULL;
    }  
    
    if(tempTaskStart.ActivityDate<system.today())
    {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Start Date must be a date greater than today'));
       return NULL;
    }
    else
    {   
      flag=1;
    }
    
    if(hdnValueForScheduler=='endDate')
    {
       if(tempTaskEnd.ActivityDate<tempTaskStart.ActivityDate)
       {
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'End Date must be greater than start date'));
         return NULL;
       }
    }
    
   
    Integer durationData;
    Integer xvalueData;
    Integer occurencesData;
    try
    {
      durationData=Integer.valueOf(duration);
    }
    catch(Exception e)
    {
       flag=0;
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Duration has to be an Integer in Minutes'));
       return NULL;
    }
    
    if(hdnValueForScheduler!='occurences')
    {
      if(hdnValueForScheduler!='endDate')
      {
        flag=0;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Select one: End Date or Occurences'));
        return NULL;
      }
    }
    if(hdnValue=='everyXWeek')
    {
      try
      {
        xvalueData=Integer.valueOf(xValue);
      }
      catch(Exception e)
      {
        flag=0;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Value of X has to be an integer'));
        return NULL;
      }
    }
    
    if(hdnValueForScheduler=='occurences')
    {
      try
      {
        occurencesData=Integer.valueOf(Occurences);
       }
       catch(Exception e)
       {
        flag=0;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Occurences has to be an integer'));
        return NULL;
       }
    }
    
    /* ----------------------------------- validation checks end ------------------------------------ */
    
    /* ----------------------------------- actual functionality begins ------------------------------ */
    
    if(flag!=0)
    {
      System.debug('inside the method send>>>');
   
      recurringVolVisitList=new List<Volunteer_Visit__c>();
     
      stDate=DateTime.newInstance(tempTaskStart.ActivityDate,starting);
     
      //getting the integer value of the start day     
      Integer startDayCount=getDayOfDate(StDate.format('E'));
      
       
      //getting the Integer value of the Day entered       
      Integer daySendMail=Integer.valueOf(selectionDay);
      
      Date datePart;
     
      //bringing the stDate to the actual initial value(in terms of the day)     
      if(hdnValue=='Weekly'|| hdnValue=='everyXWeek')
      {
        System.debug('1>>>>');
          if(startDayCount<daySendMail)
          {
            stDate=stDate.addDays(daySendMail-startDayCount);
          }
          else if(startDayCount>daySendMail)
          {
            stDate=stDate.addDays(7-(startDayCount-daySendMail));
          }
          
          
      }//if weekly or every x weeks
      
      else if(hdnValue=='Monthly')
      {
         System.debug('2>>>');
         
         System.debug('AAAAAAAAAAA' +stDate);
         //moving the date to the start of the month
         
         
         datePart=stDate.Date();
         datePart=datePart.toStartOfMonth();
         
         
         System.debug(datePart);
         
         //constructing a datetime for the start of the month
         DateTime startOfMonth=DateTime.newInstance(datePart,stDate.Time());
         
         System.debug('start of month before>>>>>>>>>>>'+startOfMonth);
         
         
         
        
         
         //getting the integer value of the day for the start day of the month
         Integer startDayOfMonthCount=getDayOfDate(startOfMonth.format('E'));         
         
         System.debug(startDayOfMonthCount);
         System.debug(daySendMail);
         
         //getting to the day
         if(startDayOfMonthCount<daySendMail)
          {
             startOfMonth=startOfMonth.addDays(daySendMail-startDayOfMonthCount);
          }
          else if(startDayOfMonthCount>daySendMail)
          {
            System.debug('count'+(7-(startDayOfMonthCount-daySendMail)));
             startOfMonth=startOfMonth.addDays(7-(startDayOfMonthCount-daySendMail));
          }
    
          System.debug('startOfMonth after'+startOfMonth);
          
          
          //moving the start of the month acording to the pattern 
          if(SelectionPattern=='1')
          {
            //startOfMonth
          }
          else if(SelectionPattern=='2')
          {
            startOfMonth=startOfMonth.addDays(7);
          }
          else if(SelectionPattern=='3')
          {
            startOfMonth=startOfMonth.addDays(14);
          }
          else if(SelectionPattern=='4')
          {
            startOfMonth=startOfMonth.addDays(21);
          }
          else if(SelectionPattern=='5')
          {
            //check if it is exceeding tat month
            if((startOfMonth.addDays(28)).Date()<datePart.addMonths(1))
              startOfMonth=startOfMonth.addDays(28);
            else
              startOfMonth=startOfMonth.addDays(21);
              
          }
          
          System.debug('startOfMonth after pattern'+startOfMonth);
          
          System.debug('stDate>>>>>>>>>>>>>'+stDate);
          
          if(startOfMonth<stDate)
            stDate=startOfMonth.addMonths(1);
         
        
        }//for monthly
            
       System.debug('start Time>>>'+startTime);
      
      System.debug('intermediary>>>>'+stDate);
      Boolean tempFlag=true;
      
      DateTime newstDate=DateTime.newInstance(stDate.date(),starting);
      stDate=newstDate;
      
      System.debug(stDate);
      
      if(stDate<System.now() || stDate.Date()==volvisit.Scheduled_Start_Date_Time__c.Date())
      {
        if(hdnValue=='Weekly')
        {
          stDate=stDate.addDays(7);
        }
        else if(hdnValue=='everyXWeek')
        {
          stDate=stDate.addDays(7*xvalueData);
        }
        else if(hdnvalue=='Monthly')
        {
           //stDate=stDate.addDays(28);
        }
        timeLapseFlag=1;
      }
           
      DateTime thisEndDate;
      
      //if occurences is selected   
      if(hdnValueForScheduler=='occurences')
      {
        for(Integer i=0;i<occurencesData;i++)
        {
       
          
         thisEndDate=stDate.addMinutes(durationData);
       
         Date datePartLoop;
       
         datePartLoop=stDate.Date();
         
         System.debug('inside occurences XXXXXXXXXX'+stDate);
         
         
         //moving the date to the start of the month
         datePartLoop=datePartLoop.toStartOfMonth();
         System.debug(datePartLoop);
       
        System.debug(i);
        if(hdnValue=='Weekly')//if weekly
        {
            //create the custom object
            DateTime tempStart=DateTime.newInstance(stDate.Date(),starting);
            DateTime tempEnd=tempStart.addMinutes(durationData);
            thisEndDate=stDate.addMinutes(durationData);
            Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
            
            recurringVolVisit=volVisit.clone(false,true);
            
            recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
            recurringVolVisit.Scheduled_Start_Date_Time__c=tempStart;
            //recurringVolVisit.Scheduled_End_Date_Time__c=tempEnd;
            recurringVolVisit.Status__c='Scheduled';
            recurringVolVisit.volunteer_visit_duration__c=durationData;
            //recurringVolVisit.Actual_Date_Time__c=NULL;
            recurringVolVisit.Main_Contact_Volunteer__c=false;
            recurringVolVisit.volunteer_work_type__c = '';
            //
     		recurringVolVisit.IsRecurring__c=true;
            //
            System.debug(recurringVolVisit.Id);
            recurringVolVisitList.add(recurringVolVisit);
            
            
            stDate=stDate.addDays(7);
            System.debug('>>>>>>loop'+stDate);
        }//if weekly
        
        else if(hdnValue=='everyXWeek')//if every x weeks
        {
            //create the custom object
            DateTime tempStart=DateTime.newInstance(stDate.Date(),starting);
            DateTime tempEnd=tempStart.addMinutes(durationData);
            thisEndDate=stDate.addMinutes(durationData);
            Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
            recurringVolVisit=volVisit.clone(false,true);
            recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
            recurringVolVisit.volunteer_work_type__c = '';
            recurringVolVisit.Scheduled_Start_Date_Time__c=tempStart;
            //recurringVolVisit.Scheduled_End_Date_Time__c=tempEnd;
            recurringVolVisit.Status__c='Scheduled';
            recurringVolVisit.volunteer_visit_duration__c=durationData;
            recurringVolVisit.Main_Contact_Volunteer__c=false;
            //
            recurringVolVisit.IsRecurring__c=true;
            //
            recurringVolVisitList.add(recurringVolVisit);
            
            
            
            stDate=stDate.addDays((7*xvalueData));
            System.debug('>>>>>>loop'+stDate);
            
        }//if every x weeks
        
        else if(hdnValue=='Monthly')//if monthly
        {
         
          //moving the date to the start of the month
          
          System.debug('looping stDateAAAAAAA'+stDate);
          
          datePart=stDate.Date();
          //datePart=datePart.addMonths(1).toStartOfMonth();
          datePart=datePart.toStartOfMonth();
          
          System.debug('XXXXXX start date Of month BBBBBB'+datePart);
          
         //constructing a datetime for the start of the month
         DateTime startOfMonth=DateTime.newInstance(datePart,stDate.Time());
         
         System.debug('XXXXXX start date time Of month BBBBBB'+datePart);
         
         //getting the integer value of the day for the start day of the month
         Integer startDayOfMonthCount=getDayOfDate(startOfMonth.format('E'));         
         
         //System.debug('start of month day>>>'+startDayOfMonthCount);
         //System.debug(daySendMail);
         
         //getting to the day
         if(startDayOfMonthCount<daySendMail)
          {
             System.debug('counta'+((daySendMail-startDayOfMonthCount)));
             startOfMonth=startOfMonth.addDays((daySendMail-startDayOfMonthCount));
          }
          else if(startDayOfMonthCount>daySendMail)
          {
            System.debug('countb'+(7-(startDayOfMonthCount-daySendMail)));
             startOfMonth=startOfMonth.addDays(7-(startDayOfMonthCount-daySendMail));
          }
    
          System.debug('startOfMonth after pattern CCCCCCC'+startOfMonth);
          
          //moving the start of the month acording to the pattern 
          if(SelectionPattern=='1')
          {
            //startOfMonth
          }
          else if(SelectionPattern=='2')
          {
            startOfMonth=startOfMonth.addDays(7);
          }
          else if(SelectionPattern=='3')
          {
            startOfMonth=startOfMonth.addDays(14);
          }
          else if(SelectionPattern=='4')
          {
            startOfMonth=startOfMonth.addDays(21);
          }
          else if(SelectionPattern=='5')
          {
            //check if it is exceeding tat month
            if((startOfMonth.addDays(28)).Date()<datePart.addMonths(1))
              startOfMonth=startOfMonth.addDays(28);
            else
              startOfMonth=startOfMonth.addDays(21);
              
          }
          
          System.debug('startOfMonth after main pattern DDDDDDDD'+startOfMonth);
          
          //if(startOfMonth<stDate)
            //stDate=startOfMonth.addMonths(1);
          //else
            stDate=startOfMonth;
     
     
         newstDate=DateTime.newInstance(stDate.date(),starting);
         stDate=newstDate;
      
         System.debug('final stDate EEEEEEEE'+stDate);
         
         thisEndDate=stDate.addMinutes(durationData);
      
        Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
        recurringVolVisit=volVisit.clone(false,true);
        recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
        recurringVolVisit.volunteer_work_type__c = '';
        recurringVolVisit.Scheduled_Start_Date_Time__c=stDate;
        //recurringVolVisit.Scheduled_End_Date_Time__c=thisEndDate;
        recurringVolVisit.Status__c='Scheduled';
        recurringVolVisit.Volunteer_Visit_Duration__c=durationData;
        recurringVolVisit.Main_Contact_Volunteer__c=false;
        //
        recurringVolVisit.IsRecurring__c=true;
        //
        recurringVolVisitList.add(recurringVolVisit);
        
       
        stDate=stDate.addMonths(1); 
          
      }//if monthly
        
       
       
           
       System.debug('>>>>>>loop'+stDate);
      }//for occurences
      
      }//if occurences
      
      else if(hdnValueForScheduler=='endDate')
      {
        
        
       
          System.debug('#########################');
          System.debug('stDate>>>>>>>'+stDate.Date());
          System.debug('end Date>>>>>>>>>>'+tempTaskEnd.ActivityDate);
        
          System.debug('Begnning stdateAAAAA'+stDate);
          
          thisEndDate=stDate.addMinutes(durationData);
       
                
        //System.debug(i);
        if(hdnValue=='Weekly')//if weekly
        {
        
          while(stDate.Date()<=tempTaskEnd.ActivityDate)
          {
            //create the custom object
            DateTime tempStart=DateTime.newInstance(stDate.Date(),starting);
            DateTime tempEnd=tempStart.addMinutes(durationData);
            thisEndDate=stDate.addMinutes(durationData);
            Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
            recurringVolVisit=volVisit.clone(false,true);
            
            recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
            recurringVolVisit.volunteer_work_type__c = '';
            recurringVolVisit.Scheduled_Start_Date_Time__c=tempStart;
            //recurringVolVisit.Scheduled_End_Date_Time__c=tempEnd;
            recurringVolVisit.Main_Contact_Volunteer__c=false;
            recurringVolVisit.Status__c='Scheduled';
            recurringVolVisit.Volunteer_Visit_Duration__c=durationData;
            //
            recurringVolVisit.IsRecurring__c=true;
            //
            System.debug(recurringVolVisit.Id);
            recurringVolVisitList.add(recurringVolVisit);
            
            
            stDate=stDate.addDays(7);
            System.debug('>>>>>>loop'+stDate);
          }//while
        }//if weekly
        
        else if(hdnValue=='everyXWeek')//if every x weeks
        {
          while(stDate.Date()<=tempTaskEnd.ActivityDate)
          {
            //create the custom object
            DateTime tempStart=DateTime.newInstance(stDate.Date(),starting);
            DateTime tempEnd=tempStart.addMinutes(durationData);
            thisEndDate=stDate.addMinutes(durationData);
            Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
            recurringVolVisit=volVisit.clone(false,true);
            recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
            recurringVolVisit.volunteer_work_type__c = '';
            recurringVolVisit.Scheduled_Start_Date_Time__c=tempStart;
            //recurringVolVisit.Scheduled_End_Date_Time__c=tempEnd;
            recurringVolVisit.Status__c='Scheduled';
            recurringVolVisit.Volunteer_Visit_Duration__c=durationData;
            recurringVolVisit.Main_Contact_Volunteer__c=false;
            //
            recurringVolVisit.IsRecurring__c=true;
            //
            recurringVolVisitList.add(recurringVolVisit);
            
                        
            stDate=stDate.addDays((7*xvalueData));
            System.debug('>>>>>>loop'+stDate);
          } 
        }//if every x weeks
     
      
      
        else if(hdnValue=='Monthly')//if monthly
        {
          
          while(tempFlag)
          {        
           
          //moving the date to the start of the month
          
          System.debug('beginning stDAte AAAAAA!!!!!'+stDate);
          
          datePart=stDate.Date();
          //datePart=datePart.addMonths(1).toStartOfMonth();
          datePart=datePart.toStartOfMonth();
          
          System.debug('XXXXXX start datePart BBBBBBBBBBB'+datePart);
          
         //constructing a datetime for the start of the month
         DateTime startOfMonth=DateTime.newInstance(datePart,stDate.Time());
         
         System.debug('XXXXXX start date CCCCCCCCCCCC'+datePart);
         
         //getting the integer value of the day for the start day of the month
         Integer startDayOfMonthCount=getDayOfDate(startOfMonth.format('E'));         
         
         System.debug('start of month day>>>'+startDayOfMonthCount);
         System.debug(daySendMail);
         
         //getting to the day
         if(startDayOfMonthCount<daySendMail)
          {
             System.debug('counta'+((daySendMail-startDayOfMonthCount)));
             startOfMonth=startOfMonth.addDays((daySendMail-startDayOfMonthCount));
          }
          else if(startDayOfMonthCount>daySendMail)
          {
            System.debug('countb'+(7-(startDayOfMonthCount-daySendMail)));
             startOfMonth=startOfMonth.addDays(7-(startDayOfMonthCount-daySendMail));
          }
    
          System.debug('startOfMonth initial DDDDDDDDDDDDDDDD'+startOfMonth);
          
          //moving the start of the month acording to the pattern 
          if(SelectionPattern=='1')
          {
            //startOfMonth
          }
          else if(SelectionPattern=='2')
          {
            startOfMonth=startOfMonth.addDays(7);
          }
          else if(SelectionPattern=='3')
          {
            startOfMonth=startOfMonth.addDays(14);
          }
          else if(SelectionPattern=='4')
          {
            startOfMonth=startOfMonth.addDays(21);
          }
          else if(SelectionPattern=='5')
          {
            //check if it is exceeding tat month
            if((startOfMonth.addDays(28)).Date()<datePart.addMonths(1))
              startOfMonth=startOfMonth.addDays(28);
            else
              startOfMonth=startOfMonth.addDays(21);
              
          }
          
          System.debug('startOfMonth after pattern EEEEEEEEEEEEEEEE'+startOfMonth);
          
          //if(startOfMonth<stDate)
           // stDate=startOfMonth.addMonths(1);
          //else
            stDate=startOfMonth;
          
        
        
            
       System.debug('start Time>>>'+startTime);
      
     
      newstDate=DateTime.newInstance(stDate.date(),starting);
      stDate=newstDate;
      
      System.debug('final value >>>>>>>>>>>>>>>FFFFFFFFFFFFFFF '+stDate);
      
      thisEndDate=stDate.addMinutes(durationData);
      if(stDate.Date()>tempTaskEnd.ActivityDate)
      {
        tempFlag=false;
        break;
      }
      
        Volunteer_Visit__c recurringVolVisit = new Volunteer_Visit__c(); 
        recurringVolVisit=volVisit.clone(false,true);
        recurringVolVisit.Main_Contact__c=volVisit.Main_Contact__c;
        recurringVolVisit.volunteer_work_type__c = '';
        recurringVolVisit.Scheduled_Start_Date_Time__c=stDate;
        //recurringVolVisit.Scheduled_End_Date_Time__c=thisEndDate;
        recurringVolVisit.Main_Contact_Volunteer__c=false;
        recurringVolVisit.Status__c='Scheduled';
        recurringVolVisit.Volunteer_Visit_Duration__c=durationData;
        //
        recurringVolVisit.IsRecurring__c=true;
        //
        recurringVolVisitList.add(recurringVolVisit);
        
        
         stDate=stDate.addMonths(1); 
          
          
        }//while
        
         System.debug('loop>>>>>>>>'+stDate);
         
       }//if monthly
      
      }//if end date
       
      System.debug(recurringVolVisitList);
      
      if(recurringVolVisitList.size()<=0)
      {
        if(timeLapseFlag==1)
        {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Time has lapsed and hence no records created'));
           return NULL;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No records created as no matches were found in the given time interval'));
        return NULL;
        
      }
      
      
      //inserting the volunteer visit objects
      if(recurringVolVisitList.size()>0)
      {
        System.debug(recurringVolVisitList);
        insert recurringVolVisitList;
        System.debug('afterXXXXXXXXXXXX'+recurringVolVisitList);
      }
      
      List<Volunteer_Registration__c> insertVolReg=new List<Volunteer_Registration__c>();
      
      
      if(copy==true)
      {
        volRegList=[Select Volunteer_Visit__c, Volunteer_Visit_Scheduled__c, View__c, SystemModstamp, Status__c, Role__c, Repeat__c, Org_ID__c, Name, IsDeleted, Inquiry_Type__c, Contact__c, Con_ID__c, Con_Email__c, Badge_Name__c, Are_you_under_18__c From Volunteer_Registration__c where volunteer_Visit__c =: volvisit.Id];
        System.debug('vol reg of orig>>'+volRegList);
        System.debug('rec volvisit>>'+recurringVolVisitList);
        
        List<Volunteer_Registration__c> clonedVolReg=new List<Volunteer_Registration__c>();
        
        List<Volunteer_Registration__c> clonedVolRegtwo=volRegList.deepClone(false);
        
        /*for(Integer i=0;i<volRegList.size();i++)
        {
          Volunteer_Registration__c thisVolReg=new Volunteer_Registration__c();
          thisVolReg=volRegList[i].clone(false,false);
          clonedVolReg.add(thisVolReg);
        }*/
        
        //Volunteer_Registration__c[] clonedVolReg=volRegList.deepClone();
        
        insertVolReg=new List<Volunteer_Registration__c>();
        
       /* for(Integer i=0;i<recurringVolVisitList.size();i++)
        {
          
          System.debug('i is xxxxxxxxxxxxxxxxxxxxxxxxx'+i);
          System.debug(recurringVolVisitList[i].Id);
          
          for(Integer n=0;n<clonedVolReg.size();n++)
          {
            System.debug('here');
            System.debug(recurringVolVisitList[i].Id);
            clonedVolReg[n].Volunteer_Visit__c=recurringVolVisitList[i].Id;
            
            insertVolReg.add(clonedVolReg[n]);
            System.debug('individual>>'+clonedVolReg[n]);
          }
          
         
        }*/
        System.debug('insert>>'+insertVolReg);
      
      
       for (Volunteer_Visit__c obj1 : recurringVolVisitList)
        {
           for (Volunteer_Registration__c obj :volRegList)
           {
             SOBject sObj = (SObject)obj ; 
             system.debug('Insert');
             Volunteer_Registration__c tempObj = (Volunteer_Registration__c) sObj.clone(false,false);  
             tempObj.Volunteer_Visit__c= obj1.Id;
            tempObj.Status__c= 'Pre-registered';
              insertVolReg.add(tempObj);
            }
        }
        insert insertVolReg;
        
       /*System.debug(clonedVolRegtwo + 'clonedVolRegtwo' + clonedVolRegtwo.size());
       for(Integer i=0;i<recurringVolVisitList.size();i++)
        {
          
          System.debug('i is xxxxxxxxxxxxxxxxxxxxxxxxx'+i);
          System.debug(recurringVolVisitList[i].Id);
          
          for(Integer n=0;n<clonedVolRegtwo.size();n++)
          {
            Volunteer_Registration__c volRegObj = clonedVolRegtwo[n];
            volRegObj.Volunteer_Visit__c = recurringVolVisitList[i].Id;
            System.debug('here');
            System.debug(recurringVolVisitList[i].Id);

            //clonedVolRegtwo[n].Volunteer_Visit__c=recurringVolVisitList[i].Id;
            
            //insertVolReg.add(clonedVolRegtwo[n]);
            insertVolReg.add(volRegObj);
            System.debug(insertVolReg + 'individual>>'+clonedVolRegtwo[n]);
          }
          
         
        }
        System.debug('insert>>'+insertVolReg);
      }
      
      if(insertVolReg.size()>0)
      {
        System.debug('before vol reg'+insertVolReg);
        insert insertVolReg;
        System.debug('after vol regXXXXXXX'+insertVolReg);
      }*/
      }
      System.debug(recVolRegList);
      
     System.debug('>>>>>>inserted'+recurringVolVisitList);
     //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Send invoked'));
     PageReference newPage=new PageReference('/apex/resultPage');
     
     return newPage;
    }//checking the flag
    else
      return NULL;
   }//try
   catch(Exception e)
   {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Exception caught is'+e));
      return NULL;
   }
 }//end of function send
    
     //function to calculate the Integer value of the day
     public integer getDayOfDate(String day)
     {
          if(day=='mon')
              return 1;
          else if(day=='tue')
              return 2;
          else if(day=='wed')     
              return 3;
          else if(day=='thu')
              return 4;
          else if(day=='fri')   
             return 5;
          else if(day=='sat')  
             return 6;
          else if(day=='sun')  
             return 7;
          else
             return 0;
      }//end of function getDayOfDate
      
      public PageReference bnCancel()
      {
        PageReference thisPage=new PageReference('/'+volvisit.Id);
        thisPage.setRedirect(true);
        return thisPage;
      }
 
      
}//end of controller class
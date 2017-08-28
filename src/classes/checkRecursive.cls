// Class for handling the recurrsion in the trigger

public Class checkRecursive{
   private static boolean run = true;
   public static boolean runOnce()
   {
       if( run )
       {
           run=false;
           return true;
       }
       else
       {
           return run;
       }
   }
   
   
   private static boolean rec = true;
   
   public static boolean avoidRecurssion()
   {
       if( rec )
       {
            rec = false;
           return true;
       }
       return false;
   }
   
}
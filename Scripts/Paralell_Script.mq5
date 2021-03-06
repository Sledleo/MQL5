#property copyright "Copyright 2017, MetaQuotes Software Corp."   #property link "https://www.mql5.com"    #property version "1.00"

#property script_show_inputs

input int TimeSleep = 10000;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   GlobalVariableSet( "TradeProcessor",  0 );

   Print("Script");

   while( GlobalVariableGet( "TradeProcessor" ) )
   {
      Print("Script Sleep - " + (string)(TimeSleep/1000) + " sec");
      
      GlobalVariableSet( "TradeProcessor",  GlobalVariableGet( "TradeProcessor" ) + 1 );
      
      Print( "TradeProcessor = " + (string)GlobalVariableGet( "TradeProcessor" ) );
      
      Sleep(TimeSleep);
   }
   
   Print("Script");

}
//+------------------------------------------------------------------+
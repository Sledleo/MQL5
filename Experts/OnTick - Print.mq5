#property copyright "Copyright 2017, MetaQuotes Software Corp." #property link "https://www.mql5.com" #property version "1.00"



//+------------------------------------------------------------------+
//
// Эксперт выводит все сообщения по событию OnTick в лог.
//
//+------------------------------------------------------------------+



#include <UserLib\ScriptFunc.mqh>   // Библиотека прикладных функций

int iii=0;

//+------------------------------------------------------------------+
int OnInit()
{
   Print( "======================================================== " );
   Print( "======================= START ========================== " );
   Print( "======================================================== " );
   EventSetTimer(1);   return(INIT_SUCCEEDED);
}



//+------------------------------------------------------------------+
void OnDeinit(const int reason)  {   EventKillTimer();   }



//+------------------------------------------------------------------+
void OnTick()
{
   MqlTick Tick;
   
   SymbolInfoTick( 
      _Symbol,       // символ 
      Tick           // ссылка на структуру MqlTick
   );
   
   
   
   if ( (Tick.flags & TICK_FLAG_LAST) == TICK_FLAG_LAST )

      Print( (string)iii + " = LAST = " );
      
      
   if ( (Tick.flags & TICK_FLAG_BUY) == TICK_FLAG_BUY )
   
      Print( (string)iii + " = BUY = " + (string)Tick.last + "    V = " + (string)Tick.volume );
      
   else
   
      Print( (string)iii + " = SELL = " + (string)Tick.last + "    V = " + (string)Tick.volume );
         
         
   if (  (Tick.flags & TICK_FLAG_ASK) == TICK_FLAG_ASK  )
   {
      Print( (string)iii + " = ASK = " + (string)Tick.ask ); 
   }
   
   
   if (  (Tick.flags & TICK_FLAG_BID) == TICK_FLAG_BID  )
   {
      Print( (string)iii + " = BID = " + (string)Tick.bid );
   }
   
   iii++;
   
   //TICK_FLAG_BID – тик изменил цену бид
   //TICK_FLAG_ASK  – тик изменил цену аск
   //TICK_FLAG_LAST – тик изменил цену последней сделки
   //TICK_FLAG_VOLUME – тик изменил объем
   //TICK_FLAG_BUY – тик возник в результате сделки на покупку
   //TICK_FLAG_SELL – тик возник в результате сделки на продажу
}



//+------------------------------------------------------------------+
void OnTimer()
{
   Print( "==OnTimer()=====" );
}
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\AccountInfo.mqh>


//--- объект для работы со счетом
CAccountInfo account;

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
int OnInit()
{
   Print("===========");
   
   
   
//--- create timer
   EventSetTimer(60);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();
      
}

//+------------------------------------------------------------------+
void OnTick()
{
//---
   
}

//+------------------------------------------------------------------+
void OnTimer()
{


}

//+------------------------------------------------------------------+
void OnTrade()
{

   
}
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, MetaQuotes Software Corp." #property link "https://www.mql5.com" #property version "1.00"

int i = 0;


//+------------------------------------------------------------------+
int OnInit()
{
   EventSetMillisecondTimer( 500 );
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
}

//+------------------------------------------------------------------+
void OnTimer()
{
   Print( "i = " + (string)i );
   i++;
}

//+------------------------------------------------------------------+
void OnTick()
{

}
//+------------------------------------------------------------------+

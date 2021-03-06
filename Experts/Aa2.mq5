//+------------------------------------------------------------------+
//|                                                          Aa1.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>    // Библиотека CTrade
CTrade trader;                // Объект CTrade

#include <UserLib\BaseFunc.mqh>     // Библиотека базовых функций
#include <UserLib\ScriptFunc.mqh>   // Библиотека прикладных функций

// Внешние константы скрипта
input double   Lot         = 1;
input int      TakeProfit  = 10;
input int      StopeLoss   = 65;

struct strTrade   {           // 49800
   int   Min   [65000],       // минимальная цена за секунду
         Max   [65000];       // максимальная цена за секунду 
   bool  Fl    [65000];       // флаг
}; 


// Глобальные переменные скрипта

strTrade t;       // Торговая структура

int   TP,
      SL,
      Sec,
      Last,
      i2  = 1,
      i3  = 1,
      aaaa  = 12,
      aaaa1 = 1,
      aaaa2 = 1;

string   s,
         s1 = "";

// Хранение времени в миллисекундах - uint  GetTickCount() количество миллисекунд, прошедших с момента старта ОС
uint  uint1;

// Хранение времени в микросекундах - ulong  GetMicrosecondCount() количество микросекунд, прошедших с момента начала работы MQL5-программы
ulong ulong1,
      OrderTicket1[100];

// Дата и время в секундах
datetime    dt = D'2017.01.13',
            dtSec;
            
// Структура даты и времени
MqlDateTime dt_struct,
            dt_struct1,
            dt_struct2;

// Структура цен по символу за один тик
MqlTick  tick,
         tick1,
         ticks_array[];

//+------------------------------------------------------------------+

int OnInit()
{
   
   Comment("OnInit");
   Print("OnInit");
   //EventSetTimer(1);    // генерировать события вызова таймера с указанной периодичностью, секунд
   
   dtSec = TimeLocal();
   
   
   
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+

void OnTimer()
{
   
   Print( i2 );
   ++i2;
   
}

//+------------------------------------------------------------------+

void OnTick()
{
   
   //Script1( i3 );
   
   //struct MqlTick {
   //   datetime     time;          // Время последнего обновления цен 
   //   double       bid;           // Текущая цена Bid 
   //   double       ask;           // Текущая цена Ask 
   //   double       last;          // Текущая цена последней сделки (Last) 
   //   ulong        volume;        // Объем для текущей цены Last 
   //   long         time_msc;      // Время последнего обновления цен в миллисекундах 
   //   uint         flags          // Флаги тиков 
   //};
   //TICK_FLAG_BID – тик изменил цену бид
   //TICK_FLAG_ASK  – тик изменил цену аск
   //TICK_FLAG_LAST – тик изменил цену последней сделки
   //TICK_FLAG_VOLUME – тик изменил объем
   //TICK_FLAG_BUY – тик возник в результате сделки на покупку
   //TICK_FLAG_SELL – тик возник в результате сделки на продажу
   
   
   SymbolInfoTick( _Symbol, tick );
   
   if ( OrdersTotal() != 0 )
   {
      for( int i = 0;  i < OrdersTotal();  i++ )
      {
         //OrderTicket1[i] = OrderGetTicket(i);
         s1 = s1 + IntegerToString( OrderGetTicket(i) ) + "   \n";
      }
      
      Print( s1 );
      
      s1 = "";
   }
   
   Comment("ask - ", tick.ask, "   bid - ", tick.bid, "\n",
      "OrdersTotal - ", OrdersTotal()
   );
   

   
//   if ( (tick.flags & TICK_FLAG_LAST)  ==  TICK_FLAG_LAST )
//   {
//      
//      TimeLocal( dt_struct1 );
//      dt_struct1.hour = 06;
//      dt_struct1.min  = 00;
//      dt_struct1.sec  = 00;
//      
//      Sec  =  (int)  ( tick.time  -  StructToTime(dt_struct1) );
//      Last =  (int)  tick.last;
//      
//      if ( t.Min[Sec] == 0 )
//      
//         t.Min[Sec] = t.Max[Sec] = Last;
//      
//      else
//      {
//         if ( t.Min[Sec] > Last )
//            t.Min[Sec] = Last;
//            
//         if ( t.Max[Sec] < Last )
//            t.Max[Sec] = Last;
//      }
//      
//      Print( Sec, " - ", t.Min[Sec], " < ", Last, " < ",  t.Max[Sec] );
//   }
   

   
   
   
   
   
//   switch( tick.flags & TICK_FLAG_LAST ) 
//   { 
//      case  TICK_FLAG_LAST :   s = "LAST";   break;
//
//      default :   if ( ( tick.flags & TICK_FLAG_VOLUME ) ==  TICK_FLAG_VOLUME )   s = "VOLUME";   else   s = "default";     break;
//   }
//   
//   // Проверка на наличие неопределенного состояния флагов
//   if ( s == "VOLUME" )
//   {
//      // Печать параметров предыдущего тика
//      Print(
//         // i3,  "  ",
//         TimeToString( tick1.time, TIME_SECONDS ),    "  ",
//         "Bid: ",    tick1.bid,      "  ",
//         "Ask: ",    tick1.ask,      "  ",
//         "Last: ",   tick1.last,     "  ",
//         "Vol: ",    tick1.volume,   "  ",
//         "Flags: ",  s1
//         );
//         
//      // Печать параметров текущего тика
//      Print(
//         // i3,  "  ",
//         TimeToString( tick.time, TIME_SECONDS ),    "  ",
//         "Bid: ",    tick.bid,      "  ",
//         "Ask: ",    tick.ask,      "  ",
//         "Last: ",   tick.last,     "  ",
//         "Vol: ",    tick.volume,   "  ",
//         "flags: ",  tick.flags,    "  ",
//         "Flags: ",  s
//         );
//   }
//   
//   // Сохраняем текущие переменные как предыщие для следующего события OnTick
//   tick1 = tick;
//   s = s1;

   //i3++;
   
}

//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{

}

//+------------------------------------------------------------------+
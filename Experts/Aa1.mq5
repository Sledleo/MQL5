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

// Глобальные переменные скрипта
int   TP,
      iii = 1,
      aaaa1 = 1,
      aaaa2 = 1,
      SL;

// Хранение времени в миллисекундах - uint  GetTickCount() количество миллисекунд, прошедших с момента старта ОС
uint uint1;

// Хранение времени в микросекундах - ulong  GetMicrosecondCount() количество микросекунд, прошедших с момента начала работы MQL5-программы
ulong ulong1;

// Дата и время в секундах
datetime    dt,
            dt0 = D'1970.01.01',
            dt2;
            
// Структура даты и времени
MqlDateTime    dt_struct,
               dt_struct0,
               dt_struct2;

// Структура цен по символу за один тик
MqlTick  tick;


//bool Invertor = true;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   
   Comment("OnInit");
   TimeToStruct(dt0, dt_struct0); 
   EventSetTimer(1);    // генерировать события вызова таймера с указанной периодичностью, секунд
   
   return(INIT_SUCCEEDED);
   
   Script1();
   
}



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}



//+------------------------------------------------------------------+
//| Expert OnTimer function                                 |
//+------------------------------------------------------------------+
void OnTimer()
{
   
   Comment("OnTimer " );
   
      
//   dt = (int)GetTickCount() / 1000;                // Возвращает количество миллисекунд, прошедших с момента старта системы ОС
//   dt = (int)GetMicrosecondCount() / 1000000;      // Возвращает количество микросекунд, прошедших с момента начала работы MQL5-программы
//   TimeToStruct(dt, dt_struct);

   
   SymbolInfoTick(_Symbol, tick);
   TimeToStruct(tick.time, dt_struct);
   TimeToStruct(tick.time_msc/1000, dt_struct2);
   dt2 = StructToTime( dt_struct2 );
   ulong1 = (ulong)tick.time_msc - (ulong)dt2*1000;
      
   Comment(
      "Count - ",    iii,              "\n",
      "year - ",     dt_struct.year,   "\n",
      "mon - ",      dt_struct.mon,    "\n",
      "day - ",      dt_struct.day,    "\n",
      "hour - ",     dt_struct.hour,   "\n",
      "min - ",      dt_struct.min,    "\n",
      "sec - ",      dt_struct.sec,    "\n",   
      "bid - ",      tick.bid,         "\n",    // Текущая цена Bid 
      "ask - ",      tick.ask,         "\n",    // Текущая цена Ask 
      "last - ",     tick.last,        "\n",    // Текущая цена последней сделки (Last) 
      "volume - ",   tick.volume,      "\n",    // Объем для текущей цены Last 
      "time_msc - ", tick.time_msc,    "\n",    // Время последнего обновления цен в миллисекундах 
      "flags - ",    tick.flags,       "\n",    // Флаги тиков 
      "year - ",     dt_struct2.year,  "\n",
      "mon - ",      dt_struct2.mon,   "\n",
      "day - ",      dt_struct2.day,   "\n",
      "hour - ",     dt_struct2.hour,  "\n",
      "min - ",      dt_struct2.min,   "\n",
      "sec - ",      dt_struct2.sec,   "\n",
      "msc - ",      ulong1
   );
   
   iii++;
      
      /*
      "year - ", dt_struct.year - dt_struct0.year, "\n",
      "mon - ",  dt_struct.mon - dt_struct0.mon,   "\n",
      "day - ",  dt_struct.day - dt_struct0.day,   "\n",
      */
   
}



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
   Comment("OnTick " );
   
}
//+------------------------------------------------------------------+


/*
int OnInit()
{
   TP = TakeProfit;
   SL = StopeLoss;
   
   if ( _Digits == 3 || _Digits == 5 ) {
      TP *= 10;
      SL *= 10;
   }
   
   return(INIT_SUCCEEDED);
}
*/

/*
void OnTick()
{
   double points;
   
   // Если нет позиции по инструменту, т.е. PositionSelect возвращает false  
   if ( !PositionSelect(_Symbol) ) {
      
      if ( Invertor )      // Invertor == true
         trader.Buy(Lot);  // покупка
      else trader.Sell(Lot); // иначе продажа
   
   }
   
   // иначе позиция есть по инструменту, т.е. PositionSelect возвращает true
   else {
      
      if ( PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ) {
         
         points = ( SymbolInfoDouble(_Symbol, SYMBOL_BID) - PositionGetDouble(POSITION_PRICE_OPEN) ) / _Point;
         
         if ( points >= TP ) {
            trader.PositionClose(_Symbol);
            Invertor = true;
         }
         
         if ( points <= SL ) {
            trader.PositionClose(_Symbol);
            Invertor = false;
         }
      }
      
      
      if ( PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL ) {
         
         points = ( PositionGetDouble(POSITION_PRICE_OPEN) - SymbolInfoDouble(_Symbol, SYMBOL_ASK) ) / _Point;
         
         if ( points >= TP ) {
            trader.PositionClose(_Symbol);
            Invertor = false;
         }
         
         if ( points <= SL ) {
            trader.PositionClose(_Symbol);
            Invertor = true;
         }
      }
   }
}
*/

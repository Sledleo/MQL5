#property copyright "Copyright 2017, MetaQuotes Software Corp." #property link "https://www.mql5.com" #property version "1.00"

#include <UserLib\ScriptFunc.mqh>   // Библиотека прикладных функций

//+------------------------------------------------------------------+
input int Volume  = 1;     // Объем
input int Price   = 60000; // Цена
input ENUM_ORDER_TYPE OrderType
                  = ORDER_TYPE_SELL_LIMIT; // Тип заявки
input int TimeOut = 5;     // Время снятия заявки

//+------------------------------------------------------------------+
int    h;            // Хендел на файл

ulong  MicroSecNow            // Количество микросекунд текущее
         = GetMicrosecondCount();
ulong  MicroSecPerv           // Количество микросекунд пердыдущее
         = MicroSecNow;

//+------------------------------------------------------------------+
int OnInit()
{
   h = FileOpen("test.csv",FILE_WRITE|FILE_ANSI|FILE_CSV,";");    // Открытие файла 
   if( h == INVALID_HANDLE ){
      Print("Ошибка открытия файла");
   }
   FileSeek(h,0,SEEK_END);    // Переход в конец файла
   
   FileWrite(h, 
         "Микросек",
         "#микросек",
         "Источник",
         "Тип Транзакции",
         "№ ордера",
         "Тип Запроса",
         "Тип Обновления",
         "Ответ",
         "№ сделки"
         );
   
   FileWrite(h,
         "MicroSec",
         "#MicroSec",
         "Source",
         "Type",
         "Order",
         "Action",
         "OrderState",
         "Retcode",
         "Deal"
         );
   
   MicroSecPerv = MicroSecNow;   MicroSecNow = GetMicrosecondCount();
   
   FileWrite(h, 
         (string)MicroSecNow,    // "MicroSec"
         (string)(MicroSecNow - MicroSecPerv),  // "#MicroSec"
         "OnInit()"             // "Source"
         //"Type",
         //"Order",
         //"Action",
         //"OrderState",
         //"Retcode",
         //"Deal"
         );   
   
   EventSetTimer(1);   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)     { FileClose(h);  EventKillTimer(); }

//+------------------------------------------------------------------+
void OnTick()
{

}


//+------------------------------------------------------------------+
void OnTimer()
{
   static bool start = true;
   static int  pause = 0;
   static ENUM_TRADE_REQUEST_ACTIONS act = TRADE_ACTION_PENDING;
   
   MqlTradeRequest      request;
   MqlTradeCheckResult  result;
   bool     check;
   MqlTick  tick;
   
   if(start)
   {
      start = false;
      pause = 3;
      
      request.magic = 12345;
      //request.volume = 1;
      
      SymbolInfoTick( _Symbol, tick );
      //request.price = tick.ask + 10;
      
      //request.action = TRADE_ACTION_PENDING; 
      request.type = ORDER_TYPE_SELL_LIMIT;
      
      
      check = OrderCheck( request, result );
      Print( "==OnTimer() - check = " + (string)check );
      Print( (string)result.retcode + " retcode = " + StrRetCode(result.retcode) );
      
      
      
   }
   
   if( !start && pause>0 )
   {
      Print( "==OnTimer() - pause = " + (string)pause );
      pause--;
      
      if( pause == 0 )
      {
         Print( "== pause = " + (string)pause );   
      }   
   }
 
   

   MicroSecPerv = MicroSecNow;   MicroSecNow = GetMicrosecondCount();
   
   FileWrite(h,
         (string)MicroSecNow,    // "MicroSec"
         (string)(MicroSecNow - MicroSecPerv),  // "#MicroSec"
         "OnTimer()"            // "Source"
         //"Type",
         //"Order",
         //"Action",
         //"OrderState",
         //"Retcode",
         //"Deal"
         );
}


//+------------------------------------------------------------------+
void OnTrade()
{
   Print( "==OnTrade()===" );
}



struct myTransaction
{
   string Type;         // trans.type - "Тип Транзакции"
   string Order;        // trans.order, result.order - "№ ордера"
   string Action;       // request.action - "Тип Запроса"
   string OrderState;   // trans.order_state - "Тип Обновления"
   string Retcode;      // result.retcode - "Ответ"
   string Deal;         // trans.deal - "№ сделки"
};

myTransaction Tr;

//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
{  
   Print( "==OnTradeTransaction()" );

   MicroSecPerv = MicroSecNow;   MicroSecNow = GetMicrosecondCount();
   
   
   Tr.Type = EnumToString(trans.type);
   
   
   if(trans.type == TRADE_TRANSACTION_REQUEST)
   {
      Tr.Order       = (string)result.order;          // trans.order, result.order
      Tr.Action      = EnumToString(request.action);  // request.action
      Tr.OrderState  = "";                            // trans.order_state
      Tr.Retcode     = (string)result.retcode;        // result.retcode
      Tr.Deal        = "";                            // trans.deal
   }
   else
   {
      Tr.Order       = (string)trans.order;           // trans.order, result.order
      Tr.Action      = "";                            // request.action
      
      if(trans.type == TRADE_TRANSACTION_ORDER_UPDATE)
         Tr.OrderState = 
            EnumToString(trans.order_state);          // trans.order_state
      else
         Tr.OrderState = "";                          // trans.order_state
      
      Tr.Retcode = "";                                // result.retcode
      
      if(trans.type == TRADE_TRANSACTION_DEAL_ADD || 
         trans.type == TRADE_TRANSACTION_DEAL_UPDATE ||
         trans.type == TRADE_TRANSACTION_DEAL_DELETE)
            Tr.Deal = (string)trans.deal;             // trans.deal
      else
            Tr.Deal = "";                             // trans.deal
   }
   
   
   FileWrite(h,
         (string)MicroSecNow,    // "MicroSec"
         (string)(MicroSecNow - MicroSecPerv),  // "#MicroSec"
         "OnTradeTrans", // "Source"
         Tr.Type,         // trans.type - "Тип Транзакции"
         Tr.Order,        // trans.order, result.order - "№ ордера"
         Tr.Action,       // request.action - "Тип Запроса"
         Tr.OrderState,   // trans.order_state - "Тип Обновления"
         Tr.Retcode,      // result.retcode - "Ответ"
         Tr.Deal          // trans.deal - "№ сделки"
         );

//   
//         //--- вывод информации о каждой транзакции
//      FileWrite(h,"\n= trans =================================================" );
//      FileWrite(h,"\n---=== Транзакция - trans===---" );
//      FileWrite(h,"Тикет сделки: " + (string)trans.deal );
//      FileWrite(h,"Тип сделки: " + EnumToString(trans.deal_type) );
//      FileWrite(h,"Тикет ордера: " + (string)trans.order );
//      FileWrite(h,"Состояние ордера: " + EnumToString(trans.order_state) );
//      FileWrite(h,"Тип ордера: " + EnumToString(trans.order_type) );
//      FileWrite(h,"Цена: " + (string)trans.price );
//      FileWrite(h,"Уровень Stop Loss: " + (string)trans.price_sl );
//      FileWrite(h,"Уровень Take Profit: " + (string)trans.price_tp );
//      FileWrite(h,"Цена срабатывания стоп-лимитного ордера: " + (string)trans.price_trigger );
//      FileWrite(h,"Торговый инструмент: " + (string)trans.symbol );
//      FileWrite(h,"Срок истечения отложенного ордера: " + TimeToString(trans.time_expiration) );
//      FileWrite(h,"Тип ордера по времени действия: " + EnumToString(trans.time_type) );
//      FileWrite(h,"Тип торговой транзакции: " + EnumToString(trans.type) );
//      FileWrite(h,"Объём в лотах: " + (string)trans.volume );
//
//      //--- если был запрос
//      if(trans.type==TRADE_TRANSACTION_REQUEST)
//        {
//         //--- вывод информации о запросе
//         FileWrite(h,"\n---=== Запрос - request ===---" );
//         FileWrite(h,"Тип выполняемого действия: " + EnumToString(request.action) );
//         FileWrite(h,"Комментарий к ордеру: " + (string)request.comment );
//         FileWrite(h,"Отклонение от запрашиваемой цены: " + (string)request.deviation );
//         FileWrite(h,"Срок истечения ордера: " + TimeToString(request.expiration) );
//         FileWrite(h,"Магик советника: " + (string)request.magic );
//         FileWrite(h,"Тикет ордера: " + (string)request.order );
//         FileWrite(h,"Цена: " + (string)request.price );
//         FileWrite(h,"Уровень Stop Loss ордера: " + (string)request.sl );
//         FileWrite(h,"Уровень Take Profit ордера: " + (string)request.tp );
//         FileWrite(h,"Уровень StopLimit ордера: " + (string)request.stoplimit );
//         FileWrite(h,"Торговый инструмент: " + (string)request.symbol );
//         FileWrite(h,"Тип ордера: " + EnumToString(request.type) );
//         FileWrite(h,"Тип ордера по исполнению: " + EnumToString(request.type_filling) );
//         FileWrite(h,"Тип ордера по времени действия: " + EnumToString(request.type_time) );
//         FileWrite(h,"Объём в лотах: " + (string)request.volume );
//
//         //--- вывод информации об ответе
//         FileWrite(h,"\n---=== Ответ - result ===---" );
//         FileWrite(h,"Код результата операции: " + (string)result.retcode );
//         FileWrite(h,"Тикет сделки: " + (string)result.deal );
//         FileWrite(h,"Тикет ордера: " + (string)result.order );
//         FileWrite(h,"Объём сделки: " + (string)result.volume );
//         FileWrite(h,"Цена в сделке: " + (string)result.price );
//         FileWrite(h,"Бид: " + (string)result.bid );
//         FileWrite(h,"Аск: " + (string)result.ask );
//         FileWrite(h,"Комментарий к операции: " + (string)result.comment );
//         FileWrite(h,"Идентификатор запроса: " + (string)result.request_id );
//        }

}

//+------------------------------------------------------------------+

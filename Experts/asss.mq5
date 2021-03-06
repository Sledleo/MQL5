#property copyright "Copyright 2017, MetaQuotes Software Corp." #property link "https://www.mql5.com" #property version "1.00"

#include <UserLib\ScriptFunc.mqh>   // Библиотека прикладных функций

int h;

//+------------------------------------------------------------------+
int OnInit()
{
   h = FileOpen( "test.txt" ,FILE_READ|FILE_WRITE|FILE_ANSI|FILE_TXT );
   if( h == INVALID_HANDLE )
      Print("Ошибка открытия файла");
   
   FileSeek(h,0,SEEK_END);
   
   
   EventSetTimer(1);   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)     { FileClose(h);  EventKillTimer(); }

//+------------------------------------------------------------------+
void OnTick()
{
//   MqlTick Tick;
//   
//   SymbolInfoTick( 
//      _Symbol,       // символ 
//      Tick           // ссылка на структуру MqlTick
//   );
//   
//   
//   
//   if ( (Tick.flags & TICK_FLAG_LAST) == TICK_FLAG_LAST )
//
//      if ( (Tick.flags & TICK_FLAG_BUY) == TICK_FLAG_BUY )
//      
//         Print( "=LAST= BUY = " + (string)Tick.last + "   V = " + (string)Tick.volume );
//         
//      else
//      
//         Print( "=LAST= SELL = " + (string)Tick.last + "   V = " + (string)Tick.volume );
//         
//         
//
//   if (  ( (Tick.flags & TICK_FLAG_BID) == TICK_FLAG_BID )  ||  ( (Tick.flags & TICK_FLAG_ASK) == TICK_FLAG_ASK )  )
//   {
//      Print( "=ASK= " + (string)Tick.ask ); 
//      Print( "=BID= " + (string)Tick.bid );
//   }
      
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
   Print( "==OnTimer()" );
   FileWrite(h,"\n == OnTimer ================================================== ");
}

//+------------------------------------------------------------------+
void OnTrade()
{
   Print( "==OnTrade()===" );
}

//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
{

   Print( "==OnTradeTransaction()" );
   
         //--- вывод информации о каждой транзакции
      FileWrite(h,"\n= trans =================================================" );
      FileWrite(h,"\n---=== Транзакция - trans===---" );
      FileWrite(h,"Тикет сделки: " + (string)trans.deal );
      FileWrite(h,"Тип сделки: " + EnumToString(trans.deal_type) );
      FileWrite(h,"Тикет ордера: " + (string)trans.order );
      FileWrite(h,"Состояние ордера: " + EnumToString(trans.order_state) );
      FileWrite(h,"Тип ордера: " + EnumToString(trans.order_type) );
      FileWrite(h,"Цена: " + (string)trans.price );
      FileWrite(h,"Уровень Stop Loss: " + (string)trans.price_sl );
      FileWrite(h,"Уровень Take Profit: " + (string)trans.price_tp );
      FileWrite(h,"Цена срабатывания стоп-лимитного ордера: " + (string)trans.price_trigger );
      FileWrite(h,"Торговый инструмент: " + (string)trans.symbol );
      FileWrite(h,"Срок истечения отложенного ордера: " + TimeToString(trans.time_expiration) );
      FileWrite(h,"Тип ордера по времени действия: " + EnumToString(trans.time_type) );
      FileWrite(h,"Тип торговой транзакции: " + EnumToString(trans.type) );
      FileWrite(h,"Объём в лотах: " + (string)trans.volume );

      //--- если был запрос
      if(trans.type==TRADE_TRANSACTION_REQUEST)
        {
         //--- вывод информации о запросе
         FileWrite(h,"\n---=== Запрос - request ===---" );
         FileWrite(h,"Тип выполняемого действия: " + EnumToString(request.action) );
         FileWrite(h,"Комментарий к ордеру: " + (string)request.comment );
         FileWrite(h,"Отклонение от запрашиваемой цены: " + (string)request.deviation );
         FileWrite(h,"Срок истечения ордера: " + TimeToString(request.expiration) );
         FileWrite(h,"Магик советника: " + (string)request.magic );
         FileWrite(h,"Тикет ордера: " + (string)request.order );
         FileWrite(h,"Цена: " + (string)request.price );
         FileWrite(h,"Уровень Stop Loss ордера: " + (string)request.sl );
         FileWrite(h,"Уровень Take Profit ордера: " + (string)request.tp );
         FileWrite(h,"Уровень StopLimit ордера: " + (string)request.stoplimit );
         FileWrite(h,"Торговый инструмент: " + (string)request.symbol );
         FileWrite(h,"Тип ордера: " + EnumToString(request.type) );
         FileWrite(h,"Тип ордера по исполнению: " + EnumToString(request.type_filling) );
         FileWrite(h,"Тип ордера по времени действия: " + EnumToString(request.type_time) );
         FileWrite(h,"Объём в лотах: " + (string)request.volume );

         //--- вывод информации об ответе
         FileWrite(h,"\n---=== Ответ - result ===---" );
         FileWrite(h,"Код результата операции: " + (string)result.retcode );
         FileWrite(h,"Тикет сделки: " + (string)result.deal );
         FileWrite(h,"Тикет ордера: " + (string)result.order );
         FileWrite(h,"Объём сделки: " + (string)result.volume );
         FileWrite(h,"Цена в сделке: " + (string)result.price );
         FileWrite(h,"Бид: " + (string)result.bid );
         FileWrite(h,"Аск: " + (string)result.ask );
         FileWrite(h,"Комментарий к операции: " + (string)result.comment );
         FileWrite(h,"Идентификатор запроса: " + (string)result.request_id );
        }

}

//+------------------------------------------------------------------+

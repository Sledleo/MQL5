#property copyright "Copyright 2014, denkir"    #property link "https://login.mql5.com/ru/users/denkir"  #property version "1.00"

//+------------------------------------------------------------------+
//| Inclusions                                                       |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>


//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input uint InpTradePause=150; // Торговая пауза, мсек
input bool InpIsLogging=true; // Выводить информацию?

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

uint gTransCnt=0;
//---
//+------------------------------------------------------------------+
//| Торговый объект                                                  |
//+------------------------------------------------------------------+
enum ENUM_TRADE_OBJ
  {
   TRADE_OBJ_NULL=0,// не задан
   //---
   TRADE_OBJ_POSITION=1,   // позиция
   TRADE_OBJ_ORDER=2,      // ордер
   TRADE_OBJ_DEAL=3,       // сделка
   TRADE_OBJ_HIST_ORDER=4, // "исторический" ордер
  };
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction
(
 const MqlTradeTransaction &trans,// транзакция
 const MqlTradeRequest &request,  // запрос
 const MqlTradeResult &result     // ответ
 )
  {
//--- пауза
   Sleep(InpTradePause);

//--- если 
   if(InpIsLogging)
     {
      //--- вывод информации о каждой транзакции
      Print("\n---===Транзакция===---");
      PrintFormat("Тикет сделки: %d",trans.deal);
      PrintFormat("Тип сделки: %s",EnumToString(trans.deal_type));
      PrintFormat("Тикет ордера: %d",trans.order);
      PrintFormat("Состояние ордера: %s",EnumToString(trans.order_state));
      PrintFormat("Тип ордера: %s",EnumToString(trans.order_type));
      PrintFormat("Цена: %0."+IntegerToString(_Digits)+"f",trans.price);
      PrintFormat("Уровень Stop Loss: %0."+IntegerToString(_Digits)+"f",trans.price_sl);
      PrintFormat("Уровень Take Profit: %0."+IntegerToString(_Digits)+"f",trans.price_tp);
      PrintFormat("Цена срабатывания стоп-лимитного ордера: %0."+IntegerToString(_Digits)+"f",trans.price_trigger);
      PrintFormat("Торговый инструмент: %s",trans.symbol);
      PrintFormat("Срок истечения отложенного ордера: %s",TimeToString(trans.time_expiration));
      PrintFormat("Тип ордера по времени действия: %s",EnumToString(trans.time_type));
      PrintFormat("Тип торговой транзакции: %s",EnumToString(trans.type));
      PrintFormat("Объём в лотах: %0.2f",trans.volume);

      //--- если был запрос
      if(trans.type==TRADE_TRANSACTION_REQUEST)
        {
         //--- вывод информации о запросе
         Print("\n---===Запрос===---");
         PrintFormat("Тип выполняемого действия: %s",EnumToString(request.action));
         PrintFormat("Комментарий к ордеру: %s",request.comment);
         PrintFormat("Отклонение от запрашиваемой цены: %d",request.deviation);
         PrintFormat("Срок истечения ордера: %s",TimeToString(request.expiration));
         PrintFormat("Магик советника: %d",request.magic);
         PrintFormat("Тикет ордера: %d",request.order);
         PrintFormat("Цена: %0."+IntegerToString(_Digits)+"f",request.price);
         PrintFormat("Уровень Stop Loss ордера: %0."+IntegerToString(_Digits)+"f",request.sl);
         PrintFormat("Уровень Take Profit ордера: %0."+IntegerToString(_Digits)+"f",request.tp);
         PrintFormat("Уровень StopLimit ордера: %0."+IntegerToString(_Digits)+"f",request.stoplimit);
         PrintFormat("Торговый инструмент: %s",request.symbol);
         PrintFormat("Тип ордера: %s",EnumToString(request.type));
         PrintFormat("Тип ордера по исполнению: %s",EnumToString(request.type_filling));
         PrintFormat("Тип ордера по времени действия: %s",EnumToString(request.type_time));
         PrintFormat("Объём в лотах: %0.2f",request.volume);

         //--- вывод информации об ответе
         Print("\n---===Ответ===---");
         PrintFormat("Код результата операции: %d",result.retcode);
         PrintFormat("Тикет сделки: %d",result.deal);
         PrintFormat("Тикет ордера: %d",result.order);
         PrintFormat("Объём сделки: %0.2f",result.volume);
         PrintFormat("Цена в сделке: %0."+IntegerToString(_Digits)+"f",result.price);
         PrintFormat("Бид: %0."+IntegerToString(_Digits)+"f",result.bid);
         PrintFormat("Аск: %0."+IntegerToString(_Digits)+"f",result.ask);
         PrintFormat("Комментарий к операции: %s",result.comment);
         PrintFormat("Идентификатор запроса: %d",result.request_id);
        }
     }
//---

   static ENUM_TRADE_OBJ trade_obj;               // на 1-м проходе задаёт торговый объект
   static ENUM_TRADE_REQUEST_ACTIONS last_action; // рыночное действие на 1-м проходе

//---
   bool is_to_reset_cnt=false;
   string deal_symbol=trans.symbol;

//---
   if(InpIsLogging)
      PrintFormat("\nПроход : #%d",gTransCnt+1);

//--- ========== Типы транзакций [START]
   switch(trans.type)
     {
      //--- 1) если это запрос
      case TRADE_TRANSACTION_REQUEST:
        {
         //---
         last_action=request.action;
         string action_str;

         //--- запрос на что?
         switch(last_action)
           {
            //--- а) по рынку
            case TRADE_ACTION_DEAL:
              {
               action_str="поставить рыночный ордер";
               trade_obj=TRADE_OBJ_POSITION;
               break;
              }
            //--- б) выставить отложенный ордер
            case TRADE_ACTION_PENDING:
              {
               action_str="выставить отложенный ордер";
               trade_obj=TRADE_OBJ_ORDER;
               break;
              }
            //--- в) изменить позицию
            case TRADE_ACTION_SLTP:
              {
               trade_obj=TRADE_OBJ_POSITION;
               //---
               StringConcatenate(action_str,request.symbol,": изменить значения Stop Loss",
                                 " и Take Profit");

               //---
               break;
              }
            //--- г) изменить ордер
            case TRADE_ACTION_MODIFY:
              {
               action_str="изменить параметры отложенного ордера";
               trade_obj=TRADE_OBJ_ORDER;
               break;
              }
            //--- д) удалить ордер
            case TRADE_ACTION_REMOVE:
              {
               action_str="удалить отложенный ордер";
               trade_obj=TRADE_OBJ_ORDER;
               break;
              }
           }
         //---
         if(InpIsLogging)
            Print("Поступил запрос: "+action_str);

         //---
         break;
        }
      //--- 2) если это добавление нового открытого ордера
      case TRADE_TRANSACTION_ORDER_ADD:
        {
         if(InpIsLogging)
           {
            if(trade_obj==TRADE_OBJ_POSITION)
               Print("Открыть новый рыночный ордер: "+
                     EnumToString(trans.order_type));
            //---
            else if(trade_obj==TRADE_OBJ_ORDER)
               Print("Установить новый отложенный ордер: "+
                     EnumToString(trans.order_type));
           }
         //---
         break;
        }
      //--- 3) если это удаление ордера из списка открытых
      case TRADE_TRANSACTION_ORDER_DELETE:
        {
         if(InpIsLogging)
            PrintFormat("Удалён из списка открытых ордер: #%d, "+
                        EnumToString(trans.order_type),trans.order);
         //---     
         break;
        }
      //--- 4) если это добавление ордера в историю
      case TRADE_TRANSACTION_HISTORY_ADD:
        {
         if(InpIsLogging)
            PrintFormat("Добавлен в историю ордер: #%d, "+
                        EnumToString(trans.order_type),trans.order);

         //--- если обрабатывается отложенный ордер
         if(trade_obj==TRADE_OBJ_ORDER)
           {
            //--- если 3-й проход
            if(gTransCnt==2)
              {
               //--- если ордер был отменён, проверить сделки
               datetime now=TimeCurrent();

               //--- запросить история сделок и ордеров
               HistorySelect(now-PeriodSeconds(PERIOD_H1),now);

               //--- попытка найти сделку для ордера
               CDealInfo myDealInfo;
               int all_deals=HistoryDealsTotal();
               //---
               bool is_found=false;
               for(int deal_idx=all_deals;deal_idx>=0;deal_idx--)
                  if(myDealInfo.SelectByIndex(deal_idx))
                     if(myDealInfo.Order()==trans.order)
                        is_found=true;

               //--- если сделка не найдена
               if(!is_found)
                 {
                  is_to_reset_cnt=true;
                  //---
                  PrintFormat("Ордер был отменён: #%d",trans.order);
                 }
              }
            //--- если 4-й проход
            if(gTransCnt==3)
              {
               is_to_reset_cnt=true;
               PrintFormat("Ордер был удалён: #%d",trans.order);
              }
           }
         //---     
         break;
        }
      //--- 5) если это добавление сделки в историю
      case TRADE_TRANSACTION_DEAL_ADD:
        {
         is_to_reset_cnt=true;
         //---
         ulong deal_ticket=trans.deal;
         ENUM_DEAL_TYPE deal_type=trans.deal_type;
         //---
         if(InpIsLogging)
            PrintFormat("Добавлена в историю сделка: #%d, "+EnumToString(deal_type),deal_ticket);

         if(deal_ticket>0)
           {
            datetime now=TimeCurrent();

            //--- запросить история сделок и ордеров
            HistorySelect(now-PeriodSeconds(PERIOD_H1),now);

            //--- выбрать сделку по тикету
            if(HistoryDealSelect(deal_ticket))
              {
               //--- проверить сделку
               CDealInfo myDealInfo;
               myDealInfo.Ticket(deal_ticket);
               long order=myDealInfo.Order();

               //--- параметры сделки
               ENUM_DEAL_ENTRY  deal_entry=myDealInfo.Entry();
               double deal_vol=0.;
               //---
               if(myDealInfo.InfoDouble(DEAL_VOLUME,deal_vol))
                  if(myDealInfo.InfoString(DEAL_SYMBOL,deal_symbol))
                    {
                     //--- позиция
                     CPositionInfo myPos;
                     double pos_vol=WRONG_VALUE;
                     //---
                     if(myPos.Select(deal_symbol))
                        pos_vol=myPos.Volume();

                     //--- если был вход в рынок
                     if(deal_entry==DEAL_ENTRY_IN)
                       {
                        //--- 1) открытие позиции
                        if(deal_vol==pos_vol)
                           PrintFormat("\n%s: открыта новая позиция",deal_symbol);

                        //--- 2) добавление к открытой позиции        
                        else if(deal_vol<pos_vol)
                           PrintFormat("\n%s: добавление к текущей позиции",deal_symbol);
                       }

                     //--- если был выход с рынка
                     else if(deal_entry==DEAL_ENTRY_OUT)
                       {
                        if(deal_vol>0.0)
                          {
                           //--- 1) закрытие позиции
                           if(pos_vol==WRONG_VALUE)
                              PrintFormat("\n%s: закрыта позиция",deal_symbol);

                           //--- 2) уменьшение открытой позиции        
                           else if(pos_vol>0.0)
                              PrintFormat("\n%s: уменьшение текущей позиции",deal_symbol);
                          }
                       }

                     //--- если был переворот
                     else if(deal_entry==DEAL_ENTRY_INOUT)
                       {
                        if(deal_vol>0.0)
                           if(pos_vol>0.0)
                              PrintFormat("\n%s: переворот позиции",deal_symbol);
                       }
                    }

               //--- активация ордера
               if(trade_obj==TRADE_OBJ_ORDER)
                  PrintFormat("Активация отложенного ордера: %d",order);
              }
           }

         //---
         break;
        }
      //--- 6) если это модификация позиции
      case TRADE_TRANSACTION_POSITION:
        {
         is_to_reset_cnt=true;
         //---
         PrintFormat("Модификация позиции: %s",deal_symbol);
         //---
         if(InpIsLogging)
           {
            PrintFormat("Новая цена slop loss: %0."+
                        IntegerToString(_Digits)+"f",trans.price_sl);
            PrintFormat("Новая цена take profit: %0."+
                        IntegerToString(_Digits)+"f",trans.price_tp);
           }

         //---
         break;
        }
      //--- 7) если это изменение открытого ордера
      case TRADE_TRANSACTION_ORDER_UPDATE:
        {

         //--- если был 1-ый проход
         if(gTransCnt==0)
           {
            trade_obj=TRADE_OBJ_ORDER;
            PrintFormat("Снятие ордера: #%d",trans.order);
           }
         //--- если был 2-ой проход
         if(gTransCnt==1)
           {
            //--- если модификация ордера
            if(last_action==TRADE_ACTION_MODIFY)
              {
               PrintFormat("Изменён отложенный ордер: #%d",trans.order);
               //--- сбросить счётчик
               is_to_reset_cnt=true;
              }
            //--- если удаление ордера
            if(last_action==TRADE_ACTION_REMOVE)
              {
               PrintFormat("Удалить отложенный ордер: #%d",trans.order);

              }
           }
         //--- если был 3-ий проход
         if(gTransCnt==2)
           {
            PrintFormat("Установлен новый отложенный ордер: #%d, "+
                        EnumToString(trans.order_type),trans.order);
            //--- сбросить счётчик
            is_to_reset_cnt=true;
           }

         //---
         break;
        }
     }
//--- ========== Типы транзакций [END]

//--- счётчик проходов
   if(is_to_reset_cnt)
     {
      gTransCnt=0;
      trade_obj=0;
      last_action=-1;
     }
   else
      gTransCnt++;
  }

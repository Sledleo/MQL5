#property copyright "Copyright 2017, MetaQuotes Software Corp." #property link      "https://www.mql5.com" #property version   "1.00"



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{

//--- проверим наличие объекта с именем "Buy" 
   if(ObjectFind(0,"Buy")>=0) 
   { 
      //--- если найденный объект не является кнопкой, удалим его 
      if(ObjectGetInteger(0,"Buy",OBJPROP_TYPE)!=OBJ_BUTTON) 
         ObjectDelete(0,"Buy"); 
   } 
   else ObjectCreate(0,"Buy",OBJ_BUTTON,0,0,0); // создадим кнопку "Buy" 

//--- настроим кнопку "Buy" 
   ObjectSetInteger(0,"Buy",OBJPROP_CORNER,CORNER_LEFT_LOWER); 
   ObjectSetInteger(0,"Buy",OBJPROP_XDISTANCE,10); 
   ObjectSetInteger(0,"Buy",OBJPROP_YDISTANCE,40); 
   ObjectSetInteger(0,"Buy",OBJPROP_XSIZE,70); 
   ObjectSetInteger(0,"Buy",OBJPROP_YSIZE,30); 
   ObjectSetString( 0,"Buy",OBJPROP_TEXT,"Buy"); 
   ObjectSetInteger(0,"Buy",OBJPROP_COLOR,clrRed); 

//--- проверим наличие объекта с именем "Sell" 
   if(ObjectFind(0,"Sell")>=0) 
   { 
   //--- если найденный объект не является кнопкой, удалим его 
      if(ObjectGetInteger(0,"Sell",OBJPROP_TYPE) != OBJ_BUTTON) 
         ObjectDelete(0,"Sell"); 
   } 
   else ObjectCreate(0,"Sell",OBJ_BUTTON,0,0,0); // создадим кнопку "Sell" 

//--- настроим кнопку "Sell" 
   ObjectSetInteger(0,"Sell",OBJPROP_CORNER,CORNER_LEFT_LOWER); 
   ObjectSetInteger(0,"Sell",OBJPROP_XDISTANCE,10); 
   ObjectSetInteger(0,"Sell",OBJPROP_YDISTANCE,80); 
   ObjectSetInteger(0,"Sell",OBJPROP_XSIZE,70); 
   ObjectSetInteger(0,"Sell",OBJPROP_YSIZE,30); 
   ObjectSetString( 0,"Sell",OBJPROP_TEXT,"Sell"); 
   ObjectSetInteger(0,"Sell",OBJPROP_COLOR,clrBlue); 
//--- принудительно обновим график, чтобы кнопки отрисовались немедленно 
   ChartRedraw(); 

   
   EventSetTimer(60); 
   return(INIT_SUCCEEDED);
}



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

//--- удалим за собой графические объекты 
   ObjectDelete(0,"Buy"); 
   ObjectDelete(0,"Sell"); 
   
}



//+------------------------------------------------------------------+ 
//| ChartEvent function                                              | 
//+------------------------------------------------------------------+ 
void OnChartEvent(const int id, 
                  const long &lparam, 
                  const double &dparam, 
                  const string &sparam) 
{ 
   //--- обработка события CHARTEVENT_CLICK ("Нажатие кнопки мышки на графике") 
   if(id==CHARTEVENT_OBJECT_CLICK) 
   { 
      Print("=> ",__FUNCTION__,": sparam = ",sparam); 
      //--- если нажата кнопка "Buy" 
      if(sparam=="Buy") 
      { 
         PrintFormat("Press - Buy"); 

         //--- отожмем нажатую кнопку обратно 
         ObjectSetInteger(0, "Buy", OBJPROP_STATE, false); 
      }
      //--- если нажата кнопка "Sell" 
      if(sparam=="Sell") 
      { 
         PrintFormat("Press - Sell"); 
         
         //--- отожмем нажатую кнопку обратно 
         ObjectSetInteger(0, "Sell", OBJPROP_STATE, false); 
      } 
      ChartRedraw(); 
   } 
//---          
} 

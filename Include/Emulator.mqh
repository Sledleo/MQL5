#property copyright "Cop"     #property link "http"

//+------------------------------------------------------------------+
//| Класс эмулятора
//+------------------------------------------------------------------+

class CEmulator
{
private:
   int    Trade;           // Сделка в лотах
   double TradePrice;      // Цена сделки
   int    Position;        // Позиция в лотах
   double PositionPrice;   // Цена позиции 
   double Equity;          // Баланс по счету
    
protected:
   
public:

   //+------------------------------------------------------------------+
   CEmulator()  // Конструктор класса. Инициализируем переменные класса
   {
      Equity = 0;          // Обнуляем переменные счета
      Position = 0;        // Обнуляем переменные позиции в лотах
      PositionPrice = 0;   // Обнуляем переменные цен позиции
   }
   
   
   //+------------------------------------------------------------------+
   double EquityGet(){ return Equity; }       // Получить баланс по счету
   //+------------------------------------------------------------------+
   void EquityCalculate()        // Вычисление баланса по счету
   {
    	// Если новая сделка(Trade) однонаправленая с текущей позицией,
    	// то баланс по счету(Equity) остается прежним - выходим из функции
      if ( Position * Trade  >=  0 )   return; 
      
      // Если позиция больше(равна) новой сделки
      else if ( MathAbs(Position) >= MathAbs(Trade) )
      	Equity = Equity  +  (PositionPrice - TradePrice) * Trade;
      
      // Если позиция меньше новой сделки
      else if ( MathAbs(Position) < MathAbs(Trade) )
      	Equity = Equity  +  (TradePrice - PositionPrice) * Position;
      
      else Print(" --- Error - EquityCalculate() --- ");   // иначе
   }
   
   
   //+------------------------------------------------------------------+
   double PositionGet(){ return Position; }           // Получить позицию в лотах
   
   
   //+------------------------------------------------------------------+
   double PositionPriceGet(){ return PositionPrice; } // Получить цену позиции
   //+------------------------------------------------------------------+
   void PositionPriceCalculate()    // Вычисление средней цены позиции
   {
      if ( Trade == 0 )                   return;
      
      else if ( Position == (-Trade) )    PositionPrice = 0.0;
      
      else if ( Position == 0 )           PositionPrice = TradePrice;
      	
      else if ( Position * Trade  >  0 )
         PositionPrice = MathRound( (Position * PositionPrice  +  Trade * TradePrice)  /
      	                           (Position + Trade) * 100000 )   /   100000;
      	
      else if ( MathAbs(Position) > MathAbs(Trade) )  return;
      	
      else if ( MathAbs(Position) < MathAbs(Trade) )  PositionPrice = TradePrice;
      	
      else Print(" --- Error - PositionPriceCalculate() --- ");   // иначе
   }
   
   
   //+------------------------------------------------------------------+
   void Calculate(double inTrade, double inTradePrice)
   {
      Trade      = (int)inTrade;         // Cохранеяем объём сделки в локальную переменную класса
      TradePrice = inTradePrice;    // Cохранеяем цену сделки в локальную переменную класса
      
      if ( Trade == 0 )   return;
      
      EquityCalculate();
      PositionPriceCalculate();
      Position += Trade;     // Новая позиция 
   }
   
};




#property copyright "CopyrigFFind.fot 2017, MetaQuotes Software Corp." #property link      "FFind.fottps://www.mql5.com" #property version   "1.00"
//+------------------------------------------------------------------+
#include <UserLib\ScriptFunc.mqh>   // Библиотека прикладных функций
//+------------------------------------------------------------------+
   
   bool Run;
   
   int index;
   int ii = 0;
   
   int   Trades[50],
         Prices[50];
   
   long handle;
   
//+------------------------------------------------------------------+   
   struct str_pos {     // Структура сделки или позиции
      int v;               // кол-во лотов
      int vp;              // предыдущее кол-во лотов
      double p;            // цена
      double pp;           // предыдущая цена
   };
//+------------------------------------------------------------------+  
   struct str_Demo {    // Структура демо-счета
   
      str_pos Trade;		      // новая сделка
      str_pos Pos;		      // позиция
      str_pos Eq;		         // эквити     

      // double K;                     // коэф. влияния текущей цены на усреднение в процентах (%)
      // при K = 100 - текущая цена = 100%, а накопление = 0%.
      // И наоборот при K = 0 - текущая цена = 0%, а накопление = 100%
   };
//+------------------------------------------------------------------+
   str_Demo d;
//+------------------------------------------------------------------+
   struct_File f[];     // Массив файлов
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int OnInit()
{
   Trades[0] = 0;    Prices[0] = 60000;
   Trades[1] = 0;    Prices[1] = 60000;
   Trades[2] = 0;    Prices[2] = 60000;
   Trades[3] = -1;   Prices[3] = 60000;
   Trades[4] = -1;   Prices[4] = 60100;
   Trades[5] = -1;   Prices[5] = 60200;
   Trades[6] = 0;    Prices[6] = 60300;
   Trades[7] = 0;    Prices[7] = 60400;
   Trades[8] = 0;    Prices[8] = 60300;
   Trades[9] = 6;    Prices[9] = 60300;
   Trades[10] = 0;   Prices[10] = 60200;
   Trades[11] = 0;   Prices[11] = 60100;
   Trades[12] = 0;   Prices[12] = 60000;
   Trades[13] = -1;  Prices[13] = 60000;
   Trades[14] = -1;  Prices[14] = 59900;
   Trades[15] = -1;  Prices[15] = 60000;
   Trades[16] = 0;   Prices[16] = 60000;
   
// Новая сделка
   d.Trade.v = 0;    // кол-во лотов
   d.Trade.vp =0;   // предыдущее кол-во лотов
   d.Trade.p = 0;    // цена
   d.Trade.pp =0;   // предыдущая цена
// Счет
   d.Pos.v =   0;      // кол-во лотов
   d.Pos.vp =  0;     // предыдущее кол-во лотов
   d.Pos.p =   0;      // цена
   d.Pos.pp =  0;     // предыдущая цена
// Эквити
   d.Eq.p =    0;       // текущий эквити
   d.Eq.pp =   0;      // предыдущий эквити
   
//+------------------------------------------------------------------+
   
   Print( "===== Начало =====" );
   
   index = 0;   ArrayResize( f, index+1, 10 );
   
   handle = FileFindFirst( "SPFB\\*", f[index].Name );
   
   if( handle != INVALID_HANDLE )     // есть хотя бы один файл или папка
   {
      Print( f[index].Name );
      
      FileReadInMassiv( ("SPFB\\" + f[index].Name), f[index].Ticks );
      for( int i=0; i<1; i++ )
      //for( int i = ArraySize(t)-5;  i < ArraySize(t);  i++ ) 
         Print( TimeToString( (datetime)f[index].Ticks[i].MilSec/1000, TIME_SECONDS ) + "." + (string)(f[index].Ticks[i].MilSec%1000) + "   " + (string)f[index].Ticks[i].Price );
      
      
      index++;   ArrayResize( f, index+1, 10 );

      while( 
         FileFindNext( handle, f[index].Name ) ) // получаем имя следующего файла или папки
      {      
         Print( f[index].Name );
         FileReadInMassiv( "SPFB\\" + f[index].Name, f[index].Ticks );
         
         for( int i=0; i<1; i++ )
         //for( int i = ArraySize(t)-5;  i < ArraySize(t);  i++ ) 
            Print( TimeToString( (datetime)f[index].Ticks[i].MilSec/1000, TIME_SECONDS ) + "." + (string)(f[index].Ticks[i].MilSec%1000) + "   " + (string)f[index].Ticks[i].Price );

         index++;   ArrayResize( f, index+1, 10 );
      }
   }
   FileFindClose( handle );
   
   Print("-----------");
   
//+------------------------------------------------------------------+   
   
   
   EventSetTimer( 3 );  // включаем таймер
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnTimer()
{
   if( ii < 17 )
   {
      d.Trade.v = Trades[ii];
      d.Trade.p = Prices[ii];
      ii++;
      
      d.Pos.vp = d.Pos.v;     // сохранение предыдущей позиции
      d.Pos.v += d.Trade.v;   // новая позиция
      
      
      d.Pos.pp = d.Pos.p;      // сохранение предыдущей цены позиции
      
      // вычиление средней цены позиции
      if ( d.Pos.v == 0 )      d.Pos.p = 0;
      	
      else if ( d.Trade.v == 0 )   	d.Pos.p = d.Pos.pp;
      	
      else if (( d.Pos.vp == 0 ) && ( d.Trade.v != 0 ))
      	d.Pos.p = d.Trade.p;
      	
      else if ( d.Pos.vp * d.Trade.v > 0 )
      	d.Pos.p = MathRound( (d.Pos.vp * d.Pos.pp +
      	                      d.Trade.v * d.Trade.p) /
      	                      d.Pos.v * 100000 ) / 100000;
      	
      else if ( MathAbs(d.Pos.vp) > MathAbs(d.Trade.v) )
      	d.Pos.p = d.Pos.pp;
      	
      else if ( MathAbs(d.Pos.vp) == MathAbs(d.Trade.v) )     // никогда не зайдем, потому что уже будет d.Pos.v == 0
      	d.Pos.p = 1000000;
      	
      else if ( MathAbs(d.Pos.vp) < MathAbs(d.Trade.v) )
      	d.Pos.p = d.Trade.p;
      	
      else Print("d.Pos.p -------else--------");   // иначе
      	
      
      d.Eq.pp = d.Eq.p;     // сохранение предыдущей эквити
      
      // вычисление эквити
    	
      if ( d.Pos.vp * d.Trade.v  >=  0 )    d.Eq.p = d.Eq.pp;
   
      	
      else if ( MathAbs(d.Pos.vp) >= MathAbs(d.Trade.v) )
      	d.Eq.p = d.Eq.pp + (d.Pos.pp - d.Trade.p) * d.Trade.v;
   
      
      else if ( MathAbs(d.Pos.vp) < MathAbs(d.Trade.v) )
      	d.Eq.p =  d.Eq.pp + (d.Trade.p - d.Pos.pp) * d.Pos.vp;
      	
      else Print("d.Pos.p -----");   // иначе
      
   // Новая сделка
      Print("Trd=" + (string)d.Trade.v +    // кол-во лотов
      " Prc=" +      (string)d.Trade.p +    // цена
   // Счет
      "  Pos=" +     (string)d.Pos.v +      // кол-во лотов
      " SrednP=" +   (string)d.Pos.p +      // цена
   // Эквити
      "  Eq=" +  (string)d.Eq.p       // текущий эквити
      );
   }   
   
   
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

   EventKillTimer();          // удаляем таймер

}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnTick()
{


}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

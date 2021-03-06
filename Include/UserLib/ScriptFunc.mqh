#property copyright "Copyright 2017, MetaQuotes Software Corp."   #property link "https://www.mql5.com"


struct struct_Tick {    // Структура тика
   int MilSec;          // Миллисекунды тика от начала дня
   int Price;           // Цена тика 
};

struct struct_File {    // Структура файла истории
   string  Name;        // Имя файла
   struct_Tick Ticks[]; // Массив тиков
};









//+------------------------------------------------------------------+

string StrRetCode(uint retcode)
{
   switch(retcode)
   {
      case 10004: return( "REQUOTE - Реквота" ); break;
      case 10006: return( "REJECT - Запрос отклонен" ); break;
      case 10007: return( "CANCEL - Запрос отменен трейдером" ); break;
      case 10008: return( "PLACED - Ордер размещен" ); break;
      case 10009: return( "DONE - Заявка выполнена" ); break;
      case 10010: return( "DONE_PARTIAL - Заявка выполнена частично" ); break;
      case 10011: return( "ERROR - Ошибка обработки запроса" ); break;
      case 10012: return( "TIMEOUT - Запрос отменен по истечению времени" ); break;
      case 10013: return( "INVALID - Неправильный запрос" ); break;
      case 10014: return( "INVALID_VOLUME - Неправильный объем в запросе" ); break;
      case 10015: return( "INVALID_PRICE - Неправильная цена в запросе" ); break;
      case 10016: return( "INVALID_STOPS - Неправильные стопы в запросе" ); break;
      case 10017: return( "TRADE_DISABLED - Торговля запрещена" ); break;
      case 10018: return( "MARKET_CLOSED - Рынок закрыт" ); break;
      case 10019: return( "NO_MONEY - Нет достаточных денежных средств для выполнения запроса" ); break;
      case 10020: return( "PRICE_CHANGED - Цены изменились" ); break;
      case 10021: return( "PRICE_OFF - Отсутствуют котировки для обработки запроса" ); break;
      case 10022: return( "INVALID_EXPIRATION - Неверная дата истечения ордера в запросе" ); break;
      case 10023: return( "ORDER_CHANGED - Состояние ордера изменилось" ); break;
      case 10024: return( "TOO_MANY_REQUESTS - Слишком частые запросы" ); break;
      case 10025: return( "NO_CHANGES - В запросе нет изменений" ); break;
      case 10026: return( "SERVER_DISABLES_AT - Автотрейдинг запрещен сервером" ); break;
      case 10027: return( "CLIENT_DISABLES_AT - Автотрейдинг запрещен клиентским терминалом" ); break;
      case 10028: return( "LOCKED - Запрос заблокирован для обработки" ); break;
      case 10029: return( "FROZEN - Ордер или позиция заморожены" ); break;
      case 10030: return( "INVALID_FILL - Указан неподдерживаемый тип исполнения ордера по остатку " ); break;
      case 10031: return( "CONNECTION - Нет соединения с торговым сервером" ); break;
      case 10032: return( "ONLY_REAL - Операция разрешена только для реальных счетов" ); break;
      case 10033: return( "LIMIT_ORDERS - Достигнут лимит на количество отложенных ордеров" ); break;
      case 10034: return( "LIMIT_VOLUME - Достигнут лимит на объем ордеров и позиций для данного символа" ); break;
      case 10035: return( "INVALID_ORDER - Неверный или запрещённый тип ордера" ); break;
      case 10036: return( "POSITION_CLOSED - Позиция с указанным POSITION_IDENTIFIER уже закрыта" ); break;
      case 10038: return( "INVALID_CLOSE_VOLUME - Закрываемый объем превышает текущий объем позиции" ); break;
      case 10039: return( "CLOSE_ORDER_EXIST - Для указанной позиции уже есть ордер на закрытие. Может возникнуть при работе в системе хеджинга:" ); break;
      case 10040: return( "LIMIT_POSITIONS - Количество открытых позиций, которое можно одновременно иметь на счете, может быть ограничено настройками сервера. При достижении лимита в ответ на выставление ордера сервер вернет ошибку TRADE_RETCODE_LIMIT_POSITIONS. Ограничение работает по-разному в зависимости от типа учета позиций на счете:" ); break;
      case 10041: return( "REJECT_CANCEL - Запрос на активацию отложенного ордера отклонен, а сам ордер отменен" ); break;
      case 10042: return( "LONG_ONLY - Запрос отклонен, так как на символе установлено правило ""Разрешены только длинные позиции""  (POSITION_TYPE_BUY)" ); break;
      case 10043: return( "SHORT_ONLY - Запрос отклонен, так как на символе установлено правило ""Разрешены только короткие позиции"" (POSITION_TYPE_SELL)" ); break;
      case 10044: return( "CLOSE_ONLY - Запрос отклонен, так как на символе установлено правило ""Разрешено только закрывать существующие позиции"" " ); break;
      default : return( " == strrecode - нет кода == " ); break;
   }
}

//+------------------------------------------------------------------+

void FileReadInMassiv(     // Фукнция чтения тиков из файла истории
   string  file_name,      // имя файла
   struct_Tick &tick[] )   // ссылка на массив тиков
{
   int   milsec = 0,
         milsec_count = 1;
   
   datetime dt_fr0,                 // хранение текущей даты как числа
            dt_fr1;                 // хранение читемого времени (без даты) как числа
            
   MqlDateTime dt_struct;        // структура для получения текущий даты и времени
   
   
   TimeLocal( dt_struct );                                        // получаем текущие дату и время
   dt_struct.hour = 0; dt_struct.min = 0; dt_struct.sec = 0;      // сбрасываем время
   dt_fr0 = StructToTime( dt_struct );                               // сохраняем текущую дату как число
   
   
   int handleFileOpen = FileOpen( file_name, FILE_READ|FILE_ANSI|FILE_CSV, ";"  ); // открываем файл
      
   if( handleFileOpen == INVALID_HANDLE ) {                // проверяем на ошибку открытия файла
      Alert( "Ошибка открытия файла" );
      return;
   }
   for( int i=0;  !FileIsEnding(handleFileOpen);  i++ ) {
   //while( !FileIsEnding( handleFileOpen ) )  { i++;
   
      ArrayResize( tick, i+1, 100000 );
         
      FileReadString( handleFileOpen );                 // читам дату и не используем ее
         
      dt_fr1 = FileReadDatetime( handleFileOpen );         // читам время, текущая дата добавлятся сама
      dt_fr1 = dt_fr1 - dt_fr0;                        // удаляем текущую дату, остается только время
      tick[i].MilSec = (int)dt_fr1 * 1000;
      //str1 = TimeToString( dt1, TIME_SECONDS );
      //str1 = (string)(int)dt1;
      
      if ( milsec == tick[i].MilSec ) {
         milsec_count++;
         //tick[i].MilSec += milsec_count;
      }
      else {
         if ( milsec_count > 1 )                   // Если несколько сделок в секунду, то
            for( int j=1; j<milsec_count;  j++ )   // подставляем миллисекунды
               tick[ i - milsec_count + j ].MilSec += j * 1000 / milsec_count;
               
         milsec = tick[i].MilSec;
         milsec_count = 1;
      }
      
      string strPrice = FileReadString( handleFileOpen );
      StringReplace( strPrice, ".", "," );
      tick[i].Price = (int)strPrice;

   }
   if ( milsec_count > 1 )                   // Если несколько сделок в секунду, то
      for( int j=1; j<milsec_count;  j++ )   // подставляем миллисекунды
         tick[ ArraySize(tick) - milsec_count + j ].MilSec += j * 1000 / milsec_count;
      
   FileClose( handleFileOpen );
   
}

//+------------------------------------------------------------------+

void Script1(int iii)
{
   Comment(iii);
   
}




//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

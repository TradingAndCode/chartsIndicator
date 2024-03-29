//+------------------------------------------------------------------+
//|                                                     InitMQL4.mqh |
//|                                                 Copyright DC2008 |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "keiji"
#property copyright "DC2008"
#property link "http://www.mql5.com"
//--- declaration of constants
#define OP_BUY 0       // Buy
#define OP_SELL 1      // Sell
#define OP_BUYLIMIT 2  // BUY LIMIT pending order
#define OP_SELLLIMIT 3 // SELL LIMIT pending order
#define OP_BUYSTOP 4   // BUY STOP pending order
#define OP_SELLSTOP 5  // SELL STOP pending order
//---
#define OBJPROP_TIME1 300
#define OBJPROP_PRICE1 301
#define OBJPROP_TIME2 302
#define OBJPROP_PRICE2 303
#define OBJPROP_TIME3 304
#define OBJPROP_PRICE3 305
//---
#define OBJPROP_RAY 310
#define OBJPROP_FIBOLEVELS 200
//---

#define OBJPROP_FIRSTLEVEL1 211
#define OBJPROP_FIRSTLEVEL2 212
#define OBJPROP_FIRSTLEVEL3 213
#define OBJPROP_FIRSTLEVEL4 214
#define OBJPROP_FIRSTLEVEL5 215
#define OBJPROP_FIRSTLEVEL6 216
#define OBJPROP_FIRSTLEVEL7 217
#define OBJPROP_FIRSTLEVEL8 218
#define OBJPROP_FIRSTLEVEL9 219
#define OBJPROP_FIRSTLEVEL10 220
#define OBJPROP_FIRSTLEVEL11 221
#define OBJPROP_FIRSTLEVEL12 222
#define OBJPROP_FIRSTLEVEL13 223
#define OBJPROP_FIRSTLEVEL14 224
#define OBJPROP_FIRSTLEVEL15 225
#define OBJPROP_FIRSTLEVEL16 226
#define OBJPROP_FIRSTLEVEL17 227
#define OBJPROP_FIRSTLEVEL18 228
#define OBJPROP_FIRSTLEVEL19 229
#define OBJPROP_FIRSTLEVEL20 230
#define OBJPROP_FIRSTLEVEL21 231
#define OBJPROP_FIRSTLEVEL22 232
#define OBJPROP_FIRSTLEVEL23 233
#define OBJPROP_FIRSTLEVEL24 234
#define OBJPROP_FIRSTLEVEL25 235
#define OBJPROP_FIRSTLEVEL26 236
#define OBJPROP_FIRSTLEVEL27 237
#define OBJPROP_FIRSTLEVEL28 238
#define OBJPROP_FIRSTLEVEL29 239
#define OBJPROP_FIRSTLEVEL30 240
#define OBJPROP_FIRSTLEVEL31 241
//---
#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
//---
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
//---
#define CHART_BAR 0
#define CHART_CANDLE 1
//---
#define MODE_ASCEND 0
#define MODE_DESCEND 1
//---
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
//---
#define EMPTY -1
//---
#define CharToStr CharToString
#define DoubleToStr DoubleToString
#define StrToDouble StringToDouble
#define StrToInteger (int)StringToInteger
#define StrToTime StringToTime
#define TimeToStr TimeToString
#define StringGetChar StringGetCharacter
#define StringSetChar StringSetCharacter
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TFMigrate(int tf)
{
  switch (tf)
  {
  case 0:
    return (PERIOD_CURRENT);
  case 1:
    return (PERIOD_M1);
  case 5:
    return (PERIOD_M5);
  case 15:
    return (PERIOD_M15);
  case 30:
    return (PERIOD_M30);
  case 60:
    return (PERIOD_H1);
  case 240:
    return (PERIOD_H4);
  case 1440:
    return (PERIOD_D1);
  case 10080:
    return (PERIOD_W1);
  case 43200:
    return (PERIOD_MN1);

  case 2:
    return (PERIOD_M2);
  case 3:
    return (PERIOD_M3);
  case 4:
    return (PERIOD_M4);
  case 6:
    return (PERIOD_M6);
  case 10:
    return (PERIOD_M10);
  case 12:
    return (PERIOD_M12);
  case 16385:
    return (PERIOD_H1);
  case 16386:
    return (PERIOD_H2);
  case 16387:
    return (PERIOD_H3);
  case 16388:
    return (PERIOD_H4);
  case 16390:
    return (PERIOD_H6);
  case 16392:
    return (PERIOD_H8);
  case 16396:
    return (PERIOD_H12);
  case 16408:
    return (PERIOD_D1);
  case 32769:
    return (PERIOD_W1);
  case 49153:
    return (PERIOD_MN1);
  default:
    return (PERIOD_CURRENT);
  }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_MA_METHOD MethodMigrate(int method)
{
  switch (method)
  {
  case 0:
    return (MODE_SMA);
  case 1:
    return (MODE_EMA);
  case 2:
    return (MODE_SMMA);
  case 3:
    return (MODE_LWMA);
  default:
    return (MODE_SMA);
  }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_APPLIED_PRICE PriceMigrate(int price)
{
  switch (price)
  {
  case 1:
    return (PRICE_CLOSE);
  case 2:
    return (PRICE_OPEN);
  case 3:
    return (PRICE_HIGH);
  case 4:
    return (PRICE_LOW);
  case 5:
    return (PRICE_MEDIAN);
  case 6:
    return (PRICE_TYPICAL);
  case 7:
    return (PRICE_WEIGHTED);
  default:
    return (PRICE_CLOSE);
  }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_STO_PRICE StoFieldMigrate(int field)
{
  switch (field)
  {
  case 0:
    return (STO_LOWHIGH);
  case 1:
    return (STO_CLOSECLOSE);
  default:
    return (STO_LOWHIGH);
  }
}

//+------------------------------------------------------------------+
enum ALLIGATOR_MODE
{
  MODE_GATORJAW = 1,
  MODE_GATORTEETH,
  MODE_GATORLIPS
};
enum ADX_MODE
{
  MODE_MAIN,
  MODE_PLUSDI,
  MODE_MINUSDI
};
enum UP_LOW_MODE
{
  MODE_BASE,
  MODE_UPPER,
  MODE_LOWER
};
enum ICHIMOKU_MODE
{
  MODE_TENKANSEN = 1,
  MODE_KIJUNSEN,
  MODE_SENKOUSPANA,
  MODE_SENKOUSPANB,
  MODE_CHINKOUSPAN
};
enum MAIN_SIGNAL_MODE
{
  MODE_MAIN,
  MODE_SIGNAL
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CopyBufferMQL4(int handle, int index, int shift)
{
  double buf[];
  switch (index)
  {
  case 0:
    if (CopyBuffer(handle, 0, shift, 1, buf) > 0)
      return (buf[0]);
    break;
  case 1:
    if (CopyBuffer(handle, 1, shift, 1, buf) > 0)
      return (buf[0]);
    break;
  case 2:
    if (CopyBuffer(handle, 2, shift, 1, buf) > 0)
      return (buf[0]);
    break;
  case 3:
    if (CopyBuffer(handle, 3, shift, 1, buf) > 0)
      return (buf[0]);
    break;
  case 4:
    if (CopyBuffer(handle, 4, shift, 1, buf) > 0)
      return (buf[0]);
    break;
  default:
    break;
  }
  return (EMPTY_VALUE);
}
double iIchimokuMQL4(string symbol,
                     int tf,
                     int tenkan_sen,
                     int kijun_sen,
                     int senkou_span_b,
                     int mode,
                     int shift)
{
  ENUM_TIMEFRAMES timeframe = TFMigrate(tf);
  int handle = iIchimoku(symbol, timeframe,
                         tenkan_sen, kijun_sen, senkou_span_b);
  if (handle < 0)
  {
    Print("The iIchimoku object is not created: Error", GetLastError());
    return (-1);
  }
  else
    return (CopyBufferMQL4(handle, mode, shift));
}

int ObjectFindMQL4(string name)
{
  return (ObjectFind(0, name));
}

int ObjectTypeMQL4(string name)
{
  return ((int)ObjectGetInteger(0, name, OBJPROP_TYPE));
}

bool ObjectCreateMQL4(string name,
                      ENUM_OBJECT type,
                      int window,
                      datetime time1,
                      double price1,
                      datetime time2 = 0,
                      double price2 = 0,
                      datetime time3 = 0,
                      double price3 = 0)
{
  return (ObjectCreate(0, name, type, window,
                       time1, price1, time2, price2, time3, price3));
}

bool ObjectMoveMQL4(string name,
                    int point,
                    datetime time1,
                    double price1)
{
  return (ObjectMove(0, name, point, time1, price1));
}


bool ObjectDeleteMQL4(string name)
  {
   return(ObjectDelete(0,name));
  }


double iMAMQL4(string symbol,
               int tf,
               int period,
               int ma_shift,
               int method,
               int price,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   
   int handle=iMA(symbol,timeframe,period,ma_shift,
                  ma_method,applied_price);
   if(handle<0)
     {
      Print("The iMA object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }

double iATRMQL4(string symbol,
                int tf,
                int period,
                int shift)
{
    ENUM_TIMEFRAMES timeframe = TFMigrate(tf);
    int handle_temp = iATR(symbol, timeframe, period);
    if (handle_temp < 0)
    {
        Print("The iATR object is not created: Error", GetLastError());
        return (-1);
    }
    else
        return (CopyBufferMQL4(handle_temp, 0, shift));
}

bool ObjectSetTextMQL4(string name,
                       string text,
                       int font_size = 13,
                       string font = NULL,
                       color text_color = CLR_NONE)
{
    int tmpObjType = (int)ObjectGetInteger(0, name, OBJPROP_TYPE);
    if (tmpObjType != OBJ_LABEL && tmpObjType != OBJ_TEXT)
        return (false);
    if (StringLen(text) > 0 && font_size > 0)
    {
        if (ObjectSetString(0, name, OBJPROP_TEXT, text) == true && ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size) == true)
        {
            if ((StringLen(font) > 0) && ObjectSetString(0, name, OBJPROP_FONT, font) == false)
                return (false);
            if (text_color > -1 && ObjectSetInteger(0, name, OBJPROP_COLOR, text_color) == false)
                return (false);
            return (true);
        }
        return (false);
    }
    return (false);
}

bool ObjectSetMQL4(string name,
                   int index,
                   double value)
{
    switch (index)
    {
    case OBJPROP_TIME1:
        ObjectSetInteger(0, name, OBJPROP_TIME, (int)value);
        return (true);
    case OBJPROP_PRICE1:
        ObjectSetDouble(0, name, OBJPROP_PRICE, value);
        return (true);
    case OBJPROP_TIME2:
        ObjectSetInteger(0, name, OBJPROP_TIME, 1, (int)value);
        return (true);
    case OBJPROP_PRICE2:
        ObjectSetDouble(0, name, OBJPROP_PRICE, 1, value);
        return (true);
    case OBJPROP_TIME3:
        ObjectSetInteger(0, name, OBJPROP_TIME, 2, (int)value);
        return (true);
    case OBJPROP_PRICE3:
        ObjectSetDouble(0, name, OBJPROP_PRICE, 2, value);
        return (true);
    case OBJPROP_COLOR:
        ObjectSetInteger(0, name, OBJPROP_COLOR, (int)value);
        return (true);
    case OBJPROP_STYLE:
        ObjectSetInteger(0, name, OBJPROP_STYLE, (int)value);
        return (true);
    case OBJPROP_WIDTH:
        ObjectSetInteger(0, name, OBJPROP_WIDTH, (int)value);
        return (true);
    case OBJPROP_BACK:
        ObjectSetInteger(0, name, OBJPROP_BACK, (int)value);
        return (true);
    case OBJPROP_RAY:
        ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, (int)value);
        return (true);
    case OBJPROP_ELLIPSE:
        ObjectSetInteger(0, name, OBJPROP_ELLIPSE, (int)value);
        return (true);
    case OBJPROP_SCALE:
        ObjectSetDouble(0, name, OBJPROP_SCALE, value);
        return (true);
    case OBJPROP_ANGLE:
        ObjectSetDouble(0, name, OBJPROP_ANGLE, value);
        return (true);
    case OBJPROP_ARROWCODE:
        ObjectSetInteger(0, name, OBJPROP_ARROWCODE, (int)value);
        return (true);
    case OBJPROP_TIMEFRAMES:
        ObjectSetInteger(0, name, OBJPROP_TIMEFRAMES, (int)value);
        return (true);
    case OBJPROP_DEVIATION:
        ObjectSetDouble(0, name, OBJPROP_DEVIATION, value);
        return (true);
    case OBJPROP_FONTSIZE:
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, (int)value);
        return (true);
    case OBJPROP_CORNER:
        ObjectSetInteger(0, name, OBJPROP_CORNER, (int)value);
        return (true);
    case OBJPROP_XDISTANCE:
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, (int)value);
        return (true);
    case OBJPROP_YDISTANCE:
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, (int)value);
        return (true);
    case OBJPROP_FIBOLEVELS:
        ObjectSetInteger(0, name, OBJPROP_LEVELS, (int)value);
        return (true);
    case OBJPROP_LEVELCOLOR:
        ObjectSetInteger(0, name, OBJPROP_LEVELCOLOR, (int)value);
        return (true);
    case OBJPROP_LEVELSTYLE:
        ObjectSetInteger(0, name, OBJPROP_LEVELSTYLE, (int)value);
        return (true);
    case OBJPROP_LEVELWIDTH:
        ObjectSetInteger(0, name, OBJPROP_LEVELWIDTH, (int)value);
        return (true);

    default:
        return (false);
    }
    return (false);
}

double iMACDMQL4(string symbol,
                 int tf,
                 int fast_ema_period,
                 int slow_ema_period,
                 int signal_period,
                 int price,
                 int mode,
                 int shift)
{
    ENUM_TIMEFRAMES timeframe = TFMigrate(tf);
    ENUM_APPLIED_PRICE applied_price = PriceMigrate(price);
    int handle = iMACD(symbol, timeframe,
                       fast_ema_period, slow_ema_period,
                       signal_period, applied_price);
    if (handle < 0)
    {
        Print("The iMACD object is not created: Error ", GetLastError());
        return (-1);
    }
    else
        return (CopyBufferMQL4(handle, mode, shift));
}

//+------------------------------------------------------------------+

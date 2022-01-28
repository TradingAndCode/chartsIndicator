//+------------------------------------------------------------------+
//|                                       Indicator: chartsIndicator |
//|                                       Created By Steven Nkeneng  |
//|                                     https://www.stevennkeneng.com|
//+------------------------------------------------------------------+
#property copyright "Steven Nkeneng (Trading & Code) - 2021-2021"
#property link "https://tradingandcode.com"
#property version "1.00"
#property description "Indicator sending trade signal based on ..."
#property description " "
#property description "WARNING : You use this software at your own risk."
#property description "The creator of these plugins cannot be held responsible for damage or loss."
#property description " "
#property description "Find More on tradingandcode.com"
#property icon "\\Images\\logo-steven.ico"

//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_plots 7

#property indicator_type1 DRAW_ARROW
#property indicator_width1 3
#property indicator_color1 0xFFFFFF
#property indicator_label1 "Buy"

#property indicator_type2 DRAW_ARROW
#property indicator_width2 3
#property indicator_color2 0xFFFFFF
#property indicator_label2 "Sell"

#property indicator_label3 "candle index"

#define indicatorName "chartsIndicator"

#define Bid bid()

#define Ask ask()

#define OBJPROP_TIME1 300

#define OBJPROP_PRICE1 301

#define OBJPROP_TIME2 302

#define OBJPROP_PRICE2 303

#define OBJPROP_TIME3 304

#define OBJPROP_PRICE3 305

#define OBJPROP_FIBOLEVELS 200

//--- indicator buffers
double Buffer1[];
double Buffer2[];
double Index[];

enum TradeType
{
  Buy = 1,
  Sell = 2
};

input bool Audible_Alerts = false;
input bool Push_Notifications = false;
input TradeType tradeType = Buy;

int lastFlatIndex = 0;
double lastFlatPrice = 0;
bool flatTenkanFound = false;
bool nextCandleGreaterThanFlat = false;
double nextCandleGreaterThanFlatPrice = 0;
bool tenkanSmallerThanFlat = false;
bool tenkanCandleComingToFlat = false;
double tenkanCandleComingToFlatPrice = 0;
bool triangleFound = false;

datetime time_alert; // used when sending alert
double myPoint;      // initialized in OnInit

double High[];
double Open[];
double Close[];
double Low[];
double Time[];

int ATR_handle;
double ATR[];



int Ichimoku_handle;
double Ichimoku_tenkan[];

//------------------------------------------------------------------------------------------------------------
//--------------------------------------------- pips counter  ----------------------------------------
//--- Vars and arrays

color color1 = LimeGreen;
color color2 = clrRed;
int corner = 1;
extern bool testing = false;

bool Initialized = false; // Has the INIT function finished?
double PipSize = 0;

string Saved_Variable_Old_Period = "";

double currentMZH = NULL, currentMZL = NULL;

double pips = 0;

int prevCalculated = 0;

int numberOfPositions = 0;

int supports = 0;
int resistances = 0;

#include "headers/initmql4.mqh"

#include "headers/utils.mqh"

#include "headers/signal.mqh"

#include "headers/flatDetector.mqh"

#include "headers/pipscounter.mqh"

#include "headers/levels.mqh"

#include "headers/moreinfo.mqh"

#include "headers/drawObjects.mqh"

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{

#include "headers/Initchecks_stecator.mqh"

  int initResult = OnSignalInit();

  if (initResult == INIT_FAILED)
  {
    return initResult;
  }

  // int initRsResult = InitRS();

  // if (initRsResult == INIT_FAILED)
  // {
  //   return initRsResult;
  // }

  onInitMoreInfo();

  createPipsValue();

  return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
  prevCalculated = prev_calculated - 1;
  OnCalcSignal(rates_total, prev_calculated);
  // OnCalcRS(rates_total, prev_calculated);
  calculateRSNumber();
  startPipsCounter();
  startMoreInfo();
  return (rates_total);
}
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{
  ObjectsDeleteAll(0, "SSSR#", 0, OBJ_RECTANGLE);
  ObjectsDeleteAll(0, "bsri_pips", 0, OBJ_LABEL);
  ObjectsDeleteAll(0, "stecatorInfo", 0, OBJ_LABEL);
  ObjectsDeleteAll(0, indicatorName, 0, OBJ_LABEL);
  ObjectsDeleteAll(0, indicatorName, 0, OBJ_TREND);
  ObjectsDeleteAll(0, indicatorName, 0, OBJPROP_RAY);
  ObjectsDeleteAll(0, indicatorName, 0, OBJ_HLINE);
  ObjectsDeleteAll(0, indicatorName, 0, OBJ_VLINE);
  Comment("");
}
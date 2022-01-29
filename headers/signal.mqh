int MA_handle;
double MA[];

int OnCalcSignal(int rates_total, int prev_calculated)
{
    int limit = rates_total - prev_calculated;
    //--- counting from 0 to rates_total

    ArraySetAsSeries(Buffer1, true);
    ArraySetAsSeries(Buffer2, true);
    //--- initial zero
    if (prev_calculated < 1)
    {
        ArrayInitialize(Buffer1, EMPTY_VALUE);
        ArrayInitialize(Buffer2, EMPTY_VALUE);
    }
    else
        limit++;

    datetime Time[];

    if (BarsCalculated(MA_handle) <= 0)
        return (0);
    if (CopyBuffer(MA_handle, 0, 0, rates_total, MA) <= 0)
        return (rates_total);
    ArraySetAsSeries(MA, true);

    if (CopyLow(Symbol(), PERIOD_CURRENT, 0, rates_total, Low) <= 0)
        return (rates_total);
    ArraySetAsSeries(Low, true);

    if (CopyClose(Symbol(), PERIOD_CURRENT, 0, rates_total, Close) <= 0)
        return (rates_total);
    ArraySetAsSeries(Close, true);

    if (CopyOpen(Symbol(), PERIOD_CURRENT, 0, rates_total, Open) <= 0)
        return (rates_total);
    ArraySetAsSeries(Open, true);

    if (CopyHigh(Symbol(), PERIOD_CURRENT, 0, rates_total, High) <= 0)
        return (rates_total);
    ArraySetAsSeries(High, true);

    if (CopyTime(Symbol(), Period(), 0, rates_total, Time) <= 0)
        return (rates_total);
    ArraySetAsSeries(Time, true);

    if (BarsCalculated(Ichimoku_handle) <= 0)
        return (0);
    if (CopyBuffer(Ichimoku_handle, TENKANSEN_LINE, 0, rates_total, Ichimoku_tenkan) <= 0)
        return (rates_total);
    ArraySetAsSeries(Ichimoku_tenkan, true);

    ArraySetAsSeries(Index, true);

    double value = 0;

    //--- main loop
    for (int i = limit - 1; i >= 0; i--)
    {
        if (i >= MathMin(5000 - 1, rates_total - 1 - 50))
            continue; // omit some old rates to prevent "Array out of range" or slow calculation

        double nextCandleTenkan = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 0, i + 1);

        Index[i] = i;

        static datetime candletime = 0;
        datetime time = iTime(NULL, PERIOD_CURRENT, i);

        if (!flatTenkanFound)
        {
            if (DetectFlatTenkan(value, i + 1))
            {
                candletime = time;
            }
        }
        else
        {
            if (NewBar())
            {
                Print("NewBar");
                if (tradeType == Sell)
                {
                    monitorSellEntry(nextCandleTenkan, i + 1, candletime);
                }
                else
                    monitorBuyEntry(nextCandleTenkan, i + 1, candletime);
            }
        }

        // Indicator Buffer 1
        if (
            //
            tradeType == Buy

            //
            && triangleFound

            //
        )
        {
            resetAll();
            Buffer1[i + 1] = Low[1 + i]; // Set indicator value at Candlestick Low
            if (i == 0 && Time[0] != time_alert)
            {
                myAlert("indicator", "Buy");
                time_alert = Time[0];
            } // Instant alert, only once per bar
        }
        else
        {
            Buffer1[i] = EMPTY_VALUE;
        }

        // Indicator Buffer 3
        if (
            //
            tradeType == Sell
            //
            && triangleFound
            //
        )
        {
            resetAll();
            Buffer2[i] = High[i+1]; // Set indicator value at Candlestick High
            if (i == 0 && Time[0] != time_alert)
            {
                myAlert("indicator", "Sell");
                time_alert = Time[0];
            } // Instant alert, only once per bar
        }
        else
        {
            Buffer2[i] = EMPTY_VALUE;
        }
    }
    return 0;
}

int OnSignalInit()
{
    SetIndexBuffer(0, Buffer1);
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetInteger(0, PLOT_ARROW, 233);

    SetIndexBuffer(1, Buffer2);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetInteger(1, PLOT_ARROW, 234);

    SetIndexBuffer(2, Index);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);

    // initialize myPoint
    myPoint = Point();
    if (Digits() == 5 || Digits() == 3)
    {
        myPoint *= 10;
    }

    MA_handle = iMA(NULL, PERIOD_CURRENT, 25, 0, MODE_LWMA, PRICE_CLOSE);

    if (MA_handle < 0)
    {
        Print("The creation of iMA has failed: MA_handle=", INVALID_HANDLE);
        Print("Runtime error = ", GetLastError());
        return (INIT_FAILED);
    }

    Ichimoku_handle = iIchimoku(NULL, PERIOD_CURRENT, 9, 26, 52);
    if (Ichimoku_handle < 0)
    {
        Print("The creation of iIchimoku has failed: Ichimoku_handle=", INVALID_HANDLE);
        Print("Runtime error = ", GetLastError());
        return (INIT_FAILED);
    }

    return INIT_SUCCEEDED;
}

void resetAll()
{
    Print("resetAll()");
    lastFlatPrice = 0;
    lastFlatIndex = 0;
    flatTenkanFound = false;
    nextCandleGreaterThanFlat = false;
    nextCandleGreaterThanFlatPrice = 0;
    tenkanCandleComingToFlat = false;
    tenkanCandleComingToFlatPrice = 0;
    triangleFound = false;
}

void monitorSellEntry(double nextCandleTenkan, int i, datetime candletime)
{
    datetime time = iTime(NULL, PERIOD_CURRENT, i);
    if (!nextCandleGreaterThanFlat)
    {
        if (lastFlatPrice > 0)
        {

            if (nextCandleTenkan > lastFlatPrice)
            {
                candletime = time;
                nextCandleGreaterThanFlat = true;
                nextCandleGreaterThanFlatPrice = nextCandleTenkan;
            }
            else
            {
                Print("reset because nextCandleTenkan < lastFlatPrice");
                resetAll();
            }
        }
        else
        {
            Print("reset because lastFlatPrice == 0");
            resetAll();
        }
    }
    else
    {
        if (!tenkanCandleComingToFlat)
        {
            Print("inside tenkanCandleComingToFlat is false");
            if (nextCandleGreaterThanFlatPrice > 0)
            {
                Print("inside nextCandleGreaterThanFlatPrice > 0 ", nextCandleGreaterThanFlatPrice);
                if (nextCandleTenkan < nextCandleGreaterThanFlatPrice)
                {
                    candletime = time;
                    Print("inside nextCandleTenkan < nextCandleGreaterThanFlatPrice before set ", nextCandleTenkan, " ", tenkanCandleComingToFlatPrice);
                    tenkanCandleComingToFlat = true;
                    tenkanCandleComingToFlatPrice = nextCandleTenkan;
                }
                else
                {
                    Print("reset because nextCandleTenkan > nextCandleGreaterThanFlatPrice");
                    resetAll();
                }
            }
            else
            {
                Print("reset because nextCandleGreaterThanFlatPrice is 0");
                resetAll();
            }
        }
        else
        {
            Print("inside tenkanCandleComingToFlat is true");
            if (tenkanCandleComingToFlatPrice > 0)
            {
                Print("inside tenkanCandleComingToFlatPrice > 0 ", tenkanCandleComingToFlatPrice, " ", nextCandleTenkan);
                if (nextCandleTenkan < tenkanCandleComingToFlatPrice)
                {
                    candletime = time;
                    Print("inside nextCandleTenkan < tenkanCandleComingToFlatPrice");
                    tenkanCandleComingToFlatPrice = nextCandleTenkan;
                    double nextCandleKijun = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 1, i);
                    double previousCandleKijun = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 1, i + 1);
                    double previousCandleKijun2 = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 1, i + 2);
                    double previousCandleTenkan = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 0, i + 1);

                    if (signalMode == Aggressiv)
                    {
                        Print("inside Aggressiv");
                        if (MA[i + 1] > nextCandleTenkan) // cross
                        {
                            Print("the signal is placed");
                            triangleFound = true;
                        }
                    }
                    else
                    {
                        if (
                            previousCandleKijun2 == nextCandleKijun && previousCandleKijun == nextCandleKijun && previousCandleTenkan > previousCandleKijun && nextCandleKijun > nextCandleTenkan && nextCandleKijun == lastFlatPrice)
                        {
                            triangleFound = true;
                        }
                    }
                }
                else
                {
                    Print("reset because nextCandleTenkan >= tenkanCandleComingToFlatPrice");
                    resetAll();
                }
            }
            else
            {
                Print("reset because tenkanCandleComingToFlatPrice is 0");
                resetAll();
            }
        }
    }
}

void monitorBuyEntry(double nextCandleTenkan, int i, datetime candletime)
{
    if (!nextCandleGreaterThanFlat)
    {
        if (lastFlatPrice > 0)
        {

            if (nextCandleTenkan < lastFlatPrice)
            {
                nextCandleGreaterThanFlat = true;
                nextCandleGreaterThanFlatPrice = nextCandleTenkan;
            }
            else
            {
                resetAll();
            }
        }
        else
            resetAll();
    }
    else
    {
        if (!tenkanCandleComingToFlat)
        {
            if (nextCandleGreaterThanFlatPrice > 0)
            {
                if (nextCandleTenkan > nextCandleGreaterThanFlatPrice)
                {
                    tenkanCandleComingToFlat = true;
                    tenkanCandleComingToFlatPrice = nextCandleTenkan;
                }
                else
                {
                    resetAll();
                }
            }
            else
                resetAll();
        }
        else
        {
            if (tenkanCandleComingToFlatPrice > 0)
            {
                if (nextCandleTenkan > tenkanCandleComingToFlatPrice)
                {
                    tenkanCandleComingToFlatPrice = nextCandleTenkan;

                    if (MA[i + 1] < nextCandleTenkan) // cross
                    {
                        triangleFound = true;
                    }
                }
                else
                    resetAll();
            }
            else
                resetAll();
        }
    }
}

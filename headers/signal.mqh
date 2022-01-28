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

        double nextCandleTenkan = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 0, i);

        Index[i] = i;

        if (!flatTenkanFound)
        {
            DetectFlatTenkan(value, i);
        }
        else
        {
            if (tradeType == Sell)
            {
                monitorSellEntry(nextCandleTenkan, i);
            }
            else
                monitorBuyEntry(nextCandleTenkan, i);
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
            Buffer2[i + 1] = High[1 + i]; // Set indicator value at Candlestick High
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
    lastFlatPrice = 0;
    lastFlatIndex = 0;
    flatTenkanFound = false;
    nextCandleGreaterThanFlat = false;
    nextCandleGreaterThanFlatPrice = 0;
    tenkanCandleComingToFlat = false;
    tenkanCandleComingToFlatPrice = 0;
    triangleFound = false;
}

void monitorSellEntry(double nextCandleTenkan, int i)
{
    if (!nextCandleGreaterThanFlat)
    {
        if (lastFlatPrice > 0)
        {

            if (nextCandleTenkan > lastFlatPrice)
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
                if (nextCandleTenkan < nextCandleGreaterThanFlatPrice)
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
                if (nextCandleTenkan < tenkanCandleComingToFlatPrice)
                {
                    tenkanCandleComingToFlatPrice = nextCandleTenkan;

                    if (MA[i] > nextCandleTenkan) // cross
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

void monitorBuyEntry(double nextCandleTenkan, int i)
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

                    if (MA[i] < nextCandleTenkan) // cross
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
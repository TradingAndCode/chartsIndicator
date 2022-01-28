


int DetectFlatTenkan(double &price, int j)
{
    if (j + 3 >= lastFlatIndex && lastFlatIndex != 0) // if the to study candles include the last flat index return 
    {
        return 0;
    }

    double trailPrice = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 0, j);

    int i = j;
    int total = 0;
    for (i; i < j + 3; i++)
    {
        double temp = iIchimokuMQL4(NULL, PERIOD_CURRENT, 9, 26, 52, 0, i);
        if (temp == trailPrice)
        {
            total++;
            // Print("the total is incrementing ", total);
        }
        else
        {
            trailPrice = temp;
        }
        if (total >= 2)
        {
            break;
        }
    }

    if (total >= 2)
    {
        price = trailPrice;

        drawSegmentHLine(indicatorName + i, price, i, i + 2);

        lastFlatIndex = j;

        lastFlatPrice = price;

        flatTenkanFound = true;

        return i;
    }
    return 0;
}
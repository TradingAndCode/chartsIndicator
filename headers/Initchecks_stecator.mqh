//+------------------------------------------------------------------+
//|                                                   Initchecks.mqh |
//|                                                   Steven Nkeneng |
//|                                        https://stevennkeneng.com |
//+------------------------------------------------------------------+
#property copyright "Steven Nkeneng"
#property link      "https://stevennkeneng.com"
#property strict

//3170564
//3542835 - hermann

if (TimeLocal() > D'01.04.2022' || AccountInfoInteger(ACCOUNT_LOGIN) != 3170564){
         
   MessageBox("This File Has Expired! Please purchase the password from Steven nkeneng!", "Expired File");

   Comment("The file was removed because it is past it's expiration date." +

           "\nPlease contact the programmer at nkeneng.steven@gmail.com for the password");

   ExpertRemove();

   return (INIT_FAILED);

}
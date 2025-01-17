//+------------------------------------------------------------------+
//|                            alik_sup_res_clusteringOnFractals.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Math/Alglib/alglib.mqh>
#include <Math/Alglib/dataanalysis.mqh>
CAlglib   my_alg =new CAlglib;
CBdSS       my_da=new CBdSS;
//my_da
CClusterizerState model_state;
CAHCReport        model_report;
input int distribution=2;
input    int clusters_count=4;
int my_fr_handle;
string my_line="line";

double fractalsAll[];
 double cluster_center,cluster_sum;
int  cluster_count;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(15);
   Print(EMPTY_VALUE);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   if(my_fr_handle!=INVALID_HANDLE)
     {
      IndicatorRelease(my_fr_handle);
     }
   for(int i=0;i<clusters_count;i++)
     {
      StringAdd(my_line,i);

      if(ObjectFind(0,my_line))
        {
         ObjectDelete(0,my_line);
        }
      my_line=StringSubstr(my_line,0,-2);
     }

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//
//
//   int visible_bars = (int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//   my_fr_handle =iFractals(_Symbol,_Period);
//   int fr_buffer_created=CopyBuffer(my_fr_handle,0,1,visible_bars,fractalsAll);
//   if(fr_buffer_created==-1)
//     {
//      CopyBuffer(my_fr_handle,0,1,visible_bars,fractalsAll);
//     }
//   int j=0;
//   CMatrixDouble fractals;
//   for(int i=0;i<visible_bars-1;i++)
//     {
//      //▼ what?!!!
//      if(fractalsAll[i]!=EMPTY_VALUE)//double(1797693134862315708145274237317))//iHigh(_Symbol,_Period,i+1))////        1797693134862315708145274237317
//        {
//         fractals.Resize(1,++j);
//         fractals.Set(0,j,fractalsAll[i]);
//        }
//     }
//   my_alg.ClusterizerCreate(model_state);
//   my_alg.ClusterizerSetPoints(model_state,fractals,distribution);
//   my_alg.ClusterizerRunAHC(model_state,model_report);
//
//   CRowInt cluster_indexes;
//   CRowInt cluster_indexs_ofData;
//   my_alg.ClusterizerGetKClusters(model_report,clusters_count,cluster_indexes,cluster_indexs_ofData);
////fractals                    array
////cluster_indexs_ofData       array
////corespond to one another
////group fractals by their cluster index
////get their average creat line object to draw chart with
//   for(int i=0;i<clusters_count-1;i++)
//     {
//      double cluster_sum=0;
//      int     cluster_count=0;
//      for(int j=0;j<fractals.Size()-1;j++)
//        {
//         if(cluster_indexs_ofData[j]==i)
//           {
//            cluster_count++;
//            cluster_sum+=fractals[j][0];
//           }
//        }
//      if(cluster_count!=0)
//        {
//
//         double cluster_center=cluster_sum/cluster_count;
//         ObjectCreate(0,StringAdd(my_line,string(j)),OBJ_HLINE,0,iTime(_Symbol,_Period,3),cluster_center);
//         my_line=StringSubstr(my_line,0,-2);
//
//        }
//     }
//
//

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---


   int visible_bars = (int)ChartGetInteger(0,CHART_VISIBLE_BARS);
   my_fr_handle =iFractals(_Symbol,_Period);
   int fr_buffer_created=CopyBuffer(my_fr_handle,0,1,visible_bars,fractalsAll);//here_ali ▼ start should become current postition of chart can get by start time
   if(fr_buffer_created==-1)
     {
      CopyBuffer(my_fr_handle,0,1,visible_bars,fractalsAll);
     }
   int j=0;
   CMatrixDouble fractals(350);
   for(int i=0;i<visible_bars-1;i++)
     {
      //▼ what?!!!
      if(fractalsAll[i]<1797693134862315708145274237317)//)!=EMPTY_VALUE)
        {
         //fractals.Resize(++j,1);
         fractals.Set(j++,0,fractalsAll[i]);
        }
     }
   my_alg.ClusterizerCreate(model_state);
   my_alg.ClusterizerSetPoints(model_state,fractals,distribution);
   my_alg.ClusterizerRunAHC(model_state,model_report);
   CRowInt cluster_indexes;
   CRowInt cluster_indexs_ofData;
   my_alg.ClusterizerGetKClusters(model_report,clusters_count,cluster_indexes,cluster_indexs_ofData);
//fractals                    array
//cluster_indexs_ofData       array          NO    this one    ->    cluster_indexes
//corespond to one another
//group fractals by their cluster index
//get their average creat line object to draw chart with
   for(int i=0;i<clusters_count-1;i++)
     {
       cluster_sum=0;
       cluster_count=0;
      for(int j=0;j<fractals.Size()-1;j++)
        {
         if(cluster_indexes[j]==i)
           {
            cluster_count++;
            cluster_sum+=fractals[j][0];
           }
        }
      if(cluster_count!=0)
        {
         StringAdd(my_line,string(i));
         cluster_center=cluster_sum/cluster_count;
         ObjectCreate(0,my_line,OBJ_HLINE,0,iTime(_Symbol,_Period,3),cluster_center);
         my_line=StringSubstr(my_line,0,-2);

        }

     }


  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---



  }
//+------------------------------------------------------------------+

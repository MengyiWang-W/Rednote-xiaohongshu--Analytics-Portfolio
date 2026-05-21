#Feature engineering
#price formatting, parsing (and averaging)
from pathlib import Path
import pandas as pd
import logging

def price_avg(raw_price):
  if pd.isna(raw_price):
     return None
  
  raw_price=str(raw_price).strip()

  try:
    if "," in raw_price:
       price=str(raw_price).split(",")
       price_avg=sum(float(p) for p in price)/len(price)
       return price_avg
    
    elif "-" in raw_price:
       low,high=str(raw_price).split("-")  
       price_avg=(float(low)+float(high))/2
       return price_avg
    
    elif "/" in raw_price:
        total,people=raw_price.split("/")
        price_avg=float(total)/float(people)
        return price_avg
    
    else:
       return float(raw_price) 
  except:
     return None
  
def get_price_level(price):
     if pd.isna(price):
        return None
     elif price <=25:
        return "low"
     elif 25<price<=55:
        return "medium"
     elif price>55:
        return "high"

def engineer_features(df):
# price
   df["price_avg"]=df["raw_price"].apply(price_avg)
   df['price_level']=df['price_avg'].apply(get_price_level)

# content length bucket（vectorized）   
   df["content_length_bucket"]=pd.cut(df["content_length"],
                                   bins=[0,200,400,float("inf")],
                                   labels=["short","medium","long"])   
   df["engagement_score"] = (
       df["like_count"] + df["save_count"] + df["comment_count"]
   ) / df["follower_count"].replace(0, pd.NA)
# engagement
   threshold=df["engagement_score"] .median()
   df["is_high_engagement"]=df["engagement_score"]>threshold

   df["like_rate"] = df["like_count"] / df["follower_count"].replace(0, pd.NA)
   df["save_rate"] = df["save_count"] / df["follower_count"].replace(0, pd.NA)
   df["comment_rate"] = df["comment_count"] / df["follower_count"].replace(0, pd.NA)
# time features
   df["post_datetime"] = pd.to_datetime(df["post_datetime"], errors="coerce")
   df["weekday"] = df["post_datetime"].dt.day_name()
   df["is_weekend"] = df["post_datetime"].dt.weekday >= 5
   
#image density
   df["image_count_bucket"]=pd.cut(df["image_count"],bins=[0,6,12,float("inf")],labels=['small',"medium","large"])
   df["image_density"]=df["image_count"]/df["content_length"].replace(0,pd.NA)
   return df
def save_features(df,OUTPUT_DIR):
   OUTPUT_DIR=Path(OUTPUT_DIR)
   OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
   df.to_csv(OUTPUT_DIR/"xhs_posts_features.csv",index=False,encoding="utf-8-sig")
   df.to_excel(OUTPUT_DIR/"xhs_posts_features.xlsx",index=False)
   logging.info("Saved feature data")


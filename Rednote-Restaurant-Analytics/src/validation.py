from pathlib import Path
import pandas as pd
import logging

#structure validation
results={"errors":[],"warnings":[]}
    #missing columns validation
expected_cols=['emotion_category', 'has_price', 'has_info_gap', 'content_length',
       'photo_quality_score', 'structured_content_flag', 'caption_text',
       'image_count', 'tags', 'restaurant_name', 'cuisine_type',
       'restaurant_popularity', 'novelty_score', 'raw_price',
       'post_datetime', 'follower_count', 'like_count', 'save_count',
       'comment_count', 'link']

schema={"emotion_category":{"type":"categorical","values":["Emotion", "Guide", "Hybrid"]},
           "has_price":{"type":"binary"},
           "has_info_gap":{"type":"binary"},
           "content_length":{"type":"numeric","min":0},
           "photo_quality_score":{"type":"categorical","values":[1,2,3]},
           "structured_content_flag":{"type":"binary"},
           "caption_text":{"type":"string"},
           "image_count":{"type":"numeric","min":0},
           "tags":{"type":"string"},
           "restaurant_name":{"type":"string"},
           "cuisine_type":{"type":"string"},
           "restaurant_popularity":{"type":"categorical","values":[1,2,3]},
           "novelty_score":{"type":"categorical","values":[1,2,3]},
           "raw_price":{"type":"string"},
           "post_datetime":{"type":"datetime"},
           "follower_count":{"type":"numeric","min":0},
           "like_count":{"type":"numeric","min":0},
           "save_count":{"type":"numeric","min":0},
           "comment_count":{"type":"numeric","min":0},
           "link":{"type":"string"}
           }
def validate_schema(df,results):
    #empty validation
    if df.empty:
       results["errors"].append("Dataframe is empty")
    missing =set(expected_cols)-set(df.columns)

    if missing:
       results["errors"].append(f"Missing columns:{missing}")

    for col, rules in schema.items():
        if col not in df.columns:
           continue
    
        if rules["type"]=="numeric":
            if not pd.api.types.is_numeric_dtype (df[col]):
                results["errors"].append(f"{col} must be numeric")

            elif "min" in rules and pd.api.types.is_numeric_dtype(df[col]):
             if (df[col]<rules["min"]).any():
                results["errors"].append(f"{col} has values below {rules['min']}")
        
        elif rules["type"]=="string":
            if not pd.api.types.is_object_dtype(df[col]):
                results["errors"].append(f"{col} must be string-like")
            
            if df[col].astype(str).str.strip().eq("").any():
                results["warnings"].append(f"{col} contains empty strings")   
    
        elif rules["type"]=="binary":
            if not df[col].dropna().isin ([0,1]).all():
                results["errors"].append(f"{col} must be 0/1")
            
        elif rules["type"]=="categorical":
            if not df[col].dropna().isin(rules["values"]).all():
                results["errors"].append(f"{col} invalid category values")
            
        elif rules["type"]=="datetime":
            converted=pd.to_datetime(df[col],errors="coerce")
            invalid_counts=converted.isna().sum()
            if invalid_counts>0:
                results["errors"].append(f"{col} has {invalid_counts} invalid datetime format")   
def summarize_validation(df, results):
        return {
            "rows": len(df),
            "columns": len(df.columns),
            "errors": len(results["errors"]),
            "warnings": len(results["warnings"])
        }      

#missing value
def check_missing(df, results):
    missing=df.isnull().sum()
    for col,val in missing.items():
       if val>0:
          results["warnings"].append(f"{col} has {val} missing values")

#range/rule validation
numeric_columns=['content_length', 'image_count', 
       'follower_count', 'like_count', 'save_count',
       'comment_count']
def check_range (df,results):
    existing_cols = [c for c in numeric_columns if c in df.columns]
    if existing_cols and (df[existing_cols] < 0).any().any():
       results["errors"].append("numeric columns cannot be negative")

#uniqueness check
def check_duplicates(df,results):
    dup=df.duplicated().sum()
    if dup>0:
       results["warnings"].append(f"{dup} duplicate rows found")

#consistency check
def check_consistency(df,results):
 if "like_count" in df.columns and "comment_count" in df.columns:
    if (df["comment_count"]>df["like_count"]).any():
        results["warnings"].append("comment_count>like_count")

def run_validation(df):
    results = {"errors": [], "warnings": []}
    validate_schema(df,results)
    check_missing(df,results)
    check_range (df,results)
    check_duplicates(df,results)
    check_consistency(df,results)
    return results
    #logging & reporting
    logging.info(results)
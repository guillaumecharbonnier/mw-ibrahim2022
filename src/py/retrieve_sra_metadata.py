#! /usr/bin/env python

import os
import requests
import pandas as pd
from pandas.io.json import json_normalize #package for flattening json in pandas df
from flatten_json import flatten
import warnings

script_dir=os.path.dirname(os.path.realpath(__file__))
out_dir=script_dir+"/../../out/py/retrieve_sra_metadata"

if not(os.path.exists(out_dir) and os.path.isdir(out_dir)):
    os.makedirs(out_dir)

os.chdir(out_dir)

srp_ids=[
    "SRP057486",
    "SRP131063",
    "SRP056481",
    "SRP084288"
]

for srp_id in srp_ids:
    host = 'http://api.omicidx.cancerdatasci.org'
    path = f'/sra/studies/{srp_id}/runs?include_fields=accession&include_fields=sample_accession&include_fields=experiment_accession&include_fields=sample&size=999'
    url = host + path
    response = requests.get(url)
    samples = response.json()
    flattened = [flatten(d) for d in samples['hits']]
    df = pd.DataFrame(flattened)
    cols_to_rename={}
    tags=list(df.filter(regex="sample_attributes_[0-9]+_tag").columns)
    for tag in tags:
        tag_prefix=df[tag].name.strip("_tag")
        if len(df[tag].unique()) != 1:
            warnings.warn("More than one value for the " + tag_prefix + " tag. Ignoring it.")
        else:
            cols_to_rename[tag_prefix + "_value"]=df[tag].iloc[0]
    df.rename(columns = cols_to_rename, inplace=True)
    df.drop(columns = tags, inplace=True)
    if len(df.sample_accession.unique()) != len(df.accession.unique()):
        warnings.warn("Different numbers of SRR and SRS.")
    if len(df.experiment_accession.unique()) != len(df.accession.unique()):
        warnings.warn("Different numbers of SRR and SRX.")
    df.to_excel(srp_id + ".xlsx")

# Used to find Layout SE or PE
# for srp_id in srp_ids:
#     host = 'http://api.omicidx.cancerdatasci.org'
#     path = f'/sra/studies/{srp_id}/experiments'
#     url = host + path
#     print(url)


# mw-ibrahim2022

MetaWorkflow module for the Antares project, published as "Transcriptomic studies of antidepressant action in rodent models of
depression: a first meta-analysis"

```
git clone git@github.com:guillaumecharbonnier/mw-ibrahim2022.git
git clone git@github.com:guillaumecharbonnier/mw-lib.git
cd mw-ibrahim2022
src/py/retrieve_sra_metadata.py
snakemake --use-conda antares -j 2
```

After compilation the main report produced in `out/bookdown/main_report` is moved to `docs` to be hosted with [github pages here](https://guillaumecharbonnier.github.io/mw-ibrahim2022). Objects larger than 20mo are removed to meet github restrictions on file size.
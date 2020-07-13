import numpy as np
import pandas as pd

pd.options.display.max_rows = 20;
pd.options.display.expand_frame_repr = True


import sys
sys.path.insert(1,'/home/arya/workspace/bio')
import UTILS.Util as utl
import multiprocessing

from UTILS.BED import BED
from UTILS.Util import mask
from time import time
CHROMS=['2L', '2R', '3L', '3R', 'X']
cp=['CHROM','POS']
coord=pd.read_pickle('/home/arya/storage/Data/Dmelanogaster/geneCoordinates/gene_map_table_fb_2014_03.tsv.dmel.df')
coords2=pd.concat([coord.rename(columns={'start':'POS'}).set_index(cp)['FBgn'], \
            coord.rename(columns={'end':'POS'}).set_index(cp)['FBgn']]).loc[CHROMS].sort_index()
chromL=coord.groupby('CHROM').end.max().loc[CHROMS]

chromL
path='/home/arya/storage/Data/Dmelanogaster/OxidativeStress/plots/intervals/'
def load_intervals(replicated):
    def geti(x):
        chrom = x[3:].split(':')[0]
        start, end = map(lambda y: 1e6 * float(y), x.replace('Mb', '').split(':')[1].split('-'))
        return BED.interval(chrom, start, end)

    fname=['intervals_single_rep.tsv','intervals.tsv'][replicated]
    I=pd.read_csv(path+fname,sep='\t').set_index('Name')
    I=I.join(I.Coordinate.apply(geti)).reset_index()
    if replicated:
        I.Name=I.Name.apply(lambda x: x[0]+chr(64+int(x[-1])))
        I['name']=I.Name.apply(lambda x: '$\mathrm{'+x[0]+'}_{''\mathrm{'+x[-1]+'}}$')
    else:
        I.Name=I.Name.apply(lambda x: x[0]+x[2]+chr(64+int(x[-1])))
        I['name']=I.Name.apply(lambda x: '$\mathrm{'+x[0]+'}_{'+x[1]+'\mathrm{'+x[2]+'}}$')
    return I.set_index('Name')

I = load_intervals(True)
def calculate_random_gene_sets(I):
    fin='/home/arya/storage/Data/Dmelanogaster/OxidativeStress/plots/intervals/random_gene_sets.df'
    try:
        return pd.read_pickle(fin)
    except:
        def get_random_interval_gens_per_len(length,n_per_chrom=2000):
            ming=max(1,np.round(length/1e5))
            print(length,ming)
            random_intervals=[]
            np.random.seed(0)
            for chrom in CHROMS:
                print(chrom)
                j=0
                while j<n_per_chrom:
                    start=np.random.randint(0,chromL.loc[chrom]-length)
                    bg=mask(coords2,BED.interval( chrom,start,start+int(length))).unique()
                    if bg.size > ming:
                        random_intervals+=[pd.Series(bg)]
                        j+=1
            return pd.concat(random_intervals,keys=list(range(len(random_intervals)))).reset_index(1,drop=True)


        random_gene_sets=I.len.groupby(level=0).apply(lambda x:  get_random_interval_gens_per_len(x.loc[x.name]))
        random_gene_sets.to_pickle(fin)


go = pd.read_pickle(utl.PATH.data + "GO/GO.fly.df").set_index('ontology').drop('C')
go=go.groupby('go').filter(lambda x: len(x) >=3).set_index('go').fngn
go
go_terms = go.index.unique()
print(go_terms.size,go.index.size)
random_gene_sets = calculate_random_gene_sets(I)
random_gene_sets=random_gene_sets[random_gene_sets.index.get_level_values(1)<1000]
# random_gene_sets=random_gene_sets.apply(lambda x: x[4:]).astype(int)
# go=go.apply(lambda x: x[4:]).astype(int)
def get_go_prob(x):
    p = random_gene_sets.groupby(level=[0, 1]).apply(lambda y: np.intersect1d(go.loc[x], y).size / y.size)
    return p.groupby(level=0).mean()

def get_go_indicator(x):
    p = random_gene_sets.groupby(level=[0, 1]).apply(lambda y: np.intersect1d(go.loc[x], y).size / y.size)
    return (p.groupby(level=0).sum()>0).astype(int)



# s=time();x=get_go_prob(go_terms[0]);print(time()-s)




ret=pd.concat(multiprocessing.Pool(22).map(get_go_indicator,go_terms),keys=go_terms)
ret.to_pickle('/home/arya/storage/Data/Dmelanogaster/OxidativeStress/plots/intervals/enrichment.probs.binary.ge3.df')
# # print(ret)
# print(time()-s)

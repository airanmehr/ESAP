import numpy as np;
import matplotlib as mpl;

np.set_printoptions(linewidth=200, precision=5, suppress=True)
import pandas as pd;

pd.options.display.max_rows = 20;
pd.options.display.expand_frame_repr = False

import matplotlib as mpl
#x
# os.environ["DISPLAY"] = "localhost:11.0"
import matplotlib.pyplot as plt
import sys,os
path='/'.join(os.getcwd().split('/')[:-4])
sys.path.insert(1,path)
# import UTILS.Plots as pplt
# import CLEAR.Libs.Markov as mkv
# import UTILS.Hyperoxia as hutl
import CL
import pandas as pd


pd.options.display.max_rows = 20;

pd.options.display.max_columns = 50;
pd.options.display.expand_frame_repr = False
import pylab as plt

path='/pedigree2/projects/arya/Data/Dmelanogaster/OxidativeStress/'
ann=pd.read_pickle(path+'vcf/merge/byChr/ANN.idf')
mpl.rcParams['figure.figsize'] = [8, 6]
mpl.rcParams['figure.dpi'] = 150
mpl.rcParams['text.usetex'] = False
a=hutl.rename(pd.read_pickle('/home/arya/fly/all/RC/all.df'))
# # X=a.xs('C',1,3)/a.xs('D',1,3)
# # x=X.groupby(level=[0,1],axis=1).mean()
#
rangeN=range(10,301,10)
CD=a.reorder_levels([0,2,1,3],axis=1).sort_index(1)
CD=CD.H.loc[:,pd.IndexSlice[:,[1, 4, 7, 12, 17, 31, 61, 114, 180]]]



def genomewide():
    mkv.estimateN(CD, rangeN=rangeN, Nt=True, numSNPs=10000, nProc=12).to_pickle(path+'N.gw.df')
    mkv.estimateN(CD, rangeN=rangeN, Nt=True, Nc=True, numSNPs=10000, nProc=12).to_pickle(path + 'N.chr.df')
    mkv.estimateN(CD, rangeN=rangeN, Nt=True, Nc=True, Nr=True, numSNPs=10000, nProc=12).to_pickle(path + 'N.chrRep.df')
    mkv.estimateN(CD, rangeN=rangeN, Nt=True, Nr=True, numSNPs=10000, nProc=12).to_pickle(path + 'N.rep.df')

    def plot(x):
        if len(x.shape)==2:
            x.loc[1,:]=200
        else:
            x[1] = 200
        x=x.sort_index()
        print x
        x.plot(use_index=True, marker='o', colors=pplt.getColorMap(15))
        plt.xticks(x.index);
        if len(x.shape) == 2:
            plt.yticks(x.iloc[:,0].sort_values());
        else:
            plt.yticks(x.sort_values());
        plt.xlabel('Generation')
        plt.xlim([-5,185])
        plt.ylabel('N')
        plt.title('Maximum Likelihood Estimate')
        plt.gca().legend(bbox_to_anchor=(1.01, 1))
        plt.tight_layout(rect=[0, 0, 0.85, 1])
        plt.show()
    plot(pd.read_pickle(path + 'N.gw.df').idxmax())
    plot(pd.read_pickle(path+'N.rep.df').idxmax().unstack(0))
    plot(pd.read_pickle(path + 'N.chr.df').groupby(level=0).idxmax().applymap(lambda x: x[1]).T)



    plot(pd.read_pickle(path + 'N.chrRep.df').groupby(level=0).apply(lambda x: x.loc[x.name].idxmax()).stack().unstack(0));




def scan():
    N=pd.read_pickle(path + 'N.gw.df').idxmax()

    HMM = mkv.HMM(eps=1e-2, CD=CD.iloc[:10], gridH=[0.5], N=N, n=200, saveCDE=False, loadCDE=False, verbose=1, maxS=None)
    HMM.fit(False)

    N
    pass

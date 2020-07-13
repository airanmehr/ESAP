import pyarrow
import  pandas as pd
a=pd.read_parquet('all.pq')
pyarrow.parquet .write_to_dataset(pyarrow.Table.from_pandas(a),root_path='flyEE.pq',partition_cols=['CHROM'])


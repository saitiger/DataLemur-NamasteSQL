SELECT br.BorrowerName,
GROUP_CONCAT(bk.BookName order by bk.BookName) BorrowedBooks
from
Borrowers br
join 
Books bk 
on 
br.BookID = bk.BookID
group by 1
order by 1

Pandas 
merged_df = pd.merge(borrowers_df, books_df, on='BookID', how='inner')
result_df = merged_df.groupby('BorrowerName').agg({
    'BookName': lambda x: ','.join(sorted(x))
}).reset_index().rename(columns={'BookName': 'BorrowedBooks'})
result_df = result_df.sort_values('BorrowerName').reset_index(drop=True)[['BorrowerName','BorrowedBooks']]
print(result_df)

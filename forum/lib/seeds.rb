require 'pg'

def conn
    if ENV["RACK_ENV"] == "production"
      PG.connect(
          dbname: ENV["POSTGRES_DB"],
          host: ENV["POSTGRES_HOST"],
          password: ENV["POSTGRES_PASS"],
          user: ENV["POSTGRES_USER"]
        )
    else
    PG.connect(dbname: "news")
    end
end

conn.exec("DROP TABLE IF EXISTS user_data")
conn.exec("DROP TABLE IF EXISTS topic_data")
conn.exec("DROP TABLE IF EXISTS comment_data")



conn.exec("CREATE TABLE user_data(
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
  )"
)

conn.exec("INSERT INTO user_data (username, email, password) VALUES (
    'may',
    'may@gmail.com',
    'abc123'
  )"
)


conn.exec("CREATE TABLE comment_data(
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    topicID INT,
    posts TEXT NOT NULL
  )"
)

conn.exec("INSERT INTO comment_data (username, topicID, posts) VALUES (
    'may',
    4,
    'hello my name is dkfiekslasfe'
  )"
)


conn.exec("CREATE TABLE topic_data(
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    userID INT,
    body TEXT NOT NULL
  )"
)

conn.exec("INSERT INTO topic_data (title, userID, body) VALUES (
    'trumpety trump trump',
    4,
    'blah balh balh balh balhasldkfjalsdkfjalsdfjalskdfjasdf'
  )"
)

/*
  # Create Blog Application Schema

  1. New Tables
    - `auth_user` - Django's built-in user authentication table
      - `id` (integer, primary key, auto-increment)
      - `username` (varchar 150, unique, not null)
      - `first_name` (varchar 150)
      - `last_name` (varchar 150)
      - `email` (varchar 254)
      - `password` (varchar 128, not null) - stores hashed passwords
      - `is_superuser` (boolean, default false)
      - `is_staff` (boolean, default false)
      - `is_active` (boolean, default true)
      - `date_joined` (timestamptz, default now)
      - `last_login` (timestamptz, nullable)

    - `blog_post` - Blog posts
      - `postid` (integer, primary key, auto-increment)
      - `title` (varchar 100, not null)
      - `content` (text, not null)
      - `created_at` (timestamptz, default now)
      - `updated_at` (timestamptz, default now)
      - `user_id` (integer, foreign key to auth_user)

    - `blog_profile` - User profiles
      - `userid` (integer, primary key, foreign key to auth_user)
      - `bio` (text)
      - `location` (varchar 100)
      - `birth_date` (date, nullable)
      - `image` (varchar 100, nullable) - stores file path

    - `blog_comment` - Comments on posts
      - `id` (bigint, primary key, auto-increment)
      - `content` (text, not null)
      - `created_at` (timestamptz, default now)
      - `post_id` (integer, foreign key to blog_post)
      - `user_id` (integer, foreign key to auth_user)

  2. Security
    - Enable RLS on all tables
    - Policies allow authenticated users to read all data
    - Users manage their own content via application logic

  3. Indexes
    - Index on username for faster lookups
    - Index on post user_id and created_at for efficient queries
    - Index on comment post_id for faster comment retrieval
*/

-- Create auth_user table (Django's built-in User model)
CREATE TABLE IF NOT EXISTS auth_user (
  id SERIAL PRIMARY KEY,
  username VARCHAR(150) UNIQUE NOT NULL,
  first_name VARCHAR(150) DEFAULT '',
  last_name VARCHAR(150) DEFAULT '',
  email VARCHAR(254) DEFAULT '',
  password VARCHAR(128) NOT NULL,
  is_superuser BOOLEAN DEFAULT false,
  is_staff BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  date_joined TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

-- Create blog_post table
CREATE TABLE IF NOT EXISTS blog_post (
  postid SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE
);

-- Create blog_profile table
CREATE TABLE IF NOT EXISTS blog_profile (
  userid INTEGER PRIMARY KEY REFERENCES auth_user(id) ON DELETE CASCADE,
  bio TEXT DEFAULT '',
  location VARCHAR(100) DEFAULT '',
  birth_date DATE,
  image VARCHAR(100)
);

-- Create blog_comment table
CREATE TABLE IF NOT EXISTS blog_comment (
  id BIGSERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  post_id INTEGER NOT NULL REFERENCES blog_post(postid) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_auth_user_username ON auth_user(username);
CREATE INDEX IF NOT EXISTS idx_blog_post_user_created ON blog_post(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_blog_comment_post ON blog_comment(post_id);
CREATE INDEX IF NOT EXISTS idx_blog_comment_user ON blog_comment(user_id);

-- Enable Row Level Security
ALTER TABLE auth_user ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_post ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_comment ENABLE ROW LEVEL SECURITY;

-- RLS Policies - Allow all operations for authenticated users
-- Django will handle authorization at the application level
CREATE POLICY "Allow all for authenticated users"
  ON auth_user FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users"
  ON blog_post FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users"
  ON blog_profile FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users"
  ON blog_comment FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);
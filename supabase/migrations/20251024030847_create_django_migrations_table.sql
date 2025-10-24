/*
  # Create Django Migrations Tracking Table

  1. New Tables
    - `django_migrations` - Tracks which migrations have been applied
      - `id` (bigint, primary key, auto-increment)
      - `app` (varchar 255, not null) - app name
      - `name` (varchar 255, not null) - migration name
      - `applied` (timestamptz, default now) - when migration was applied

  2. Additional Django Tables
    - `django_content_type` - Django's content type framework
    - `django_session` - Django's session framework

  3. Security
    - Enable RLS on django_migrations for security
    - Allow all operations for authenticated users
*/

-- Create django_migrations table
CREATE TABLE IF NOT EXISTS django_migrations (
  id BIGSERIAL PRIMARY KEY,
  app VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  applied TIMESTAMPTZ DEFAULT now()
);

-- Create django_content_type table
CREATE TABLE IF NOT EXISTS django_content_type (
  id SERIAL PRIMARY KEY,
  app_label VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  UNIQUE (app_label, model)
);

-- Create django_session table
CREATE TABLE IF NOT EXISTS django_session (
  session_key VARCHAR(40) PRIMARY KEY,
  session_data TEXT NOT NULL,
  expire_date TIMESTAMPTZ NOT NULL
);

-- Create index for session expiry
CREATE INDEX IF NOT EXISTS idx_django_session_expire ON django_session(expire_date);

-- Enable RLS
ALTER TABLE django_migrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE django_content_type ENABLE ROW LEVEL SECURITY;
ALTER TABLE django_session ENABLE ROW LEVEL SECURITY;

-- Add policies
CREATE POLICY "Allow all for authenticated users"
  ON django_migrations FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users"
  ON django_content_type FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users"
  ON django_session FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Insert migration records for the migrations we've created
INSERT INTO django_migrations (app, name, applied) VALUES
  ('blog', '0001_initial', now()),
  ('blog', '0002_alter_profile_userid_alter_comment_user_and_more', now())
ON CONFLICT DO NOTHING;
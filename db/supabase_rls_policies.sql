-- RLS Policies for keep_alive table
-- Run this SQL in Supabase Dashboard > SQL Editor
-- This allows anonymous users (anon key) to INSERT, DELETE, and SELECT from keep_alive table

-- Enable RLS on keep_alive table (if not already enabled)
ALTER TABLE keep_alive ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anonymous users to INSERT
CREATE POLICY "Allow anonymous inserts on keep_alive"
ON keep_alive
FOR INSERT
TO anon
WITH CHECK (true);

-- Create policy to allow anonymous users to DELETE
CREATE POLICY "Allow anonymous deletes on keep_alive"
ON keep_alive
FOR DELETE
TO anon
USING (true);

-- Create policy to allow anonymous users to SELECT (needed for DELETE with ordering)
CREATE POLICY "Allow anonymous selects on keep_alive"
ON keep_alive
FOR SELECT
TO anon
USING (true);

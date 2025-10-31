-- Fix RLS policies for security (corrected)

-- 1. Fix profiles table - only allow users to see their own profile
DROP POLICY IF EXISTS "Users can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can view profiles" ON profiles;
CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- The update and insert policies already exist, so we skip them

-- 2. Fix conversation_history table - restrict to user's own conversations
DROP POLICY IF EXISTS "Allow all access to conversation_history" ON conversation_history;
DROP POLICY IF EXISTS "Allow all operations on conversation_history" ON conversation_history;

CREATE POLICY "Users can view their own conversations"
  ON conversation_history FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert their own conversations"
  ON conversation_history FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update their own conversations"
  ON conversation_history FOR UPDATE
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can delete their own conversations"
  ON conversation_history FOR DELETE
  USING (auth.uid()::text = user_id);

-- 3. Fix file_versions table - restrict to user's own files via conversation ownership
DROP POLICY IF EXISTS "Allow all access to file_versions" ON file_versions;
DROP POLICY IF EXISTS "Allow all operations on file_versions" ON file_versions;

CREATE POLICY "Users can view their own file versions"
  ON file_versions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM conversation_history 
      WHERE conversation_history.id = file_versions.conversation_id 
      AND conversation_history.user_id = auth.uid()::text
    )
  );

CREATE POLICY "Users can insert their own file versions"
  ON file_versions FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM conversation_history 
      WHERE conversation_history.id = file_versions.conversation_id 
      AND conversation_history.user_id = auth.uid()::text
    )
  );

CREATE POLICY "Users can update their own file versions"
  ON file_versions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM conversation_history 
      WHERE conversation_history.id = file_versions.conversation_id 
      AND conversation_history.user_id = auth.uid()::text
    )
  );

CREATE POLICY "Users can delete their own file versions"
  ON file_versions FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM conversation_history 
      WHERE conversation_history.id = file_versions.conversation_id 
      AND conversation_history.user_id = auth.uid()::text
    )
  );
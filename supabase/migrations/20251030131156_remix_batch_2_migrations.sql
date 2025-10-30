
-- Migration: 20251030121842

-- Migration: 20251030114314
-- Create table for conversation history
CREATE TABLE public.conversation_history (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  project_name TEXT NOT NULL,
  messages JSONB NOT NULL DEFAULT '[]'::jsonb,
  files JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create table for file versions
CREATE TABLE public.file_versions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID NOT NULL REFERENCES public.conversation_history(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_content TEXT NOT NULL,
  version_number INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.conversation_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_versions ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (no authentication required for this app)
CREATE POLICY "Allow all access to conversation_history" 
ON public.conversation_history 
FOR ALL 
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow all access to file_versions" 
ON public.file_versions 
FOR ALL 
USING (true)
WITH CHECK (true);

-- Create indexes for better performance
CREATE INDEX idx_conversation_user_project ON public.conversation_history(user_id, project_name);
CREATE INDEX idx_file_versions_conversation ON public.file_versions(conversation_id);
CREATE INDEX idx_file_versions_file_name ON public.file_versions(file_name);

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for conversation_history
CREATE TRIGGER update_conversation_history_updated_at
BEFORE UPDATE ON public.conversation_history
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Migration: 20251030114333
-- Fix function search path with CASCADE
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Recreate trigger for conversation_history
CREATE TRIGGER update_conversation_history_updated_at
BEFORE UPDATE ON public.conversation_history
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();


-- Migration: 20251030122049
-- Create conversation_history table if not exists
CREATE TABLE IF NOT EXISTS public.conversation_history (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  project_name TEXT NOT NULL,
  messages JSONB NOT NULL DEFAULT '[]'::jsonb,
  files JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create file_versions table if not exists
CREATE TABLE IF NOT EXISTS public.file_versions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID NOT NULL REFERENCES public.conversation_history(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_content TEXT NOT NULL,
  version_number INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_conversation_history_user_id ON public.conversation_history(user_id);
CREATE INDEX IF NOT EXISTS idx_conversation_history_project ON public.conversation_history(project_name);
CREATE INDEX IF NOT EXISTS idx_file_versions_conversation ON public.file_versions(conversation_id);
CREATE INDEX IF NOT EXISTS idx_file_versions_filename ON public.file_versions(file_name);

-- Enable Row Level Security
ALTER TABLE public.conversation_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_versions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist and recreate them
DROP POLICY IF EXISTS "Allow all operations on conversation_history" ON public.conversation_history;
DROP POLICY IF EXISTS "Allow all operations on file_versions" ON public.file_versions;

CREATE POLICY "Allow all operations on conversation_history"
  ON public.conversation_history
  FOR ALL
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all operations on file_versions"
  ON public.file_versions
  FOR ALL
  USING (true)
  WITH CHECK (true);

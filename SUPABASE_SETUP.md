# Supabase Setup Instructions (FREE Firebase Alternative)

## Why Supabase?
- **Free Tier**: 500MB database, 1GB storage, 50,000 monthly active users
- **Open Source**: Can self-host if needed
- **PostgreSQL**: More powerful than NoSQL
- **Similar to Firebase**: Easy migration from Firebase concepts

## Step 1: Create Supabase Project

1. Go to [Supabase](https://supabase.com/)
2. Click "Start your project" → "New project"
3. Create organization if needed
4. Enter project details:
   - **Name**: `student-system`
   - **Database Password**: Create a strong password (save it!)
   - **Region**: Choose closest to your users
5. Click "Create new project"

## Step 2: Get Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy these values:
   - **Project URL**
   - **anon public** key

## Step 3: Update Flutter App

Update the credentials in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'https://your-project-id.supabase.co', // Your Project URL
  anonKey: 'your-anon-key-here', // Your anon public key
);
```

## Step 4: Create Database Tables

In Supabase dashboard, go to **SQL Editor** and run this script:

```sql
-- Enable Row Level Security
ALTER TABLE IF EXISTS public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.lesson_lines ENABLE ROW LEVEL SECURITY;

-- Groups table
CREATE TABLE IF NOT EXISTS public.groups (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Students table
CREATE TABLE IF NOT EXISTS public.students (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    group_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Lessons table
CREATE TABLE IF NOT EXISTS public.lessons (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    date TIMESTAMP WITH TIME ZONE,
    from_time TIMESTAMP WITH TIME ZONE,
    to_time TIMESTAMP WITH TIME ZONE,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    group_name VARCHAR(255),
    topic VARCHAR(500),
    notes TEXT,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Lesson Lines table
CREATE TABLE IF NOT EXISTS public.lesson_lines (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    lesson_id UUID REFERENCES public.lessons(id) ON DELETE CASCADE NOT NULL,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE NOT NULL,
    student_name VARCHAR(255),
    paid BOOLEAN DEFAULT false,
    attended BOOLEAN DEFAULT false,
    amount DECIMAL(10,2),
    notes TEXT,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Row Level Security Policies
-- Groups policies
CREATE POLICY "Users can only see their own groups" ON public.groups
    FOR ALL USING (auth.uid() = user_id);

-- Students policies  
CREATE POLICY "Users can only see their own students" ON public.students
    FOR ALL USING (auth.uid() = user_id);

-- Lessons policies
CREATE POLICY "Users can only see their own lessons" ON public.lessons
    FOR ALL USING (auth.uid() = user_id);

-- Lesson lines policies
CREATE POLICY "Users can only see their own lesson lines" ON public.lesson_lines
    FOR ALL USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_groups_user_id ON public.groups(user_id);
CREATE INDEX IF NOT EXISTS idx_students_user_id ON public.students(user_id);
CREATE INDEX IF NOT EXISTS idx_students_group_id ON public.students(group_id);
CREATE INDEX IF NOT EXISTS idx_lessons_user_id ON public.lessons(user_id);
CREATE INDEX IF NOT EXISTS idx_lessons_group_id ON public.lessons(group_id);
CREATE INDEX IF NOT EXISTS idx_lesson_lines_user_id ON public.lesson_lines(user_id);
CREATE INDEX IF NOT EXISTS idx_lesson_lines_lesson_id ON public.lesson_lines(lesson_id);
CREATE INDEX IF NOT EXISTS idx_lesson_lines_student_id ON public.lesson_lines(student_id);

-- Enable realtime (optional)
ALTER PUBLICATION supabase_realtime ADD TABLE public.groups;
ALTER PUBLICATION supabase_realtime ADD TABLE public.students;
ALTER PUBLICATION supabase_realtime ADD TABLE public.lessons;
ALTER PUBLICATION supabase_realtime ADD TABLE public.lesson_lines;
```

## Step 5: Configure Authentication

1. In Supabase dashboard, go to **Authentication** → **Settings**
2. Configure your settings:
   - **Site URL**: `http://localhost:3000` (for development)
   - **Redirect URLs**: Add your app's URL schemes
3. Enable **Email** provider (it's enabled by default)

## Step 6: Test Your Setup

1. Run your Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```

2. Try to register a new account
3. Check Supabase dashboard → **Authentication** → **Users** to see the new user
4. Try creating groups/students and check **Database** → **Table Editor**

## Step 7: Production Configuration

### Security Rules
The SQL script above already includes Row Level Security (RLS) policies that ensure users can only access their own data.

### Environment Variables
For production, use environment variables instead of hardcoding credentials:

```dart
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
);
```

## Troubleshooting

### Common Issues:

1. **Connection Error**: 
   - Check URL and anon key are correct
   - Ensure internet connection

2. **Authentication Error**:
   - Verify email confirmation is enabled/disabled as needed
   - Check redirect URLs configuration

3. **Database Access Error**:
   - Ensure RLS policies are created
   - Check user is authenticated before database operations

4. **Build Errors**:
   - Run `flutter clean` and `flutter pub get`
   - Ensure minimum SDK versions are met

## Free Tier Limitations

- **Database**: 500MB
- **Storage**: 1GB  
- **Bandwidth**: 5GB
- **Monthly Active Users**: 50,000
- **API Requests**: 500,000

These limits are very generous for a student management system!

## Benefits Over Firebase

✅ **Completely Free** for most use cases  
✅ **SQL Database** (more powerful than Firestore)  
✅ **Open Source** (can self-host)  
✅ **Real-time** subscriptions  
✅ **Better querying** capabilities  
✅ **No vendor lock-in**  

## Need Help?

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Integration Guide](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- [Supabase Discord Community](https://discord.supabase.com/)

## Alternative: Local Development

For completely free development, you can run Supabase locally:

```bash
npx supabase init
npx supabase start
```

This gives you a local Supabase instance with no internet dependency!
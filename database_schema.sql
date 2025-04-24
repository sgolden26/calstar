-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    berkeley_student_id VARCHAR(50) UNIQUE,
    major VARCHAR(100),
    graduation_year INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Departments Table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    description TEXT
);

-- Professors Table
CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    department_id INTEGER REFERENCES departments(id),
    email VARCHAR(255),
    bio TEXT,
    website_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(id),
    code VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    units INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(department_id, code)
);

-- Course Offerings Table (for specific semester offerings)
CREATE TABLE course_offerings (
    id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(id),
    professor_id INTEGER REFERENCES professors(id),
    semester VARCHAR(20) NOT NULL, -- e.g., "Fall 2023"
    year INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(course_id, professor_id, semester, year)
);

-- Course Reviews Table
CREATE TABLE course_reviews (
    id SERIAL PRIMARY KEY,
    course_offering_id INTEGER REFERENCES course_offerings(id),
    user_id INTEGER REFERENCES users(id),
    overall_rating INTEGER NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    difficulty_rating INTEGER NOT NULL CHECK (difficulty_rating BETWEEN 1 AND 5),
    workload_rating INTEGER NOT NULL CHECK (workload_rating BETWEEN 1 AND 5),
    content_review TEXT,
    anonymous BOOLEAN DEFAULT FALSE,
    approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(course_offering_id, user_id)
);

-- Professor Reviews Table
CREATE TABLE professor_reviews (
    id SERIAL PRIMARY KEY,
    professor_id INTEGER REFERENCES professors(id),
    user_id INTEGER REFERENCES users(id),
    overall_rating INTEGER NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    clarity_rating INTEGER NOT NULL CHECK (clarity_rating BETWEEN 1 AND 5),
    helpfulness_rating INTEGER NOT NULL CHECK (helpfulness_rating BETWEEN 1 AND 5),
    content_review TEXT,
    anonymous BOOLEAN DEFAULT FALSE,
    approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(professor_id, user_id)
);

-- Resources Table (syllabi, textbooks, study guides, etc.)
CREATE TABLE resources (
    id SERIAL PRIMARY KEY,
    course_offering_id INTEGER REFERENCES course_offerings(id),
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    resource_type VARCHAR(50) NOT NULL, -- 'syllabus', 'textbook', 'study_guide', etc.
    file_path VARCHAR(255), -- Path/reference to where the file is stored (e.g., Box URL)
    file_size INTEGER,
    file_type VARCHAR(50),
    approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tags Table
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Course Tags Junction Table
CREATE TABLE course_tags (
    course_id INTEGER REFERENCES courses(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (course_id, tag_id)
);

-- User Roles Table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- User Roles Junction Table
CREATE TABLE user_roles (
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

-- Reported Content Table
CREATE TABLE reported_content (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(50) NOT NULL, -- 'course_review', 'professor_review', 'resource'
    content_id INTEGER NOT NULL,
    reported_by INTEGER REFERENCES users(id),
    reason TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'resolved', 'dismissed'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- Add indexes for frequently queried columns
CREATE INDEX idx_course_reviews_course_offering_id ON course_reviews(course_offering_id);
CREATE INDEX idx_professor_reviews_professor_id ON professor_reviews(professor_id);
CREATE INDEX idx_resources_course_offering_id ON resources(course_offering_id);
CREATE INDEX idx_course_offerings_course_id ON course_offerings(course_id);
CREATE INDEX idx_course_offerings_professor_id ON course_offerings(professor_id);
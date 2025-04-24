from django.db import models
from django.utils import timezone

class Department(models.Model):
    """Academic departments at UC Berkeley"""
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=10, unique=True)
    description = models.TextField(blank=True)
    
    def __str__(self):
        return f"{self.code} - {self.name}"
    
    class Meta:
        ordering = ['code']

class Professor(models.Model):
    """Professors teaching courses at UC Berkeley"""
    full_name = models.CharField(max_length=255)
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, related_name='professors')
    email = models.EmailField(blank=True)
    bio = models.TextField(blank=True)
    website_url = models.URLField(blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    
    def __str__(self):
        return self.full_name
    
    def average_rating(self):
        """Calculate the average rating for this professor"""
        reviews = self.reviews.all()
        if not reviews:
            return 0
        return sum(review.overall_rating for review in reviews) / len(reviews)
    
    class Meta:
        ordering = ['full_name']

class Course(models.Model):
    """Courses offered at UC Berkeley"""
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='courses')
    code = models.CharField(max_length=20)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    units = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    
    class Meta:
        unique_together = ('department', 'code')
        ordering = ['department__code', 'code']
    
    def __str__(self):
        return f"{self.department.code} {self.code}: {self.title}"
    
    def average_rating(self):
        """Calculate the average rating for this course across all offerings"""
        reviews = [review for offering in self.offerings.all() for review in offering.reviews.all()]
        if not reviews:
            return 0
        return sum(review.overall_rating for review in reviews) / len(reviews)

class CourseOffering(models.Model):
    """Specific instances of courses taught in a particular semester"""
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='offerings')
    professor = models.ForeignKey(Professor, on_delete=models.CASCADE, related_name='course_offerings')
    semester = models.CharField(max_length=20)  # e.g., "Fall", "Spring", "Summer"
    year = models.IntegerField()
    created_at = models.DateTimeField(default=timezone.now)
    
    class Meta:
        unique_together = ('course', 'professor', 'semester', 'year')
        ordering = ['-year', 'semester']
    
    def __str__(self):
        return f"{self.course.department.code} {self.course.code} - {self.semester} {self.year} - Prof. {self.professor.full_name}"

class Tag(models.Model):
    """Tags for categorizing courses"""
    name = models.CharField(max_length=50, unique=True)
    
    def __str__(self):
        return self.name

class CourseTag(models.Model):
    """Junction table for course tags"""
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='tags')
    tag = models.ForeignKey(Tag, on_delete=models.CASCADE, related_name='courses')
    
    class Meta:
        unique_together = ('course', 'tag')
        
    def __str__(self):
        return f"{self.course} - {self.tag.name}"
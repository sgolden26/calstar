from django.db import models
from django.utils import timezone
from users.models import User
from courses.models import CourseOffering

class Resource(models.Model):
    """Educational resources like syllabi, textbooks, study guides, etc."""
    RESOURCE_TYPES = (
        ('syllabus', 'Syllabus'),
        ('textbook', 'Textbook'),
        ('study_guides', 'Study Guides'),
        ('lecture_notes', 'Lecture Notes'),
        ('past_exams', 'Past Exams'),
        ('other', 'Other'),
    )
    
    course_offering = models.ForeignKey(CourseOffering, on_delete=models.CASCADE, related_name='resources')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='uploaded_resources')
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    resource_type = models.CharField(max_length=50, choices=RESOURCE_TYPES)
    file_path = models.CharField(max_length=255)  # Path/reference to where the file is stored
    file_size = models.IntegerField(null=True, blank=True)  # Size in bytes
    file_type = models.CharField(max_length=50, blank=True)  # MIME type or file extension
    approved = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.title} ({self.get_resource_type_display()}) for {self.course_offering}"
    
    class Meta:
        ordering = ['-created_at']

# Custom storage for Berkeley Box will go in storage.py
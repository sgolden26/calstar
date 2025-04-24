from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone

class User(AbstractUser):
    """Custom user model for UC Berkeley students"""
    berkeley_student_id = models.CharField(max_length=50, unique=True, null=True, blank=True)
    major = models.CharField(max_length=100, blank=True)
    graduation_year = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.email

class Role(models.Model):
    """User roles for permission management"""
    name = models.CharField(max_length=50, unique=True)
    
    def __str__(self):
        return self.name

class UserRole(models.Model):
    """Junction table for user roles"""
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    role = models.ForeignKey(Role, on_delete=models.CASCADE)
    
    class Meta:
        unique_together = ('user', 'role')
        
    def __str__(self):
        return f"{self.user.username} - {self.role.name}"
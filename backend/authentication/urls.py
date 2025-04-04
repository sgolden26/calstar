from django.urls import path
from . import views

urlpatterns = [
    # Auth endpoints will go here
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
]
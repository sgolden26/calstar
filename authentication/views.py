from django.shortcuts import render, redirect
from django.contrib.auth import login, logout

def login_view(request):
    # Basic placeholder for now
    return render(request, 'authentication/login.html')

def logout_view(request):
    logout(request)
    return redirect('login')
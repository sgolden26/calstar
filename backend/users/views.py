from django.http import HttpResponse
from django.shortcuts import render

# basic test page 
def home(request):
    return HttpResponse("<h1>Welcome to CalStar!</h1>")
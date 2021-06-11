from django.shortcuts import render

def home(request):
    context = {}
    return render(request, 'task/home.html', context)

def create(request):
    context = {}
    return render(request, 'task/create.html', context)

def vote(request, task_id):
    context = {}
    return render(request, 'task/vote.html', context)

def results(request, task_id):
    context = {}
    return render(request, 'task/results.html', context)

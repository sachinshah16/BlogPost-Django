from django.shortcuts import render, redirect
from .models import Post
from django.contrib.auth import authenticate, get_user_model
from django.contrib.auth import login as auth_login, logout as auth_logout
from django.contrib.auth.decorators import login_required 

User = get_user_model()

# Create your views here.
def home(request):
    
    posts = []
    
    if request.user.is_authenticated:
        posts = Post.objects.all().order_by('-created_at')
        # print(posts)
        
        return render(request, "blog/index.html", context = {'pageName' : 'Home | BlogPost','posts':posts})
    return render(request, "blog/index.html", context = {'pageName' : 'Home | BlogPost'})

def about(request):
    return render(request, 'blog/about.html', context = {'pageName' : 'About | BlogPost'})

def contact(request):
    return render(request, 'blog/contact.html', context = {'pageName' : 'Contact | BlogPost'})

def login_view(request):
    # You can add logic here to handle login form submission
    
    message = ""
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        # Add authentication logic here if needed
        # For now, just pass the username to the template (for demonstration)
        user = authenticate(request, username=username, password=password)
        if user is not None:  # Example check
            auth_login(request,user)
            return redirect('/')  # Redirect to profile page after login
        else:
            message = "Invalid credentials"
            
    return render(request, 'blog/login.html', context={'pageName': 'Login | BlogPost', 'error_message': message})

def signup(request):
    if request.method == "POST":
        firstname = request.POST.get('firstname')
        lastname = request.POST.get('lastname')
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')
        
        # Here, you would typically save the user data to the database
        # For demonstration, we'll just redirect to the profile page with the username
        
        if firstname and username and email and password:
            if User.objects.filter(username=username).exists():
                error_message = "Username already exists. Please choose a different one."
                return render(request, 'blog/signup.html', context={'pageName': 'Signup | BlogPost', 'error_message': error_message})
            user = User.objects.create_user(username=username, password=password, email=email, first_name=firstname, last_name=lastname)
            user = authenticate(request, username=username, password=password)
            if user is not None:
                auth_login(request, user)
                return redirect('profile') # Redirect to profile page after signup
        else:
            error_message = "Please fill in all required fields."
            return render(request, 'blog/signup.html', context={'pageName': 'Signup | BlogPost', 'error_message': error_message})
    return render(request, 'blog/signup.html', context = {'pageName' : 'Signup | BlogPost'})

@login_required(login_url='login')
def profile(request):
    
    if not request.user.is_authenticated:
        return redirect('login')
    
    return render(request, 'blog/profile.html', context = {'pageName' : 'Profile | BlogPost'})

@login_required(login_url='login')
def editProfile(request):
    return render(request, 'blog/edit_profile.html', context={'pageName':'Edit-Profile | BlogPost'})

@login_required(login_url='login')
def logout_view(request):
    auth_logout(request)
    return redirect('/')

@login_required(login_url='login')
def post(request):
    if request.method == 'POST':
        post_title = request.POST.get('title')
        post_content = request.POST.get("content")
        
        
        if not post_title or not post_content:
            error_message = "Title and content are required fields."
            return render(request, 'blog/post.html', {
                'error_message': error_message,
                # Pass back the data so user doesn't lose input
                'title': post_title,
                'content': post_content 
            })
        else:
            new_post = Post.objects.create(
                title = post_title,
                content = post_content,
                user = request.user
            )
            return redirect('/')
            
        
        
    return render(request, 'blog/post.html')
            

def show_post(request):
    pass           
        
    
    
    
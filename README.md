
### Profile 앱
* models.py
```
class Profile(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE,related_name='profile')
    # on_delete=models.CASCADE  User가 삭제시 같이 삭제
    # related_name='profile'
    image = models.ImageField(upload_to='profile/',null=True)
    nickname = models.CharField(max_length=20,unique=True,null=True)
    message = models.CharField(max_length=100,null=True)
```



* forms.py
```
from django.forms import ModelForm

from profileapp.models import Profile


class ProfileCreationForm(ModelForm):
    class Meta:
        model = Profile
        fields = ['image','nickname','message']
# ModelForm 클래스를 상속받아 Profile 모델을 사용하고 이 클래스에서는 Profile 모델의 image,nickname,message 필드를 사용하겠다


```


* 이미지 출력

```
settings.py 추가

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR,'media')

urls.py 추가
urlpatterns에 + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

```

* decorator
```
profileapp/decorators.py 
    from django.http import HttpResponseForbidden

    from profileapp.models import Profile
    
    
    def profile_ownership_required(func):
        def decorated(request,*args,**kwargs):
            profile = Profile.objects.get(pk=kwargs['pk'])
            if not profile.user == request.user:
                return HttpResponseForbidden()
            return func(request,*args,**kwargs)
        return decorated
```

```
# decorator 사용법 

@method_decorator(profile_ownership_required,'get')
@method_decorator(profile_ownership_required,'post')
class ProfileUpdateView(UpdateView):
    model = Profile
    context_object_name = 'target_profile'
    form_class = ProfileCreationForm
    template_name = 'profileapp/update.html'

    def get_success_url(self):
        return reverse('accountapp:detail', kwargs={'pk':self.object.user.pk})
```
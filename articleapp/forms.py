from django.forms import ModelForm
from django import forms
from articleapp.models import Article
from projectapp.models import Project


class ArticleCreationForm(ModelForm):
    content = forms.CharField(widget=forms.Textarea(attrs={'class': 'editable',
                                                           'style': 'height: auto;text-align: left;'}))
    project = forms.ModelChoiceField(queryset=Project.objects.all(),required=False) # 프로젝트 필수선택 x로 하는 것

    class Meta:
        model = Article
        fields = ['title','image','project','content']
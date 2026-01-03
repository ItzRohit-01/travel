from django.contrib import admin
from .models import Trip, PopularCity


@admin.register(Trip)
class TripAdmin(admin.ModelAdmin):
	list_display = ("title", "destination", "user_id", "start_date", "end_date", "status")
	search_fields = ("title", "destination", "user_id")
	list_filter = ("status", "start_date")


@admin.register(PopularCity)
class PopularCityAdmin(admin.ModelAdmin):
	list_display = ("name", "country", "rating", "reviews")
	search_fields = ("name", "country")

import datetime
from django.core.management.base import BaseCommand
from django.utils import timezone

from trips.models import Trip, PopularCity


class Command(BaseCommand):
    help = "Seed five demo trips and five popular cities"

    def handle(self, *args, **options):
        user_id = "demo-user"

        trips_payload = [
            {
                "user_id": user_id,
                "title": "Paris Adventure",
                "destination": "Paris, France",
                "start_date": timezone.now().date() - datetime.timedelta(days=30),
                "end_date": timezone.now().date() - datetime.timedelta(days=23),
                "image_url": "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
                "status": "Completed",
            },
            {
                "user_id": user_id,
                "title": "Tokyo Exploration",
                "destination": "Tokyo, Japan",
                "start_date": timezone.now().date() - datetime.timedelta(days=60),
                "end_date": timezone.now().date() - datetime.timedelta(days=52),
                "image_url": "https://images.unsplash.com/photo-1505066829862-1c9c3c1c60cf",
                "status": "Completed",
            },
            {
                "user_id": user_id,
                "title": "Barcelona Beach",
                "destination": "Barcelona, Spain",
                "start_date": timezone.now().date() - datetime.timedelta(days=15),
                "end_date": timezone.now().date() - datetime.timedelta(days=8),
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "status": "Completed",
            },
            {
                "user_id": user_id,
                "title": "Rome Classics",
                "destination": "Rome, Italy",
                "start_date": timezone.now().date() + datetime.timedelta(days=10),
                "end_date": timezone.now().date() + datetime.timedelta(days=16),
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "status": "Planned",
            },
            {
                "user_id": user_id,
                "title": "Dubai Skyline",
                "destination": "Dubai, UAE",
                "start_date": timezone.now().date() + datetime.timedelta(days=25),
                "end_date": timezone.now().date() + datetime.timedelta(days=32),
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "status": "Planned",
            },
        ]

        cities_payload = [
            {
                "name": "Paris",
                "country": "France",
                "image_url": "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
                "rating": 4.8,
                "reviews": 2548,
            },
            {
                "name": "Tokyo",
                "country": "Japan",
                "image_url": "https://images.unsplash.com/photo-1505066829862-1c9c3c1c60cf",
                "rating": 4.7,
                "reviews": 1893,
            },
            {
                "name": "Barcelona",
                "country": "Spain",
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "rating": 4.6,
                "reviews": 1642,
            },
            {
                "name": "Rome",
                "country": "Italy",
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "rating": 4.9,
                "reviews": 3124,
            },
            {
                "name": "Dubai",
                "country": "UAE",
                "image_url": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
                "rating": 4.5,
                "reviews": 2800,
            },
        ]

        for payload in trips_payload:
            Trip.objects.update_or_create(
                user_id=payload["user_id"],
                title=payload["title"],
                defaults={
                    "destination": payload["destination"],
                    "start_date": payload["start_date"],
                    "end_date": payload["end_date"],
                    "image_url": payload.get("image_url", ""),
                    "status": payload["status"],
                },
            )

        for payload in cities_payload:
            PopularCity.objects.update_or_create(
                name=payload["name"],
                country=payload["country"],
                defaults={
                    "image_url": payload.get("image_url", ""),
                    "rating": payload["rating"],
                    "reviews": payload["reviews"],
                },
            )

        self.stdout.write(self.style.SUCCESS("Seeded 5 trips and 5 popular cities."))

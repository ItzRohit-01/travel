from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import TripViewSet, PopularCityViewSet

router = DefaultRouter()
router.register(r"trips", TripViewSet)
router.register(r"popular-cities", PopularCityViewSet, basename="popularcity")

urlpatterns = [
    path("", include(router.urls)),
]

from django.shortcuts import render
from rest_framework import viewsets
from .models import Trip, PopularCity
from .serializers import TripSerializer, PopularCitySerializer

class TripViewSet(viewsets.ModelViewSet):
    serializer_class = TripSerializer
    queryset = Trip.objects.all()
    def get_queryset(self):
        user_id = self.request.query_params.get("userId")
        qs = super().get_queryset()
        return qs.filter(user_id=user_id) if user_id else qs

class PopularCityViewSet(viewsets.ModelViewSet):
    serializer_class = PopularCitySerializer
    queryset = PopularCity.objects.all()
from rest_framework import serializers
from .models import Trip, PopularCity

class TripSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trip
        fields = "__all__"

class PopularCitySerializer(serializers.ModelSerializer):
    class Meta:
        model = PopularCity
        fields = "__all__"
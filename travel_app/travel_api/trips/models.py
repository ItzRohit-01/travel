import uuid
from django.db import models


class Trip(models.Model):
	id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
	user_id = models.CharField(max_length=128, db_index=True)
	title = models.CharField(max_length=255)
	destination = models.CharField(max_length=255)
	start_date = models.DateField()
	end_date = models.DateField()
	image_url = models.URLField(blank=True)
	status = models.CharField(max_length=64, default="Planned")
	created_at = models.DateTimeField(auto_now_add=True)
	updated_at = models.DateTimeField(auto_now=True)

	class Meta:
		ordering = ["-start_date"]

	def __str__(self) -> str:
		return f"{self.title} ({self.destination})"


class PopularCity(models.Model):
	name = models.CharField(max_length=128)
	country = models.CharField(max_length=128)
	image_url = models.URLField(blank=True)
	rating = models.DecimalField(max_digits=3, decimal_places=1, default=0)
	reviews = models.PositiveIntegerField(default=0)
	created_at = models.DateTimeField(auto_now_add=True)
	updated_at = models.DateTimeField(auto_now=True)

	class Meta:
		ordering = ["-rating", "name"]

	def __str__(self) -> str:
		return f"{self.name}, {self.country}"

# Deployment Guide

## Table of Contents
1. [Pre-deployment Checklist](#pre-deployment-checklist)
2. [Environment Configuration](#environment-configuration)
3. [Flutter Mobile Deployment](#flutter-mobile-deployment)
4. [Django Backend Deployment](#django-backend-deployment)
5. [Database Setup](#database-setup)
6. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Pre-deployment Checklist

### Security
- [ ] All API keys moved to environment variables
- [ ] Firebase production project configured
- [ ] HTTPS/SSL certificates obtained
- [ ] CORS policies properly configured
- [ ] Rate limiting enabled
- [ ] Database credentials secured
- [ ] Django SECRET_KEY changed from default
- [ ] DEBUG mode disabled in production

### Testing
- [ ] All unit tests passing
- [ ] Integration tests completed
- [ ] Load testing performed
- [ ] Security audit completed
- [ ] API endpoints tested
- [ ] Mobile app tested on real devices

### Documentation
- [ ] API documentation updated
- [ ] README.md complete
- [ ] Environment variables documented
- [ ] Deployment runbook created

### Performance
- [ ] Database indexes optimized
- [ ] Images compressed and optimized
- [ ] API response caching implemented
- [ ] CDN configured for static assets

---

## Environment Configuration

### Development
```bash
# .env.development
DEBUG=True
DATABASE_URL=sqlite:///db.sqlite3
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:3000
API_BASE_URL=http://localhost:8000/api
```

### Staging
```bash
# .env.staging
DEBUG=False
DATABASE_URL=postgresql://user:pass@staging-db:5432/travel_db
ALLOWED_HOSTS=staging.globaltrotter.com
CORS_ALLOWED_ORIGINS=https://staging.globaltrotter.com
API_BASE_URL=https://api-staging.globaltrotter.com
```

### Production
```bash
# .env.production
DEBUG=False
SECRET_KEY=<generate-strong-secret-key>
DATABASE_URL=postgresql://user:pass@prod-db:5432/travel_db
ALLOWED_HOSTS=globaltrotter.com,www.globaltrotter.com
CORS_ALLOWED_ORIGINS=https://globaltrotter.com
API_BASE_URL=https://api.globaltrotter.com
REDIS_URL=redis://redis:6379/0
```

---

## Flutter Mobile Deployment

### Android Deployment

#### 1. Configure Signing

Create `android/key.properties`:
```properties
storePassword=<store-password>
keyPassword=<key-password>
keyAlias=globaltrotter
storeFile=<path-to-keystore>
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 2. Build Release APK

```bash
# Build APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# App Bundle location:
# build/app/outputs/bundle/release/app-release.aab
```

#### 3. Publish to Google Play Store

1. **Create Play Console Account**
   - Visit https://play.google.com/console
   - Pay $25 one-time registration fee

2. **Create New Application**
   - Upload app bundle (.aab file)
   - Fill out store listing
   - Add screenshots and description
   - Set content rating

3. **Configure Release**
   - Choose internal/closed/open testing
   - Or proceed directly to production
   - Review and publish

4. **Post-publication**
   - Monitor crash reports
   - Respond to user reviews
   - Track installation metrics

---

### iOS Deployment

#### 1. Configure Xcode Project

```bash
# Open iOS project
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select Runner project
# 2. Update Bundle Identifier (e.g., com.yourcompany.globaltrotter)
# 3. Select Team (requires Apple Developer account)
# 4. Configure Signing & Capabilities
```

#### 2. Build Release

```bash
# Build iOS app
flutter build ios --release

# Or build directly in Xcode
# Product > Archive
```

#### 3. Publish to App Store

1. **Apple Developer Account**
   - Enroll at https://developer.apple.com
   - Cost: $99/year

2. **App Store Connect**
   - Create new app
   - Fill out app information
   - Add screenshots (multiple device sizes)
   - Write app description

3. **Submit for Review**
   - Upload build via Xcode
   - Answer compliance questions
   - Submit for review (1-3 days)

4. **Post-approval**
   - Choose manual or automatic release
   - Monitor TestFlight feedback
   - Track analytics

---

## Django Backend Deployment

### Option 1: Heroku (Easiest)

#### 1. Install Heroku CLI
```bash
# Windows (Chocolatey)
choco install heroku-cli

# macOS
brew tap heroku/brew && brew install heroku

# Linux
curl https://cli-assets.heroku.com/install.sh | sh
```

#### 2. Prepare Application

Create `Procfile`:
```
web: gunicorn travel_api.wsgi --log-file -
release: python manage.py migrate
```

Create `runtime.txt`:
```
python-3.11.0
```

Update `requirements.txt`:
```bash
pip install gunicorn whitenoise dj-database-url
pip freeze > requirements.txt
```

Update `settings.py`:
```python
import dj_database_url

# Production settings
if not DEBUG:
    # Database
    DATABASES['default'] = dj_database_url.config(
        conn_max_age=600,
        ssl_require=True
    )
    
    # Static files
    MIDDLEWARE.insert(1, 'whitenoise.middleware.WhiteNoiseMiddleware')
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
    
    # Security
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SECURE_BROWSER_XSS_FILTER = True
    SECURE_CONTENT_TYPE_NOSNIFF = True
```

#### 3. Deploy to Heroku

```bash
# Login to Heroku
heroku login

# Create app
heroku create globaltrotter-api

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini

# Set environment variables
heroku config:set SECRET_KEY="your-secret-key"
heroku config:set DEBUG=False
heroku config:set ALLOWED_HOSTS="globaltrotter-api.herokuapp.com"

# Deploy
git push heroku main

# Run migrations
heroku run python manage.py migrate

# Create superuser
heroku run python manage.py createsuperuser

# Check logs
heroku logs --tail
```

---

### Option 2: DigitalOcean App Platform

#### 1. Prepare Application

Create `.do/app.yaml`:
```yaml
name: globaltrotter-api
services:
- name: api
  github:
    repo: your-username/travel-app
    branch: main
    deploy_on_push: true
  build_command: pip install -r requirements.txt
  run_command: gunicorn travel_api.wsgi
  environment_slug: python
  envs:
  - key: DEBUG
    value: "False"
  - key: SECRET_KEY
    scope: RUN_TIME
    type: SECRET
databases:
- name: travel-db
  engine: PG
  version: "14"
```

#### 2. Deploy via Web UI

1. Visit https://cloud.digitalocean.com
2. Create new App
3. Connect GitHub repository
4. Configure build settings
5. Add PostgreSQL database
6. Set environment variables
7. Deploy

---

### Option 3: AWS EC2 (Full Control)

#### 1. Launch EC2 Instance

```bash
# Connect to instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install Python and dependencies
sudo apt install python3-pip python3-venv nginx postgresql-client -y
```

#### 2. Set up Application

```bash
# Clone repository
git clone https://github.com/your-repo/travel-app.git
cd travel-app/travel_api

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt gunicorn

# Set environment variables
sudo nano /etc/environment
# Add: export SECRET_KEY="..."
```

#### 3. Configure Gunicorn

Create `/etc/systemd/system/gunicorn.service`:
```ini
[Unit]
Description=Gunicorn daemon for GlobalTrotter API
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/travel-app/travel_api
Environment="PATH=/home/ubuntu/travel-app/travel_api/venv/bin"
ExecStart=/home/ubuntu/travel-app/travel_api/venv/bin/gunicorn \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          travel_api.wsgi:application

[Install]
WantedBy=multi-user.target
```

Start service:
```bash
sudo systemctl start gunicorn
sudo systemctl enable gunicorn
```

#### 4. Configure Nginx

Create `/etc/nginx/sites-available/globaltrotter`:
```nginx
server {
    listen 80;
    server_name api.globaltrotter.com;

    location = /favicon.ico { access_log off; log_not_found off; }
    
    location /static/ {
        root /home/ubuntu/travel-app/travel_api;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/globaltrotter /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx
```

#### 5. Set up SSL with Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d api.globaltrotter.com
```

---

## Database Setup

### PostgreSQL Production Setup

#### 1. Create Production Database

```bash
# Connect to PostgreSQL
sudo -u postgres psql

# Create database and user
CREATE DATABASE travel_db_prod;
CREATE USER travel_user WITH PASSWORD 'secure_password';
ALTER ROLE travel_user SET client_encoding TO 'utf8';
ALTER ROLE travel_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE travel_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE travel_db_prod TO travel_user;
\q
```

#### 2. Configure Connection Pooling

Install PgBouncer:
```bash
sudo apt install pgbouncer -y
```

Configure `/etc/pgbouncer/pgbouncer.ini`:
```ini
[databases]
travel_db_prod = host=localhost port=5432 dbname=travel_db_prod

[pgbouncer]
listen_addr = 127.0.0.1
listen_port = 6432
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = transaction
max_client_conn = 100
default_pool_size = 20
```

#### 3. Database Backups

Create backup script `/usr/local/bin/backup-db.sh`:
```bash
#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/backups/postgresql"
BACKUP_FILE="$BACKUP_DIR/travel_db_$TIMESTAMP.sql.gz"

mkdir -p $BACKUP_DIR

pg_dump -U travel_user travel_db_prod | gzip > $BACKUP_FILE

# Keep only last 7 days
find $BACKUP_DIR -name "travel_db_*.sql.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_FILE"
```

Schedule with cron:
```bash
sudo crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-db.sh
```

---

## Monitoring & Maintenance

### Application Monitoring

#### 1. Sentry (Error Tracking)

```bash
pip install sentry-sdk
```

In `settings.py`:
```python
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration

sentry_sdk.init(
    dsn="your-sentry-dsn",
    integrations=[DjangoIntegration()],
    traces_sample_rate=0.1,
    send_default_pii=True
)
```

#### 2. Application Logs

Configure logging in `settings.py`:
```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/globaltrotter/django.log',
            'maxBytes': 1024*1024*15,  # 15MB
            'backupCount': 10,
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}
```

#### 3. Health Checks

Create health check endpoint in `views.py`:
```python
from django.http import JsonResponse
from django.db import connection

def health_check(request):
    try:
        # Check database
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        
        return JsonResponse({
            'status': 'healthy',
            'database': 'connected'
        })
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'error': str(e)
        }, status=500)
```

#### 4. Performance Monitoring

Install New Relic or similar:
```bash
pip install newrelic
newrelic-admin generate-config LICENSE-KEY newrelic.ini
```

Start with New Relic:
```bash
NEW_RELIC_CONFIG_FILE=newrelic.ini newrelic-admin run-program gunicorn travel_api.wsgi
```

---

### Database Maintenance

#### Regular Tasks

```bash
# Vacuum database (weekly)
sudo -u postgres psql travel_db_prod -c "VACUUM ANALYZE;"

# Check database size
sudo -u postgres psql travel_db_prod -c "SELECT pg_size_pretty(pg_database_size('travel_db_prod'));"

# Check table sizes
sudo -u postgres psql travel_db_prod -c "SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;"
```

---

### Security Updates

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Python packages
pip list --outdated
pip install --upgrade package-name

# Update Flutter
flutter upgrade

# Check for security vulnerabilities
# Python:
pip install safety
safety check

# Node/npm (if using):
npm audit
```

---

## Rollback Procedure

### Application Rollback

```bash
# Heroku
heroku releases
heroku rollback v123

# Manual deployment
git checkout previous-stable-tag
./deploy.sh

# Docker
docker pull globaltrotter-api:previous-tag
docker-compose up -d
```

### Database Rollback

```bash
# Restore from backup
gunzip < /backups/travel_db_20260102.sql.gz | psql -U travel_user travel_db_prod

# Django migration rollback
python manage.py migrate trips 0005_previous_migration
```

---

## Performance Optimization

### Django Performance

```python
# Enable query caching
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379/1',
    }
}

# Use select_related and prefetch_related
trips = Trip.objects.select_related('user').prefetch_related('activities')

# Database connection pooling
DATABASES['default']['CONN_MAX_AGE'] = 600
```

### Static Files CDN

Configure CloudFlare or AWS CloudFront:
```python
# settings.py
STATIC_URL = 'https://cdn.globaltrotter.com/static/'
MEDIA_URL = 'https://cdn.globaltrotter.com/media/'
```

---

## Troubleshooting

### Common Issues

**502 Bad Gateway**
```bash
# Check Gunicorn
sudo systemctl status gunicorn
sudo journalctl -u gunicorn

# Check Nginx
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

**Database Connection Issues**
```bash
# Check PostgreSQL
sudo systemctl status postgresql
sudo tail -f /var/log/postgresql/postgresql-14-main.log

# Test connection
psql -U travel_user -h localhost -d travel_db_prod
```

**High Memory Usage**
```bash
# Check processes
top
htop

# Restart services
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

---

## Related Documentation

- [Architecture Overview](ARCHITECTURE.md)
- [Development Guide](DEVELOPMENT.md)
- [API Documentation](API.md)
- [README](../README.md)

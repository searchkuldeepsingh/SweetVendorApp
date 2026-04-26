#!/bin/bash

# Setup Flutter PATH and run pub get
export PATH="$PATH:/Users/ektachirag/Documents/flutter/bin"

echo "=========================================="
echo "🔧 Flutter Setup"
echo "=========================================="
echo ""

# Check Flutter version
echo "1️⃣  Flutter Version:"
flutter --version
echo ""

# Navigate to project
cd /Users/ektachirag/Documents/development/SweetVendorApp
echo "2️⃣  Project Directory:"
pwd
echo ""

# Run pub get
echo "3️⃣  Getting Dependencies..."
flutter pub get
echo ""

echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Next step: flutter run"

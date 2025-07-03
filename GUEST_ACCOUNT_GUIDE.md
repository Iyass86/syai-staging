# Guest Account Feature Documentation

## Overview

The guest account feature allows users to explore the application without creating a full account. This provides a low-friction entry point while encouraging eventual account creation for full feature access.

## Features

### 🎯 Guest Login

- **One-click access**: Users can start using the app immediately
- **No personal data required**: No email, password, or personal information needed
- **Temporary session**: Guest sessions are device-specific and temporary
- **Clear indicators**: Guest status is clearly shown throughout the app

### 🔐 Authentication Flow

1. **Login Page**: Added "Continue as Guest" button below regular login options
2. **Guest Session**: Creates a mock user with limited permissions
3. **Status Tracking**: App tracks guest status throughout the session
4. **Upgrade Prompts**: Regular encouragement to create a full account

### 🚦 Access Control

- **Dashboard**: Full access for overview and basic features
- **Chat**: Restricted - requires registered account
- **Social Media Features**: Restricted - requires registered account
- **Advanced Analytics**: Restricted - requires registered account

## Implementation Details

### AuthController Updates

```dart
// New properties
final isGuestUser = false.obs;

// Guest login method
Future<void> loginAsGuest() async

// Guest user creation
User _createGuestUser()

// Guest status check
bool get isGuest

// Account upgrade
Future<void> upgradeGuestAccount(String email, String password, String name)
```

### Middleware Enhancements

- **Enhanced AuthGuard**: Added `allowGuests` parameter
- **Guest-aware routing**: Different protection levels for different features
- **MiddlewareManager**: New methods for guest-friendly and guest-restricted routes

### UI Components

1. **Login Page**: Guest login button with explanatory text
2. **GuestAccountUpgrade**: Promotional widget for dashboard
3. **GuestStatusIndicator**: App bar indicator showing guest status
4. **GuestBadge**: Simple badge for guest identification

## Route Protection Levels

### 🟢 Guest-Friendly Routes

- Dashboard (limited features)
- Basic app navigation
- Public content viewing

### 🟡 Registered-Only Routes

- Chat functionality
- Social media integrations
- Data export features
- Account settings

### 🔴 Premium Routes

- Advanced analytics
- Admin features
- Premium content

## User Experience

### Guest Benefits

- ✅ Immediate access to core features
- ✅ No barrier to entry
- ✅ Explore app functionality
- ✅ See value before committing

### Guest Limitations

- ❌ No data persistence across sessions
- ❌ Limited feature access
- ❌ No social media integrations
- ❌ No advanced analytics

### Upgrade Incentives

- 📊 Feature comparison displays
- 🎯 Strategic upgrade prompts
- 💎 Premium feature previews
- 🔄 Easy upgrade process

## Technical Implementation

### Guest User Structure

```dart
User _createGuestUser() {
  return User(
    id: 'guest_${timestamp}',
    email: 'guest@local.app',
    userMetadata: {
      'role': 'guest',
      'is_guest': true,
      'display_name': 'Guest User',
    },
    // ... other required fields
  );
}
```

### Middleware Configuration

```dart
// Allow guests
MiddlewareManager.guestFriendlyAuth(AppRoutes.dashboard)

// Registered users only
MiddlewareManager.registeredOnly(AppRoutes.chat)

// Premium features only
MiddlewareManager.premiumOnly(AppRoutes.analytics)
```

### Storage Handling

- Guest sessions use temporary storage
- No persistent data saved
- Session clears on app restart
- Upgrade transfers to permanent account

## Security Considerations

### Guest Session Security

- ✅ Limited access scope
- ✅ No sensitive data access
- ✅ Temporary session tokens
- ✅ Clear session boundaries

### Data Protection

- ✅ No personal data collection
- ✅ Session isolation
- ✅ Clean session termination
- ✅ Secure upgrade process

## Analytics & Metrics

### Track Guest Behavior

- Guest login frequency
- Feature exploration patterns
- Upgrade conversion rates
- Session duration and depth

### Conversion Funnel

1. **Guest Login**: Entry point tracking
2. **Feature Exploration**: Usage patterns
3. **Upgrade Prompts**: Response rates
4. **Account Creation**: Conversion success

## Future Enhancements

### Phase 2 Features

- 🔄 Guest data migration on upgrade
- 📱 Social login for guests
- 🎯 Personalized upgrade recommendations
- 📊 Advanced guest analytics

### Phase 3 Features

- 🌐 Cross-device guest sessions
- 🔐 Guest session recovery
- 🎮 Gamified upgrade incentives
- 🤖 AI-powered feature recommendations

## Configuration

### Environment Settings

```dart
// Enable/disable guest mode
static const bool GUEST_MODE_ENABLED = true;

// Guest session duration (hours)
static const int GUEST_SESSION_DURATION = 24;

// Maximum guest sessions per device
static const int MAX_GUEST_SESSIONS = 3;
```

### Feature Flags

- `enable_guest_login`: Toggle guest functionality
- `show_upgrade_prompts`: Control upgrade messaging
- `guest_feature_access`: Configure feature availability

## Testing

### Test Scenarios

1. **Guest Login Flow**: Verify seamless entry
2. **Feature Access**: Test permission boundaries
3. **Upgrade Process**: Validate account creation
4. **Session Management**: Test cleanup and limits

### Edge Cases

- Network connectivity issues
- Storage limitations
- Concurrent sessions
- App backgrounding/foregrounding

## Support & Troubleshooting

### Common Issues

1. **Guest session lost**: Expected behavior on app restart
2. **Feature access denied**: Check route protection settings
3. **Upgrade fails**: Validate form inputs and network

### Debug Tools

- Guest status logging
- Session state inspection
- Feature access tracking
- Conversion event monitoring

## Best Practices

### User Onboarding

- Clear guest vs. registered benefits
- Strategic upgrade timing
- Non-intrusive prompts
- Value-first messaging

### Technical Implementation

- Proper session management
- Secure guest isolation
- Clean upgrade paths
- Comprehensive error handling

---

**Last Updated**: June 28, 2025
**Version**: 1.0.0
**Author**: Development Team

# Enhanced Authentication System Documentation

## Overview

This document outlines the enhanced authentication system with comprehensive AuthGuard middleware for protecting routes in the Flutter application.

## Middleware Components

### 1. AuthGuard

**File**: `lib/app/middleware/auth_guard.dart`

Enhanced middleware that provides:

- **Basic Authentication Check**: Verifies user authentication status
- **Credential Validation**: Validates stored tokens and user data
- **Email Verification**: Optional requirement for email verification
- **Role-Based Access Control**: Supports role-based route protection
- **Error Handling**: Comprehensive error handling with user feedback
- **Debugging**: Detailed logging for troubleshooting

**Features**:

- `requiresVerification`: Enforces email verification before access
- `requiredRoles`: List of roles allowed to access the route
- Automatic session cleanup on invalid credentials
- User-friendly error messages

### 2. GuestGuard

**File**: `lib/app/middleware/guest_guard.dart`

Protects routes that should only be accessible to non-authenticated users:

- Redirects authenticated users away from login/register pages
- Prevents authenticated users from accessing guest-only content
- Customizable redirect destination

### 3. AdminGuard

**File**: `lib/app/middleware/admin_guard.dart`

Specialized middleware for admin-only routes:

- Higher priority than standard AuthGuard
- Role verification for admin access
- Support for multiple admin roles (admin, super_admin)
- Enhanced security checks

### 4. MiddlewareManager

**File**: `lib/app/middleware/middleware_manager.dart`

Centralized configuration manager providing predefined middleware setups:

- `standardAuth()`: Basic authentication
- `verifiedAuth()`: Authentication with email verification
- `roleBasedAuth()`: Authentication with specific roles
- `adminOnly()`: Admin-only access
- `superAdminOnly()`: Super admin only access
- `guestOnly()`: Guest-only access
- `premiumAuth()`: Premium user access
- `socialMediaAuth()`: Social media features access

## Route Protection Matrix

| Route                 | Protection Level  | Verification Required | Roles             |
| --------------------- | ----------------- | --------------------- | ----------------- |
| `/`                   | None              | -                     | -                 |
| `/login`              | Guest Only        | -                     | -                 |
| `/register`           | Guest Only        | -                     | -                 |
| `/dashboard`          | Standard Auth     | No                    | Any authenticated |
| `/chat`               | Verified Auth     | Yes                   | Any verified      |
| `/snap_auth`          | Social Media Auth | Yes                   | Any verified      |
| `/social_media_page`  | Social Media Auth | Yes                   | Any verified      |
| `/snap-accounts`      | Social Media Auth | Yes                   | Any verified      |
| `/snap-organizations` | Verified Auth     | Yes                   | Any verified      |
| `/auth/callback`      | None              | -                     | -                 |
| `/404`                | None              | -                     | -                 |

## Security Features

### 1. Multi-Level Validation

- Controller registration check
- Authentication status verification
- Token and user data validation
- Session integrity verification

### 2. Session Management

- Automatic cleanup of invalid sessions
- Secure token storage validation
- User data consistency checks

### 3. User Feedback

- Informative error messages
- Snackbar notifications for access denials
- Reason tracking for redirects

### 4. Debugging Support

- Comprehensive logging
- Error tracking with context
- Route access monitoring

## Usage Examples

### Basic Route Protection

```dart
GetPage(
  name: AppRoutes.dashboard,
  page: () => const DashboardPage(),
  middlewares: [
    MiddlewareManager.standardAuth(AppRoutes.dashboard),
  ],
),
```

### Email Verification Required

```dart
GetPage(
  name: AppRoutes.chat,
  page: () => const ChatPage(),
  middlewares: [
    MiddlewareManager.verifiedAuth(AppRoutes.chat),
  ],
),
```

### Role-Based Access

```dart
GetPage(
  name: AppRoutes.adminPanel,
  page: () => const AdminPanel(),
  middlewares: [
    MiddlewareManager.adminOnly(AppRoutes.adminPanel),
  ],
),
```

### Guest-Only Access

```dart
GetPage(
  name: AppRoutes.login,
  page: () => const LoginPage(),
  middlewares: [
    MiddlewareManager.guestOnly(AppRoutes.login),
  ],
),
```

## Configuration Options

### AuthGuard Parameters

- `routeKey`: Identifier for the protected route
- `requiresVerification`: Boolean to enforce email verification
- `requiredRoles`: List of allowed user roles

### Redirect Arguments

All middleware provide redirect arguments including:

- `from`: Original route user was trying to access
- `key`: Route key for tracking
- `reason`: Specific reason for redirect

## Future Enhancements

1. **Permission-Based Access**: Granular permission system
2. **Time-Based Access**: Route access based on time/date
3. **Device-Based Protection**: Device fingerprinting
4. **Rate Limiting**: Request rate limiting per user
5. **Audit Logging**: Comprehensive access logging
6. **Multi-Factor Authentication**: 2FA integration

## Troubleshooting

### Common Issues

1. **Controller Not Found**: Ensure AuthController is properly registered
2. **Infinite Redirects**: Check middleware priorities and conditions
3. **Missing User Data**: Verify storage service functionality
4. **Role Access Issues**: Confirm user role metadata setup

### Debug Information

Enable debug logging to see:

- Route access attempts
- Authentication checks
- Redirect reasons
- Error contexts

## Best Practices

1. **Consistent Route Keys**: Always use AppRoutes constants
2. **Appropriate Protection Levels**: Match security requirements
3. **User Experience**: Provide clear feedback for access denials
4. **Error Handling**: Graceful degradation on auth errors
5. **Testing**: Comprehensive testing of all auth scenarios

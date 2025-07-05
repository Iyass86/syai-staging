# Snapchat OAuth Callback Implementation

## Overview

This implementation provides a robust OAuth callback system for Snapchat authentication in your Flutter web application.

## Components

### 1. SnapOAuthCallbackPage (`/lib/app/ui/pages/snap_oauth_callback_page.dart`)

- **Purpose**: Flutter page that handles OAuth callback processing
- **Route**: `/auth/snap/callback`
- **Features**:
  - Modern UI with loading states
  - Error handling with retry functionality
  - Automatic token generation
  - Seamless navigation to organizations page

### 2. Callback HTML (`/web/snap_callback.html`)

- **Purpose**: Static HTML page for initial OAuth callback
- **URL**: `https://syai.io/snap_callback.html`
- **Features**:
  - Handles OAuth errors and success states
  - Attractive UI with loading animations
  - Redirects to Flutter app callback page
  - Works independently of Flutter app state

### 3. Enhanced Controller Methods

- **`handleOAuthCallback()`**: Processes OAuth callback URLs
- **`extractAuthorizationCodeFromUrl()`**: Extracts authorization code
- **`extractStateFromUrl()`**: Extracts state parameter for CSRF protection
- **`extractErrorFromUrl()`**: Extracts error information

## OAuth Flow

1. **User Initiates OAuth**: User clicks "Connect Snapchat" button
2. **Redirect to Snapchat**: User is redirected to Snapchat authorization page
3. **Snapchat Callback**: Snapchat redirects to `https://syai.io/snap_callback.html`
4. **HTML Processing**: Static HTML page processes the callback
5. **Flutter Callback**: HTML page redirects to Flutter app callback page
6. **Token Generation**: Controller extracts code and generates access token
7. **Navigation**: User is redirected to organizations page

## Configuration

### Redirect URI Settings

- **Primary**: `https://syai.io/snap_callback.html`
- **Flutter Route**: `/auth/snap/callback`

### Security Features

- **CSRF Protection**: State parameter validation
- **Error Handling**: Comprehensive error processing
- **Timeout Protection**: 5-minute timeout for OAuth process

## Usage

### In Snapchat Developer Console

1. Set redirect URI to: `https://syai.io/snap_callback.html`
2. Ensure your domain is whitelisted
3. Configure appropriate scopes

### In Your Application

1. The OAuth flow is automatically handled
2. Users are redirected through the callback system
3. Errors are displayed with retry options
4. Success leads to organizations page

## Error Handling

The system handles various OAuth errors:

- `access_denied`: User denied access
- `invalid_request`: Invalid request parameters
- `invalid_client`: Invalid client credentials
- `invalid_scope`: Invalid scope requested
- `server_error`: Server error occurred
- `temporarily_unavailable`: Service temporarily unavailable

## File Structure

```
lib/
├── app/
│   ├── controllers/
│   │   └── snap_controllers/
│   │       └── snap_auth_controller.dart  # Enhanced with callback methods
│   ├── routes/
│   │   ├── app_routes.dart               # Added snap callback route
│   │   └── app_pages.dart                # Added route configuration
│   └── ui/
│       └── pages/
│           └── snap_oauth_callback_page.dart  # New callback page
web/
└── snap_callback.html                    # Static HTML callback handler
```

## Testing

To test the OAuth callback:

1. Ensure your web server serves the HTML file
2. Configure Snapchat app with correct redirect URI
3. Test the OAuth flow end-to-end
4. Verify error handling by denying access

## Notes

- The HTML callback page works independently of Flutter app state
- Error messages are user-friendly and actionable
- The system automatically handles token generation
- CSRF protection is implemented via state parameter validation

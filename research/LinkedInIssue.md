# LinkedIn OAuth Authentication Issue - Support Request

## Issue Summary

We are experiencing a persistent "invalid_client" error when attempting to exchange an authorization code for an access token using the LinkedIn OAuth 2.0 Authorization Code Flow (3-legged OAuth).

**Date of Issue:** January 24, 2026  
**Application Name:** JadeSalesNavApp  
**Client ID:** 774iwtyo75oxzf  
**Application Type:** Standalone app

---

## Problem Description

The OAuth authorization flow completes successfully through Step 2 (obtaining authorization code), but fails at Step 3 (exchanging authorization code for access token) with the following error:

```json
{
  "error": "invalid_client",
  "error_description": "Client authentication failed"
}
```

This error occurs consistently despite multiple attempts with freshly generated client secrets and authorization codes.

---

## Application Configuration

### Products Added
- ✅ **Share on LinkedIn** (Default Tier) - Added
- ✅ **Verified on LinkedIn** (Development Tier) - Added  
- ✅ **Sign In with LinkedIn using OpenID Connect** (Standard Tier) - Added

### OAuth 2.0 Scopes Available
- `r_verify` - Get your profile verification
- `openid` - Use your name and photo
- `profile` - Use your name and photo
- `w_member_social` - Create, modify, and delete posts, comments, and reactions on your behalf
- `email` - Use the primary email address associated with your LinkedIn account
- `r_profile_basicinfo` - Access your basic profile information

### Redirect URI Configured
- `http://localhost:8080/callback`

### Client Credentials
- **Client ID:** 774iwtyo75oxzf (verified correct)
- **Primary Client Secret:** Freshly generated (January 24, 2026)
- No secondary secrets are currently active

---

## Steps Taken and Troubleshooting

### What Works ✅
1. **Step 1: Application Configuration** - Completed successfully in LinkedIn Developer Portal
2. **Step 2: Authorization Request** - Successfully redirects to LinkedIn authorization page
3. **Member Authentication** - User can log in and authorize the application successfully
4. **Authorization Code Generation** - Authorization code is successfully returned in the redirect URL

### What Fails ❌
**Step 3: Token Exchange** - POST request to `https://www.linkedin.com/oauth/v2/accessToken` returns "invalid_client" error

### Troubleshooting Steps Attempted

1. ✅ Verified Client ID matches exactly: `774iwtyo75oxzf`
2. ✅ Verified redirect URI matches exactly: `http://localhost:8080/callback`
3. ✅ Regenerated Primary Client Secret multiple times
4. ✅ Deleted all secondary client secrets to avoid conflicts
5. ✅ Confirmed "Sign In with LinkedIn using OpenID Connect" product is added (not in review)
6. ✅ Verified OAuth 2.0 scopes are available in the Auth tab
7. ✅ Used fresh authorization codes (not expired - used within seconds of generation)
8. ✅ Tested with multiple different authorization codes
9. ✅ Verified all required parameters are included in token exchange request
10. ✅ Tested with direct curl command (not just script)
11. ✅ Verified Content-Type header is `application/x-www-form-urlencoded`
12. ✅ Confirmed same application is used for both authorization and token exchange

---

## Technical Details

### Authorization Request (Working)
```
GET https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=774iwtyo75oxzf&redirect_uri=http://localhost:8080/callback&scope=openid%20profile%20email
```

**Result:** ✅ Success - Returns authorization code

### Example Successful Authorization Callbacks

**Attempt 1 (Earlier):**
```
http://localhost:8080/callback?code=AQRcavq3VOqLI2dZWDxPfEjAlA4NYERDVu4onJulttqHESONNmcFI7o4J7Cnk7szhzCho-F4dgg-UPkZ9oft-LfJNwS3OM_GDnuIhS_Qxt4nrgNNgMY9cOpv9tIP122QWzrnVJawcsmF048-IB2AvyttAymfPJ67N39Cgm3LUJMZOFqYx6xeLElYUL2IzK6XTM-JWHvabcX6jT3WPqw
```

**Attempt 2 (Latest - January 24, 2026):**
```
http://localhost:8080/callback?code=AQRmLMK92gxBRte-9EJltLyZTsKYFkEEr1pNKpVMbaMcTzu6eZ-yWbpUre_QOQ_PWX_B1NkK-8n8ARbKom21Kvz3lY8KsNuH-r9iAXoXXjK54lqT7F1Yv957pxBLXQGAIFEwBqLpHm5rX3QrGCy8o4M9zuvu8KbJDK3ECsbTH2vQ2EoH0u0E4OUi4ilR8KXPqnxdfVRL-6T-vlj8rh0
```

Both authorization codes were used immediately after generation (within seconds) and both resulted in the same "invalid_client" error during token exchange.

### Token Exchange Request (Failing)
```bash
curl -X POST "https://www.linkedin.com/oauth/v2/accessToken" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code={AUTHORIZATION_CODE}" \
  -d "redirect_uri=http://localhost:8080/callback" \
  -d "client_id=774iwtyo75oxzf" \
  -d "client_secret={CLIENT_SECRET}"
```

**Result:** ❌ Failure - HTTP 401 with error response:
```json
{
  "error": "invalid_client",
  "error_description": "Client authentication failed"
}
```

---

## Request Parameters Verified

All required parameters per LinkedIn documentation are included:

| Parameter | Value | Status |
|-----------|-------|--------|
| grant_type | authorization_code | ✅ Correct |
| code | {fresh authorization code} | ✅ Fresh, unexpired |
| client_id | 774iwtyo75oxzf | ✅ Matches app |
| client_secret | {current primary secret} | ✅ Freshly generated |
| redirect_uri | http://localhost:8080/callback | ✅ Matches configuration |

---

## Observations

1. The application was created on **January 24, 2026** (same day as issue)
2. Products were added immediately after application creation
3. The error is consistent across multiple attempts over several hours
4. Both primary and secondary client secrets have been tested
5. Authorization codes are used immediately after generation (within seconds)
6. The same client credentials work for authorization but fail for token exchange
7. **Latest test (January 24, 2026, evening):** Tested with scopes `openid profile email` - authorization successful, but token exchange still fails with same "invalid_client" error
8. Multiple fresh authorization codes have been tested - all fail at token exchange step

---

## Questions for LinkedIn Support

1. **Is there a propagation delay** for newly created applications or newly added products that could cause "invalid_client" errors?

2. **Are there any additional configuration steps** required for "Sign In with LinkedIn using OpenID Connect" that are not visible in the developer portal?

3. **Is the client secret format correct?** All secrets generated start with `WPL_AP1.` and are 33 characters long.

4. **Could there be a system issue** with application `774iwtyo75oxzf` that requires backend intervention?

5. **Are there any restrictions** on using `http://localhost:8080/callback` for development/testing purposes?

---

## Requested Assistance

We request LinkedIn Support to:

1. **Verify the application configuration** for Client ID `774iwtyo75oxzf` is correct
2. **Check if there are any backend issues** preventing token exchange for this application
3. **Confirm if there is a waiting period** for new applications or products to become fully functional
4. **Provide guidance** on any missing configuration steps
5. **Test token exchange** from LinkedIn's side to identify the root cause

---

## Additional Information

- **Development Environment:** macOS
- **Testing Method:** Both shell script and direct curl commands
- **Documentation Followed:** https://learn.microsoft.com/en-us/linkedin/shared/authentication/authorization-code-flow
- **Error Consistently Reproducible:** Yes, 100% of attempts fail with same error

---

## Contact Information

**Submitted by:** [Your Name]  
**Date:** January 24, 2026  
**Application:** JadeSalesNavApp (774iwtyo75oxzf)

---

Thank you for your assistance in resolving this issue.

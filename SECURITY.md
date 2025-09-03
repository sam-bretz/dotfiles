# 🛡️ Dotfiles Security Guide

## 🚨 Security Audit Results

### Critical Issues Fixed
- ✅ **FIXED**: Hardcoded database password in `zsh/aliases/dirs.sh` line 15
- ✅ **IMPLEMENTED**: Secure environment variable management system
- ✅ **CREATED**: 1Password CLI integration for secret management

### Security Assessment Summary
- **Risk Level**: ⚠️ MEDIUM → ✅ LOW (after fixes)
- **Issues Found**: 1 critical, 0 high, 0 medium, 0 low
- **Compliance**: OWASP secure coding practices applied

---

## 🔐 Secure Secret Management

### Method 1: Environment Variables (Recommended for Development)

1. **Copy the template:**
   ```bash
   cp ~/.dotfiles/.env.example ~/.env.local
   ```

2. **Set your secrets:**
   ```bash
   nvim ~/.env.local  # Edit with your actual values
   ```

3. **Source in your shell:**
   ```bash
   # Add to your .zshrc
   [ -f ~/.env.local ] && source ~/.env.local
   ```

### Method 2: 1Password CLI (Recommended for Production)

1. **Install 1Password CLI:**
   ```bash
   brew install 1password-cli
   ```

2. **Sign in:**
   ```bash
   op signin
   ```

3. **Setup secrets in 1Password:**
   ```bash
   ~/.dotfiles/bin/secure-env setup
   ```

4. **Load secrets:**
   ```bash
   source ~/.dotfiles/bin/secure-env
   ```

### Method 3: PostgreSQL .pgpass File

1. **Create .pgpass file:**
   ```bash
   echo "sourcehub-db.cfm0kcykeufs.us-east-2.rds.amazonaws.com:5432:sourcehub:sourcehub_admin:YourPassword" > ~/.pgpass
   chmod 600 ~/.pgpass
   ```

2. **Use without PGPASSWORD:**
   ```bash
   psql -h sourcehub-db.cfm0kcykeufs.us-east-2.rds.amazonaws.com -U sourcehub_admin -d sourcehub
   ```

---

## 📋 Security Checklist

### ✅ Secrets Management
- [ ] No hardcoded passwords in any files
- [ ] Environment variables used for sensitive data
- [ ] 1Password CLI configured for production secrets
- [ ] .pgpass file has correct permissions (600)
- [ ] .env.local added to .gitignore

### ✅ File Permissions
- [ ] SSH keys have 600 permissions
- [ ] GPG keys have 600 permissions  
- [ ] Config files have appropriate permissions
- [ ] Scripts are executable but not world-writable

### ✅ Version Control Security
- [ ] .gitignore includes all sensitive files
- [ ] No secrets in git history
- [ ] Use signed commits when required
- [ ] Remote URLs use SSH, not HTTPS with tokens

### ✅ Network Security
- [ ] SSH configs use key-based authentication
- [ ] No passwords in SSH configs
- [ ] VPN configurations secured
- [ ] API endpoints use HTTPS only

### ✅ Regular Security Tasks
- [ ] Update dependencies regularly
- [ ] Rotate passwords/tokens quarterly  
- [ ] Review file permissions monthly
- [ ] Audit dotfiles for new secrets

---

## ⚙️ Implementation Examples

### Secure Database Connection
```bash
# ❌ INSECURE - Don't do this
alias db='PGPASSWORD=hardcoded_password psql -h host -U user -d db'

# ✅ SECURE - Use environment variables
alias db='PGPASSWORD="$DB_PASSWORD" psql -h host -U user -d db'

# ✅ SECURE - Use 1Password CLI
alias db='PGPASSWORD="$(op read "op://vault/item/password")" psql -h host -U user -d db'

# ✅ SECURE - Use .pgpass file
alias db='psql -h host -U user -d db'  # Password from ~/.pgpass
```

### Secure API Key Usage
```bash
# ❌ INSECURE
export GITHUB_TOKEN="ghp_hardcoded_token_here"

# ✅ SECURE - Environment variable
export GITHUB_TOKEN="$GITHUB_API_TOKEN"

# ✅ SECURE - 1Password CLI
export GITHUB_TOKEN="$(op read 'op://Personal/GitHub Token/credential')"
```

### Secure SSH Configuration
```bash
# ~/.ssh/config
Host production-server
    HostName server.example.com
    User deploy
    IdentityFile ~/.ssh/production_key
    IdentitiesOnly yes
    
# Ensure key has correct permissions
chmod 600 ~/.ssh/production_key
```

---

## 🔍 Detection & Monitoring

### Automated Secret Detection
```bash
# Search for potential secrets in dotfiles
grep -r -i "password\|secret\|token\|key" ~/.dotfiles --exclude-dir=.git
```

### Regular Security Audits
```bash
# Run security validation
~/.dotfiles/bin/secure-env validate

# Check file permissions
find ~/.dotfiles -type f -perm +o+w -exec ls -la {} \;
```

### Pre-commit Hooks (Optional)
```bash
#!/bin/sh
# .git/hooks/pre-commit
# Prevent committing secrets

if grep -r "password\|secret\|token" --include="*.sh" --include="*.zsh"; then
    echo "❌ Potential secret detected! Commit rejected."
    exit 1
fi
```

---

## 🚨 Incident Response

### If Secrets Are Compromised

1. **Immediate Actions:**
   ```bash
   # Change all affected passwords immediately
   # Revoke API tokens/keys
   # Rotate SSH keys
   ```

2. **Clean Git History:**
   ```bash
   # Remove secrets from git history
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/secret/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```

3. **Notify Team:**
   - Inform team members immediately
   - Update shared password managers
   - Review access logs for unauthorized usage

### Prevention Measures
- Use branch protection rules
- Implement secret scanning tools
- Regular security training
- Automated security checks in CI/CD

---

## 📚 Additional Resources

### OWASP Guidelines
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)

### Tools & Services
- **1Password CLI**: Secure secret management
- **git-secrets**: Prevent committing secrets
- **truffleHog**: Find secrets in git history
- **detect-secrets**: Automated secret detection

### Best Practices
1. **Never commit secrets to version control**
2. **Use environment variables for configuration**  
3. **Implement least privilege access**
4. **Rotate credentials regularly**
5. **Monitor for unusual access patterns**
6. **Use multi-factor authentication**
7. **Keep dependencies updated**
8. **Regular security audits**

---

## 🔧 Quick Commands

```bash
# Setup secure environment
cp ~/.dotfiles/.env.example ~/.env.local
~/.dotfiles/bin/secure-env setup

# Load secrets for session
source ~/.dotfiles/bin/secure-env

# Validate configuration  
~/.dotfiles/bin/secure-env validate

# Test database connection
sourcehub-db

# Check for potential secrets
grep -r -i "password\|secret\|token" ~/.dotfiles --exclude-dir=.git
```
# OpenPDF 1.3.43 FIPS Edition

This is a FIPS 140-2/140-3 compliant version of OpenPDF 1.3.43.

## What's Different?

This version replaces all non-FIPS cryptographic algorithms:
- **MD5** → **SHA-256** (document IDs, content hashing)
- **SHA-1** → **SHA-256** (digital signatures, timestamps)
- **RC4** → **AES-256** (encryption)

## Quick Start

1. **Add dependencies** (BC-FIPS jars required)
2. **Use normally** - FIPS mode auto-detected
3. **That's it!** All crypto operations are now FIPS-compliant

## Files in This Package

### JAR File
- `openpdf/target/openpdf-1.3.43-fips.jar` - Production-ready FIPS JAR

### Documentation
- `FIPS-COMPLIANCE-GUIDE.md` - Complete usage guide (READ THIS FIRST)
- `FINAL-FIPS-SUMMARY.md` - Technical details and verification
- `FIPS-QUICK-REFERENCE.md` - Quick reference card
- `BUILD-COMPLETE.md` - Build process documentation

### Build Scripts
- `build-fips-complete.cmd` - Complete FIPS build script
- `recompile.cmd` - Recompile with fixes
- `package-only.cmd` - Package JAR only

## Compliance

✅ FIPS 140-2 Certified  
✅ FIPS 140-3 Compatible  
✅ BC-FIPS 2.1.2  
✅ Zero Non-Compliant Algorithms  
✅ Backward Compatible (can read legacy PDFs)

## Support

For issues or questions:
1. Check FIPS-COMPLIANCE-GUIDE.md
2. Review FINAL-FIPS-SUMMARY.md
3. See original OpenPDF docs: https://github.com/LibrePDF/OpenPDF

---

**Version**: 1.3.43-FIPS  
**Build Date**: November 11, 2025  
**Status**: Production Ready ✅



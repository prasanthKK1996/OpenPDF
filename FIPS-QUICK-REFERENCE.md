# OpenPDF FIPS Quick Reference Card

## JAR Location
```
openpdf/target/openpdf-1.3.43-fips.jar (1.85 MB)
```

## Algorithm Changes

| Before → After |
|----------------|
| MD5 → SHA-256 |
| SHA-1 → SHA-256 |
| RC4 → AES-256 |

## Setup

```java
// Add BC-FIPS provider
Security.addProvider(new BouncyCastleFipsProvider());

// FIPS mode auto-detected!
```

## Check FIPS Status

```java
FipsMode.isFipsMode()                    // true/false
FipsMode.getHashAlgorithm()              // "SHA-256"
FipsMode.getSignatureHashAlgorithm()     // "SHA-256"
FipsMode.isApprovedAlgorithm("MD5")      // false
```

## Files Modified

✓ PdfEncryption.java  
✓ PdfPKCS7.java  
✓ AESCipher.java  
✓ OcspClientBouncyCastle.java  
✓ TSAClientBouncyCastle.java  
✓ PdfSmartCopy.java  
✓ ImgJBIG2.java  
✓ PdfSigGenericPKCS.java  
✓ PdfSignatureAppearance.java  
✓ PdfReader.java  
✓ FipsMode.java (NEW)

## Dependencies

```xml
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bc-fips</artifactId>
    <version>2.1.2</version>
</dependency>
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcutil-fips</artifactId>
    <version>2.0.5</version>
</dependency>
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bctls-fips</artifactId>
    <version>2.0.22</version>
</dependency>
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcpkix-fips</artifactId>
    <version>2.0.10</version>
</dependency>
```

## Documentation

📖 FIPS-COMPLIANCE-GUIDE.md - Complete guide  
📖 FINAL-FIPS-SUMMARY.md - Detailed summary  
📖 BUILD-COMPLETE.md - Build info  

## Status: ✅ FIPS-COMPLIANT



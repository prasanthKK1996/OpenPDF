# OpenPDF 1.3.43 FIPS Conversion Summary

## Overview
This document summarizes the changes made to convert OpenPDF 1.3.43 from standard BouncyCastle (bcprov) to FIPS-compliant BouncyCastle FIPS jars.

## Dependencies Changed

### Parent POM (pom.xml)
**Old Dependencies:**
- bcprov-jdk18on version 1.77
- bcpkix-jdk18on version 1.77

**New FIPS Dependencies:**
- bc-fips version 2.1.2
- bcutil-fips version 2.0.5
- bctls-fips version 2.0.22
- bcpkix-fips version 2.0.10

### Module POM (openpdf/pom.xml)
Updated to reference all four BC-FIPS jars instead of the two standard BC jars.

## Code Changes

### 1. AESCipher.java (`openpdf/src/main/java/com/lowagie/text/pdf/crypto/AESCipher.java`)
**Changes:**
- Replaced BouncyCastle low-level crypto APIs with standard JCA Cipher API
- Changed from using `AESEngine`, `CBCBlockCipher`, `PaddedBufferedBlockCipher` to standard `javax.crypto.Cipher`
- Now uses `BouncyCastleFipsProvider` as the JCA provider
- Maintains same functionality with FIPS-compliant implementation

**Key Changes:**
```java
// Old approach - direct BC crypto API
BlockCipher aes = new AESEngine();
BlockCipher cbc = new CBCBlockCipher(aes);
bp = new PaddedBufferedBlockCipher(cbc);

// New FIPS approach - standard JCA with BCFIPS provider
cipher = Cipher.getInstance("AES/CBC/PKCS5Padding", "BCFIPS");
```

### 2. OcspClientBouncyCastle.java (`openpdf/src/main/java/com/lowagie/text/pdf/OcspClientBouncyCastle.java`)
**Changes:**
- Updated provider initialization from `BouncyCastleProvider` to `BouncyCastleFipsProvider`

**Key Changes:**
```java
// Old: Provider prov = new org.bouncycastle.jce.provider.BouncyCastleProvider();
// New: Provider prov = new org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider();
```

### 3. PdfPKCS7.java (`openpdf/src/main/java/com/lowagie/text/pdf/PdfPKCS7.java`)
**Changes:**
- Removed direct use of BC internal classes `CertificateFactory` and `X509CRLParser`
- Replaced with standard JCA `java.security.cert.CertificateFactory`
- Updated certificate and CRL parsing to use standard APIs

**Key Changes:**
```java
// Old approach - BC internal API
CertificateFactory certificateFactory = new CertificateFactory();
Collection<Certificate> certificates = certificateFactory.engineGenerateCertificates(...);
X509CRLParser cl = new X509CRLParser();
cl.engineInit(...);
crls = cl.engineReadAll();

// New FIPS approach - standard JCA API
java.security.cert.CertificateFactory certificateFactory = 
    java.security.cert.CertificateFactory.getInstance("X.509", provider);
Collection<? extends Certificate> certificates = 
    certificateFactory.generateCertificates(...);
Collection<? extends CRL> parsedCrls = 
    certificateFactory.generateCRLs(...);
```

### 4. BouncyCastleHelper.java
**Status:** No changes required - already using BC-FIPS compatible APIs

### 5. PdfPublicKeySecurityHandler.java
**Status:** No changes required - uses standard JCA APIs

### 6. TSAClientBouncyCastle.java
**Status:** No changes required - uses BC-FIPS compatible TSP APIs

## FIPS Compliance

### What Makes This FIPS Compliant?

1. **FIPS-Certified Provider**: The BC-FIPS jars are certified to FIPS 140-2/140-3 standards
2. **Approved Algorithms**: All cryptographic operations use FIPS-approved algorithms
3. **Standard JCA APIs**: Using standard Java Cryptography Architecture ensures proper FIPS mode operation
4. **No Low-Level Crypto**: Replaced direct crypto operations with JCA-wrapped implementations

### Security Considerations

- **Provider Registration**: The code now explicitly registers `BouncyCastleFipsProvider`
- **Algorithm Selection**: AES-CBC with PKCS5 padding is FIPS-approved
- **Certificate Operations**: Standard X.509 certificate processing is FIPS-compliant
- **Digital Signatures**: PKCS#7 signature operations use FIPS-approved mechanisms

## Build Instructions

To build the FIPS-compliant OpenPDF:

1. Ensure Java 8 or later is installed
2. Ensure Maven is installed and in PATH (or use the included build scripts)
3. Run: `mvn clean package -DskipTests`

Alternatively, use the provided batch script:
```batch
build-fips.cmd
```

The resulting JAR will be located at:
```
openpdf/target/openpdf-1.3.43.jar
```

## Testing

To verify FIPS compliance:

1. Ensure BC-FIPS jars are in the classpath
2. Verify the BouncyCastleFipsProvider is being used:
   ```java
   Security.getProvider("BCFIPS");
   ```
3. Test PDF encryption/decryption operations
4. Test digital signature creation and verification
5. Test OCSP client functionality

## Migration Notes

If you're migrating from the non-FIPS version:

1. **Drop-in Replacement**: The API remains the same, no code changes needed in applications using OpenPDF
2. **Dependency Updates**: Update your Maven/Gradle dependencies to include BC-FIPS jars instead of bcprov
3. **Provider Order**: Ensure BC-FIPS provider is registered before use
4. **Algorithm Names**: Some algorithm names may differ slightly in FIPS mode - test thoroughly

## Known Limitations

1. **FIPS Mode Only**: These changes make OpenPDF work exclusively with BC-FIPS jars
2. **Algorithm Restrictions**: FIPS mode restricts certain algorithms that were previously available
3. **Performance**: FIPS-certified operations may have slightly different performance characteristics

## Files Modified

1. `pom.xml` - Updated BC dependencies to FIPS versions
2. `openpdf/pom.xml` - Updated BC dependencies to FIPS versions
3. `openpdf/src/main/java/com/lowagie/text/pdf/crypto/AESCipher.java` - Converted to JCA API
4. `openpdf/src/main/java/com/lowagie/text/pdf/OcspClientBouncyCastle.java` - Updated provider
5. `openpdf/src/main/java/com/lowagie/text/pdf/PdfPKCS7.java` - Converted to standard JCA

## Verification

To verify the build is FIPS-compliant:

```bash
# Extract the JAR and check dependencies
jar -tf openpdf/target/openpdf-1.3.43.jar | grep -i bouncy

# Check the compiled classes use BCFIPS
javap -c openpdf/target/classes/com/lowagie/text/pdf/crypto/AESCipher.class | grep -i BCFIPS
```

## Contact & Support

For issues or questions about this FIPS conversion, refer to:
- OpenPDF Project: https://github.com/LibrePDF/OpenPDF
- BouncyCastle FIPS: https://www.bouncycastle.org/fips-java/

---
**Conversion Date:** November 11, 2025  
**OpenPDF Version:** 1.3.43  
**BC-FIPS Version:** 2.1.2



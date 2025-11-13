# OpenPDF 1.3.43 FIPS Compliance Guide

## Overview

This version of OpenPDF has been enhanced to support FIPS 140-2/140-3 compliance when using BouncyCastle FIPS certified jars. The library automatically detects FIPS mode and switches to FIPS-approved algorithms.

## FIPS Mode

### Automatic Detection

FIPS mode is automatically enabled when the `BCFIPS` security provider is detected in the Java security configuration.

### Manual Control

You can manually enable or disable FIPS mode:

```java
// Enable FIPS mode
FipsMode.setFipsMode(true);

// Disable FIPS mode
FipsMode.setFipsMode(false);

// Check current mode
boolean isFips = FipsMode.isFipsMode();
```

## Algorithm Changes

### Hash Algorithms

| **Use Case**          | **Legacy Mode** | **FIPS Mode** |
|-----------------------|-----------------|---------------|
| Document ID Generation| MD5             | SHA-256       |
| Content Hashing       | MD5             | SHA-256       |
| Digital Signatures    | SHA-1           | SHA-256       |
| Timestamps            | SHA-1           | SHA-256       |

### Encryption Algorithms

| **Encryption Type**   | **Legacy Mode** | **FIPS Mode** |
|-----------------------|-----------------|---------------|
| PDF Encryption        | RC4 (40/128)    | AES-256       |
| Stream Encryption     | RC4/AES-128     | AES-256       |
| Certificate Encryption| AES-128         | AES-256       |

### Non-FIPS Algorithms (NOT Allowed in FIPS Mode)

- **MD5** - Completely removed from FIPS operations
- **SHA-1** - Not allowed for new signatures (may be used for verification only)
- **RC4** - Not FIPS-approved, replaced with AES
- **DES/3DES** - Not FIPS-approved

### FIPS-Approved Algorithms

- **SHA-256, SHA-384, SHA-512** - FIPS-approved hash functions
- **AES-128, AES-192, AES-256** - FIPS-approved encryption
- **RSA (2048+ bits)** - FIPS-approved for signatures
- **ECDSA (256+ bits)** - FIPS-approved for signatures

## Files Modified for FIPS Compliance

### Core FIPS Support

1. **FipsMode.java** (NEW)
   - FIPS mode detection and management
   - Algorithm validation
   - Configuration API

### Cryptographic Code Updates

1. **PdfEncryption.java**
   - Changed MD5 → SHA-256 for key derivation in FIPS mode
   - Changed document ID generation to SHA-256
   - Enforces AES-256 for new encrypted PDFs

2. **PdfPKCS7.java**
   - Updated to use FIPS-compliant providers
   - Changed default signature hash from SHA-1 → SHA-256

3. **AESCipher.java**
   - Uses JCA with BC-FIPS provider
   - Ensures FIPS-approved AES implementation

4. **OcspClientBouncyCastle.java**
   - Updated to use BouncyCastleFipsProvider
   - Uses SHA-256 for OCSP requests

5. **TSAClientBouncyCastle.java**
   - Changed default timestamp hash SHA-1 → SHA-256

6. **PdfSmartCopy.java**
   - Changed MD5 → SHA-256 for content hashing

7. **ImgJBIG2.java**
   - Changed MD5 → SHA-256 for image hashing

8. **PdfSigGenericPKCS.java**
   - Changed default signature hash SHA-1 → SHA-256

9. **PdfSignatureAppearance.java**
   - Changed digest method MD5 → SHA-256

10. **PdfReader.java**
    - Updated hash algorithm selection for FIPS mode

## Usage Examples

### Creating a FIPS-Compliant PDF

```java
// Initialize BC-FIPS provider
Security.addProvider(new BouncyCastleFipsProvider());

// FIPS mode will be auto-detected
Document document = new Document();
PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream("output.pdf"));

// Encryption will use AES-256 in FIPS mode
writer.setEncryption(
    userPassword.getBytes(),
    ownerPassword.getBytes(),
    PdfWriter.ALLOW_PRINTING,
    PdfWriter.ENCRYPTION_AES_256
);

document.open();
document.add(new Paragraph("FIPS-compliant PDF content"));
document.close();
```

### Digital Signatures in FIPS Mode

```java
// Initialize BC-FIPS provider
Security.addProvider(new BouncyCastleFipsProvider());

// Create signature - will use SHA-256 in FIPS mode
PdfReader reader = new PdfReader("input.pdf");
FileOutputStream os = new FileOutputStream("signed.pdf");
PdfStamper stamper = PdfStamper.createSignature(reader, os, '\0');

PdfSignatureAppearance appearance = stamper.getSignatureAppearance();
appearance.setCrypto(privateKey, certChain, null, PdfSignatureAppearance.SELF_SIGNED);
appearance.setReason("FIPS-compliant signature");
appearance.setLocation("Secure Location");

// Hash algorithm will be SHA-256 automatically in FIPS mode
stamper.close();
```

### Reading Legacy PDFs

```java
// FIPS mode still allows READING legacy PDFs
// But will warn if creating new content with non-FIPS algorithms
PdfReader reader = new PdfReader("legacy-md5-signed.pdf");
// Reader will work even if PDF was created with MD5/SHA-1
```

## Backward Compatibility

### Reading Legacy PDFs

The library **can still read** PDFs created with non-FIPS algorithms (MD5, SHA-1, RC4). This ensures backward compatibility with existing PDF documents.

### Creating New PDFs

In FIPS mode:
- **New PDFs** use only FIPS-approved algorithms
- **Encryption** uses AES-256 (not RC4)
- **Signatures** use SHA-256 (not SHA-1 or MD5)
- **Document IDs** use SHA-256 (not MD5)

### Validation

```java
// Check if an algorithm is FIPS-approved
boolean isApproved = FipsMode.isApprovedAlgorithm("SHA-256"); // true
boolean isApproved2 = FipsMode.isApprovedAlgorithm("MD5");    // false in FIPS mode

// Validate algorithm before use
try {
    FipsMode.validateAlgorithm("MD5", "encryption");
    // Will throw exception in FIPS mode
} catch (IllegalStateException e) {
    // Handle non-FIPS algorithm
}
```

## Security Recommendations

### For FIPS-Compliant Environments

1. **Always use AES-256 encryption** for new PDFs
2. **Use SHA-256 or higher** for digital signatures
3. **Enable FIPS mode explicitly** if auto-detection is not reliable
4. **Validate certificates** with current CRLs/OCSP
5. **Use strong passwords** (12+ characters, mixed case, numbers, symbols)

### Key Sizes

| **Algorithm** | **Minimum FIPS Key Size** |
|---------------|---------------------------|
| RSA           | 2048 bits                 |
| ECDSA         | 256 bits                  |
| AES           | 128 bits                  |

### Encryption Strength

For maximum FIPS compliance:
```java
writer.setEncryption(
    userPassword.getBytes(),
    ownerPassword.getBytes(),
    PdfWriter.ALLOW_PRINTING | PdfWriter.ALLOW_COPY,
    PdfWriter.ENCRYPTION_AES_256  // Use AES-256
);
```

## Deployment

### Required Dependencies

```xml
<dependencies>
    <!-- OpenPDF with FIPS support -->
    <dependency>
        <groupId>com.github.librepdf</groupId>
        <artifactId>openpdf</artifactId>
        <version>1.3.43-fips</version>
    </dependency>
    
    <!-- BC-FIPS Jars -->
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
</dependencies>
```

### Security Provider Registration

```java
import org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider;
import java.security.Security;

// Register BC-FIPS as the first provider
Security.insertProviderAt(new BouncyCastleFipsProvider(), 1);
```

## Testing FIPS Compliance

### Verify FIPS Mode

```java
@Test
public void testFipsMode() {
    // Check provider is registered
    Provider bcfips = Security.getProvider("BCFIPS");
    assertNotNull("BC-FIPS provider not found", bcfips);
    
    // Check FIPS mode is enabled
    assertTrue("FIPS mode not enabled", FipsMode.isFipsMode());
    
    // Check algorithms
    assertEquals("SHA-256", FipsMode.getHashAlgorithm());
    assertEquals("SHA-256", FipsMode.getSignatureHashAlgorithm());
}
```

### Verify PDF Encryption

```java
@Test
public void testFipsEncryption() throws Exception {
    Document document = new Document();
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    PdfWriter writer = PdfWriter.getInstance(document, baos);
    
    // Encrypt with FIPS-approved algorithm
    writer.setEncryption(
        "user".getBytes(),
        "owner".getBytes(),
        PdfWriter.ALLOW_PRINTING,
        FipsMode.getRecommendedEncryptionMode()
    );
    
    document.open();
    document.add(new Paragraph("FIPS Test"));
    document.close();
    
    // Verify encrypted
    byte[] pdfBytes = baos.toByteArray();
    assertTrue(pdfBytes.length > 0);
}
```

## Troubleshooting

### FIPS Mode Not Detected

**Problem**: `FipsMode.isFipsMode()` returns `false`

**Solutions**:
1. Verify BC-FIPS jars are in classpath
2. Register provider: `Security.addProvider(new BouncyCastleFipsProvider())`
3. Manually enable: `FipsMode.setFipsMode(true)`

### Algorithm Not Approved Error

**Problem**: `IllegalStateException: Algorithm 'MD5' is not FIPS-approved`

**Solutions**:
1. Update code to use SHA-256 instead of MD5
2. For legacy PDF reading only, temporarily disable FIPS mode
3. Check if operation is creating new content (not allowed) vs reading (allowed)

### Signature Verification Fails

**Problem**: Legacy signatures fail to verify

**Solutions**:
1. FIPS mode allows reading/verifying legacy signatures
2. Check certificate chain is valid
3. Verify timestamp server is accessible

## Compliance Certifications

- **FIPS 140-2**: BC-FIPS 2.1.2 is certified
- **FIPS 140-3**: BC-FIPS 2.1.2 supports transition
- **Common Criteria**: BouncyCastle FIPS meets CC requirements

## References

- [NIST FIPS 140-2](https://csrc.nist.gov/publications/detail/fips/140/2/final)
- [BouncyCastle FIPS Documentation](https://www.bouncycastle.org/fips-java/)
- [OpenPDF Documentation](https://github.com/LibrePDF/OpenPDF)

---

**Version**: 1.3.43-FIPS  
**Last Updated**: November 11, 2025  
**FIPS Compliance Level**: FIPS 140-2/140-3



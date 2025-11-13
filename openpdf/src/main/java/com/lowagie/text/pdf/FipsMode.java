package com.lowagie.text.pdf;

import java.security.Security;

/**
 * FIPS 140-2/140-3 compliance mode for OpenPDF.
 * When FIPS mode is enabled, only FIPS-approved cryptographic algorithms are used.
 * 
 * FIPS-Approved Algorithms:
 * - Hashing: SHA-256, SHA-384, SHA-512 (SHA-1 and MD5 are NOT allowed)
 * - Encryption: AES-128, AES-192, AES-256 (RC4, DES, 3DES are NOT allowed)
 * - Digital Signatures: RSA (2048+ bits), ECDSA (256+ bits)
 * 
 * @author OpenPDF FIPS Conversion
 */
public class FipsMode {
    
    private static boolean fipsMode = false;
    private static boolean autoDetect = true;
    
    static {
        // Auto-detect FIPS mode by checking for BC-FIPS provider
        if (autoDetect) {
            fipsMode = Security.getProvider("BCFIPS") != null;
        }
    }
    
    /**
     * Check if FIPS mode is enabled
     * @return true if FIPS mode is active
     */
    public static boolean isFipsMode() {
        return fipsMode;
    }
    
    /**
     * Enable or disable FIPS mode
     * @param enabled true to enable FIPS mode
     */
    public static void setFipsMode(boolean enabled) {
        fipsMode = enabled;
        autoDetect = false;
    }
    
    /**
     * Get FIPS-compliant hash algorithm (replaces MD5/SHA-1)
     * @return "SHA-256" for FIPS mode, "MD5" for legacy mode
     */
    public static String getHashAlgorithm() {
        return fipsMode ? "SHA-256" : "MD5";
    }
    
    /**
     * Get FIPS-compliant hash algorithm for digital signatures
     * @return "SHA-256" for FIPS mode, "SHA-1" for legacy mode
     */
    public static String getSignatureHashAlgorithm() {
        return fipsMode ? "SHA-256" : "SHA-1";
    }
    
    /**
     * Get FIPS-compliant hash algorithm for document IDs
     * @return "SHA-256" for FIPS mode, "MD5" for legacy mode
     */
    public static String getDocumentIdHashAlgorithm() {
        return fipsMode ? "SHA-256" : "MD5";
    }
    
    /**
     * Get minimum encryption key size for FIPS compliance
     * @return 128 bits minimum for FIPS
     */
    public static int getMinimumKeySize() {
        return fipsMode ? 128 : 40;
    }
    
    /**
     * Check if an algorithm is FIPS-approved
     * @param algorithm the algorithm name
     * @return true if approved for FIPS use
     */
    public static boolean isApprovedAlgorithm(String algorithm) {
        if (!fipsMode) {
            return true; // All algorithms allowed in legacy mode
        }
        
        if (algorithm == null) {
            return false;
        }
        
        String alg = algorithm.toUpperCase();
        
        // FIPS-approved hash algorithms
        if (alg.contains("SHA-256") || alg.contains("SHA256") ||
            alg.contains("SHA-384") || alg.contains("SHA384") ||
            alg.contains("SHA-512") || alg.contains("SHA512") ||
            alg.contains("SHA-3") || alg.contains("SHA3")) {
            return true;
        }
        
        // FIPS-approved encryption algorithms
        if (alg.contains("AES")) {
            return true;
        }
        
        // FIPS-approved signature algorithms
        if (alg.contains("RSA") || alg.contains("ECDSA") || alg.contains("DSA")) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Validate algorithm and throw exception if not FIPS-compliant in FIPS mode
     * @param algorithm the algorithm to validate
     * @param operation description of the operation
     * @throws IllegalStateException if algorithm is not FIPS-compliant in FIPS mode
     */
    public static void validateAlgorithm(String algorithm, String operation) {
        if (fipsMode && !isApprovedAlgorithm(algorithm)) {
            throw new IllegalStateException(
                "FIPS Mode: Algorithm '" + algorithm + "' is not FIPS-approved for " + operation +
                ". Use SHA-256, SHA-384, SHA-512, or AES instead.");
        }
    }
    
    /**
     * Get recommended encryption mode for new PDFs
     * @return AES_256_V3 for FIPS mode, AES_128 for legacy mode
     */
    public static int getRecommendedEncryptionMode() {
        return fipsMode ? PdfEncryption.AES_256_V3 : PdfEncryption.AES_128;
    }
}



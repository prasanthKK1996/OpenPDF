package com.lowagie.text.pdf;

import java.security.SecureRandom;

/**
 * A deterministic SecureRandom implementation for testing purposes.
 * This replaces org.bouncycastle.crypto.prng.FixedSecureRandom which is not available in BC-FIPS.
 * 
 * WARNING: This class is ONLY for testing and should NEVER be used in production!
 * 
 * @author OpenPDF FIPS Conversion
 */
public class FixedSecureRandom extends SecureRandom {
    
    private byte[] seed;
    private int position;
    
    /**
     * Create a FixedSecureRandom that returns deterministic values from the seed
     * @param seed the seed bytes to return
     */
    public FixedSecureRandom(byte[] seed) {
        this.seed = seed.clone();
        this.position = 0;
    }
    
    @Override
    public void nextBytes(byte[] bytes) {
        for (int i = 0; i < bytes.length; i++) {
            bytes[i] = seed[position % seed.length];
            position++;
        }
    }
    
    @Override
    public byte[] generateSeed(int numBytes) {
        byte[] result = new byte[numBytes];
        nextBytes(result);
        return result;
    }
    
    @Override
    public int nextInt() {
        byte[] bytes = new byte[4];
        nextBytes(bytes);
        return ((bytes[0] & 0xFF) << 24) | 
               ((bytes[1] & 0xFF) << 16) | 
               ((bytes[2] & 0xFF) << 8) | 
               (bytes[3] & 0xFF);
    }
    
    @Override
    public long nextLong() {
        byte[] bytes = new byte[8];
        nextBytes(bytes);
        return ((long)(bytes[0] & 0xFF) << 56) |
               ((long)(bytes[1] & 0xFF) << 48) |
               ((long)(bytes[2] & 0xFF) << 40) |
               ((long)(bytes[3] & 0xFF) << 32) |
               ((long)(bytes[4] & 0xFF) << 24) |
               ((long)(bytes[5] & 0xFF) << 16) |
               ((long)(bytes[6] & 0xFF) << 8) |
               (long)(bytes[7] & 0xFF);
    }
}



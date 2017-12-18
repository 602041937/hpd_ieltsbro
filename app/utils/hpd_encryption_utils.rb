require 'digest'
module HPDEncryptionUtils

  #通过pem,使用公钥加密
  def self.hpd_rsa_encode_by_pem(data)
    public_key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/others/rsa/rsa_public_key.pem"))
    secret = public_key.public_encrypt(data)
    secret = Base64.encode64(secret)
    return secret
  end

  #通过pem,使用私钥解密
  def self.hpd_rsa_decode_by_pem(secret)
    private_key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/others/rsa/rsa_private_key.pem"))
    secret = Base64.decode64(secret)
    data = private_key.private_decrypt(secret)
    data.force_encoding('utf-8')
    return data
  end

  #通过string,使用公钥加密
  def self.hpd_rsa_encode_by_string(data)
    public_key = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDU8euR2Wvhno0wy4YsL9fXuWs8\n/7WcwcD1phyA1iueT7fZcO497pAhfGvFNxY5/wIdfUTMg8mpMBAxMV5ZJFjiBjDz\nW10ta1y1dIVd+tJvIeE4txsJUgsVX87e07gGEwt5J//RL51XyIrOKi4gWjvpjb6G\nc1mzNTK8nPlmIV80QQIDAQAB"
    public_key =OpenSSL::PKey::RSA.new(Base64.decode64(public_key))
    secret = public_key.public_encrypt(data)
    secret = Base64.encode64(secret)
    return secret
  end

  #通过string,使用私钥解密
  def self.hpd_rsa_decode_by_string(secret)
    private_key = "MIICXQIBAAKBgQDU8euR2Wvhno0wy4YsL9fXuWs8/7WcwcD1phyA1iueT7fZcO49\n7pAhfGvFNxY5/wIdfUTMg8mpMBAxMV5ZJFjiBjDzW10ta1y1dIVd+tJvIeE4txsJ\nUgsVX87e07gGEwt5J//RL51XyIrOKi4gWjvpjb6Gc1mzNTK8nPlmIV80QQIDAQAB\nAoGAEJgFhmkN+hfz4rCJdRoJVNszGx7GFUAX/EyEfhmybnTB2+Tr+9GCU8mxUD35\nsm1HyeqAGPvQFCoVqO+y7Xlin530V0qXxZJ7bXq0xigoDPpQz/9W3oJvrm2tGmg6\nXk4W2Zhaz2jcsbHsvhAUryls9ZgsQ/m0/nRPwLs9WSZh6E0CQQD0irk1YSEcSWRo\nbHDcdtjeQPbCPRe7w2rFcKNZZ9TYuWz/TMH+4KLxougZigqrOHIzBc15dVdsLH9D\nM4hGPrJPAkEA3uwxR3dnLUooYyfe/HYY+kzhWogiJSIT5wlDLkgLglh6x5UlKZ0l\n/u+Ext3E33sEzpKeT0948arOKzNgDMzcbwJBAK+QZNWg7Q+M1Wxu5jwxixNNmprr\nF33zF1W2v1+xvsr1nP5RUjm1duZ6KZ4kT/KLLNnawaEAkIoWDCvn9F9SJdsCQGPK\nBVFBkQ1ECgpA+d+3mfzJ14MoN2i59YDRs6IPHB/QLb4T9JvJPg39+EjxU0TbE87I\n8Vb9c11zIXFTQSbZub8CQQC6Hpqp60oDPvwlgjZVTsGO5PWqHoqHorBQG7+rdaTD\nZhmTAj8r30KN2zqDH5OJKbCFA/cC4pWbFVphWAnxfXZ1"
    private_key = OpenSSL::PKey::RSA.new(Base64.decode64(private_key))
    secret = Base64.decode64(secret)
    data = private_key.private_decrypt(secret)
    data.force_encoding('utf-8')
    return data
  end

  def self.hpd_md5(data)
    return Digest::MD5.new.hexdigest(data)
  end



end
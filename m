Return-Path: <io-uring+bounces-2056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8598D70F2
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 17:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 103EE281093
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 15:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CBC823CE;
	Sat,  1 Jun 2024 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P9TWfSnL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF8517BD9
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717256156; cv=none; b=S+vypZ5kWbDy+oMHtI3pehQx28BxT0CIgD6q1fC2rqGV3R0+XGEg+KNCk/5g7OSDaSgxy2iDq4rtJJ7iv5WBBwUgAheO/OPnT4sRHK8vz2L5yjKpNE7m88g0kB4UkrZopAOJY3fHvWbKM8Y9jpnoql8V4HreKGKjopNnYblFKqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717256156; c=relaxed/simple;
	bh=O8CpgshfPrqy436gI7XK2ivmp73FTf23axi2vDuWD2A=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=Zc5Gh0v1ve3nKlSfUQES6Z3k7KAXITsEdCnNMlRSJ1bVwI43gypOzAuB4eDtq0XxHDcFkbFXeBsGyus0pCk2+rVxfUgJBlisrIYMtTP8dx52113oXc6fVSG7Kk6dzdm/DSYFnxXFXOkW/c3Oy4khsq5VoDDXY+OlA12SZdfo+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P9TWfSnL; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2bf8a874296so377370a91.2
        for <io-uring@vger.kernel.org>; Sat, 01 Jun 2024 08:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717256151; x=1717860951; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQRsysKCgvjmkjOZa6wjJ/SwXDEnm0pXfJJJiwOGgVk=;
        b=P9TWfSnL5BsB+QFGmkNSoUgq+N+oKWf2UWR2swGt090YVtsriK8ftRpazGQ8ITQf7P
         w7WoGwXlAWFEFJRYV1yRl6oQzQOUBKvTJEegZUAV73pwgJhB4T7OwzSOhiKA4JKS3Ojo
         hjmAOFlY/a6dAho0AjZVGLmYbokNyL+GTn2P4VS4bAV101V3GsQaBlyFPh3H3FcGr+f8
         9apRzY4jhQ8sFkFY5hehI6ASZ0sVOFtRv7GXRwcqNoFYeANxvDkdm7QI+KqUCgmlawvt
         LIuyOhwGZTlCAAh2YbTG+2pqO4Wgk2MGUgBZJWzNaDVw+5z9JHQyp++gztJ9a8JsacJo
         zsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717256151; x=1717860951;
        h=in-reply-to:from:content-language:references:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nQRsysKCgvjmkjOZa6wjJ/SwXDEnm0pXfJJJiwOGgVk=;
        b=eErMJ1idFHyH2JWE+O/mPO4OMKdicO6lnFI5HUyh7hARuPMI6PTr6WROaOoAaBqshp
         mnyIV2y5ArXM4sfLKwtob1tke2/TV7MPsrE5vvcKaQlmTzxOtkQgyaoP4Rvl4i2ZVDui
         sBeXvSK/7YBpUYwmxH6xrGmZYYgdYvzP2DQrid4Sh3DEDRHIRILdZ+kqRmL36xVJyALN
         jSI+FnV7Nd+jwLk3uO6oBSJllXxilXl/FMA2Ddbrz9iTnlCGuXTNFeAMYVLSWqKDZY7B
         X4OfV2mC9kX6sxLgO9PPuje2XHohAUA7lrLqehktCKOqPsx9sgEFFmFOSFASX6Dyep8h
         d+ew==
X-Forwarded-Encrypted: i=1; AJvYcCX499XmZAXNPv2XIds8VUtCEnDawtBGt0aqAb5gCEbPf6THuHaueNnt7zhY8FKG9nIBNRSE5Bt1BFnTpzS7zWauBay/1pLi8D4=
X-Gm-Message-State: AOJu0Yxg0NUFotXXj+k5DMdI0rM3mhXF6muJZGtWegJ7SPUzi4xK3UXk
	Bf2oFz4SwMPyYacDIm2BiSGXVdKT6hGVLGVih/zZU42MqEDE0AFXDKn7Jev27Mg=
X-Google-Smtp-Source: AGHT+IH8ipffuwPLhTBkINjjPjwXQRBSE88UChrlYbX/oEJyD1KIeCzDi7bLKEgC2F3Co4UazfjjtA==
X-Received: by 2002:a17:90a:3d46:b0:2bd:feb6:b09b with SMTP id 98e67ed59e1d1-2c1dc56c446mr4498685a91.1.1717256151030;
        Sat, 01 Jun 2024 08:35:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a77afb08sm5359031a91.43.2024.06.01.08.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jun 2024 08:35:50 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------ejJ0h74Dy2W146GKBqFL3Cwx"
Message-ID: <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
Date: Sat, 1 Jun 2024 09:35:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise/fadvise 32-bit length
To: Stefan <source@s.muenzel.net>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>

This is a multi-part message in MIME format.
--------------ejJ0h74Dy2W146GKBqFL3Cwx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/24 9:22 AM, Stefan wrote:
> On 1/6/2024 17:05, Jens Axboe wrote:
>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>> io_uring uses the __u32 len field in order to pass the length to
>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>> 64bit platforms.
>>>>
>>>> When using liburing, the length is silently truncated to 32bits (so
>>>> 8GB length would become zero, which has a different meaning of "until
>>>> the end of the file" for fadvise).
>>>>
>>>> If my understanding is correct, we could fix this by introducing new
>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>> of the length field for length.
>>>
>>> We probably just want to introduce a flag and ensure that older stable
>>> kernels check it, and then use a 64-bit field for it when the flag is
>>> set.
>>
>> I think this should do it on the kernel side, as we already check these
>> fields and return -EINVAL as needed. Should also be trivial to backport.
>> Totally untested... Might want a FEAT flag for this, or something where
>> it's detectable, to make the liburing change straight forward.
>>
>>
>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>> index 7085804c513c..cb7b881665e5 100644
>> --- a/io_uring/advise.c
>> +++ b/io_uring/advise.c
>> @@ -17,14 +17,14 @@
>>   struct io_fadvise {
>>       struct file            *file;
>>       u64                offset;
>> -    u32                len;
>> +    u64                len;
>>       u32                advice;
>>   };
>>     struct io_madvise {
>>       struct file            *file;
>>       u64                addr;
>> -    u32                len;
>> +    u64                len;
>>       u32                advice;
>>   };
>>   @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>       struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>   -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>           return -EINVAL;
>>         ma->addr = READ_ONCE(sqe->addr);
>> -    ma->len = READ_ONCE(sqe->len);
>> +    ma->len = READ_ONCE(sqe->off);
>> +    if (!ma->len)
>> +        ma->len = READ_ONCE(sqe->len);
>>       ma->advice = READ_ONCE(sqe->fadvise_advice);
>>       req->flags |= REQ_F_FORCE_ASYNC;
>>       return 0;
>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>       struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>   -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>           return -EINVAL;
>>         fa->offset = READ_ONCE(sqe->off);
>> -    fa->len = READ_ONCE(sqe->len);
>> +    fa->len = READ_ONCE(sqe->addr);
>> +    if (!fa->len)
>> +        fa->len = READ_ONCE(sqe->len);
>>       fa->advice = READ_ONCE(sqe->fadvise_advice);
>>       if (io_fadvise_force_async(fa))
>>           req->flags |= REQ_F_FORCE_ASYNC;
>>
> 
> 
> If we want to have the length in the same field in both *ADVISE
> operations, we can put a flag in splice_fd_in/optlen.

I don't think that part matters that much.

> Maybe the explicit flag is a bit clearer for users of the API
> compared to the implicit flag when setting sqe->len to zero?

We could go either way. The unused fields returning -EINVAL if set right
now can serve as the flag field - if you have it set, then that is your
length. If not, then the old style is the length. That's the approach I
took, rather than add an explicit flag to it. Existing users that would
set the 64-bit length fields would get -EINVAL already. And since the
normal flags field is already used for advice flags, I'd prefer just
using the existing 64-bit zero fields for it rather than add a flag in
an odd location. Would also make for an easier backport to stable.

But don't feel that strongly about that part.

Attached kernel patch with FEAT added, and liburing patch with 64
versions added.

-- 
Jens Axboe

--------------ejJ0h74Dy2W146GKBqFL3Cwx
Content-Type: text/plain; charset=UTF-8; name="kpatch.txt"
Content-Disposition: attachment; filename="kpatch.txt"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2lvX3VyaW5nLmgKaW5kZXggOTk0YmY3YWYwZWZlLi43M2E4YmFiYTM0Mjgg
MTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oCisrKyBiL2luY2x1
ZGUvdWFwaS9saW51eC9pb191cmluZy5oCkBAIC01NDAsNiArNTQwLDcgQEAgc3RydWN0IGlv
X3VyaW5nX3BhcmFtcyB7CiAjZGVmaW5lIElPUklOR19GRUFUX0xJTktFRF9GSUxFCQkoMVUg
PDwgMTIpCiAjZGVmaW5lIElPUklOR19GRUFUX1JFR19SRUdfUklORwkoMVUgPDwgMTMpCiAj
ZGVmaW5lIElPUklOR19GRUFUX1JFQ1ZTRU5EX0JVTkRMRQkoMVUgPDwgMTQpCisjZGVmaW5l
IElPUklOR19GRUFUXzY0QklUX0FEVklTRQkoMVUgPDwgMTUpCiAKIC8qCiAgKiBpb191cmlu
Z19yZWdpc3RlcigyKSBvcGNvZGVzIGFuZCBhcmd1bWVudHMKZGlmZiAtLWdpdCBhL2lvX3Vy
aW5nL2FkdmlzZS5jIGIvaW9fdXJpbmcvYWR2aXNlLmMKaW5kZXggNzA4NTgwNGM1MTNjLi5j
YjdiODgxNjY1ZTUgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2FkdmlzZS5jCisrKyBiL2lvX3Vy
aW5nL2FkdmlzZS5jCkBAIC0xNywxNCArMTcsMTQgQEAKIHN0cnVjdCBpb19mYWR2aXNlIHsK
IAlzdHJ1Y3QgZmlsZQkJCSpmaWxlOwogCXU2NAkJCQlvZmZzZXQ7Ci0JdTMyCQkJCWxlbjsK
Kwl1NjQJCQkJbGVuOwogCXUzMgkJCQlhZHZpY2U7CiB9OwogCiBzdHJ1Y3QgaW9fbWFkdmlz
ZSB7CiAJc3RydWN0IGZpbGUJCQkqZmlsZTsKIAl1NjQJCQkJYWRkcjsKLQl1MzIJCQkJbGVu
OworCXU2NAkJCQlsZW47CiAJdTMyCQkJCWFkdmljZTsKIH07CiAKQEAgLTMzLDExICszMywx
MyBAQCBpbnQgaW9fbWFkdmlzZV9wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBjb25zdCBz
dHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpCiAjaWYgZGVmaW5lZChDT05GSUdfQURWSVNFX1NZ
U0NBTExTKSAmJiBkZWZpbmVkKENPTkZJR19NTVUpCiAJc3RydWN0IGlvX21hZHZpc2UgKm1h
ID0gaW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0IGlvX21hZHZpc2UpOwogCi0JaWYgKHNx
ZS0+YnVmX2luZGV4IHx8IHNxZS0+b2ZmIHx8IHNxZS0+c3BsaWNlX2ZkX2luKQorCWlmIChz
cWUtPmJ1Zl9pbmRleCB8fCBzcWUtPnNwbGljZV9mZF9pbikKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKIAltYS0+YWRkciA9IFJFQURfT05DRShzcWUtPmFkZHIpOwotCW1hLT5sZW4gPSBSRUFE
X09OQ0Uoc3FlLT5sZW4pOworCW1hLT5sZW4gPSBSRUFEX09OQ0Uoc3FlLT5vZmYpOworCWlm
ICghbWEtPmxlbikKKwkJbWEtPmxlbiA9IFJFQURfT05DRShzcWUtPmxlbik7CiAJbWEtPmFk
dmljZSA9IFJFQURfT05DRShzcWUtPmZhZHZpc2VfYWR2aWNlKTsKIAlyZXEtPmZsYWdzIHw9
IFJFUV9GX0ZPUkNFX0FTWU5DOwogCXJldHVybiAwOwpAQCAtNzgsMTEgKzgwLDEzIEBAIGlu
dCBpb19mYWR2aXNlX3ByZXAoc3RydWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBp
b191cmluZ19zcWUgKnNxZSkKIHsKIAlzdHJ1Y3QgaW9fZmFkdmlzZSAqZmEgPSBpb19raW9j
Yl90b19jbWQocmVxLCBzdHJ1Y3QgaW9fZmFkdmlzZSk7CiAKLQlpZiAoc3FlLT5idWZfaW5k
ZXggfHwgc3FlLT5hZGRyIHx8IHNxZS0+c3BsaWNlX2ZkX2luKQorCWlmIChzcWUtPmJ1Zl9p
bmRleCB8fCBzcWUtPnNwbGljZV9mZF9pbikKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAlmYS0+
b2Zmc2V0ID0gUkVBRF9PTkNFKHNxZS0+b2ZmKTsKLQlmYS0+bGVuID0gUkVBRF9PTkNFKHNx
ZS0+bGVuKTsKKwlmYS0+bGVuID0gUkVBRF9PTkNFKHNxZS0+YWRkcik7CisJaWYgKCFmYS0+
bGVuKQorCQlmYS0+bGVuID0gUkVBRF9PTkNFKHNxZS0+bGVuKTsKIAlmYS0+YWR2aWNlID0g
UkVBRF9PTkNFKHNxZS0+ZmFkdmlzZV9hZHZpY2UpOwogCWlmIChpb19mYWR2aXNlX2ZvcmNl
X2FzeW5jKGZhKSkKIAkJcmVxLT5mbGFncyB8PSBSRVFfRl9GT1JDRV9BU1lOQzsKZGlmZiAt
LWdpdCBhL2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jCmluZGV4
IDgxNmU5M2U3Zjk0OS4uNzY4OTZkYjczOTBkIDEwMDY0NAotLS0gYS9pb191cmluZy9pb191
cmluZy5jCisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKQEAgLTM1NjksNyArMzU2OSw3IEBA
IHN0YXRpYyBfX2NvbGQgaW50IGlvX3VyaW5nX2NyZWF0ZSh1bnNpZ25lZCBlbnRyaWVzLCBz
dHJ1Y3QgaW9fdXJpbmdfcGFyYW1zICpwLAogCQkJSU9SSU5HX0ZFQVRfRVhUX0FSRyB8IElP
UklOR19GRUFUX05BVElWRV9XT1JLRVJTIHwKIAkJCUlPUklOR19GRUFUX1JTUkNfVEFHUyB8
IElPUklOR19GRUFUX0NRRV9TS0lQIHwKIAkJCUlPUklOR19GRUFUX0xJTktFRF9GSUxFIHwg
SU9SSU5HX0ZFQVRfUkVHX1JFR19SSU5HIHwKLQkJCUlPUklOR19GRUFUX1JFQ1ZTRU5EX0JV
TkRMRTsKKwkJCUlPUklOR19GRUFUX1JFQ1ZTRU5EX0JVTkRMRSB8IElPUklOR19GRUFUXzY0
QklUX0FEVklTRTsKIAogCWlmIChjb3B5X3RvX3VzZXIocGFyYW1zLCBwLCBzaXplb2YoKnAp
KSkgewogCQlyZXQgPSAtRUZBVUxUOwo=
--------------ejJ0h74Dy2W146GKBqFL3Cwx
Content-Type: text/plain; charset=UTF-8; name="liburing.txt"
Content-Disposition: attachment; filename="liburing.txt"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3NyYy9pbmNsdWRlL2xpYnVyaW5nLmggYi9zcmMvaW5jbHVkZS9saWJ1
cmluZy5oCmluZGV4IDBhMDIzNjQ1NDBhOC4uNmY2ZDlkYjJmMDhhIDEwMDY0NAotLS0gYS9z
cmMvaW5jbHVkZS9saWJ1cmluZy5oCisrKyBiL3NyYy9pbmNsdWRlL2xpYnVyaW5nLmgKQEAg
LTc2NCw2ICs3NjQsMjEgQEAgSU9VUklOR0lOTElORSB2b2lkIGlvX3VyaW5nX3ByZXBfbWFk
dmlzZShzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUsIHZvaWQgKmFkZHIsCiAJc3FlLT5mYWR2
aXNlX2FkdmljZSA9IChfX3UzMikgYWR2aWNlOwogfQogCitJT1VSSU5HSU5MSU5FIHZvaWQg
aW9fdXJpbmdfcHJlcF9mYWR2aXNlNjQoc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlLCBpbnQg
ZmQsCisJCQkJCSBfX3U2NCBvZmZzZXQsIG9mZl90IGxlbiwgaW50IGFkdmljZSkKK3sKKwlp
b191cmluZ19wcmVwX3J3KElPUklOR19PUF9GQURWSVNFLCBzcWUsIGZkLCBOVUxMLCAwLCBv
ZmZzZXQpOworCXNxZS0+YWRkciA9IGxlbjsKKwlzcWUtPmZhZHZpc2VfYWR2aWNlID0gKF9f
dTMyKSBhZHZpY2U7Cit9CisKK0lPVVJJTkdJTkxJTkUgdm9pZCBpb191cmluZ19wcmVwX21h
ZHZpc2U2NChzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUsIHZvaWQgKmFkZHIsCisJCQkJCSBv
ZmZfdCBsZW5ndGgsIGludCBhZHZpY2UpCit7CisJaW9fdXJpbmdfcHJlcF9ydyhJT1JJTkdf
T1BfTUFEVklTRSwgc3FlLCAtMSwgYWRkciwgMCwgbGVuZ3RoKTsKKwlzcWUtPmZhZHZpc2Vf
YWR2aWNlID0gKF9fdTMyKSBhZHZpY2U7Cit9CisKIElPVVJJTkdJTkxJTkUgdm9pZCBpb191
cmluZ19wcmVwX3NlbmQoc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlLCBpbnQgc29ja2ZkLAog
CQkJCSAgICAgIGNvbnN0IHZvaWQgKmJ1Ziwgc2l6ZV90IGxlbiwgaW50IGZsYWdzKQogewpk
aWZmIC0tZ2l0IGEvc3JjL2luY2x1ZGUvbGlidXJpbmcvaW9fdXJpbmcuaCBiL3NyYy9pbmNs
dWRlL2xpYnVyaW5nL2lvX3VyaW5nLmgKaW5kZXggOTMzMDczM2VmZDY2Li4xMmZiZmNmM2U2
ODkgMTAwNjQ0Ci0tLSBhL3NyYy9pbmNsdWRlL2xpYnVyaW5nL2lvX3VyaW5nLmgKKysrIGIv
c3JjL2luY2x1ZGUvbGlidXJpbmcvaW9fdXJpbmcuaApAQCAtNTM3LDYgKzUzNyw3IEBAIHN0
cnVjdCBpb191cmluZ19wYXJhbXMgewogI2RlZmluZSBJT1JJTkdfRkVBVF9MSU5LRURfRklM
RQkJKDFVIDw8IDEyKQogI2RlZmluZSBJT1JJTkdfRkVBVF9SRUdfUkVHX1JJTkcJKDFVIDw8
IDEzKQogI2RlZmluZSBJT1JJTkdfRkVBVF9SRUNWU0VORF9CVU5ETEUJKDFVIDw8IDE0KQor
I2RlZmluZSBJT1JJTkdfRkVBVF82NEJJVF9BRFZJU0UJKDFVIDw8IDE1KQogCiAvKgogICog
aW9fdXJpbmdfcmVnaXN0ZXIoMikgb3Bjb2RlcyBhbmQgYXJndW1lbnRzCmRpZmYgLS1naXQg
YS9zcmMvbGlidXJpbmctZmZpLm1hcCBiL3NyYy9saWJ1cmluZy1mZmkubWFwCmluZGV4IDNi
ZTQ4ZDAyYWM4Ni4uMGU0YmQ5ZDFkNzhkIDEwMDY0NAotLS0gYS9zcmMvbGlidXJpbmctZmZp
Lm1hcAorKysgYi9zcmMvbGlidXJpbmctZmZpLm1hcApAQCAtMTk5LDQgKzE5OSw2IEBAIExJ
QlVSSU5HXzIuNiB7CiB9IExJQlVSSU5HXzIuNTsKIAogTElCVVJJTkdfMi43IHsKKwkJaW9f
dXJpbmdfcHJlcF9mYWR2aXNlNjQ7CisJCWlvX3VyaW5nX3ByZXBfbWFkdmlzZTY0OwogfSBM
SUJVUklOR18yLjY7Cg==

--------------ejJ0h74Dy2W146GKBqFL3Cwx--


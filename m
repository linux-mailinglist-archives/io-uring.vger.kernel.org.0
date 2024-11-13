Return-Path: <io-uring+bounces-4647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A73139C7134
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 14:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 352E71F21C0E
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 13:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB03200135;
	Wed, 13 Nov 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsRt+HSd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2265E1E0DBB;
	Wed, 13 Nov 2024 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505359; cv=none; b=anlP6jUzmHaxxVGf1nV71eHvUukQtrKKjXWOhm0+HF0jBncaZ60Su11gZM+nS24+OUL+AilToS4+Y5vJZfsHJ/ZHJ6XlpzcdbQRZhsrOh/aXarbqN7Qp6q0GcGMh0KQ3zWl3/CtVHywTsWJEdpRoLQ7vgij5IYXp0kIvfbl/eG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505359; c=relaxed/simple;
	bh=ZHO3TW8UuP/0k2HV/m0/53ox9/+jzGlBqqnXmSGJvtI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=nkXJFFzkZquxXozzgyT6P/SbuUu8VV8ktaz1Oezmv6T5hgL3RY15VYaDNC7NKt7DNSwoyn1k8zdqAZHMEyOM/U52Gq61Gp4moobl1Gn8y/PBrx8iq6L1Q2xbEBBmagtLVpyjBQX6N3kyFyuw4xKev9NNddWMXHQyNEj+2x79B74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LsRt+HSd; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5cf6f7ee970so667011a12.3;
        Wed, 13 Nov 2024 05:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731505355; x=1732110155; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lcx7iIFB0kI/xOgdylVqxZSeRdMB0IY7wD+28otgglI=;
        b=LsRt+HSdM7Zpb8ZvRt3ATZqq4oBLnh0phNN4COeZ5orp9Y0UbQGgC3NLMHeBK6WH8I
         ih9Cg5uIYSrDnLyeKLegiPSVpVy0w/aCuOSPswV4UtUdUoXa3GT4+Ekc0JzZrTzmdHht
         r6AjZsX8yhcUeqQjzUS7fykWMKgHGRywFid4PUV/6sN9PBYVOBAfNNxQkUonoeBSsJ52
         ogSVcEwFOV/xMdQWgFXxJx+mzCNMsG8QjT2wEFr+cCdTODDc/VeWDEzvgRd2azdEW5C6
         zCKZJh0BcTKu1USpX4BuqRofMohKUa42uYzrig+dy/ReZOkvpuitNchXetcawtL09QJt
         Te9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731505355; x=1732110155;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lcx7iIFB0kI/xOgdylVqxZSeRdMB0IY7wD+28otgglI=;
        b=TFHDp7py7rlHNJWpkztarDu7XDsaPxEGT3uXH4KpcWvA3pd7bEsr6b+W0h9bdYjY26
         DVLAQDOQwaBmsOrBtDItnyS5R4yOIwo5vkcP1dlPF5NKEZhJ74cdRaXq4QDBuUNu3nYZ
         r1is8ygE7Soq1Bfv+tNFQTB1U9Ycix60m8KgYjyq4DBWYY4Y5BAwFvPywbS8Zorkk06a
         13/PVL1PjX7Z/XbSNA+RxNnmTbLi5QyjIswxq5h2bUSkx3TcJvlnDMvDzC9H5pX2Earc
         t7NcKE8ADLf+BIoAy0+Gp6pr+2nxwlcsJYa3q9daULmqXDekPcvF5Z3TxsB1cjt0Vfh9
         4LhQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+hmzZSlXs7d8uZKYClRJPOdzhLLXkVIGN69C8T67v/SCc/6b7Rh8spScdT/ZYmeduK1osVl1e3lzjZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNBOCX+Uqs79MveURkPJFV8ebDXTtEQX842Uc3KS7to7yGKqOY
	5WHddvh9h4ggkytIyjIj/p+txjDtt2JKbuRDXoJUyief3S5MOSCO
X-Google-Smtp-Source: AGHT+IGu36OgIURULdZzSRFpH9EWz3Y4e1u00mjdb4cOs7Nr0xzsTSyE6ad0kjfsmnR4FyEn+8tH1g==
X-Received: by 2002:a05:6402:42c6:b0:5c4:24c2:43e0 with SMTP id 4fb4d7f45d1cf-5cf4f351c7bmr5869126a12.13.1731505355005;
        Wed, 13 Nov 2024 05:42:35 -0800 (PST)
Received: from [192.168.42.17] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03c4edd8sm7207696a12.71.2024.11.13.05.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 05:42:34 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------q0liBxCIfPPClYaelhI7qduZ"
Message-ID: <f3a83b6a-c4b9-4933-998d-ebd1d09e3405@gmail.com>
Date: Wed, 13 Nov 2024 13:43:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH V10 0/12] io_uring: support group buffer & ublk
 zc
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
 <173101830487.993487.13218873496602462534.b4-ty@kernel.dk>
 <b0004544-91f7-47b8-a8d6-da7c6e925883@kernel.dk> <ZzKm_lN_1U_u6St7@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZzKm_lN_1U_u6St7@fedora>

This is a multi-part message in MIME format.
--------------q0liBxCIfPPClYaelhI7qduZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 00:53, Ming Lei wrote:
> On Thu, Nov 07, 2024 at 03:25:59PM -0700, Jens Axboe wrote:
>> On 11/7/24 3:25 PM, Jens Axboe wrote:
...
> Hi Jens,
> 
> Any comment on the rest of the series?

Ming, it's dragging on because it's over complicated. I very much want
it to get to some conclusion, get it merged and move on, and I strongly
believe Jens shares the sentiment on getting the thing done.

Please, take the patches attached, adjust them to your needs and put
ublk on top. Or tell if there is a strong reason why it doesn't work.
The implementation is very simple and doesn't need almost anything
from io_uring, it's low risk and we can merge in no time.

If you can't cache the allocation in ublk, io_uring can add a cache.
If ublk needs more space and cannot embed the structure, we can add
a "private" pointer into io_mapped_ubuf. If it needs to check the IO
direction, we can add that as well (though I have doubts you really need
it, read-only might makes sense, write-only not so much). We'll also
merge Jens' patch allowing to remove a buffer with a request.

-- 
Pavel Begunkov
--------------q0liBxCIfPPClYaelhI7qduZ
Content-Type: text/x-patch; charset=UTF-8;
 name="io_uring-leased-buffers.patch"
Content-Disposition: attachment; filename="io_uring-leased-buffers.patch"
Content-Transfer-Encoding: base64

RnJvbSA3OGE5YzhhM2I5ZDU5ZTc0NjVkNmMxNTgyODNhNTMxYTIyMWZhM2IyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpEYXRlOiBUdWUsIDEyIE5vdiAyMDI0IDIyOjU4OjE4ICswMDAw
ClN1YmplY3Q6IFtQQVRDSCAxLzRdIGlvX3VyaW5nOiBleHBvcnQgaW9fbWFwcGVkX3VidWYg
ZGVmaW5pdGlvbgoKLS0tCiBpbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2tidWYuaCB8IDE5ICsr
KysrKysrKysrKysrKysrKysKIGlvX3VyaW5nL3JzcmMuaCAgICAgICAgICAgICAgIHwgMTIg
KystLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDEwIGRl
bGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvaW9fdXJpbmcv
a2J1Zi5oCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pb191cmluZy9rYnVmLmggYi9p
bmNsdWRlL2xpbnV4L2lvX3VyaW5nL2tidWYuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRl
eCAwMDAwMDAwMDAwMDAuLmEzMjU3OGRmM2Q4ZQotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1
ZGUvbGludXgvaW9fdXJpbmcva2J1Zi5oCkBAIC0wLDAgKzEsMTkgQEAKKy8qIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVyICovCisjaWZuZGVmIF9MSU5VWF9J
T19VUklOR19LQlVGX0gKKyNkZWZpbmUgX0xJTlVYX0lPX1VSSU5HX0tCVUZfSAorCisjaW5j
bHVkZSA8dWFwaS9saW51eC9pb191cmluZy5oPgorI2luY2x1ZGUgPGxpbnV4L2lvX3VyaW5n
X3R5cGVzLmg+CisjaW5jbHVkZSA8bGludXgvYnZlYy5oPgorCitzdHJ1Y3QgaW9fbWFwcGVk
X3VidWYgeworCXU2NAkJdWJ1ZjsKKwl1bnNpZ25lZCBpbnQJbGVuOworCXVuc2lnbmVkIGlu
dAlucl9idmVjczsKKwl1bnNpZ25lZCBpbnQgICAgZm9saW9fc2hpZnQ7CisJcmVmY291bnRf
dAlyZWZzOworCXVuc2lnbmVkIGxvbmcJYWNjdF9wYWdlczsKKwlzdHJ1Y3QgYmlvX3ZlYwli
dmVjW10gX19jb3VudGVkX2J5KG5yX2J2ZWNzKTsKK307CisKKyNlbmRpZgpcIE5vIG5ld2xp
bmUgYXQgZW5kIG9mIGZpbGUKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3JzcmMuaCBiL2lvX3Vy
aW5nL3JzcmMuaAppbmRleCA3YTQ2NjhkZWFhMWEuLjg4NWNjZWNhZGUwOCAxMDA2NDQKLS0t
IGEvaW9fdXJpbmcvcnNyYy5oCisrKyBiL2lvX3VyaW5nL3JzcmMuaApAQCAtMiw2ICsyLDgg
QEAKICNpZm5kZWYgSU9VX1JTUkNfSAogI2RlZmluZSBJT1VfUlNSQ19ICiAKKyNpbmNsdWRl
IDxsaW51eC9pb191cmluZy9rYnVmLmg+CisKICNkZWZpbmUgSU9fTk9ERV9BTExPQ19DQUNI
RV9NQVggMzIKIAogI2RlZmluZSBJT19SU1JDX1RBR19UQUJMRV9TSElGVAkoUEFHRV9TSElG
VCAtIDMpCkBAIC0yNCwxNiArMjYsNiBAQCBzdHJ1Y3QgaW9fcnNyY19ub2RlIHsKIAl9Owog
fTsKIAotc3RydWN0IGlvX21hcHBlZF91YnVmIHsKLQl1NjQJCXVidWY7Ci0JdW5zaWduZWQg
aW50CWxlbjsKLQl1bnNpZ25lZCBpbnQJbnJfYnZlY3M7Ci0JdW5zaWduZWQgaW50ICAgIGZv
bGlvX3NoaWZ0OwotCXJlZmNvdW50X3QJcmVmczsKLQl1bnNpZ25lZCBsb25nCWFjY3RfcGFn
ZXM7Ci0Jc3RydWN0IGJpb192ZWMJYnZlY1tdIF9fY291bnRlZF9ieShucl9idmVjcyk7Ci19
OwotCiBzdHJ1Y3QgaW9faW11X2ZvbGlvX2RhdGEgewogCS8qIEhlYWQgZm9saW8gY2FuIGJl
IHBhcnRpYWxseSBpbmNsdWRlZCBpbiB0aGUgZml4ZWQgYnVmICovCiAJdW5zaWduZWQgaW50
CW5yX3BhZ2VzX2hlYWQ7Ci0tIAoyLjQ2LjAKCgpGcm9tIDY4MzljYTFjYTk0YTg5ZWMxMTM2
MmYzMmFmMjJlMmMwY2ZkZmFhODEgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCkRhdGU6IFR1
ZSwgMTIgTm92IDIwMjQgMjM6MTI6MTUgKzAwMDAKU3ViamVjdDogW1BBVENIIDIvNF0gaW9f
dXJpbmc6IGFkZCBpb19tYXBwZWRfdWJ1ZiByZWxlYXNlIGNhbGxiYWNrCgotLS0KIGluY2x1
ZGUvbGludXgvaW9fdXJpbmcva2J1Zi5oIHwgMTAgKysrKysrKysrKwogaW9fdXJpbmcvcnNy
Yy5jICAgICAgICAgICAgICAgfCAgNiArKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
aW9fdXJpbmcva2J1Zi5oIGIvaW5jbHVkZS9saW51eC9pb191cmluZy9rYnVmLmgKaW5kZXgg
YTMyNTc4ZGYzZDhlLi5hYTNlZWFhMWFjMjUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgv
aW9fdXJpbmcva2J1Zi5oCisrKyBiL2luY2x1ZGUvbGludXgvaW9fdXJpbmcva2J1Zi5oCkBA
IC0xMyw3ICsxMywxNyBAQCBzdHJ1Y3QgaW9fbWFwcGVkX3VidWYgewogCXVuc2lnbmVkIGlu
dCAgICBmb2xpb19zaGlmdDsKIAlyZWZjb3VudF90CXJlZnM7CiAJdW5zaWduZWQgbG9uZwlh
Y2N0X3BhZ2VzOworCXZvaWQgKCpyZWxlYXNlKShzdHJ1Y3QgaW9fbWFwcGVkX3VidWYgKik7
CiAJc3RydWN0IGJpb192ZWMJYnZlY1tdIF9fY291bnRlZF9ieShucl9idmVjcyk7CiB9Owog
CitzdGF0aWMgaW5saW5lIHZvaWQgaW91X2luaXRfa2J1ZihzdHJ1Y3QgaW9fbWFwcGVkX3Vi
dWYgKmJ1ZiwKKwkJCQkgdm9pZCAoKnJlbGVhc2UpKHN0cnVjdCBpb19tYXBwZWRfdWJ1ZiAq
KSkKK3sKKwlyZWZjb3VudF9zZXQoJmJ1Zi0+cmVmcywgMSk7CisJYnVmLT5hY2N0X3BhZ2Vz
ID0gMDsKKwlidWYtPnVidWYgPSAwOworCWJ1Zi0+cmVsZWFzZSA9IHJlbGVhc2U7Cit9CisK
ICNlbmRpZgpcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUKZGlmZiAtLWdpdCBhL2lvX3Vy
aW5nL3JzcmMuYyBiL2lvX3VyaW5nL3JzcmMuYwppbmRleCBhZGFhZTg2MzA5MzIuLjg0ZWE1
YTQ4MDA1OCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvcnNyYy5jCisrKyBiL2lvX3VyaW5nL3Jz
cmMuYwpAQCAtMTEwLDYgKzExMCwxMCBAQCBzdGF0aWMgdm9pZCBpb19idWZmZXJfdW5tYXAo
c3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVjdCBpb19yc3JjX25vZGUgKm5vZGUpCiAK
IAkJaWYgKCFyZWZjb3VudF9kZWNfYW5kX3Rlc3QoJmltdS0+cmVmcykpCiAJCQlyZXR1cm47
CisJCWlmIChpbXUtPnJlbGVhc2UpIHsKKwkJCWltdS0+cmVsZWFzZShpbXUpOworCQkJcmV0
dXJuOworCQl9CiAJCWZvciAoaSA9IDA7IGkgPCBpbXUtPm5yX2J2ZWNzOyBpKyspCiAJCQl1
bnBpbl91c2VyX3BhZ2UoaW11LT5idmVjW2ldLmJ2X3BhZ2UpOwogCQlpZiAoaW11LT5hY2N0
X3BhZ2VzKQpAQCAtNzYyLDYgKzc2Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgaW9fcnNyY19ub2Rl
ICppb19zcWVfYnVmZmVyX3JlZ2lzdGVyKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LAogCX0K
IAogCXNpemUgPSBpb3YtPmlvdl9sZW47CisJaW91X2luaXRfa2J1ZihpbXUsIE5VTEwpOwog
CS8qIHN0b3JlIG9yaWdpbmFsIGFkZHJlc3MgZm9yIGxhdGVyIHZlcmlmaWNhdGlvbiAqLwog
CWltdS0+dWJ1ZiA9ICh1bnNpZ25lZCBsb25nKSBpb3YtPmlvdl9iYXNlOwogCWltdS0+bGVu
ID0gaW92LT5pb3ZfbGVuOwpAQCAtNzY5LDcgKzc3NCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaW9f
cnNyY19ub2RlICppb19zcWVfYnVmZmVyX3JlZ2lzdGVyKHN0cnVjdCBpb19yaW5nX2N0eCAq
Y3R4LAogCWltdS0+Zm9saW9fc2hpZnQgPSBQQUdFX1NISUZUOwogCWlmIChjb2FsZXNjZWQp
CiAJCWltdS0+Zm9saW9fc2hpZnQgPSBkYXRhLmZvbGlvX3NoaWZ0OwotCXJlZmNvdW50X3Nl
dCgmaW11LT5yZWZzLCAxKTsKIAlvZmYgPSAodW5zaWduZWQgbG9uZykgaW92LT5pb3ZfYmFz
ZSAmICgoMVVMIDw8IGltdS0+Zm9saW9fc2hpZnQpIC0gMSk7CiAJbm9kZS0+YnVmID0gaW11
OwogCXJldCA9IDA7Ci0tIAoyLjQ2LjAKCgpGcm9tIDU1YjU2ZWQ4YzVjYjU4NzI3YzdkYWFi
ZDFlNTZlNmYxOTQ3NDllN2YgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCkRhdGU6IFR1ZSwg
MTIgTm92IDIwMjQgMjM6MzM6MjQgKzAwMDAKU3ViamVjdDogW1BBVENIIDMvNF0gaW9fdXJp
bmc6IGFkZCBhIGhlbHBlciBmb3IgbGVhc2luZyBhIGJ1ZmZlcgoKLS0tCiBpbmNsdWRlL2xp
bnV4L2lvX3VyaW5nL2tidWYuaCB8IDIzICsrKysrKysrKysrKysrKysrKysrKysrCiBpb191
cmluZy9yc3JjLmMgICAgICAgICAgICAgICB8IDMyICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDU1IGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2tidWYuaCBiL2luY2x1ZGUvbGludXgvaW9f
dXJpbmcva2J1Zi5oCmluZGV4IGFhM2VlYWExYWMyNS4uOTFjZmNkYzY4NWNjIDEwMDY0NAot
LS0gYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2tidWYuaAorKysgYi9pbmNsdWRlL2xpbnV4
L2lvX3VyaW5nL2tidWYuaApAQCAtNCw2ICs0LDcgQEAKIAogI2luY2x1ZGUgPHVhcGkvbGlu
dXgvaW9fdXJpbmcuaD4KICNpbmNsdWRlIDxsaW51eC9pb191cmluZ190eXBlcy5oPgorI2lu
Y2x1ZGUgPGxpbnV4L2lvX3VyaW5nL2NtZC5oPgogI2luY2x1ZGUgPGxpbnV4L2J2ZWMuaD4K
IAogc3RydWN0IGlvX21hcHBlZF91YnVmIHsKQEAgLTI2LDQgKzI3LDI2IEBAIHN0YXRpYyBp
bmxpbmUgdm9pZCBpb3VfaW5pdF9rYnVmKHN0cnVjdCBpb19tYXBwZWRfdWJ1ZiAqYnVmLAog
CWJ1Zi0+cmVsZWFzZSA9IHJlbGVhc2U7CiB9CiAKKyNpZiBkZWZpbmVkKENPTkZJR19JT19V
UklORykKK2ludCBpb3VfZXhwb3J0X2tidWYoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHVu
c2lnbmVkIGlzc3VlX2ZsYWdzLAorCQkgICAgc3RydWN0IGlvX21hcHBlZF91YnVmICpidWYs
IHVuc2lnbmVkIGluZGV4KTsKKyNlbHNlCitzdGF0aWMgaW5saW5lIGludCBpb3VfZXhwb3J0
X2tidWYoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsCisJCQkJICB1bnNpZ25lZCBpc3N1ZV9m
bGFncywKKwkJCQkgIHN0cnVjdCBpb19tYXBwZWRfdWJ1ZiAqYnVmLCB1bnNpZ25lZCBpbmRl
eCkKK3sKKwlyZXR1cm4gLUVPUE5PVFNVUFA7Cit9CisjZW5kaWYKKworc3RhdGljIGlubGlu
ZSBpbnQgaW9fdXJpbmdfY21kX2V4cG9ydF9rYnVmKHN0cnVjdCBpb191cmluZ19jbWQgKmNt
ZCwKKwkJCQkJICAgdW5zaWduZWQgaXNzdWVfZmxhZ3MsCisJCQkJCSAgIHN0cnVjdCBpb19t
YXBwZWRfdWJ1ZiAqYnVmLAorCQkJCQkgICB1bnNpZ25lZCBpbmRleCkKK3sKKwlzdHJ1Y3Qg
aW9fcmluZ19jdHggKmN0eCA9IGNtZF90b19pb19raW9jYihjbWQpLT5jdHg7CisKKwlyZXR1
cm4gaW91X2V4cG9ydF9rYnVmKGN0eCwgaXNzdWVfZmxhZ3MsIGJ1ZiwgaW5kZXgpOworfQor
CiAjZW5kaWYKXCBObyBuZXdsaW5lIGF0IGVuZCBvZiBmaWxlCmRpZmYgLS1naXQgYS9pb191
cmluZy9yc3JjLmMgYi9pb191cmluZy9yc3JjLmMKaW5kZXggODRlYTVhNDgwMDU4Li4wNzg0
MmE2YTgwMjAgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3JzcmMuYworKysgYi9pb191cmluZy9y
c3JjLmMKQEAgLTc5Nyw2ICs3OTcsMzggQEAgc3RhdGljIHN0cnVjdCBpb19yc3JjX25vZGUg
KmlvX3NxZV9idWZmZXJfcmVnaXN0ZXIoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsCiAJcmV0
dXJuIG5vZGU7CiB9CiAKK3N0YXRpYyBpbnQgX19pb3VfZXhwb3J0X2tidWYoc3RydWN0IGlv
X3JpbmdfY3R4ICpjdHgsIHVuc2lnbmVkIGlzc3VlX2ZsYWdzLAorCQkJICAgICBzdHJ1Y3Qg
aW9fbWFwcGVkX3VidWYgKmJ1ZiwgdW5zaWduZWQgaWR4KQoreworCXN0cnVjdCBpb19yc3Jj
X25vZGUgKm5vZGU7CisKKwlpZiAodW5saWtlbHkoaWR4ID49IGN0eC0+YnVmX3RhYmxlLm5y
KSkgeworCQlpZiAoIWN0eC0+YnVmX3RhYmxlLm5yKQorCQkJcmV0dXJuIC1FTlhJTzsKKwkJ
cmV0dXJuIC1FSU5WQUw7CisJfQorCWlkeCA9IGFycmF5X2luZGV4X25vc3BlYyhpZHgsIGN0
eC0+YnVmX3RhYmxlLm5yKTsKKworCW5vZGUgPSBpb19yc3JjX25vZGVfYWxsb2MoY3R4LCBJ
T1JJTkdfUlNSQ19CVUZGRVIpOworCWlmICghbm9kZSkKKwkJcmV0dXJuIC1FTk9NRU07CisJ
bm9kZS0+YnVmID0gYnVmOworCWlvX3Jlc2V0X3JzcmNfbm9kZShjdHgsICZjdHgtPmJ1Zl90
YWJsZSwgaWR4KTsKKwljdHgtPmJ1Zl90YWJsZS5ub2Rlc1tpZHhdID0gbm9kZTsKKwlyZXR1
cm4gMDsKK30KKworaW50IGlvdV9leHBvcnRfa2J1ZihzdHJ1Y3QgaW9fcmluZ19jdHggKmN0
eCwgdW5zaWduZWQgaXNzdWVfZmxhZ3MsCisJCSAgICBzdHJ1Y3QgaW9fbWFwcGVkX3VidWYg
KmJ1ZiwgdW5zaWduZWQgaWR4KQoreworCWludCByZXQ7CisKKwlpb19yaW5nX3N1Ym1pdF9s
b2NrKGN0eCwgaXNzdWVfZmxhZ3MpOworCXJldCA9IF9faW91X2V4cG9ydF9rYnVmKGN0eCwg
aXNzdWVfZmxhZ3MsIGJ1ZiwgaWR4KTsKKwlpb19yaW5nX3N1Ym1pdF91bmxvY2soY3R4LCBp
c3N1ZV9mbGFncyk7CisJcmV0dXJuIHJldDsKK30KKwogaW50IGlvX3NxZV9idWZmZXJzX3Jl
Z2lzdGVyKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCB2b2lkIF9fdXNlciAqYXJnLAogCQkJ
ICAgIHVuc2lnbmVkIGludCBucl9hcmdzLCB1NjQgX191c2VyICp0YWdzKQogewotLSAKMi40
Ni4wCg==
--------------q0liBxCIfPPClYaelhI7qduZ
Content-Type: text/x-csrc; charset=UTF-8; name="leased-buffer-test.c"
Content-Disposition: attachment; filename="leased-buffer-test.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8
ZmNudGwuaD4KI2luY2x1ZGUgPGFzc2VydC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojaW5j
bHVkZSAibGlidXJpbmcuaCIKI2luY2x1ZGUgInRlc3QuaCIKCiNkZWZpbmUgQlVGX1NJWkUg
NDA5NgoKc3RhdGljIGNoYXIgYnVmW0JVRl9TSVpFXTsKc3RhdGljIGNoYXIgYnVmX3RtcFtC
VUZfU0laRV07CgpzdGF0aWMgdm9pZCBpb191cmluZ19wcmVwX215X2NtZF9sZWFzZShzdHJ1
Y3QgaW9fdXJpbmdfc3FlICpzcWUpCnsKCWlvX3VyaW5nX3ByZXBfcncoSU9SSU5HX09QX1VS
SU5HX0NNRCwgc3FlLCBmZCwgMCwgMCwgMCk7CgkvKiBUT0RPICovCgkuLi4KfQoKc3RhdGlj
IHZvaWQgZG9fc3VibWl0X3dhaXQxKHN0cnVjdCBpb191cmluZyAqcmluZykKewoJc3RydWN0
IGlvX3VyaW5nX2NxZSAqY3FlOwoJaW50IHJldDsKCglyZXQgPSBpb191cmluZ19zdWJtaXQo
cmluZyk7Cglhc3NlcnQocmV0ID09IDEpOwoJcmV0ID0gaW9fdXJpbmdfd2FpdF9jcWUocmlu
ZywgJmNxZSk7Cglhc3NlcnQocmV0ID49IDApOwoJcHJpbnRmKCJjcWUgZGF0YSAlaSByZXMg
JWlcbiIsIChpbnQpY3FlLT51c2VyX2RhdGEsIGNxZS0+cmVzKTsKCWlvX3VyaW5nX2NxZV9z
ZWVuKHJpbmcsIGNxZSk7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCnsK
CXVuc2lnbmVkIGxvbmcgYnVmX29mZnNldCA9IDA7Cgl1bnNpZ25lZCBzbG90ID0gMDsgLyog
cmVnIGJ1ZmZlciB0YWJsZSBpbmRleCAqLwoJc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOwoJ
aW50IHBpcGUxWzJdLCBwaXBlMlsyXTsKCXN0cnVjdCBpb191cmluZyByaW5nOwoJaW50IHJl
dCwgaTsKCglmb3IgKGkgPSAwOyBpIDwgQlVGX1NJWkU7IGkrKykKCQlidWZbaV0gPSAoY2hh
cilpOwoKCXJldCA9IHBpcGUocGlwZTEpOwoJYXNzZXJ0KHJldCA9PSAwKTsKCXJldCA9IHBp
cGUocGlwZTIpOwoJYXNzZXJ0KHJldCA9PSAwKTsKCglyZXQgPSBpb191cmluZ19xdWV1ZV9p
bml0KDgsICZyaW5nLCAwKTsKCWFzc2VydChyZXQgPT0gMCk7CglyZXQgPSBpb191cmluZ19y
ZWdpc3Rlcl9idWZmZXJzX3NwYXJzZSgmcmluZywgMTYpOwoJYXNzZXJ0KHJldCA+PSAwKTsK
CglyZXQgPSB3cml0ZShwaXBlMVsxXSwgYnVmLCBCVUZfU0laRSk7Cglhc3NlcnQocmV0ID09
IEJVRl9TSVpFKTsKCglzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKCWlvX3VyaW5n
X3ByZXBfbXlfY21kX2xlYXNlKHNxZSwgYmRldl9mZCwgc2xvdCk7CglzcWUtPnVzZXJfZGF0
YSA9IDE7Cglkb19zdWJtaXRfd2FpdDEoJnJpbmcpOwoKCS8vIHJlYWQgZGF0YSBpbnRvIHRo
ZSBsZWFzZWQgYnVmZmVyCglzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKCWlvX3Vy
aW5nX3ByZXBfcmVhZF9maXhlZChzcWUsIHBpcGUxWzBdLCAodm9pZCAqKWJ1Zl9vZmZzZXQs
IEJVRl9TSVpFLCAwLCBzbG90KTsKCXNxZS0+dXNlcl9kYXRhID0gMjsKCWRvX3N1Ym1pdF93
YWl0MSgmcmluZyk7CgoJLy8gd3JpdGUgZnJvbSB0aGUgbGVhc2VkIGJ1ZmZlciBpbnRvIGEg
cGlwZQoJc3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7Cglpb191cmluZ19wcmVwX3dy
aXRlX2ZpeGVkKHNxZSwgcGlwZTJbMV0sICh2b2lkICopYnVmX29mZnNldCwgQlVGX1NJWkUs
IDAsIHNsb3QpOwoJc3FlLT51c2VyX2RhdGEgPSAzOwoJZG9fc3VibWl0X3dhaXQxKCZyaW5n
KTsKCgkvLyBjaGVjayB0aGUgcmlnaHQgZGF0YSBpcyBpbiB0aGUgcGlwZQoJcmV0ID0gcmVh
ZChwaXBlMlswXSwgYnVmX3RtcCwgQlVGX1NJWkUpOwoJYXNzZXJ0KHJldCA9PSBCVUZfU0la
RSk7Cglmb3IgKGkgPSAwOyBpIDwgQlVGX1NJWkU7IGkrKykgewoJCWFzc2VydChidWZbaV0g
PT0gYnVmX3RtcFtpXSk7Cgl9CgoJc3RydWN0IGlvdmVjIGlvdmVjID0ge307CglyZXQgPSBp
b191cmluZ19yZWdpc3Rlcl9idWZmZXJzX3VwZGF0ZV90YWcoJnJpbmcsIDAsICZpb3ZlYywg
TlVMTCwgMSk7Cglhc3NlcnQocmV0ID49IDApOwoKCWlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJp
bmcpOwoJcmV0dXJuIDA7Cn0K

--------------q0liBxCIfPPClYaelhI7qduZ--


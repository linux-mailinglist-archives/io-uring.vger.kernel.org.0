Return-Path: <io-uring+bounces-4632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229579C6427
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 23:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04BE4B2C4DD
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 21:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C70321A4A3;
	Tue, 12 Nov 2024 21:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BYOt45/J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD3219E57
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 21:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731445886; cv=none; b=sR0z/fi9Fhwn7Kn7R2rVlWcb/kZLOc16/2OQvGWBkUJv4RWQRjIB07zz/5nBUtW9tr7fV2Lkux/fSviyCqT+9x3VLdQDP2OHVBIRyn0Vn5UZ3x+MMJDNWhfHi317usHP7rhIJG0iYOLggwPUM57tj9yaLjGsC6c/+q+NL7SL60Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731445886; c=relaxed/simple;
	bh=Ieb4ATFF72cbnkwnTtqsVRNutrQLMihpVNensJitd5g=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=nVH2+1/TnA0t5Je9Xjf0aRgR25PQ2tjeYgHZawiNfN33VVA9U4EGrPLaGUQh1BcU2YB3v9hxpeNfiTL1tdhbvLW8WfNl4PUV1UxqEIbdDgmC7+dWvxr77+efvx2oYVo2vBGizTU5Z1CrdzOY0dXkJP27iKSFJsZ5F9l4nXYq4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BYOt45/J; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3e6104701ffso3852755b6e.0
        for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 13:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731445882; x=1732050682; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zx/LRWZm6eL8qjaTKYYIUujDRsfpSnhIFP7//yV3oaY=;
        b=BYOt45/JhoJ3Qz4o2+4US3OWMfbSQ+iWh0XsfqBVIy78mQW7TEgRQS4WOCX0jBCIdH
         Pi/xRtFN8e18jAaIioY+yHcjHPQ5JNuT+o5XTWFZ7PcrWk9b7DwNvmxlooyOypFmHHm2
         01kKBVRuXPrSfy/yqumVG1C5yRtYSBN2uR24kvIr2IVmBzKDKg8zfTqvsJSIFyKfdPh8
         kfWsizzELjiIynbgWYTM64Nt9CrlyFNr9y+MmV87epEw4KNpuxEwjLPkN3hL5sPFqEo9
         F/ZQpgoJrGXln1kgTSpeQclhD7vNGZFJo1YJpt23Rb7o61tDf1kWBLTSEZu9SfxxyQV3
         c0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731445882; x=1732050682;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zx/LRWZm6eL8qjaTKYYIUujDRsfpSnhIFP7//yV3oaY=;
        b=igWTdxOPu0P9ERLBZW50OMMJlYdJj3A/fguw4YHhOT4K45Yv9r/wDUVneNITL/rhiO
         S1NhPrdTAwR/Kca6Ls9A+1BMTdpcEFFN+BBVWhd0dmG4WAitOMbNAejPzgv/AFf6tm1B
         6X3zgvgeIHzwxlx0ZA7EKhc5I7KlILsoi6MfrrV9vUFwDV1OZ74X5wDwt+UvMM7SmR45
         zAsFxEHa1+YXiFqSe5aJ9o3oiMHcmqwSK0LL4TVxX5rA48w9cPCmC1rnmw813rPMba2e
         mb6kOoDjcNeC38D4g5aNdO2CLgqtoV/wiOfJGPM/Q7BnsrmLIn6/4h6ll6qt4y3amJSq
         eIEg==
X-Forwarded-Encrypted: i=1; AJvYcCUdnit5dfUpMrv3E94oEX5q/plhuXNT/ccO5imrH+co8VY3YS1/8U4P+2j1pwfEKONhVn1I3/i3ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdF8VO+kLHf59xhNaGI4QLCAzFcd/lueSwrhCDnl+mkqk6ryIA
	hpqIImN5e5nMKu1h2MigaqvFo44I95fQxor/t1UWVmhB0hJXbceRElnUaSrn04oplKQsETxgtvN
	zB3E=
X-Google-Smtp-Source: AGHT+IE3+PG72U8vEqDW5BAS5/Q1VF4I2BriVUIF9TKCq/wE7mOfoMLRSM9SFb7ei2/3EaDrbXLe3Q==
X-Received: by 2002:a05:6808:4198:b0:3e7:a15c:467b with SMTP id 5614622812f47-3e7a15c4c3dmr8293700b6e.34.1731445882459;
        Tue, 12 Nov 2024 13:11:22 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7b097a634sm71050b6e.30.2024.11.12.13.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 13:11:21 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------WfQk0SteRHtz0N4R4yGwHpH4"
Message-ID: <ac7a8504-8d83-4ba9-9518-98288bbd4b52@kernel.dk>
Date: Tue, 12 Nov 2024 14:11:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded writes
From: Jens Axboe <axboe@kernel.dk>
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241112163021.1948119-1-maharmstone@fb.com>
 <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
Content-Language: en-US
In-Reply-To: <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>

This is a multi-part message in MIME format.
--------------WfQk0SteRHtz0N4R4yGwHpH4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 2:01 PM, Jens Axboe wrote:
> This is why io_kiocb->async_data exists. uring_cmd is already using that
> for the sqe, I think you'd want to add a 2nd "void *op_data" or
> something in there, and have the uring_cmd alloc cache get clear that to
> NULL and have uring_cmd alloc cache put kfree() it if it's non-NULL.
> 
> We'd also need to move the uring_cache struct into
> include/linux/io_uring_types.h so that btrfs can get to it (and probably
> rename it to something saner, uring_cmd_async_data for example).

Here are two patches that implement that basic thing on the io_uring
uring_cmd side. With that, you can then do:

> static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issue_flags)
> {
> 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> 	struct uring_cmd_async_data *data = req->async_data;
> 	struct btrfs_ioctl_encoded_io_args *args;
> 
> 	if (!data->op_data) {
> 		data->op_data = kmalloc(sizeof(*args), GFP_NOIO);
> 		if (!data->op_data)
> 			return -ENOMEM;
> 		if (copy_from_user(data->op_data, sqe_addr, sizeof(*args))
> 			return -EFAULT;
> 	}
> 	...
> }

and have it be both stable, and not need to worry about freeing it
either. Hope that helps. Totally untested...

-- 
Jens Axboe
--------------WfQk0SteRHtz0N4R4yGwHpH4
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-cmd-add-per-op-data-to-struct-io_uring_cmd_.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-cmd-add-per-op-data-to-struct-io_uring_cmd_.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBmMDYwMzg3NjQ5ODJkY2YwNDQwZTJlZWY4MDczNzAwYmVjZDgyMDNkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMTIgTm92IDIwMjQgMTQ6MDk6MTIgLTA3MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gaW9fdXJpbmcvY21kOiBhZGQgcGVyLW9wIGRhdGEgdG8gc3RydWN0IGlvX3VyaW5nX2Nt
ZF9kYXRhCgpJbiBjYXNlIGFuIG9wIGhhbmRsZXIgZm9yIC0+dXJpbmdfY21kKCkgbmVlZHMg
c3RhYmxlIHN0b3JhZ2UgZm9yIHVzZXIKZGF0YSwgaXQgY2FuIGFsbG9jYXRlIGlvX3VyaW5n
X2NtZF9kYXRhLT5vcF9kYXRhIGFuZCB1c2UgaXQgZm9yIHRoZQpkdXJhdGlvbiBvZiB0aGUg
cmVxdWVzdC4gV2hlbiB0aGUgcmVxdWVzdCBnZXRzIGNsZWFuZWQgdXAsIHVyaW5nX2NtZAp3
aWxsIGZyZWUgaXQgYXV0b21hdGljYWxseS4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2Ug
PGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oIHwg
IDEgKwogaW9fdXJpbmcvdXJpbmdfY21kLmMgICAgICAgICB8IDEzICsrKysrKysrKysrLS0K
IDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oIGIvaW5jbHVkZS9saW51
eC9pb191cmluZy9jbWQuaAppbmRleCA5NTQxYjg5MjRlODkuLmNiM2E0YzRmMjYzYyAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaAorKysgYi9pbmNsdWRlL2xp
bnV4L2lvX3VyaW5nL2NtZC5oCkBAIC0yMCw2ICsyMCw3IEBAIHN0cnVjdCBpb191cmluZ19j
bWQgewogCiBzdHJ1Y3QgaW9fdXJpbmdfY21kX2RhdGEgewogCXN0cnVjdCBpb191cmluZ19z
cWUJc3Flc1syXTsKKwl2b2lkCQkJKm9wX2RhdGE7CiB9OwogCiBzdGF0aWMgaW5saW5lIGNv
bnN0IHZvaWQgKmlvX3VyaW5nX3NxZV9jbWQoY29uc3Qgc3RydWN0IGlvX3VyaW5nX3NxZSAq
c3FlKQpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvdXJpbmdfY21kLmMgYi9pb191cmluZy91cmlu
Z19jbWQuYwppbmRleCBhN2ExMWNiNWUyMmUuLmU2NzZkYWU3M2EwZiAxMDA2NDQKLS0tIGEv
aW9fdXJpbmcvdXJpbmdfY21kLmMKKysrIGIvaW9fdXJpbmcvdXJpbmdfY21kLmMKQEAgLTIz
LDEyICsyMywxNiBAQCBzdGF0aWMgc3RydWN0IGlvX3VyaW5nX2NtZF9kYXRhICppb191cmlu
Z19hc3luY19nZXQoc3RydWN0IGlvX2tpb2NiICpyZXEpCiAKIAljYWNoZSA9IGlvX2FsbG9j
X2NhY2hlX2dldCgmY3R4LT51cmluZ19jYWNoZSk7CiAJaWYgKGNhY2hlKSB7CisJCWNhY2hl
LT5vcF9kYXRhID0gTlVMTDsKIAkJcmVxLT5mbGFncyB8PSBSRVFfRl9BU1lOQ19EQVRBOwog
CQlyZXEtPmFzeW5jX2RhdGEgPSBjYWNoZTsKIAkJcmV0dXJuIGNhY2hlOwogCX0KLQlpZiAo
IWlvX2FsbG9jX2FzeW5jX2RhdGEocmVxKSkKLQkJcmV0dXJuIHJlcS0+YXN5bmNfZGF0YTsK
KwlpZiAoIWlvX2FsbG9jX2FzeW5jX2RhdGEocmVxKSkgeworCQljYWNoZSA9IHJlcS0+YXN5
bmNfZGF0YTsKKwkJY2FjaGUtPm9wX2RhdGEgPSBOVUxMOworCQlyZXR1cm4gY2FjaGU7CisJ
fQogCXJldHVybiBOVUxMOwogfQogCkBAIC0zNyw2ICs0MSwxMSBAQCBzdGF0aWMgdm9pZCBp
b19yZXFfdXJpbmdfY2xlYW51cChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50
IGlzc3VlX2ZsYWdzKQogCXN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCA9IGlvX2tpb2Ni
X3RvX2NtZChyZXEsIHN0cnVjdCBpb191cmluZ19jbWQpOwogCXN0cnVjdCBpb191cmluZ19j
bWRfZGF0YSAqY2FjaGUgPSByZXEtPmFzeW5jX2RhdGE7CiAKKwlpZiAoY2FjaGUtPm9wX2Rh
dGEpIHsKKwkJa2ZyZWUoY2FjaGUtPm9wX2RhdGEpOworCQljYWNoZS0+b3BfZGF0YSA9IE5V
TEw7CisJfQorCiAJaWYgKGlzc3VlX2ZsYWdzICYgSU9fVVJJTkdfRl9VTkxPQ0tFRCkKIAkJ
cmV0dXJuOwogCWlmIChpb19hbGxvY19jYWNoZV9wdXQoJnJlcS0+Y3R4LT51cmluZ19jYWNo
ZSwgY2FjaGUpKSB7Ci0tIAoyLjQ1LjIKCg==
--------------WfQk0SteRHtz0N4R4yGwHpH4
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-cmd-rename-struct-uring_cache-to-io_uring_c.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-cmd-rename-struct-uring_cache-to-io_uring_c.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBmNDQ0YzllMmE2ZjEzODA0MTlhOWMxODYzZjkwNDhhZTA4YTFiNWMwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMTIgTm92IDIwMjQgMTQ6MDU6MjcgLTA3MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gaW9fdXJpbmcvY21kOiByZW5hbWUgc3RydWN0IHVyaW5nX2NhY2hlIHRvCiBpb191cmlu
Z19jbWRfZGF0YQoKSW4gcHJlcGFyYXRpb24gZm9yIG1ha2luZyB0aGlzIG1vcmUgZ2VuZXJp
Y2FsbHkgYXZhaWxhYmxlIGZvcgotPnVyaW5nX2NtZCgpIHVzYWdlIHRoYXQgbmVlZHMgc3Rh
YmxlIGNvbW1hbmQgZGF0YSwgcmVuYW1lIGl0IGFuZCBtb3ZlCml0IHRvIGlvX3VyaW5nL2Nt
ZC5oIGluc3RlYWQuCgpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwu
ZGs+Ci0tLQogaW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaCB8ICA0ICsrKysKIGlvX3Vy
aW5nL2lvX3VyaW5nLmMgICAgICAgICAgfCAgMiArLQogaW9fdXJpbmcvdXJpbmdfY21kLmMg
ICAgICAgICB8IDEwICsrKysrLS0tLS0KIGlvX3VyaW5nL3VyaW5nX2NtZC5oICAgICAgICAg
fCAgNCAtLS0tCiA0IGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmggYi9p
bmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oCmluZGV4IDU3OGEzZmRmNWM3MS4uOTU0MWI4
OTI0ZTg5IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oCisrKyBi
L2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgKQEAgLTE4LDYgKzE4LDEwIEBAIHN0cnVj
dCBpb191cmluZ19jbWQgewogCXU4CQlwZHVbMzJdOyAvKiBhdmFpbGFibGUgaW5saW5lIGZv
ciBmcmVlIHVzZSAqLwogfTsKIAorc3RydWN0IGlvX3VyaW5nX2NtZF9kYXRhIHsKKwlzdHJ1
Y3QgaW9fdXJpbmdfc3FlCXNxZXNbMl07Cit9OworCiBzdGF0aWMgaW5saW5lIGNvbnN0IHZv
aWQgKmlvX3VyaW5nX3NxZV9jbWQoY29uc3Qgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlKQog
ewogCXJldHVybiBzcWUtPmNtZDsKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL2lvX3VyaW5nLmMg
Yi9pb191cmluZy9pb191cmluZy5jCmluZGV4IDA3NjE3MTk3N2Q1ZS4uZjc1YmMyOTU5ZjYw
IDEwMDY0NAotLS0gYS9pb191cmluZy9pb191cmluZy5jCisrKyBiL2lvX3VyaW5nL2lvX3Vy
aW5nLmMKQEAgLTMyMSw3ICszMjEsNyBAQCBzdGF0aWMgX19jb2xkIHN0cnVjdCBpb19yaW5n
X2N0eCAqaW9fcmluZ19jdHhfYWxsb2Moc3RydWN0IGlvX3VyaW5nX3BhcmFtcyAqcCkKIAly
ZXQgfD0gaW9fYWxsb2NfY2FjaGVfaW5pdCgmY3R4LT5yd19jYWNoZSwgSU9fQUxMT0NfQ0FD
SEVfTUFYLAogCQkJICAgIHNpemVvZihzdHJ1Y3QgaW9fYXN5bmNfcncpKTsKIAlyZXQgfD0g
aW9fYWxsb2NfY2FjaGVfaW5pdCgmY3R4LT51cmluZ19jYWNoZSwgSU9fQUxMT0NfQ0FDSEVf
TUFYLAotCQkJICAgIHNpemVvZihzdHJ1Y3QgdXJpbmdfY2FjaGUpKTsKKwkJCSAgICBzaXpl
b2Yoc3RydWN0IGlvX3VyaW5nX2NtZF9kYXRhKSk7CiAJc3Bpbl9sb2NrX2luaXQoJmN0eC0+
bXNnX2xvY2spOwogCXJldCB8PSBpb19hbGxvY19jYWNoZV9pbml0KCZjdHgtPm1zZ19jYWNo
ZSwgSU9fQUxMT0NfQ0FDSEVfTUFYLAogCQkJICAgIHNpemVvZihzdHJ1Y3QgaW9fa2lvY2Ip
KTsKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJpbmdf
Y21kLmMKaW5kZXggZTlkOTlkM2VjYzM0Li5hN2ExMWNiNWUyMmUgMTAwNjQ0Ci0tLSBhL2lv
X3VyaW5nL3VyaW5nX2NtZC5jCisrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jCkBAIC0xNiwx
MCArMTYsMTAgQEAKICNpbmNsdWRlICJyc3JjLmgiCiAjaW5jbHVkZSAidXJpbmdfY21kLmgi
CiAKLXN0YXRpYyBzdHJ1Y3QgdXJpbmdfY2FjaGUgKmlvX3VyaW5nX2FzeW5jX2dldChzdHJ1
Y3QgaW9fa2lvY2IgKnJlcSkKK3N0YXRpYyBzdHJ1Y3QgaW9fdXJpbmdfY21kX2RhdGEgKmlv
X3VyaW5nX2FzeW5jX2dldChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSkKIHsKIAlzdHJ1Y3QgaW9f
cmluZ19jdHggKmN0eCA9IHJlcS0+Y3R4OwotCXN0cnVjdCB1cmluZ19jYWNoZSAqY2FjaGU7
CisJc3RydWN0IGlvX3VyaW5nX2NtZF9kYXRhICpjYWNoZTsKIAogCWNhY2hlID0gaW9fYWxs
b2NfY2FjaGVfZ2V0KCZjdHgtPnVyaW5nX2NhY2hlKTsKIAlpZiAoY2FjaGUpIHsKQEAgLTM1
LDcgKzM1LDcgQEAgc3RhdGljIHN0cnVjdCB1cmluZ19jYWNoZSAqaW9fdXJpbmdfYXN5bmNf
Z2V0KHN0cnVjdCBpb19raW9jYiAqcmVxKQogc3RhdGljIHZvaWQgaW9fcmVxX3VyaW5nX2Ns
ZWFudXAoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykK
IHsKIAlzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQgPSBpb19raW9jYl90b19jbWQocmVx
LCBzdHJ1Y3QgaW9fdXJpbmdfY21kKTsKLQlzdHJ1Y3QgdXJpbmdfY2FjaGUgKmNhY2hlID0g
cmVxLT5hc3luY19kYXRhOworCXN0cnVjdCBpb191cmluZ19jbWRfZGF0YSAqY2FjaGUgPSBy
ZXEtPmFzeW5jX2RhdGE7CiAKIAlpZiAoaXNzdWVfZmxhZ3MgJiBJT19VUklOR19GX1VOTE9D
S0VEKQogCQlyZXR1cm47CkBAIC0xNzksNyArMTc5LDcgQEAgc3RhdGljIGludCBpb191cmlu
Z19jbWRfcHJlcF9zZXR1cChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwKIAkJCQkgICBjb25zdCBz
dHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpCiB7CiAJc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91
Y21kID0gaW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0IGlvX3VyaW5nX2NtZCk7Ci0Jc3Ry
dWN0IHVyaW5nX2NhY2hlICpjYWNoZTsKKwlzdHJ1Y3QgaW9fdXJpbmdfY21kX2RhdGEgKmNh
Y2hlOwogCiAJY2FjaGUgPSBpb191cmluZ19hc3luY19nZXQocmVxKTsKIAlpZiAodW5saWtl
bHkoIWNhY2hlKSkKQEAgLTI1Niw3ICsyNTYsNyBAQCBpbnQgaW9fdXJpbmdfY21kKHN0cnVj
dCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAKIAlyZXQgPSBm
aWxlLT5mX29wLT51cmluZ19jbWQoaW91Y21kLCBpc3N1ZV9mbGFncyk7CiAJaWYgKHJldCA9
PSAtRUFHQUlOKSB7Ci0JCXN0cnVjdCB1cmluZ19jYWNoZSAqY2FjaGUgPSByZXEtPmFzeW5j
X2RhdGE7CisJCXN0cnVjdCBpb191cmluZ19jbWRfZGF0YSAqY2FjaGUgPSByZXEtPmFzeW5j
X2RhdGE7CiAKIAkJaWYgKGlvdWNtZC0+c3FlICE9ICh2b2lkICopIGNhY2hlKQogCQkJbWVt
Y3B5KGNhY2hlLCBpb3VjbWQtPnNxZSwgdXJpbmdfc3FlX3NpemUocmVxLT5jdHgpKTsKZGlm
ZiAtLWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5oIGIvaW9fdXJpbmcvdXJpbmdfY21kLmgK
aW5kZXggN2RiYTBmMWVmYzU4Li5mNjgzN2VlMDk1NWIgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5n
L3VyaW5nX2NtZC5oCisrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5oCkBAIC0xLDkgKzEsNSBA
QAogLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKIAotc3RydWN0IHVyaW5n
X2NhY2hlIHsKLQlzdHJ1Y3QgaW9fdXJpbmdfc3FlIHNxZXNbMl07Ci19OwotCiBpbnQgaW9f
dXJpbmdfY21kKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxh
Z3MpOwogaW50IGlvX3VyaW5nX2NtZF9wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBjb25z
dCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpOwogCi0tIAoyLjQ1LjIKCg==

--------------WfQk0SteRHtz0N4R4yGwHpH4--


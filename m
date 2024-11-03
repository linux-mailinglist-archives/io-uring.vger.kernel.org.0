Return-Path: <io-uring+bounces-4367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 702C79BA752
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 19:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A99A5B21A2D
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371F04C81;
	Sun,  3 Nov 2024 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hcss/xYH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83DA50
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656992; cv=none; b=WIeUMDDj1IKCZxboYrbGeLcMbAQv7MvydfSpXUppDPuQdZ8sQiYbQzXZt47YPyNVaXOj+IBUk60TwSA0RMtBNfFcZh7ZNJKjYBDLU8G7YDRme2zdYj/Z0dlwjhxHpOLntoUsxaXAWEMFru4MWO8r5yjgKGrbnca9dAkj2V8pLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656992; c=relaxed/simple;
	bh=y9xREvDklVgStq74Z49C4FoSyFFvWNqC9J/rVfh/vTI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=eBO1sl7QXerTgzvXpnHu5HLe+2Z5Kmu1uRRwP4wnmzkQVgOfal+2VOHBQAgpHblkdf95bPmUIERzHPyWtVEv3R1DEiMnQ04boGgh57DpCxVdLXkiHzD+1x+Nf6Cm3BKo98osbQz0JVbzHAeMfOqmzIklU78n8Pa0NgqM/gsUoIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hcss/xYH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71e681bc315so2404759b3a.0
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 10:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656988; x=1731261788; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GeUcLfsw/Qe/lUn/6U+MBMiaKPQFU0SbWtLoyxdig6c=;
        b=Hcss/xYH8VOAAgjSJtTkgKeLHfDba6Gjg3Ob2CBctLbx27u/Bp9wr75aFnSXZSPqz1
         g4eZU9R6zslkbgJsm9/+08ZakUtBx7BT2mvQXECuQ2A9OQ0xZ1Jnrsf5QNUBOwgzFKzF
         Uueedw0reHCjS3DPVsTWSX1CEQO+gbBZKcGsQ0ZACFV3kxnY3UlH+ABYulWSvV4d/wZX
         +0rdgSaQoo5Z7PHRY9tdekJdGnuOfOsvug2gmjBXS9nr783Q8AfjQ0BCvKQgjMqbeg87
         sicHEBY6MEJJtF4lHmTqhz8Uk0LlOrKpVwMhm6fkQP9Eo05lULKUh8T79m7QGOHOEM0I
         NaVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656988; x=1731261788;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GeUcLfsw/Qe/lUn/6U+MBMiaKPQFU0SbWtLoyxdig6c=;
        b=vRXV18z/+Tx1TaA2QjZYcTdAkEO3SNE0KNy54PFttaGkuwYCyZXM0ifFp1WhPE+nV5
         f+gkpZQJlqXoKRf5w2GekaeElZFhY/mfEDClUnSN+m0i8apa3WWcet/u3va+2k0ttAMw
         CANfffYD905Ujm1Q+y8X30nyjbMr/DG/csfjMwdflEr5agTUjE+XDgwgb5vGHdcyXqz3
         89UmmV3XBwqf3NzX2r0TkhD37TUndfMNbCDR0F4smvx+1fqXVxMDvSIo0/5rKXZe6vRk
         hnvtHeQGeVKMnTPyLY7m8hJOJJ7BT6ekB9fZa3wNi8Vk6Egs2AGhQumiWQywNONuFvZj
         Qt/g==
X-Gm-Message-State: AOJu0Yw4RxgzeCpI02zOr1diu+Pqf+tVdB+E7SwV+z206HgS9fqgDFfC
	tSWH12TSiB0gUHNTWu/6C8b7SuM2DXY4gwyWqOTmnMMcRvJgureduqeWShVV17ikeTJNJk7lm8B
	Eh70=
X-Google-Smtp-Source: AGHT+IGqeSKn/pMDUgxIhhY+70fYlU2/guBVA8b957SJ1q26R3CtLwdaqrOHxUBXtIfrqjD3eCHfrg==
X-Received: by 2002:a05:6a20:9151:b0:1db:94ca:660c with SMTP id adf61e73a8af0-1dba4205101mr16384756637.18.1730656988449;
        Sun, 03 Nov 2024 10:03:08 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee45a13178sm5511642a12.90.2024.11.03.10.03.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 10:03:07 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------u0BtIdXH10OOmi8Q990uBaIk"
Message-ID: <65cb233b-8401-4ac1-b667-191ce2173cd0@kernel.dk>
Date: Sun, 3 Nov 2024 11:03:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/2] io_rsrc_node cleanups
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
References: <20241103174918.76256-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20241103174918.76256-1-axboe@kernel.dk>

This is a multi-part message in MIME format.
--------------u0BtIdXH10OOmi8Q990uBaIk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 10:47 AM, Jens Axboe wrote:
> Hi,
> 
> Nothing major here - just a patch reclaiming a bit of space in struct
> io_rsrc_node. Nothing that yields anything yet, but may as well free
> up the 'type' to have more future room.
> 
> 2nd patch reclaims 8b from struct io_kiocb, by taking advantage of the
> fact that provided and registered buffers cannot currently be used
> together. This may change in the future, but it's true for now.
> 
>  include/linux/io_uring_types.h |  7 ++++++-
>  io_uring/io_uring.c            |  6 +++---
>  io_uring/net.c                 |  3 ++-
>  io_uring/nop.c                 |  3 ++-
>  io_uring/notif.c               |  4 ++--
>  io_uring/rsrc.c                | 11 +++++------
>  io_uring/rsrc.h                | 31 +++++++++++++++++++++++--------
>  io_uring/rw.c                  |  3 ++-
>  io_uring/uring_cmd.c           |  4 ++--
>  9 files changed, 47 insertions(+), 25 deletions(-)

Not sure what happened with git send-email here, but here are the two
patches.

-- 
Jens Axboe

--------------u0BtIdXH10OOmi8Q990uBaIk
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-rsrc-split-io_kiocb-node-type-assignments.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-rsrc-split-io_kiocb-node-type-assignments.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSAwYzgxYTk0NTVlMGY1YjQ0MGJiMjllZmNlZjM1MjI1ODQxMzI4YTkxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFN1biwgMyBOb3YgMjAyNCAwODo0NjowNyAtMDcwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBpb191cmluZy9yc3JjOiBzcGxpdCBpb19raW9jYiBub2RlIHR5cGUgYXNzaWdubWVudHMK
CkN1cnJlbnRseSB0aGUgaW9fcnNyY19ub2RlIGFzc2lnbm1lbnQgaW4gaW9fa2lvY2IgaXMg
YW4gYXJyYXkgb2YgdHdvCnBvaW50ZXJzLCBhcyB0d28gbm9kZXMgbWF5IGJlIGFzc2lnbmVk
IHRvIGEgcmVxdWVzdCAtIG9uZSBmaWxlIG5vZGUsCmFuZCBvbmUgYnVmZmVyIG5vZGUuIEhv
d2V2ZXIsIHRoZSBidWZmZXIgbm9kZSBjYW4gY28tZXhpc3Qgd2l0aCB0aGUKcHJvdmlkZWQg
YnVmZmVycywgYXMgY3VycmVudGx5IGl0J3Mgbm90IHN1cHBvcnRlZCB0byB1c2UgYm90aCBw
cm92aWRlZAphbmQgcmVnaXN0ZXJlZCBidWZmZXJzIGF0IHRoZSBzYW1lIHRpbWUuCgpUaGlz
IGNydWNpYWxseSBicmluZ3Mgc3RydWN0IGlvX2tpb2NiIGRvd24gdG8gNCBjYWNoZSBsaW5l
cyBhZ2FpbiwgYXMKYmVmb3JlIGl0IHNwaWxsZWQgaW50byB0aGUgNXRoIGNhY2hlbGluZS4K
ClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpbmNs
dWRlL2xpbnV4L2lvX3VyaW5nX3R5cGVzLmggfCAgNyArKysrKystCiBpb191cmluZy9pb191
cmluZy5jICAgICAgICAgICAgfCAgNiArKystLS0KIGlvX3VyaW5nL25ldC5jICAgICAgICAg
ICAgICAgICB8ICAzICsrLQogaW9fdXJpbmcvbm9wLmMgICAgICAgICAgICAgICAgIHwgIDMg
KystCiBpb191cmluZy9ub3RpZi5jICAgICAgICAgICAgICAgfCAgNCArKy0tCiBpb191cmlu
Zy9yc3JjLmggICAgICAgICAgICAgICAgfCAxNiArKysrKysrKysrLS0tLS0tCiBpb191cmlu
Zy9ydy5jICAgICAgICAgICAgICAgICAgfCAgMyArKy0KIGlvX3VyaW5nL3VyaW5nX2NtZC5j
ICAgICAgICAgICB8ICA0ICsrLS0KIDggZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygr
KSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pb191cmlu
Z190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9pb191cmluZ190eXBlcy5oCmluZGV4IDhlYTAx
ZmYwMDliMS4uYTg3OTI3YTM5MmYyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2lvX3Vy
aW5nX3R5cGVzLmgKKysrIGIvaW5jbHVkZS9saW51eC9pb191cmluZ190eXBlcy5oCkBAIC00
NzksNiArNDc5LDcgQEAgZW51bSB7CiAJUkVRX0ZfQkxfTk9fUkVDWUNMRV9CSVQsCiAJUkVR
X0ZfQlVGRkVSU19DT01NSVRfQklULAogCVJFUV9GX0dST1VQX0xFQURFUl9CSVQsCisJUkVR
X0ZfQlVGX05PREVfQklULAogCiAJLyogbm90IGEgcmVhbCBiaXQsIGp1c3QgdG8gY2hlY2sg
d2UncmUgbm90IG92ZXJmbG93aW5nIHRoZSBzcGFjZSAqLwogCV9fUkVRX0ZfTEFTVF9CSVQs
CkBAIC01NjEsNiArNTYyLDggQEAgZW51bSB7CiAJUkVRX0ZfQlVGRkVSU19DT01NSVQJPSBJ
T19SRVFfRkxBRyhSRVFfRl9CVUZGRVJTX0NPTU1JVF9CSVQpLAogCS8qIHNxZSBncm91cCBs
ZWFkICovCiAJUkVRX0ZfR1JPVVBfTEVBREVSCT0gSU9fUkVRX0ZMQUcoUkVRX0ZfR1JPVVBf
TEVBREVSX0JJVCksCisJLyogYnVmIG5vZGUgaXMgdmFsaWQgKi8KKwlSRVFfRl9CVUZfTk9E
RQkJPSBJT19SRVFfRkxBRyhSRVFfRl9CVUZfTk9ERV9CSVQpLAogfTsKIAogdHlwZWRlZiB2
b2lkICgqaW9fcmVxX3R3X2Z1bmNfdCkoc3RydWN0IGlvX2tpb2NiICpyZXEsIHN0cnVjdCBp
b190d19zdGF0ZSAqdHMpOwpAQCAtNjQxLDYgKzY0NCw4IEBAIHN0cnVjdCBpb19raW9jYiB7
CiAJCSAqIFJFUV9GX0JVRkZFUl9SSU5HIGlzIHNldC4KIAkJICovCiAJCXN0cnVjdCBpb19i
dWZmZXJfbGlzdAkqYnVmX2xpc3Q7CisKKwkJc3RydWN0IGlvX3JzcmNfbm9kZQkqYnVmX25v
ZGU7CiAJfTsKIAogCXVuaW9uIHsKQEAgLTY1MCw3ICs2NTUsNyBAQCBzdHJ1Y3QgaW9fa2lv
Y2IgewogCQlfX3BvbGxfdCBhcG9sbF9ldmVudHM7CiAJfTsKIAotCXN0cnVjdCBpb19yc3Jj
X25vZGUJCSpyc3JjX25vZGVzWzJdOworCXN0cnVjdCBpb19yc3JjX25vZGUJCSpmaWxlX25v
ZGU7CiAKIAlhdG9taWNfdAkJCXJlZnM7CiAJYm9vbAkJCQljYW5jZWxfc2VxX3NldDsKZGlm
ZiAtLWdpdCBhL2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jCmlu
ZGV4IDkyMWQ3OWRmYjk1NS4uNWI0MjFlNjdjMDMxIDEwMDY0NAotLS0gYS9pb191cmluZy9p
b191cmluZy5jCisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKQEAgLTEwODEsOCArMTA4MSw4
IEBAIHZvaWQgaW9fcmVxX2RlZmVyX2ZhaWxlZChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgczMy
IHJlcykKIHN0YXRpYyB2b2lkIGlvX3ByZWluaXRfcmVxKHN0cnVjdCBpb19raW9jYiAqcmVx
LCBzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkKIHsKIAlyZXEtPmN0eCA9IGN0eDsKLQlyZXEt
PnJzcmNfbm9kZXNbSU9SSU5HX1JTUkNfRklMRV0gPSBOVUxMOwotCXJlcS0+cnNyY19ub2Rl
c1tJT1JJTkdfUlNSQ19CVUZGRVJdID0gTlVMTDsKKwlyZXEtPmJ1Zl9ub2RlID0gTlVMTDsK
KwlyZXEtPmZpbGVfbm9kZSA9IE5VTEw7CiAJcmVxLT5saW5rID0gTlVMTDsKIAlyZXEtPmFz
eW5jX2RhdGEgPSBOVUxMOwogCS8qIG5vdCBuZWNlc3NhcnksIGJ1dCBzYWZlciB0byB6ZXJv
ICovCkBAIC0yMDQ0LDcgKzIwNDQsNyBAQCBpbmxpbmUgc3RydWN0IGZpbGUgKmlvX2ZpbGVf
Z2V0X2ZpeGVkKHN0cnVjdCBpb19raW9jYiAqcmVxLCBpbnQgZmQsCiAJaW9fcmluZ19zdWJt
aXRfbG9jayhjdHgsIGlzc3VlX2ZsYWdzKTsKIAlub2RlID0gaW9fcnNyY19ub2RlX2xvb2t1
cCgmY3R4LT5maWxlX3RhYmxlLmRhdGEsIGZkKTsKIAlpZiAobm9kZSkgewotCQlpb19yZXFf
YXNzaWduX3JzcmNfbm9kZShyZXEsIG5vZGUpOworCQlpb19yZXFfYXNzaWduX3JzcmNfbm9k
ZSgmcmVxLT5maWxlX25vZGUsIG5vZGUpOwogCQlyZXEtPmZsYWdzIHw9IGlvX3Nsb3RfZmxh
Z3Mobm9kZSk7CiAJCWZpbGUgPSBpb19zbG90X2ZpbGUobm9kZSk7CiAJfQpkaWZmIC0tZ2l0
IGEvaW9fdXJpbmcvbmV0LmMgYi9pb191cmluZy9uZXQuYwppbmRleCAyZjdiMzM0ZWQ3MDgu
LjJjY2MyYjQwOTQzMSAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvbmV0LmMKKysrIGIvaW9fdXJp
bmcvbmV0LmMKQEAgLTEzNDgsNyArMTM0OCw4IEBAIHN0YXRpYyBpbnQgaW9fc2VuZF96Y19p
bXBvcnQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykK
IAkJaW9fcmluZ19zdWJtaXRfbG9jayhjdHgsIGlzc3VlX2ZsYWdzKTsKIAkJbm9kZSA9IGlv
X3JzcmNfbm9kZV9sb29rdXAoJmN0eC0+YnVmX3RhYmxlLCBzci0+YnVmX2luZGV4KTsKIAkJ
aWYgKG5vZGUpIHsKLQkJCWlvX3JlcV9hc3NpZ25fcnNyY19ub2RlKHNyLT5ub3RpZiwgbm9k
ZSk7CisJCQlpb19yZXFfYXNzaWduX3JzcmNfbm9kZSgmc3ItPm5vdGlmLT5idWZfbm9kZSwg
bm9kZSk7CisJCQlzci0+bm90aWYtPmZsYWdzIHw9IFJFUV9GX0JVRl9OT0RFOwogCQkJcmV0
ID0gMDsKIAkJfQogCQlpb19yaW5nX3N1Ym1pdF91bmxvY2soY3R4LCBpc3N1ZV9mbGFncyk7
CmRpZmYgLS1naXQgYS9pb191cmluZy9ub3AuYyBiL2lvX3VyaW5nL25vcC5jCmluZGV4IDE0
OWRiZGM1MzYwNy4uYmMyMmJjYzczOWYzIDEwMDY0NAotLS0gYS9pb191cmluZy9ub3AuYwor
KysgYi9pb191cmluZy9ub3AuYwpAQCAtNjcsNyArNjcsOCBAQCBpbnQgaW9fbm9wKHN0cnVj
dCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAJCWlvX3Jpbmdf
c3VibWl0X2xvY2soY3R4LCBpc3N1ZV9mbGFncyk7CiAJCW5vZGUgPSBpb19yc3JjX25vZGVf
bG9va3VwKCZjdHgtPmJ1Zl90YWJsZSwgbm9wLT5idWZmZXIpOwogCQlpZiAobm9kZSkgewot
CQkJaW9fcmVxX2Fzc2lnbl9yc3JjX25vZGUocmVxLCBub2RlKTsKKwkJCWlvX3JlcV9hc3Np
Z25fcnNyY19ub2RlKCZyZXEtPmJ1Zl9ub2RlLCBub2RlKTsKKwkJCXJlcS0+ZmxhZ3MgfD0g
UkVRX0ZfQlVGX05PREU7CiAJCQlyZXQgPSAwOwogCQl9CiAJCWlvX3Jpbmdfc3VibWl0X3Vu
bG9jayhjdHgsIGlzc3VlX2ZsYWdzKTsKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL25vdGlmLmMg
Yi9pb191cmluZy9ub3RpZi5jCmluZGV4IDRmMDJlOTY5Y2YwOC4uOGRmYmIwYmQ4ZTRkIDEw
MDY0NAotLS0gYS9pb191cmluZy9ub3RpZi5jCisrKyBiL2lvX3VyaW5nL25vdGlmLmMKQEAg
LTExNyw4ICsxMTcsOCBAQCBzdHJ1Y3QgaW9fa2lvY2IgKmlvX2FsbG9jX25vdGlmKHN0cnVj
dCBpb19yaW5nX2N0eCAqY3R4KQogCW5vdGlmLT5maWxlID0gTlVMTDsKIAlub3RpZi0+dGFz
ayA9IGN1cnJlbnQ7CiAJaW9fZ2V0X3Rhc2tfcmVmcygxKTsKLQlub3RpZi0+cnNyY19ub2Rl
c1tJT1JJTkdfUlNSQ19GSUxFXSA9IE5VTEw7Ci0Jbm90aWYtPnJzcmNfbm9kZXNbSU9SSU5H
X1JTUkNfQlVGRkVSXSA9IE5VTEw7CisJbm90aWYtPmZpbGVfbm9kZSA9IE5VTEw7CisJbm90
aWYtPmJ1Zl9ub2RlID0gTlVMTDsKIAogCW5kID0gaW9fbm90aWZfdG9fZGF0YShub3RpZik7
CiAJbmQtPnpjX3JlcG9ydCA9IGZhbHNlOwpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcnNyYy5o
IGIvaW9fdXJpbmcvcnNyYy5oCmluZGV4IDlhOGZhYzMxZmE0OS4uYmMzYTg2M2IxNGJiIDEw
MDY0NAotLS0gYS9pb191cmluZy9yc3JjLmgKKysrIGIvaW9fdXJpbmcvcnNyYy5oCkBAIC05
NSwxMCArOTUsMTQgQEAgc3RhdGljIGlubGluZSBib29sIGlvX3Jlc2V0X3JzcmNfbm9kZShz
dHJ1Y3QgaW9fcnNyY19kYXRhICpkYXRhLCBpbnQgaW5kZXgpCiAKIHN0YXRpYyBpbmxpbmUg
dm9pZCBpb19yZXFfcHV0X3JzcmNfbm9kZXMoc3RydWN0IGlvX2tpb2NiICpyZXEpCiB7Ci0J
aW9fcHV0X3JzcmNfbm9kZShyZXEtPnJzcmNfbm9kZXNbSU9SSU5HX1JTUkNfRklMRV0pOwot
CWlvX3B1dF9yc3JjX25vZGUocmVxLT5yc3JjX25vZGVzW0lPUklOR19SU1JDX0JVRkZFUl0p
OwotCXJlcS0+cnNyY19ub2Rlc1tJT1JJTkdfUlNSQ19GSUxFXSA9IE5VTEw7Ci0JcmVxLT5y
c3JjX25vZGVzW0lPUklOR19SU1JDX0JVRkZFUl0gPSBOVUxMOworCWlmIChyZXEtPmZpbGVf
bm9kZSkgeworCQlpb19wdXRfcnNyY19ub2RlKHJlcS0+ZmlsZV9ub2RlKTsKKwkJcmVxLT5m
aWxlX25vZGUgPSBOVUxMOworCX0KKwlpZiAocmVxLT5mbGFncyAmIFJFUV9GX0JVRl9OT0RF
KSB7CisJCWlvX3B1dF9yc3JjX25vZGUocmVxLT5idWZfbm9kZSk7CisJCXJlcS0+YnVmX25v
ZGUgPSBOVUxMOworCX0KIH0KIAogc3RhdGljIGlubGluZSBzdHJ1Y3QgaW9fcmluZ19jdHgg
KmlvX3JzcmNfbm9kZV9jdHgoc3RydWN0IGlvX3JzcmNfbm9kZSAqbm9kZSkKQEAgLTExMSwx
MSArMTE1LDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IGlvX3JzcmNfbm9kZV90eXBlKHN0cnVj
dCBpb19yc3JjX25vZGUgKm5vZGUpCiAJcmV0dXJuIG5vZGUtPmN0eF9wdHIgJiBJT1JJTkdf
UlNSQ19UWVBFX01BU0s7CiB9CiAKLXN0YXRpYyBpbmxpbmUgdm9pZCBpb19yZXFfYXNzaWdu
X3JzcmNfbm9kZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwKK3N0YXRpYyBpbmxpbmUgdm9pZCBp
b19yZXFfYXNzaWduX3JzcmNfbm9kZShzdHJ1Y3QgaW9fcnNyY19ub2RlICoqZHN0X25vZGUs
CiAJCQkJCSAgIHN0cnVjdCBpb19yc3JjX25vZGUgKm5vZGUpCiB7CiAJbm9kZS0+cmVmcysr
OwotCXJlcS0+cnNyY19ub2Rlc1tpb19yc3JjX25vZGVfdHlwZShub2RlKV0gPSBub2RlOwor
CSpkc3Rfbm9kZSA9IG5vZGU7CiB9CiAKIGludCBpb19maWxlc191cGRhdGUoc3RydWN0IGlv
X2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncyk7CmRpZmYgLS1naXQgYS9p
b191cmluZy9ydy5jIGIvaW9fdXJpbmcvcncuYwppbmRleCAxZWE2YmUyY2NjOTAuLjE0NDcz
MDM0NGMwZiAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvcncuYworKysgYi9pb191cmluZy9ydy5j
CkBAIC0zNDEsNyArMzQxLDggQEAgc3RhdGljIGludCBpb19wcmVwX3J3X2ZpeGVkKHN0cnVj
dCBpb19raW9jYiAqcmVxLCBjb25zdCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUKIAlub2Rl
ID0gaW9fcnNyY19ub2RlX2xvb2t1cCgmY3R4LT5idWZfdGFibGUsIHJlcS0+YnVmX2luZGV4
KTsKIAlpZiAoIW5vZGUpCiAJCXJldHVybiAtRUZBVUxUOwotCWlvX3JlcV9hc3NpZ25fcnNy
Y19ub2RlKHJlcSwgbm9kZSk7CisJaW9fcmVxX2Fzc2lnbl9yc3JjX25vZGUoJnJlcS0+YnVm
X25vZGUsIG5vZGUpOworCXJlcS0+ZmxhZ3MgfD0gUkVRX0ZfQlVGX05PREU7CiAKIAlpbyA9
IHJlcS0+YXN5bmNfZGF0YTsKIAlyZXQgPSBpb19pbXBvcnRfZml4ZWQoZGRpciwgJmlvLT5p
dGVyLCBub2RlLT5idWYsIHJ3LT5hZGRyLCBydy0+bGVuKTsKZGlmZiAtLWdpdCBhL2lvX3Vy
aW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJpbmdfY21kLmMKaW5kZXggNTM1OTA5YTM4
ZTc2Li44OGE3M2QyMWZjMGIgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jCisr
KyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jCkBAIC0yMTksNyArMjE5LDcgQEAgaW50IGlvX3Vy
aW5nX2NtZF9wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBjb25zdCBzdHJ1Y3QgaW9fdXJp
bmdfc3FlICpzcWUpCiAJCSAqIGJlaW5nIGNhbGxlZC4gVGhpcyBwcmV2ZW50cyBkZXN0cnVj
dGlvbiBvZiB0aGUgbWFwcGVkIGJ1ZmZlcgogCQkgKiB3ZSdsbCBuZWVkIGF0IGFjdHVhbCBp
bXBvcnQgdGltZS4KIAkJICovCi0JCWlvX3JlcV9hc3NpZ25fcnNyY19ub2RlKHJlcSwgbm9k
ZSk7CisJCWlvX3JlcV9hc3NpZ25fcnNyY19ub2RlKCZyZXEtPmJ1Zl9ub2RlLCBub2RlKTsK
IAl9CiAJaW91Y21kLT5jbWRfb3AgPSBSRUFEX09OQ0Uoc3FlLT5jbWRfb3ApOwogCkBAIC0y
NzUsNyArMjc1LDcgQEAgaW50IGlvX3VyaW5nX2NtZF9pbXBvcnRfZml4ZWQodTY0IHVidWYs
IHVuc2lnbmVkIGxvbmcgbGVuLCBpbnQgcncsCiAJCQkgICAgICBzdHJ1Y3QgaW92X2l0ZXIg
Kml0ZXIsIHZvaWQgKmlvdWNtZCkKIHsKIAlzdHJ1Y3QgaW9fa2lvY2IgKnJlcSA9IGNtZF90
b19pb19raW9jYihpb3VjbWQpOwotCXN0cnVjdCBpb19yc3JjX25vZGUgKm5vZGUgPSByZXEt
PnJzcmNfbm9kZXNbSU9SSU5HX1JTUkNfQlVGRkVSXTsKKwlzdHJ1Y3QgaW9fcnNyY19ub2Rl
ICpub2RlID0gcmVxLT5idWZfbm9kZTsKIAogCS8qIE11c3QgaGF2ZSBoYWQgcnNyY19ub2Rl
IGFzc2lnbmVkIGF0IHByZXAgdGltZSAqLwogCWlmIChub2RlKQotLSAKMi40NS4yCgo=
--------------u0BtIdXH10OOmi8Q990uBaIk
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-rsrc-encode-node-type-and-ctx-together.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-rsrc-encode-node-type-and-ctx-together.patch"
Content-Transfer-Encoding: base64

RnJvbSAwMjA4NTNlMTU0NjgxNmEzMDgwNjdlNjY5MGQzOWIxYTljMzFhNjlkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFN1biwgMyBOb3YgMjAyNCAwODoxNzoyOCAtMDcwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBpb191cmluZy9yc3JjOiBlbmNvZGUgbm9kZSB0eXBlIGFuZCBjdHggdG9nZXRoZXIKClJh
dGhlciB0aGFuIGtlZXAgdGhlIHR5cGUgZmllbGQgc2VwYXJhdGUgcm9tIGN0eCwgdXNlIHRo
ZSBmYWN0IHRoYXQgd2UKY2FuIGVuY29kZSB1cCB0byA0IHR5cGVzIG9mIG5vZGVzIGluIHRo
ZSBMU0Igb2YgdGhlIGN0eCBwb2ludGVyLiBEb2Vzbid0CnJlY2xhaW0gYW55IHNwYWNlIHJp
Z2h0IG5vdyBvbiA2NC1iaXQgYXJjaHMsIGJ1dCBpdCBsZWF2ZXMgYSBmdWxsIGludApmb3Ig
ZnV0dXJlIHVzZS4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4KLS0tCiBpb191cmluZy9yc3JjLmMgfCAxMSArKysrKy0tLS0tLQogaW9fdXJpbmcvcnNy
Yy5oIHwgMTcgKysrKysrKysrKysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0
aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9yc3JjLmMg
Yi9pb191cmluZy9yc3JjLmMKaW5kZXggNjBmYTg1Nzk4NWNiLi4yZmIxNzkxZDcyNTUgMTAw
NjQ0Ci0tLSBhL2lvX3VyaW5nL3JzcmMuYworKysgYi9pb191cmluZy9yc3JjLmMKQEAgLTEy
NCw5ICsxMjQsOCBAQCBzdHJ1Y3QgaW9fcnNyY19ub2RlICppb19yc3JjX25vZGVfYWxsb2Mo
c3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIGludCB0eXBlKQogCiAJbm9kZSA9IGt6YWxsb2Mo
c2l6ZW9mKCpub2RlKSwgR0ZQX0tFUk5FTCk7CiAJaWYgKG5vZGUpIHsKLQkJbm9kZS0+Y3R4
ID0gY3R4OworCQlub2RlLT5jdHhfcHRyID0gKHVuc2lnbmVkIGxvbmcpIGN0eCB8IHR5cGU7
CiAJCW5vZGUtPnJlZnMgPSAxOwotCQlub2RlLT50eXBlID0gdHlwZTsKIAl9CiAJcmV0dXJu
IG5vZGU7CiB9CkBAIC00NDUsMjEgKzQ0NCwyMSBAQCBpbnQgaW9fZmlsZXNfdXBkYXRlKHN0
cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAKIHZvaWQg
aW9fZnJlZV9yc3JjX25vZGUoc3RydWN0IGlvX3JzcmNfbm9kZSAqbm9kZSkKIHsKLQlzdHJ1
Y3QgaW9fcmluZ19jdHggKmN0eCA9IG5vZGUtPmN0eDsKKwlzdHJ1Y3QgaW9fcmluZ19jdHgg
KmN0eCA9IGlvX3JzcmNfbm9kZV9jdHgobm9kZSk7CiAKIAlsb2NrZGVwX2Fzc2VydF9oZWxk
KCZjdHgtPnVyaW5nX2xvY2spOwogCiAJaWYgKG5vZGUtPnRhZykKLQkJaW9fcG9zdF9hdXhf
Y3FlKG5vZGUtPmN0eCwgbm9kZS0+dGFnLCAwLCAwKTsKKwkJaW9fcG9zdF9hdXhfY3FlKGN0
eCwgbm9kZS0+dGFnLCAwLCAwKTsKIAotCXN3aXRjaCAobm9kZS0+dHlwZSkgeworCXN3aXRj
aCAoaW9fcnNyY19ub2RlX3R5cGUobm9kZSkpIHsKIAljYXNlIElPUklOR19SU1JDX0ZJTEU6
CiAJCWlmIChpb19zbG90X2ZpbGUobm9kZSkpCiAJCQlmcHV0KGlvX3Nsb3RfZmlsZShub2Rl
KSk7CiAJCWJyZWFrOwogCWNhc2UgSU9SSU5HX1JTUkNfQlVGRkVSOgogCQlpZiAobm9kZS0+
YnVmKQotCQkJaW9fYnVmZmVyX3VubWFwKG5vZGUtPmN0eCwgbm9kZSk7CisJCQlpb19idWZm
ZXJfdW5tYXAoY3R4LCBub2RlKTsKIAkJYnJlYWs7CiAJZGVmYXVsdDoKIAkJV0FSTl9PTl9P
TkNFKDEpOwpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcnNyYy5oIGIvaW9fdXJpbmcvcnNyYy5o
CmluZGV4IGE0MGZhZDc4M2E2OS4uOWE4ZmFjMzFmYTQ5IDEwMDY0NAotLS0gYS9pb191cmlu
Zy9yc3JjLmgKKysrIGIvaW9fdXJpbmcvcnNyYy5oCkBAIC0xMSwxMiArMTEsMTMgQEAKIGVu
dW0gewogCUlPUklOR19SU1JDX0ZJTEUJCT0gMCwKIAlJT1JJTkdfUlNSQ19CVUZGRVIJCT0g
MSwKKworCUlPUklOR19SU1JDX1RZUEVfTUFTSwkJPSAweDNVTCwKIH07CiAKIHN0cnVjdCBp
b19yc3JjX25vZGUgewotCXN0cnVjdCBpb19yaW5nX2N0eAkJKmN0eDsKKwl1bnNpZ25lZCBs
b25nCQkJY3R4X3B0cjsKIAlpbnQJCQkJcmVmczsKLQl1MTYJCQkJdHlwZTsKIAogCXU2NCB0
YWc7CiAJdW5pb24gewpAQCAtMTAwLDExICsxMDEsMjEgQEAgc3RhdGljIGlubGluZSB2b2lk
IGlvX3JlcV9wdXRfcnNyY19ub2RlcyhzdHJ1Y3QgaW9fa2lvY2IgKnJlcSkKIAlyZXEtPnJz
cmNfbm9kZXNbSU9SSU5HX1JTUkNfQlVGRkVSXSA9IE5VTEw7CiB9CiAKK3N0YXRpYyBpbmxp
bmUgc3RydWN0IGlvX3JpbmdfY3R4ICppb19yc3JjX25vZGVfY3R4KHN0cnVjdCBpb19yc3Jj
X25vZGUgKm5vZGUpCit7CisJcmV0dXJuIChzdHJ1Y3QgaW9fcmluZ19jdHggKikgKG5vZGUt
PmN0eF9wdHIgJiB+SU9SSU5HX1JTUkNfVFlQRV9NQVNLKTsKK30KKworc3RhdGljIGlubGlu
ZSBpbnQgaW9fcnNyY19ub2RlX3R5cGUoc3RydWN0IGlvX3JzcmNfbm9kZSAqbm9kZSkKK3sK
KwlyZXR1cm4gbm9kZS0+Y3R4X3B0ciAmIElPUklOR19SU1JDX1RZUEVfTUFTSzsKK30KKwog
c3RhdGljIGlubGluZSB2b2lkIGlvX3JlcV9hc3NpZ25fcnNyY19ub2RlKHN0cnVjdCBpb19r
aW9jYiAqcmVxLAogCQkJCQkgICBzdHJ1Y3QgaW9fcnNyY19ub2RlICpub2RlKQogewogCW5v
ZGUtPnJlZnMrKzsKLQlyZXEtPnJzcmNfbm9kZXNbbm9kZS0+dHlwZV0gPSBub2RlOworCXJl
cS0+cnNyY19ub2Rlc1tpb19yc3JjX25vZGVfdHlwZShub2RlKV0gPSBub2RlOwogfQogCiBp
bnQgaW9fZmlsZXNfdXBkYXRlKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQg
aXNzdWVfZmxhZ3MpOwotLSAKMi40NS4yCgo=

--------------u0BtIdXH10OOmi8Q990uBaIk--


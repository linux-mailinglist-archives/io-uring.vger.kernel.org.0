Return-Path: <io-uring+bounces-8486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C39D9AE899E
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 18:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6B43A49CE
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 16:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F472BF01C;
	Wed, 25 Jun 2025 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vQR6bMkp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ABA26A1AA
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868405; cv=none; b=YOK+6cBm5huyk/yzTT5B/uDjOA1mFObqSOVt2zncdeO6l74mcabd9/2aa7WXZjSjw5/zl3eGUgEhDiK0bvesHKyE5fDtHga8GTbI1gLPot0nzME5k55pf5rYrLQ3zrIei+DGhaQs2V0sUgzm9CGBRQ/pA3raWa2xoYR9e8/YHpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868405; c=relaxed/simple;
	bh=WZW4dD0Nce8kg9wSVxKf/XzYXIMcysvoXZ5aW5HCkT0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Is2PQ1/4dQWfuM2WES1+WQAT81J/HR27fq/ucjQZU4/Oi3wuNFNzIaSHqQNhiKtBuvaL3n4q9zLh82/SRnvvRUVI1zT6+avMHmiVe5myoA/x0aNL3oMUgbEXl+nn8klnjioK48u889b/kc5B9dkcPvQZdKj/nnx90tn/q4WAmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vQR6bMkp; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7426c44e014so130080b3a.3
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750868401; x=1751473201; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCC3PFVX7I9tJllaYUgQEAzC3cPIbfIybIQpD5sVqMk=;
        b=vQR6bMkpqj9BCinuUm9C5U2/AS2aCRoqUr8QclijWZW9L8iuDaaSj9DFQ0KI0N+7Tq
         b3MTAblIodH3jyfHV/jIO7l14xF/ZQRipOTy66sYMseuH+gpRgB7eGOjHfJ8IQcUYglo
         WfQDmJpuJu1PuzK8xaQuh7DB36qa0Zd1lfxC633hjU7dkvGCKtrBBajq0Thsb401Rj7w
         DE85teI6IV95fQoBeV7OL+siTLN3B+rDssHxoiEoIZWzWRhfyRjbK25LeYi421KliWxF
         L55xmOjcfv9nFDXXjhHAUmAyav5o8lfZ9EK6kiLosIAL5q7JXY89zoZCJLMqqkkLyUZy
         3WrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750868401; x=1751473201;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oCC3PFVX7I9tJllaYUgQEAzC3cPIbfIybIQpD5sVqMk=;
        b=uCdr0CjFKR+3ocDqXwppoKWJ9EXFxqmrim/TueXi24oDnpFUSoOjAKQJMfztZNu4pq
         g3SZJY6ZYG27QL6MNMqcP5dGoyl3MsKJUkTWM8i+p0J82oRH80Kld9NfA2NeOEG659If
         mKp3DkgtOrmvuyFDlDqXZZnkqzaXqzYYa1y+V04YpMqTggRPP7xGQukXePt6DlU5RyDU
         1u9qkJotY81AjAVk5HYHv5BrbganM2t7EmrAN+r7MSml2LNNs3dJCVyAziC0N8KIy/kC
         qtbdrpQwaF/juIQlmRpJVCB969tekSIHv3pwm9PubpUN622hh0Y+AUItk+mhpJzzRF45
         RLVw==
X-Gm-Message-State: AOJu0YxX41j/0nFYDtvGSlkvgDSaFHE3pcI746WG07EmAbKv7QiU7Zve
	bxoQE/iO+3ZC6Nx35Szt3inLr+YENORMwMf6jAgxZPuIjo4kS/Lq5Sk2m+GB8B1+racpd4dENaD
	UIsfc
X-Gm-Gg: ASbGncv4poFhuU4+ZPEcKTA+wePgWTaxedY0laHY3TeIxrojBS5HiGDtSd0XK56l5El
	aJFkRaib4hi4AZDkFtUXAAhJ8lGiVfYpbH80D5PP3XKDE5kBbK8P/kpkbpLuVIJzx2p0GwOiATl
	HCFCQu+i2kBapcy9rtBMu5spaJ/ZEAVgxjGX/mxaNx7LR1jw9mUl82CWDkR9FqeDEhYNm0Xy8Cd
	XcdzVVKiJ9rFNLjpvKjf8k6JOygTeMKHjecEUv5u4U0qXO/uVJxzOD6O1nr/Bx4GOmLY/l75dH7
	oQidoQD719Oy40ETKBBRCHc6+n6efaA7CZXqCc0tknzqj9Uy+PSCyuCz8Q==
X-Google-Smtp-Source: AGHT+IHVfvmE1yX275UOAW71xuO8bx/+AgCrOIaASjqr1Hwv4je2Aaec0YDT8RnzdC0F8FOK6uJEnQ==
X-Received: by 2002:a05:6a20:7fa8:b0:21d:2244:7c5c with SMTP id adf61e73a8af0-2208c5b92fbmr685894637.26.1750868400889;
        Wed, 25 Jun 2025 09:20:00 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f12584e1sm13145339a12.59.2025.06.25.09.19.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 09:20:00 -0700 (PDT)
Message-ID: <9590f9bc-6326-4f62-a03a-7c9c89643331@kernel.dk>
Date: Wed, 25 Jun 2025 10:19:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: mark iov as dynamically allocated even for
 single segments
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A bigger array of vecs could've been allocated, but
io_ring_buffers_peek() still decided to cap the mapped range depending
on how much data was available. Hence don't rely on the segment count
to know if the request should be marked as needing cleanup, always
check upfront if the iov array is different than the fast_iov array.

Fixes: 26ec15e4b0c1 ("io_uring/kbuf: don't truncate end buffer for multiple buffer peeks")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 9550d4c8f866..5c1e8c4ba468 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1077,6 +1077,12 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		if (unlikely(ret < 0))
 			return ret;
 
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
+			kmsg->vec.nr = ret;
+			kmsg->vec.iovec = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
+
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
@@ -1085,11 +1091,6 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
-			kmsg->vec.nr = ret;
-			kmsg->vec.iovec = arg.iovs;
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
 	} else {
 		void __user *buf;
 
-- 
Jens Axboe



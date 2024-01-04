Return-Path: <io-uring+bounces-373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B0B8248F6
	for <lists+io-uring@lfdr.de>; Thu,  4 Jan 2024 20:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4A62282960
	for <lists+io-uring@lfdr.de>; Thu,  4 Jan 2024 19:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2562C845;
	Thu,  4 Jan 2024 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C4TLrtF0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8922C2C844
	for <io-uring@vger.kernel.org>; Thu,  4 Jan 2024 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6dc003289c9so124717a34.0
        for <io-uring@vger.kernel.org>; Thu, 04 Jan 2024 11:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704396251; x=1705001051; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrPXhEKgfweifq3mzhgDL4uR7jCf/jwWcSnzX3q4mnQ=;
        b=C4TLrtF0faHE7Dy0XpYIqWqECyWpIxT8qUCkjhRembrGPRolwfZBsib/LYjqR1FSkP
         mET2VELCaPaxzkSr+1IetUtqmYDAveXg8Xmz2YrLH3dgeYz9LdtqBBLHgcjL23/aPAZ4
         KhNe55cXwzyaADqYeubUVpudjxi29PpiFmlnuSB5E9ASeklRWt5Ux2Q5sWeOZLX4mUeN
         RM8OiyOx1XV6CsRFdjdYpVfGlMRSL0uxgQ6RLyLAAzUiTJngkOipH2ml3Jn1E/YrYe3w
         eYbMU+JkU6DIqCD8TxTbVTW6THTGP94yYbE/DKI3nTagnMKt1xFVn3RC5QeJ9mxYcbRo
         7uCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396251; x=1705001051;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XrPXhEKgfweifq3mzhgDL4uR7jCf/jwWcSnzX3q4mnQ=;
        b=IhssPNL5tZDFTHu+PvUD1+ImeoCGaLRDoC4SHGrpmooaEN0KTwNXr1OF57zJMC/Uy1
         ruV41+gaODgZoJfJpO3JbHgMgSIXSAIuGZPpgSYVbX/sT02ToFV+8Yx00B2Ai0yBi8+i
         iuDOx4ilf1QV1Vy8nr8Dn6iq36B17iaKt1N7jHnKybZz4eGPbN98FH6g94LsDCdX2ckF
         Db8uqsdX6As1qCOdHR2sHvbvEwWT2KUHOYLek9YF2y2dAjj5O6E3ZzrbFGzT7cUSsbhC
         +yMbCHDT47EY24SzbxngjbGEkgRWQdU3s9n0D071GcKtovVDtRM8Sx1yfugOtBwnOHTv
         vjeA==
X-Gm-Message-State: AOJu0YwME6eWecWm4OY3M9M3c+GmzjBWLPfw65M12ruBGqX2z6iHa7YV
	6Ntqo/tCO8ryRdLSXpmXZk3se5dZgruKCJCAzG7Rd8i2KMbA3w==
X-Google-Smtp-Source: AGHT+IGlt5c2/p8Dez1nWNoNoQ1bvIKK0EqawW4YNkGaepClJrJTbOh3NPpN5s8D7IfYazNGXqKXIg==
X-Received: by 2002:a05:6830:909:b0:6dc:6a7:857d with SMTP id v9-20020a056830090900b006dc06a7857dmr2061422ott.1.1704396251168;
        Thu, 04 Jan 2024 11:24:11 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y14-20020a9d634e000000b006dc0adef891sm22256otk.41.2024.01.04.11.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 11:24:10 -0800 (PST)
Message-ID: <c6227bc1-51ae-4b77-bb51-811919994924@kernel.dk>
Date: Thu, 4 Jan 2024 12:24:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure local task_work is run on wait timeout
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added an earlier break condition here, which is fine if
we're using non-local task_work as it'll be run on return to userspace.
However, if DEFER_TASKRUN is used, then we could be leaving local
task_work that is ready to process in the ctx list until next time that
we enter the kernel to wait for events.

Move the break condition to _after_ we have run task_work.

Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a9a519fa9926..4afb911fc042 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2615,8 +2615,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, 0);
 
-		if (ret < 0)
-			break;
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2626,6 +2624,18 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (!llist_empty(&ctx->work_llist))
 			io_run_local_work(ctx);
 
+		/*
+		 * Non-local task_work will be run on exit to userspace, but
+		 * if we're using DEFER_TASKRUN, then we could have waited
+		 * with a timeout for a number of requests. If the timeout
+		 * hits, we could have some requests ready to process. Ensure
+		 * this break is _after_ we have run task_work, to avoid
+		 * deferring running potentially pending requests until the
+		 * next time we wait for events.
+		 */
+		if (ret < 0)
+			break;
+
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */

-- 
Jens Axboe



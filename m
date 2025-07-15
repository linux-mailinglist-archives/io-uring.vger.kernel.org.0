Return-Path: <io-uring+bounces-8686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B65B065EA
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 20:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99E297AE9D8
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 18:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59781DF98D;
	Tue, 15 Jul 2025 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u3fPlqHB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC28633F
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752603719; cv=none; b=nrk/QUk7a8vKr0E3dWuDjjv/u2wJhkJhRJI2A0vagC/au/LZB7AIF/9/YeR+Nsfuq2qccd3EwvYqvhsBUgzctFBqNt/ZdT+h76DR2Cz6kN9KmkcBsXEwxuguBVT5YfNvWZaiwrBHlmJF4AnbaJkhsz57nHjVjAPrCScCb+Evx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752603719; c=relaxed/simple;
	bh=47Jd/latC4HRqGPIb5QO3EMW1sS+J0hCZTZ3ax4Tr7c=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=oaeLUogeUuawpCUS/j7YrirLi7Uv9zYUCTTOUahyNP/dhLqleLe517gkk2U4TtLeMMbk2fldKwIGbT98LrfqTufMVu1xX53OGP8+291G3TTSvNYI+sZ24AEJaSjhzjLNA4pEa7T9bApn9rcKWSAJTwAGPDRSNvHbEkSNiCc5/NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u3fPlqHB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3df3854e622so523585ab.1
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 11:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752603714; x=1753208514; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2I9tyItgm10gH8L+I7L1ftkMN0JDbRR3GWdvx3XeQA=;
        b=u3fPlqHBYJv6W7dxS+P9f+q/ymSdACsX1h7W9nJ2kfEUZVClSW+qp8tWoGXvyvclG4
         Qcf/1pQSAgXihCyBEUgC/4KcGfDHbeECCrUsiitW0IWP8targCJlyVQBduWIBpuWCM7W
         Q0hHNWShy9UzvYo/pMj9BPrXlkDTwz8fOO76N67QxXLxjY+fRt3Y/SWW0WXCatmBdAwL
         SdnPGdGoeqA72ev7UEmCeIc8ujLXanQJz+bW2E8Qv4EbIGm4SA+be3uA1FZzGxVmBYd6
         B+XMBYrNmPxolIW5GY1+Hs9lMlTd09NwuB4paYZpumzUpnm/GEyJvi3nmOv4pyrIAx56
         3A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752603714; x=1753208514;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t2I9tyItgm10gH8L+I7L1ftkMN0JDbRR3GWdvx3XeQA=;
        b=IGIe3aq3LzXRWQ2OsZJVCFkpIEZC7NiMH/7EORXWcCQAKzlPRriCxgX0YTxqNc+zkC
         +tnvliFHrANgxlaVOi7kDPml3aPt8OsuClpgwbGcDzLyX741UHe1Wg9acp8RzOSxCyHn
         SOc+CKMJ4KvWXKo8CvKedTd04n//8J5W91FCd0PutlX20UT+f6Ip1f5ikvgOCxc9QAe2
         OiyvZkKlovUSNjCz8cGJTqCNW3ZcNaF4tpnHYkUyoeeZSdxPnM5JHSdVcTd8yxoHL0WG
         4AUNIHivrHtQ1Ott+TNZhMfGu7+qwIaoA3/swVdnqBoBEUM8d56gsZqNfhSWiLwIVguC
         xqug==
X-Gm-Message-State: AOJu0YwazaOBZZIRf5gqd1A6nS8DbNsJ0TYhxS4K6hhBSwAgMX1d52KU
	4gB9VIDtdLXTV88Bxj9JSweu4aJvtHl33Nyl4Pdo0zUouIN78Igv3ATkzZ+0rqmA8M4Z7EfncT4
	yf3/U
X-Gm-Gg: ASbGncu6o6PKywJrd2qQC2ruiAIzltsLKQ+S3thMS+jOtBJmOiwX1UmWKimZdo1Gym8
	IYO/ox1iSM+lrBrzUKIAkt8sTh5RhPjYRfqMBZRT5DMv4+nUGeK2i/UKvivvPIZvqmiaXcg3DCF
	aveeBHgQ37nRZ36J8Eg5spQLnE7kLl62Za0m/OngG6Y78F3+eClCCb2ZYJziaMcV27yFfXqSfcK
	2tivpNmgnhkiGzpMZLbUV/w62E832JtRYO+N2p0FOs29ZhTcNHtO1yluoc+875bdaWzv5IYj6Cg
	imVhda0Mq1AT5wKH3Rk/xR6CXUFGbpZuQyahU3NeFsLY/B/ldLjUavpNhg+qtaXDhzGre8yL4X5
	caet2kdYq0UEBJPCdkQ==
X-Google-Smtp-Source: AGHT+IE3DP4PUmNq2PE60I/o5p1hZXWeFANGS/fYzaB0/N36wLRtHdZpcstJDlbECPKXEc1lpDoWAQ==
X-Received: by 2002:a05:6e02:1582:b0:3e1:25b6:2a9a with SMTP id e9e14a558f8ab-3e277caafb8mr49307585ab.6.1752603714458;
        Tue, 15 Jul 2025 11:21:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556532a46sm2675694173.13.2025.07.15.11.21.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 11:21:53 -0700 (PDT)
Message-ID: <75a31bc0-2253-435c-869a-22a450ff4fff@kernel.dk>
Date: Tue, 15 Jul 2025 12:21:52 -0600
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
Subject: [PATCH for-next] io_uring: deduplicate wakeup handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Both io_poll_wq_wake() and io_cqring_wake() contain the exact same code,
and most of the comment in the latter applies equally to both.

Move the test and wakeup handling into a basic helper that they can both
use, and move part of the comment that applies generically to this new
helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dc17162e7af1..abc6de227f74 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -294,11 +294,22 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
+static inline void __io_wq_wake(struct wait_queue_head *wq)
+{
+	/*
+	 *
+	 * Pass in EPOLLIN|EPOLL_URING_WAKE as the poll wakeup key. The latter
+	 * set in the mask so that if we recurse back into our own poll
+	 * waitqueue handlers, we know we have a dependency between eventfd or
+	 * epoll and should terminate multishot poll at that point.
+	 */
+	if (wq_has_sleeper(wq))
+		__wake_up(wq, TASK_NORMAL, 0, poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
+}
+
 static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 {
-	if (wq_has_sleeper(&ctx->poll_wq))
-		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
-				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
+	__io_wq_wake(&ctx->poll_wq);
 }
 
 static inline void io_cqring_wake(struct io_ring_ctx *ctx)
@@ -307,15 +318,9 @@ static inline void io_cqring_wake(struct io_ring_ctx *ctx)
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
 	 * won't necessarily wake up all the tasks, io_should_wake() will make
 	 * that decision.
-	 *
-	 * Pass in EPOLLIN|EPOLL_URING_WAKE as the poll wakeup key. The latter
-	 * set in the mask so that if we recurse back into our own poll
-	 * waitqueue handlers, we know we have a dependency between eventfd or
-	 * epoll and should terminate multishot poll at that point.
 	 */
-	if (wq_has_sleeper(&ctx->cq_wait))
-		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
-				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
+
+	__io_wq_wake(&ctx->cq_wait);
 }
 
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)

-- 
Jens Axboe



Return-Path: <io-uring+bounces-607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D442B856947
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 17:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F7CBB21BA9
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 16:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9F713959E;
	Thu, 15 Feb 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xwyU+dEG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7367C13A24E
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013409; cv=none; b=YPjm5nPAadTvH4qoQyHw/6XThf7Z6c6/9TcQDW30LU5b0SsprkT2eTsaKk+iJOIWu73lIlguHU19cH10+3m7Fq4O4lFxruFKbzl5WBM+ckanBsG+zGQh7jyU1b5BzhOtNvHPWlhP+rrdzjen/vXfpBqitOsAQ8RaIHaU2CoZVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013409; c=relaxed/simple;
	bh=bmsxmG+OqlGTcY/3NXZ+G6esoExlSkE8JVHVGK3CfKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsTB34FqPE3aBEGy7MQ9YVlKrOKriLcuhQ2f4ObLGlx+fQg9P9hYdq7HoCG7kHfZp957wFPXRVpcXuttmN+V81d8eYfOfVfyygGvVZZqiVWuJuHWyWs/LTnxiYXnqKvND+WzalSMn20INku/cOeq3RJkhwfOzeZnUoHuJNuPbr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xwyU+dEG; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so535565ab.1
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 08:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708013406; x=1708618206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RODZUjyaVV50YYBvMGYdEqYxM/1CrYMy8Opg6CHor5g=;
        b=xwyU+dEGC5iQoaKmNJIoDJXupqYCY6XELsMbQp0KoLG+q3bi6II84v+j2Bu0PaFbqn
         CUuBUj9fWfB1TUnjF9Lfshtc9GvsYvBMR4kqAIw7jcDlf8iiKo30t6epz79gLn0vkTa4
         14eqOHWAtIwN95LmSc+hQ+HXaslMFasbTP7vIEc2BWPk+IQONCLf30p9fOVHPQJifned
         shJ9StR7RIZ+f97GQz3TWStptI5Un1VLXRxKGLxVu3ehBLr886yMuY+W/Ij+FJxljxRm
         as/HdMNCzib3YCuell3XHrmJfNvGGvVx+4GkqalsjdSNya3GEGHdHCRLpozwaxClDmh2
         zB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708013406; x=1708618206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RODZUjyaVV50YYBvMGYdEqYxM/1CrYMy8Opg6CHor5g=;
        b=veMwTCBRYKkcNg8qxhBD6PNFGJzJ8yi3sW98JyikS5ME6XR9lP0/Mo4XsAWfsCBjKf
         5uj9ZYFrMN26a4ajKFSDdorL9MsmFlYF4xanrapo311ddDvt0wjw4jnc9gvpZsR8yaEv
         WCNOlq5gIRqDs7SoYE7wJpXO3777VPSkHiM6OP4VlP8bgMYxuMG+dLO0MrYKhvxgjTrH
         u1KYXDk3TbsitTaY9JVcnNSMncWA34B2iwkNcLWdQGiez/VYa4O2oQYN5XdNtrloxazf
         OTQKX7S5AOPd/ebGU+HDss05y/JivdruLk5IPbgDX4+ShIVnllnOPb3p063wht6O+s8C
         aBag==
X-Gm-Message-State: AOJu0YwR4Wltof2tNuTtZqaIgwlpeVjaHKsfBSgGYPAE59vrPTV5fySm
	L01gkdcGca+XcdvBuspx114VP1zU9RZL+6ck9s1gLeyMxLMTK+xqOcO8JmqujWQDMAEfNkH1Ax9
	4
X-Google-Smtp-Source: AGHT+IGYV3MEI69MAMPuDiabhbXQZVf2mkXgoJNiEmmu3Crd7ms9Q5eTNs3gHkpGLdp5vNoELDWidA==
X-Received: by 2002:a05:6e02:1d0a:b0:363:b545:3a97 with SMTP id i10-20020a056e021d0a00b00363b5453a97mr2235087ila.0.1708013406181;
        Thu, 15 Feb 2024 08:10:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e02074400b0036275404ab3sm458524ils.85.2024.02.15.08.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:10:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move schedule wait logic into helper
Date: Thu, 15 Feb 2024 09:06:56 -0700
Message-ID: <20240215161002.3044270-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215161002.3044270-1-axboe@kernel.dk>
References: <20240215161002.3044270-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for expanding how we handle waits, move the actual
schedule and schedule_timeout() handling into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45a2f8f3a77c..8f52acc14ebc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2516,22 +2516,10 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
-/* when returns >0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
 {
-	int io_wait, ret;
-
-	if (unlikely(READ_ONCE(ctx->check_cq)))
-		return 1;
-	if (unlikely(!llist_empty(&ctx->work_llist)))
-		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
-		return 1;
-	if (unlikely(task_sigpending(current)))
-		return -EINTR;
-	if (unlikely(io_should_wake(iowq)))
-		return 0;
+	int io_wait, ret = 0;
 
 	/*
 	 * Mark us as being in io_wait if we have pending requests, so cpufreq
@@ -2541,7 +2529,6 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
-	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
@@ -2550,6 +2537,24 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+/* when returns >0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq)
+{
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
+	if (unlikely(!llist_empty(&ctx->work_llist)))
+		return 1;
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+		return 1;
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+	if (unlikely(io_should_wake(iowq)))
+		return 0;
+
+	return __io_cqring_wait_schedule(ctx, iowq);
+}
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
-- 
2.43.0



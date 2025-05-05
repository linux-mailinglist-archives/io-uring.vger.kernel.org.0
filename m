Return-Path: <io-uring+bounces-7838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B6AAAA5BE
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 01:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4BD37A9895
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 23:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B994F28D841;
	Mon,  5 May 2025 22:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSQTOacl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E52828CF5E;
	Mon,  5 May 2025 22:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484252; cv=none; b=AyzOZ0tZ+XOVwOH3GvKN7F7dB8JbDqu1tE/jvWP30dZ21mSeCXg7POaq30bLMf86yO76I6P0swuVU3ucMYSKrjZtRTG5DYGMAkRusU2ndS6w4q24Zieq8CQeQ2C4F6KmleyeYPdEKx9TdBuBYHSzhoBoHjLd5T2XL6W51X/s/l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484252; c=relaxed/simple;
	bh=777VY6Mu1P9Z4jqCtcNKZWrGxYdlrwWcqoOiOUx/R58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jly7maXnSyAtf90YAg9f4LXV/HAtShT/hfnH4aIMSZpuDEWv+9STwcVQjDHaKOEAgT2x8H4HshUoyLFPK0lxJEV5XTklgZSpn92QfalW6XrUFbaTF0E6HjF5OIToFFg3G2m0v+3KBjjOW8HR7xCekb9es3KKEiBA85cwj7Et98I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSQTOacl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9966C4CEED;
	Mon,  5 May 2025 22:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484252;
	bh=777VY6Mu1P9Z4jqCtcNKZWrGxYdlrwWcqoOiOUx/R58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSQTOaclwVqOnlbCx2LYOoE2uIv9v9J/nez7KMat4xob8r8LDAcUumjTInqJeqqWh
	 TDjvZKcT6uJjoVbLyQqETZD5gvAFpL1jvH71VTz0Hgg3kIkyHDcGJuREaEYq1FIdC2
	 2/za1hQhqRNbdDH4RaXJlj+2nEue76jJ9xYTxW/iMxqv3MO6nt9c8w45WygiM19IQG
	 G8b/PCfyZeUYitfbk4gvy5QzGQlyz1k/Am/DgoJmHcla6+OQjeFDlsQx/lLvcGmZxS
	 tl+CJOeBzh2joXGw4Fv+jUKfewj1rJO98JcJfGQb3ZKFG7kRHVG65b6evzWlaod6as
	 IH/2eWbCejEgg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 413/642] io_uring: sanitise ring params earlier
Date: Mon,  5 May 2025 18:10:29 -0400
Message-Id: <20250505221419.2672473-413-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 92a3bac9a57c39728226ab191859c85f5e2829c0 ]

Do all struct io_uring_params validation early on before allocating the
context. That makes initialisation easier, especially by having fewer
places where we need to care about partial de-initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/363ba90b83ff78eefdc88b60e1b2c4a39d182247.1738344646.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 77 ++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 96c660bf4ef59..bb4fb2faf6baf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3539,6 +3539,44 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
+static int io_uring_sanitise_params(struct io_uring_params *p)
+{
+	unsigned flags = p->flags;
+
+	/* There is no way to mmap rings without a real fd */
+	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
+	    !(flags & IORING_SETUP_NO_MMAP))
+		return -EINVAL;
+
+	if (flags & IORING_SETUP_SQPOLL) {
+		/* IPI related flags don't make sense with SQPOLL */
+		if (flags & (IORING_SETUP_COOP_TASKRUN |
+			     IORING_SETUP_TASKRUN_FLAG |
+			     IORING_SETUP_DEFER_TASKRUN))
+			return -EINVAL;
+	}
+
+	if (flags & IORING_SETUP_TASKRUN_FLAG) {
+		if (!(flags & (IORING_SETUP_COOP_TASKRUN |
+			       IORING_SETUP_DEFER_TASKRUN)))
+			return -EINVAL;
+	}
+
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((flags & IORING_SETUP_HYBRID_IOPOLL) && !(flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	/*
+	 * For DEFER_TASKRUN we require the completion task to be the same as
+	 * the submission task. This implies that there is only one submitter.
+	 */
+	if ((flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    !(flags & IORING_SETUP_SINGLE_ISSUER))
+		return -EINVAL;
+
+	return 0;
+}
+
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
 	if (!entries)
@@ -3549,10 +3587,6 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 		entries = IORING_MAX_ENTRIES;
 	}
 
-	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
-	    && !(p->flags & IORING_SETUP_NO_MMAP))
-		return -EINVAL;
-
 	/*
 	 * Use twice as many entries for the CQ ring. It's possible for the
 	 * application to drive a higher depth than the size of the SQ ring,
@@ -3614,6 +3648,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct file *file;
 	int ret;
 
+	ret = io_uring_sanitise_params(p);
+	if (ret)
+		return ret;
+
 	ret = io_uring_fill_params(entries, p);
 	if (unlikely(ret))
 		return ret;
@@ -3661,37 +3699,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
 	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	ret = -EINVAL;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		/* IPI related flags don't make sense with SQPOLL */
-		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
-				  IORING_SETUP_TASKRUN_FLAG |
-				  IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
-		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
-		    !(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	else
 		ctx->notify_method = TWA_SIGNAL;
-	}
-
-	/* HYBRID_IOPOLL only valid with IOPOLL */
-	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
-			IORING_SETUP_HYBRID_IOPOLL)
-		goto err;
-
-	/*
-	 * For DEFER_TASKRUN we require the completion task to be the same as the
-	 * submission task. This implies that there is only one submitter, so enforce
-	 * that.
-	 */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
-	    !(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
-		goto err;
-	}
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
-- 
2.39.5



Return-Path: <io-uring+bounces-2836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BC79578A6
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E771C237FC
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91092183CC6;
	Mon, 19 Aug 2024 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BV1TREEH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C271537D4
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110252; cv=none; b=Fy8U3bofYMd91sj/m5Fsuz6wfHs4ezA0uMKrKBtuVOZmtqAjrvSFLz23rZ14nX6GQkamXAln9Guregfod10lQ43rVhDHsyzEUMEsyP2/QUbwFZA/7zOHsNNGB5FFXN9wGb7mD9EpRCNwhaNkxmzOTdVBUhmJy7KUK9nhmE4ZLrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110252; c=relaxed/simple;
	bh=xMoc4My7QZ8jZ5RQ5B8Hxyx6CrgWlRJp/Q9mFmCwZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJrNQqszbG4B8IwFdols7rUvZJy6Uu8LtThHF8sX458kfO0eCh3lXylSRMcJbfvUaZ6azCrc1f5Dnyb18l8I/jEMHPve8f6D7VCUNvewKv14wi7iAFhfyREPIvFsgXdZTiUCCTxa0TfdlsiqnlhvdifZOh2vMZ81aaAFAF5Eu54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BV1TREEH; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2d3d382de43so837063a91.0
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110248; x=1724715048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6LTIh3DcVfrLOVFkRBBopt0cmnN3QyNN9FFhzOKYYo=;
        b=BV1TREEHm2uxD4Qhr/CdoOOtk5nP1l003PQ6320gB+nd8CqlnDNXijML1sjiygTrd5
         MC3E605zAxu9fdJyIII8ONQlDhST2ER+B9xVpdgGrHJpeZFAsRxM96/8vsca8o3GyheX
         hkZOjd/Gj6bg2egLka0Ygw2UNZGEcUgMftcCMTkpfpZwRVsMBNK09G7tllw4tIN+9aIz
         fxjrqAZCERtJvlRJshSAd+Oc4oMyZ8krOejFkzfnLA4kMNgNfx7HX01bGBo1VMkHysqW
         H54Ww1IAQbsLbT8+fR8PhDwRMDj0AstdsdVntMbs/dRhCxFMIQGtCwF8qRDq15cnWrIw
         rOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110248; x=1724715048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6LTIh3DcVfrLOVFkRBBopt0cmnN3QyNN9FFhzOKYYo=;
        b=eW+TpZC3OUUY/hA+1LelOi99wMSqZloMpFxrNPUjjKJyjzQVqxmbsshmQu+MfX7JvW
         Yee4NRWsWTJgJNDOp+HgX928mzcvQ+fqtWXyNiJa19g776TZhtp2H/3AWncGOBN3YNoJ
         1p8sHzpoR6fX2RI21A/Wcnq7IxkRAvlQe8ijrDIFvq8J8rSYGtgaIiOFXZHFzPoS2mlX
         QEUMrGsrw52jdMSjwnWhxjLc81lvvmR2O9UJq2aGxzxxHk1f5i1VqMllyjdwkT0Cygrw
         ftIhy3wDKpUSm+mMJI0NrVHw1eqo2UH9Th3l5fs98tjrWksQZkk6p13uOZO7f8L8H73s
         MUeA==
X-Gm-Message-State: AOJu0YyG2YLfMva109gFY3sniEQeyC1ZPOoENYcdqx10zWR4W05iN7Lr
	sffMOzd2oZgzCoYJorLMCOl8MJ+qOwPU4wZcmnLV1LYj1gOh6NKg0rRHukIcX3fccju74kPSAjm
	d
X-Google-Smtp-Source: AGHT+IHYsRqGLanl5cGrCrR1wkrrhsX4yFqxQT2sJD+4ZZD0wcMYWal2h3gHNJ/2FiU5iyvPr2Ca4A==
X-Received: by 2002:a17:902:f545:b0:202:41cb:7d73 with SMTP id d9443c01a7336-20241cb80c9mr32240365ad.11.1724110247580;
        Mon, 19 Aug 2024 16:30:47 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: encapsulate extraneous wait flags into a separate struct
Date: Mon, 19 Aug 2024 17:28:49 -0600
Message-ID: <20240819233042.230956-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240819233042.230956-1-axboe@kernel.dk>
References: <20240819233042.230956-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than need to pass in 2 or 3 separate arguments, add a struct
to encapsulate the timeout and sigset_t parts of waiting. In preparation
for adding another argument for waiting.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20229e72b65c..37053d32c668 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2384,13 +2384,18 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+struct ext_arg {
+	size_t argsz;
+	struct __kernel_timespec __user *ts;
+	const sigset_t __user *sig;
+};
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
-			  const sigset_t __user *sig, size_t sigsz,
-			  struct __kernel_timespec __user *uts)
+			  struct ext_arg *ext_arg)
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
@@ -2415,10 +2420,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout = KTIME_MAX;
 
-	if (uts) {
+	if (ext_arg->ts) {
 		struct timespec64 ts;
 
-		if (get_timespec64(&ts, uts))
+		if (get_timespec64(&ts, ext_arg->ts))
 			return -EFAULT;
 
 		iowq.timeout = timespec64_to_ktime(ts);
@@ -2426,14 +2431,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
 	}
 
-	if (sig) {
+	if (ext_arg->sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      sigsz);
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)ext_arg->sig,
+						      ext_arg->argsz);
 		else
 #endif
-			ret = set_user_sigmask(sig, sigsz);
+			ret = set_user_sigmask(ext_arg->sig, ext_arg->argsz);
 
 		if (ret)
 			return ret;
@@ -3112,9 +3117,8 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 	return 0;
 }
 
-static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-			  struct __kernel_timespec __user **ts,
-			  const sigset_t __user **sig)
+static int io_get_ext_arg(unsigned flags, const void __user *argp,
+			  struct ext_arg *ext_arg)
 {
 	struct io_uring_getevents_arg arg;
 
@@ -3123,8 +3127,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	 * is just a pointer to the sigset_t.
 	 */
 	if (!(flags & IORING_ENTER_EXT_ARG)) {
-		*sig = (const sigset_t __user *) argp;
-		*ts = NULL;
+		ext_arg->sig = (const sigset_t __user *) argp;
+		ext_arg->ts = NULL;
 		return 0;
 	}
 
@@ -3132,15 +3136,15 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	 * EXT_ARG is set - ensure we agree on the size of it and copy in our
 	 * timespec and sigset_t pointers if good.
 	 */
-	if (*argsz != sizeof(arg))
+	if (ext_arg->argsz != sizeof(arg))
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
 	if (arg.pad)
 		return -EINVAL;
-	*sig = u64_to_user_ptr(arg.sigmask);
-	*argsz = arg.sigmask_sz;
-	*ts = u64_to_user_ptr(arg.ts);
+	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
+	ext_arg->argsz = arg.sigmask_sz;
+	ext_arg->ts = u64_to_user_ptr(arg.ts);
 	return 0;
 }
 
@@ -3246,15 +3250,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			}
 			mutex_unlock(&ctx->uring_lock);
 		} else {
-			const sigset_t __user *sig;
-			struct __kernel_timespec __user *ts;
+			struct ext_arg ext_arg = { .argsz = argsz };
 
-			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
 				ret2 = io_cqring_wait(ctx, min_complete, flags,
-						      sig, argsz, ts);
+						      &ext_arg);
 			}
 		}
 
-- 
2.43.0



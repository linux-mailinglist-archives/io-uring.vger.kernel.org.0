Return-Path: <io-uring+bounces-2800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 314639551F6
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEEF1B22D92
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267A476F17;
	Fri, 16 Aug 2024 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BK6W3aIu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680C1C230D
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841054; cv=none; b=utPdi4/xDFsP/iLsNYofafOWMAutGod+QwHJliorAjmqISmSorqrpUNGZvq5EsK+Udwtu7U19YHs71C5CQRqDnhqTWUPzjK5szc/efil/D8Cgta1DO89I0iT0e59/3M1I3rVx1BGrPiEuYNZHTTENiPAWZbKvz14v1elV3xLv1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841054; c=relaxed/simple;
	bh=tB0tCZSdRi2oyTqFUEOB3V9vv0GX0xX7UvXSoNVRUfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pA7t/913flxynDWxCwo8cour3qQ/N20WxG+4TtFL4BWMnVluFvuYx6wt8tMwYLvDsZypkh0IOt2AvXMx/v1Ucik7xMj5wgJ+7aj1IAo1zzZfbMIxvKcjvBLqS540ocqlR5TvgsrVVY+g8ud26cO7fVrmDtKyDMOuTTf2AQFss4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BK6W3aIu; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70d2ff38af8so84372b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841050; x=1724445850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9Voe6ecOrXy/INncXXq7Jez8vuNLGZ98y4ll3KiRPM=;
        b=BK6W3aIu0zGXYlpCEvPz1GtyZID75kjMvDEmrYsZyihItl0KWr0Z0Rlpb5n4NLhTtw
         sukMxc6lAL1NOkMYhU7qiXf9my7SilNpLkzV44FgHcp8GlvXvBOC4txa5Gh0n5ucrC4N
         0WvEERasVRMOQ4T+8dBF0uKrco5JFqkfkG98+EEjfCwM5SEwNGwqgq43CNp8JPICF1Jo
         25Eu+KTzmJfemwSZ1ngtfa1RAkvy8giYsOajs5PihanMtL2Seb0LctfAL9y18PJ9oB0w
         oi2cJD3Fu/HjhYXDIuVryYOoHecN7lKvxkC20KE0xnnMGwAVRPCRvQb+ky+eqUpbyAcc
         pXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841050; x=1724445850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9Voe6ecOrXy/INncXXq7Jez8vuNLGZ98y4ll3KiRPM=;
        b=ArMcpLoyZ4VBxoyanMUA6lFF5AeDGjcTn0JLTfCJQ+p+vLHyeNcoke2NrajY1ttdMh
         E1xuzcWPwOYhJj8FCDKOKjDRU1uU8/4eY0tYs14c91U/wydhc8xVwDrwp6O2c0iWk0QR
         Tv1na/hUcywFQoWmCUTxonHNh6P2V9r8QFhTVhhDMpAAVxJrb8d9SEPdMp6UovwppUnK
         mCx7ySQaYnYnVyoxuqlaT41UQefDUn2iCd9NK4ZFYtez/nDjYMAa2OshiUZ1pi4CdvpK
         APD/oJocrCXq+e23XVIXvIq079W90rC6++hmFO4TLrLzn3Zx4y2VAcqRqOktBThhQZ8D
         nDew==
X-Gm-Message-State: AOJu0YzT50eXTF9MpORzppSrUta8mXFM940j0o3NGK+XCaBAuTQxObiE
	AmvzKZRoyXR8nQ3Xm9wh9OaAG8CwWISsC7nhVat+9DJsxBOW7f7aEdlXMB37QxQDek1anLlBAiM
	1
X-Google-Smtp-Source: AGHT+IH5KdRDm0AW2n4BI4YRmXCkVnG5fRc9AgGsHtkdFNztEq0wZBcTHH6cC4xOlMtNZCUM5jZQaw==
X-Received: by 2002:a17:902:ea0f:b0:1fd:aac9:a722 with SMTP id d9443c01a7336-20203ed4500mr27792415ad.4.1723841050536;
        Fri, 16 Aug 2024 13:44:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: encapsulate extraneous wait flags into a separate struct
Date: Fri, 16 Aug 2024 14:38:12 -0600
Message-ID: <20240816204302.85938-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240816204302.85938-2-axboe@kernel.dk>
References: <20240816204302.85938-2-axboe@kernel.dk>
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
index 5e75672525df..f90a4490908b 100644
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
@@ -2416,10 +2421,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.timeout = KTIME_MAX;
 	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;
 
-	if (uts) {
+	if (ext_arg->ts) {
 		struct timespec64 ts;
 
-		if (get_timespec64(&ts, uts))
+		if (get_timespec64(&ts, ext_arg->ts))
 			return -EFAULT;
 
 		iowq.timeout = timespec64_to_ktime(ts);
@@ -2427,14 +2432,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
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
@@ -3113,9 +3118,8 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 	return 0;
 }
 
-static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-			  struct __kernel_timespec __user **ts,
-			  const sigset_t __user **sig)
+static int io_get_ext_arg(unsigned flags, const void __user *argp,
+			  struct ext_arg *ext_arg)
 {
 	struct io_uring_getevents_arg arg;
 
@@ -3124,8 +3128,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	 * is just a pointer to the sigset_t.
 	 */
 	if (!(flags & IORING_ENTER_EXT_ARG)) {
-		*sig = (const sigset_t __user *) argp;
-		*ts = NULL;
+		ext_arg->sig = (const sigset_t __user *) argp;
+		ext_arg->ts = NULL;
 		return 0;
 	}
 
@@ -3133,15 +3137,15 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
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
 
@@ -3247,15 +3251,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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



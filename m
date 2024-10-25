Return-Path: <io-uring+bounces-4037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D8F9B0546
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A7E2B22D76
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADB21D435C;
	Fri, 25 Oct 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zwG5Xhhe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D558D1FB899
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865654; cv=none; b=jfEzIqbkx4haJloVZvXmPPF7K/ohCeZY7w7sNwxVB2EQQ5uvtyaz50njuTroYO1AStLF9MXFxsxTT5IbpVh/LEIq53XwrAYQyrEJd9FFIXG/8c4dcOiPqxAZQcTBcZ2CjQhe0SxyLG32PCunytf+nmrvX4JEtucqbL3xvBCT+sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865654; c=relaxed/simple;
	bh=TFLXeVbjDBK3oRUxG43NOPRmcmPuVe4er0iJBbUtLKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsxvWBc/MyF5cawk6EuLp5XDctPKRI37DILRp3veBQNjD0+B+EF9kg8ZIspYtyhRaUrBHDrYUJozA/pyJC2KVwFfbtx6ukKoBZr7l7YJkUP1qiu4fFbXCKZT94xXThFBEulSIxCO8CUoPdETNgPALIZYldCfqM80Rt6Hr6IwkOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zwG5Xhhe; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83a9be2c0e6so80205139f.2
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865650; x=1730470450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U0fZJfyzyn/9wmH25vXqeJ0H5GV6ZLBvZYzSg9ipdwM=;
        b=zwG5XhheSKcsKSdCUQH4xhSxezbWpUhoIrz5PXOhOSsYJEZSTTFGkQndeMKCT1lr3X
         4w3DxzY/rp+XXPFrqraCaxAQpQ79pydxS/a7stD3Bb+SVqUGGqpcuVI3xm6eejsGOGo6
         7QwovQBNOUjLtSqf++s2STsEfd2/w/vtmVifUhcoMFLpbs3gqE+FRFh2r/xBk4CMgMAR
         ya10es0PUVAtQFC52kuiWaFvQwPzDMBULbiWsSjD/Znodf3NoLEg2ZtDD/blHYQEmrNo
         kXZQsvYidewMEEHoZGGKPUn7ppgXhN/2BiASnFGaKxHPmVM6+n6qsVxnXePkMzAWobgM
         sHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865650; x=1730470450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U0fZJfyzyn/9wmH25vXqeJ0H5GV6ZLBvZYzSg9ipdwM=;
        b=r6xgcJXc61ZZ0HtJO1viMPLoor84A4Oi+iM3lMEnI4J/ihXcQKI8Gzn/YJDQg8nFwH
         Nx/3nS6Yh+mG0HSsjQcMdLkG0qnKALZmp7ZtLumW/tsvzvvgaqmBK8qMTE5PWlIU3D2q
         gSwR8CzoRiZLS8mxkvtufreVaUG8Ee44S2ll0cyzJSrZLOAL3V8CWIPir2W+nUTCYMMB
         461szRMxDFEGy/KaZJ5DnFTIjtg5Nmxp3sYPr1JaAuRVfUd5CU7QqCQzwWY+RKvB5eOJ
         aKcJAKNi29Q7UtUdlTxhS0MeX0GDFUzYloyXXnajp4e5cuC2dQx+STmjHaVnPs6b8qr6
         fxjw==
X-Gm-Message-State: AOJu0YyjQkO1I3kbkLot0qJUyRRrntAC1AI0F9D6p/guBAjLErJdW8Ic
	EXb+N4TR4en8EHtDkY5r5wAl8cBcKfJYlI5rjmz85b+pfcsIp/+0v0YYFi8e5MHgDc5qMLHvOQs
	u
X-Google-Smtp-Source: AGHT+IEE6hVUm4Sbu908CCg8SvLPhAXw3Py1cpOtbUzSOJT0qbQjgP7eVDyiC2+OGKO6dw+fYstRpA==
X-Received: by 2002:a05:6602:15d1:b0:82d:13ce:2956 with SMTP id ca18e2360f4ac-83af61e95d7mr903578539f.10.1729865650108;
        Fri, 25 Oct 2024 07:14:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb673sm277292173.16.2024.10.25.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:14:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for fixed wait regions
Date: Fri, 25 Oct 2024 08:13:00 -0600
Message-ID: <20241025141403.169518-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025141403.169518-1-axboe@kernel.dk>
References: <20241025141403.169518-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generally applications have 1 or a few waits of waiting, yet they pass
in a struct io_uring_getevents_arg every time. This needs to get copied
and, in turn, the timeout value needs to get copied.

Rather than do this for every invocation, allow the application to
register a fixed set of wait regions that can simply be indexed when
asking the kernel to wait on events.

At ring setup time, the application can register a number of these wait
regions and initialize region/index 0 upfront:

	struct io_uring_reg_wait *reg;

	reg = io_uring_setup_reg_wait(ring, nr_regions, &ret);

	/* set timeout and mark as set, sigmask/sigmask_sz as needed */
	reg->ts.tv_sec = 0;
	reg->ts.tv_nsec = 100000;
	reg->flags = IORING_REG_WAIT_TS;

where nr_regions >= 1 && nr_regions <= PAGE_SIZE / sizeof(*reg). The
above initializes index 0, but 63 other regions can be initialized,
if needed. Now, instead of doing:

	struct __kernel_timespec timeout = { .tv_nsec = 100000, };

	io_uring_submit_and_wait_timeout(ring, &cqe, nr, &t, NULL);

to wait for events for each submit_and_wait, or just wait, operation, it
can just reference the above region at offset 0 and do:

	io_uring_submit_and_wait_reg(ring, &cqe, nr, 0);

to achieve the same goal of waiting 100usec without needing to copy
both struct io_uring_getevents_arg (24b) and struct __kernel_timeout
(16b) for each invocation. Struct io_uring_reg_wait looks as follows:

struct io_uring_reg_wait {
	struct __kernel_timespec	ts;
	__u32				min_wait_usec;
	__u32				flags;
	__u64				sigmask;
	__u32				sigmask_sz;
	__u32				pad[3];
	__u64				pad2[2];
};

embedding the timeout itself in the region, rather than passing it as
a pointer as well. Note that the signal mask is still passed as a
pointer, both for compatability reasons, but also because there doesn't
seem to be a lot of high frequency waits scenarios that involve setting
and resetting the signal mask for each wait.

The application is free to modify any region before a wait call, or it
can use keep multiple regions with different settings to avoid needing to
modify the same one for wait calls. Up to a page size of regions is mapped
by default, allowing PAGE_SIZE / 64 available regions for use.

The registered region must fit within a page. On a 4kb page size system,
that allows for 64 wait regions if a full page is used, as the size of
struct io_uring_reg_wait is 64b. The region registered must be aligned
to io_uring_reg_wait in size. It's valid to register less than 64
entries.

In network performance testing with zero-copy, this reduced the time
spent waiting on the TX side from 3.12% to 0.3% and the RX side from 4.4%
to 0.3%.

Wait regions are fixed for the lifetime of the ring - once registered,
they are persistent until the ring is torn down. The regions support
minimum wait timeout as well as the regular waits.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 10 +++++
 include/uapi/linux/io_uring.h  | 41 +++++++++++++++++
 io_uring/io_uring.c            | 68 +++++++++++++++++++++++-----
 io_uring/register.c            | 82 ++++++++++++++++++++++++++++++++++
 io_uring/register.h            |  1 +
 5 files changed, 191 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 841579dcdae9..2f12828b22a4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -327,6 +327,14 @@ struct io_ring_ctx {
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
 		struct wait_queue_head	cq_wait;
+
+		/*
+		 * If registered with IORING_REGISTER_CQWAIT_REG, a single
+		 * page holds N entries, mapped in cq_wait_arg. cq_wait_index
+		 * is the maximum allowable index.
+		 */
+		struct io_uring_reg_wait	*cq_wait_arg;
+		unsigned char			cq_wait_index;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
@@ -430,6 +438,8 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+
+	struct page			**cq_wait_page;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c4737892c7cd..7dfa046b3c61 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -518,6 +518,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
+#define IORING_ENTER_EXT_ARG_REG	(1U << 6)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -618,6 +619,9 @@ enum io_uring_register_op {
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
+	/* register fixed io_uring_reg_wait arguments */
+	IORING_REGISTER_CQWAIT_REG		= 34,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -801,6 +805,43 @@ enum io_uring_register_restriction_op {
 	IORING_RESTRICTION_LAST
 };
 
+enum {
+	IORING_REG_WAIT_TS		= (1U << 0),
+};
+
+/*
+ * Argument for IORING_REGISTER_CQWAIT_REG, registering a region of
+ * struct io_uring_reg_wait that can be indexed when io_uring_enter(2) is
+ * called rather than pass in a wait argument structure separately.
+ */
+struct io_uring_cqwait_reg_arg {
+	__u32		flags;
+	__u32		struct_size;
+	__u32		nr_entries;
+	__u32		pad;
+	__u64		user_addr;
+	__u64		pad2[3];
+};
+
+/*
+ * Argument for io_uring_enter(2) with
+ * IORING_GETEVENTS | IORING_ENTER_EXT_ARG_REG set, where the actual argument
+ * is an index into a previously registered fixed wait region described by
+ * the below structure.
+ */
+struct io_uring_reg_wait {
+	struct __kernel_timespec	ts;
+	__u32				min_wait_usec;
+	__u32				flags;
+	__u64				sigmask;
+	__u32				sigmask_sz;
+	__u32				pad[3];
+	__u64				pad2[2];
+};
+
+/*
+ * Argument for io_uring_enter(2) with IORING_GETEVENTS | IORING_ENTER_EXT_ARG
+ */
 struct io_uring_getevents_arg {
 	__u64	sigmask;
 	__u32	sigmask_sz;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4cd0ee52710d..2863b957e373 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2736,6 +2736,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
+	io_unregister_cqwait_reg(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -3224,21 +3225,43 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
-static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t argsz)
+static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
+			const struct io_uring_getevents_arg __user *uarg)
 {
-	if (flags & IORING_ENTER_EXT_ARG) {
-		struct io_uring_getevents_arg arg;
+	struct io_uring_reg_wait *arg = READ_ONCE(ctx->cq_wait_arg);
 
-		if (argsz != sizeof(arg))
+	if (arg) {
+		unsigned int index = (unsigned int) (uintptr_t) uarg;
+
+		if (index <= ctx->cq_wait_index)
+			return arg + index;
+	}
+
+	return ERR_PTR(-EFAULT);
+}
+
+static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
+			       const void __user *argp, size_t argsz)
+{
+	struct io_uring_getevents_arg arg;
+
+	if (!(flags & IORING_ENTER_EXT_ARG))
+		return 0;
+
+	if (flags & IORING_ENTER_EXT_ARG_REG) {
+		if (argsz != sizeof(struct io_uring_reg_wait))
 			return -EINVAL;
-		if (copy_from_user(&arg, argp, sizeof(arg)))
-			return -EFAULT;
+		return PTR_ERR(io_get_ext_arg_reg(ctx, argp));
 	}
+	if (argsz != sizeof(arg))
+		return -EINVAL;
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
 	return 0;
 }
 
-static int io_get_ext_arg(unsigned flags, const void __user *argp,
-			  struct ext_arg *ext_arg)
+static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
+			  const void __user *argp, struct ext_arg *ext_arg)
 {
 	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
@@ -3252,6 +3275,28 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		return 0;
 	}
 
+	if (flags & IORING_ENTER_EXT_ARG_REG) {
+		struct io_uring_reg_wait *w;
+
+		if (ext_arg->argsz != sizeof(struct io_uring_reg_wait))
+			return -EINVAL;
+		w = io_get_ext_arg_reg(ctx, argp);
+		if (IS_ERR(w))
+			return PTR_ERR(w);
+
+		if (w->flags & ~IORING_REG_WAIT_TS)
+			return -EINVAL;
+		ext_arg->min_time = READ_ONCE(w->min_wait_usec) * NSEC_PER_USEC;
+		ext_arg->sig = u64_to_user_ptr(READ_ONCE(w->sigmask));
+		ext_arg->argsz = READ_ONCE(w->sigmask_sz);
+		if (w->flags & IORING_REG_WAIT_TS) {
+			ext_arg->ts.tv_sec = READ_ONCE(w->ts.tv_sec);
+			ext_arg->ts.tv_nsec = READ_ONCE(w->ts.tv_nsec);
+			ext_arg->ts_set = true;
+		}
+		return 0;
+	}
+
 	/*
 	 * EXT_ARG is set - ensure we agree on the size of it and copy in our
 	 * timespec and sigset_t pointers if good.
@@ -3297,7 +3342,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER |
+			       IORING_ENTER_EXT_ARG_REG)))
 		return -EINVAL;
 
 	/*
@@ -3380,7 +3426,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 */
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
-			ret2 = io_validate_ext_arg(flags, argp, argsz);
+			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
@@ -3390,7 +3436,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		} else {
 			struct ext_arg ext_arg = { .argsz = argsz };
 
-			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
+			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
diff --git a/io_uring/register.c b/io_uring/register.c
index fc6c94d694b2..1eb686eaa310 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -570,6 +570,82 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+void io_unregister_cqwait_reg(struct io_ring_ctx *ctx)
+{
+	unsigned short npages = 1;
+
+	if (!ctx->cq_wait_page)
+		return;
+
+	io_pages_unmap(ctx->cq_wait_arg, &ctx->cq_wait_page, &npages, true);
+	ctx->cq_wait_arg = NULL;
+	if (ctx->user)
+		__io_unaccount_mem(ctx->user, 1);
+}
+
+/*
+ * Register a page holding N entries of struct io_uring_reg_wait, which can
+ * be used via io_uring_enter(2) if IORING_GETEVENTS_EXT_ARG_REG is set.
+ * If that is set with IORING_GETEVENTS_EXT_ARG, then instead of passing
+ * in a pointer for a struct io_uring_getevents_arg, an index into this
+ * registered array is passed, avoiding two (arg + timeout) copies per
+ * invocation.
+ */
+static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
+{
+	struct io_uring_cqwait_reg_arg arg;
+	struct io_uring_reg_wait *reg;
+	struct page **pages;
+	unsigned long len;
+	int nr_pages, poff;
+	int ret;
+
+	if (ctx->cq_wait_page || ctx->cq_wait_arg)
+		return -EBUSY;
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+	if (!arg.nr_entries || arg.flags)
+		return -EINVAL;
+	if (arg.struct_size != sizeof(*reg))
+		return -EINVAL;
+	if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
+		return -EOVERFLOW;
+	if (len > PAGE_SIZE)
+		return -EINVAL;
+	/* offset + len must fit within a page, and must be reg_wait aligned */
+	poff = arg.user_addr & ~PAGE_MASK;
+	if (len + poff > PAGE_SIZE)
+		return -EINVAL;
+	if (poff % arg.struct_size)
+		return -EINVAL;
+
+	pages = io_pin_pages(arg.user_addr, len, &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+	ret = -EINVAL;
+	if (nr_pages != 1)
+		goto out_free;
+	if (ctx->user) {
+		ret = __io_account_mem(ctx->user, 1);
+		if (ret)
+			goto out_free;
+	}
+
+	reg = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
+	if (reg) {
+		ctx->cq_wait_index = arg.nr_entries - 1;
+		WRITE_ONCE(ctx->cq_wait_page, pages);
+		WRITE_ONCE(ctx->cq_wait_arg, (void *) reg + poff);
+		return 0;
+	}
+	ret = -ENOMEM;
+	if (ctx->user)
+		__io_unaccount_mem(ctx->user, 1);
+out_free:
+	io_pages_free(&pages, nr_pages);
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -764,6 +840,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_resize_rings(ctx, arg);
 		break;
+	case IORING_REGISTER_CQWAIT_REG:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_cqwait_reg(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/register.h b/io_uring/register.h
index a5f39d5ef9e0..3e935e8fa4b2 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -5,5 +5,6 @@
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
 struct file *io_uring_register_get_file(unsigned int fd, bool registered);
+void io_unregister_cqwait_reg(struct io_ring_ctx *ctx);
 
 #endif
-- 
2.45.2



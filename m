Return-Path: <io-uring+bounces-3945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D81FF9ACF9E
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6337B2369B
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BE01C0DD6;
	Wed, 23 Oct 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xbzRKFKP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CED1CACC8
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699009; cv=none; b=YWtbCk5euzPgjHkdvsHrO8RcWble16rUPYOYEW2qdJ8gKae+2bdPjtE5f6jkt5rr2Wq6UhysQRs2rUPQ+VZ+6ZBksh/7neYMf2xXQwJVa26YBJWFNZP4cTtCZ6reCmMpHUOrN2UoUQsTp2KRdPaHM79aSMge7+fj7ECoq/vp/KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699009; c=relaxed/simple;
	bh=s/E2tW7QCtv4OtGMUfwLNwN2hLwrAjCX1lcaRY4vE2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+TjLfm3qFg/OhPYWQVyKZW8r7I9rr+vo9cL1a5/thCzQvVRyKnLwdL2DLuR0wFSVG3dXU8fSAvG8QRW/ffG7wWZ9u5ADZKJIsBSXBnqP0LstCySPZv6qumWY44mTTar6heivHyT75YFFmrhL/+KV14n1Li7twh8b04ZD0Nx9Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xbzRKFKP; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ab94452a7so237480939f.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 08:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699006; x=1730303806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+Zh1gzaSOjXXONr7aRvoYvCGpH5OrTj4pnUiP1o7ws=;
        b=xbzRKFKPiaokN74iFq9wB8xV1wZOe9Jkr/hjtwSibUjeSv4L8LldQMkHX0upKGnuYY
         6aDLYILbJJ8+klQiaDWaXfrJqXYYT9FEqG9PHG+Y2OjRz/OT9DX2fDs6+D6sAGFjGpUC
         ZI4BQ7rHnuQoBC1WXgE/zllF3dGIzNiNjAsI5qTDzodiVk+mrEAKmTRldk1r5W2skk24
         X3hGam2XJUsoFh/bawzNJFEs1h3Pe53+LLoGkiriytP6X7I/4rr2gQ5qDdgknVJZ/8Z6
         IsbLwV5z/snTLuUmN/CVv6kNA+otLko3iSSB8P3SegeLm1yDjgCUkB6qUHSfOFy55xjT
         ujkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699006; x=1730303806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+Zh1gzaSOjXXONr7aRvoYvCGpH5OrTj4pnUiP1o7ws=;
        b=ac9PkfWGvrHfm83GWqGnhWCl0zNO5mVcrhhzVMTSOGb6rH5sewqOXYT7QaBQL0CoWa
         fCE0+j1PLmLWr+OwD81xnXnjmPLN+fBGGHrKCc77FCr66oy6cpGtyebu7qhYaWV+F3b/
         yMHrZvhUPTahciIkZRHE+vJBHgDOjvcc1mrX3GviGdG8RyGwzj0KXQU2Jd7x0ELl58Xm
         PsB711RNXN3BLUN1a9zVnG+UMqbx3RiiDYatryqaqjU72YSmNS8/SH11dhuDBnAE/O8s
         0q4zA7yZSnEV7kTMtnSUmFLOjiqfCswtRJZUBieBpEL62Ne/YPHGFaOeFbmltGT3A/lc
         RgIQ==
X-Gm-Message-State: AOJu0YyxMSbhDcYDy8NVAD/LYlANrFUXe63RaSgNi1I0B90XlgZb9Wx0
	V5Ft9ujy0nj+3cdd84Aolmkdf0L8gPZC5pQW2bQ0tM3nKZqwlmpYYwl/IfF83D6JTcLqMnw/4rY
	4
X-Google-Smtp-Source: AGHT+IH/N+KcaVg7ZmoLS5MqNbL9ENVHAFq0Ju/QYKq3EifZhLzAx9Bq7547dUFhWpYIfUG3NoeosA==
X-Received: by 2002:a05:6e02:1d02:b0:3a0:9fd8:f70b with SMTP id e9e14a558f8ab-3a4d594419dmr33799355ab.6.1729699006050;
        Wed, 23 Oct 2024 08:56:46 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6091bfsm2131572173.97.2024.10.23.08.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 08:56:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for fixed wait regions
Date: Wed, 23 Oct 2024 09:54:34 -0600
Message-ID: <20241023155639.1124650-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023155639.1124650-1-axboe@kernel.dk>
References: <20241023155639.1124650-1-axboe@kernel.dk>
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
regions ala:

	struct io_uring_reg_wait *reg;

	posix_memalign((void **) &reg, page_size, page_size);
	memset(reg, 0, page_size);

	/* set timeout and mark it as set, sigmask/sigmask_sz as needed */
	reg->ts.tv_sec = 0;
	reg->ts.tv_nsec = 100000;
	reg->flags = IORING_REG_WAIT_TS;

	io_uring_register_cqwait_reg(ring, reg, nr_regions);

and instead of doing:

	struct __kernel_timespec timeout = { .tv_nsec = 100000, };

	io_uring_submit_and_wait_timeout(ring, &cqe, nr, &t, NULL);

for each submit_and_wait, or just wait, operation, it can just reference
the above region at offset 0 and do:

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
they are persistent until the ring is torn down.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 10 +++++
 include/uapi/linux/io_uring.h  | 18 ++++++++
 io_uring/io_uring.c            | 68 ++++++++++++++++++++++++-----
 io_uring/register.c            | 79 ++++++++++++++++++++++++++++++++++
 io_uring/register.h            |  1 +
 5 files changed, 165 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6d3ee71bd832..9746f4bb5182 100644
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
@@ -423,6 +431,8 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+
+	struct page			**cq_wait_page;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c4737892c7cd..4ead32fa9275 100644
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
 
@@ -801,6 +805,20 @@ enum io_uring_register_restriction_op {
 	IORING_RESTRICTION_LAST
 };
 
+enum {
+	IORING_REG_WAIT_TS		= (1U << 0),
+};
+
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
 struct io_uring_getevents_arg {
 	__u64	sigmask;
 	__u32	sigmask_sz;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bfea5d1fbc67..27ea988e19ba 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2735,6 +2735,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
+	io_unregister_cqwait_reg(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -3223,21 +3224,43 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
-static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t argsz)
+static struct io_uring_reg_wait *io_get_ext_arg_fixed(struct io_ring_ctx *ctx,
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
+		return PTR_ERR(io_get_ext_arg_fixed(ctx, argp));
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
@@ -3251,6 +3274,28 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		return 0;
 	}
 
+	if (flags & IORING_ENTER_EXT_ARG_REG) {
+		struct io_uring_reg_wait *w;
+
+		if (ext_arg->argsz != sizeof(struct io_uring_reg_wait))
+			return -EINVAL;
+		w = io_get_ext_arg_fixed(ctx, argp);
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
@@ -3295,7 +3340,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER |
+			       IORING_ENTER_EXT_ARG_REG)))
 		return -EINVAL;
 
 	/*
@@ -3378,7 +3424,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 */
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
-			ret2 = io_validate_ext_arg(flags, argp, argsz);
+			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
@@ -3388,7 +3434,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		} else {
 			struct ext_arg ext_arg = { .argsz = argsz };
 
-			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
+			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
diff --git a/io_uring/register.c b/io_uring/register.c
index e38d83c8bbf1..8cc293c6c7a7 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -532,6 +532,79 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
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
+static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg,
+				  unsigned nr_args)
+{
+	struct io_uring_reg_wait *arg;
+	struct page **pages;
+	unsigned long len;
+	int nr_pages, poff;
+	int ret;
+
+	if (ctx->cq_wait_page || ctx->cq_wait_arg)
+		return -EBUSY;
+	/* must be >= 1 and must fit within a page */
+	if (!nr_args || nr_args > PAGE_SIZE / sizeof(*arg))
+		return -EINVAL;
+	if (check_mul_overflow(sizeof(*arg), nr_args, &len))
+		return -EOVERFLOW;
+	if (len > PAGE_SIZE)
+		return -EINVAL;
+	/* offset + len must fit within a page, and must be reg_wait aligned */
+	poff = (unsigned long) uarg & ~PAGE_MASK;
+	if (len + poff > PAGE_SIZE)
+		return -EINVAL;
+	if (poff % sizeof(struct io_uring_reg_wait))
+		return -EINVAL;
+
+	pages = io_pin_pages((unsigned long) uarg, len, &nr_pages);
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
+	arg = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
+	if (arg) {
+		ctx->cq_wait_index = nr_args - 1;
+		WRITE_ONCE(ctx->cq_wait_page, pages);
+		WRITE_ONCE(ctx->cq_wait_arg, (void *) arg + poff);
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
@@ -726,6 +799,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_resize_rings(ctx, arg);
 		break;
+	case IORING_REGISTER_CQWAIT_REG:
+		ret = -EINVAL;
+		if (!arg)
+			break;
+		ret = io_register_cqwait_reg(ctx, arg, nr_args);
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



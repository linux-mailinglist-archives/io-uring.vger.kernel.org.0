Return-Path: <io-uring+bounces-3926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5B99AB7F2
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E6BE1F239A4
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 20:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBB21CC88A;
	Tue, 22 Oct 2024 20:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tYsiZIIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F03D1CCECB
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729630040; cv=none; b=D/zOEbrVW3Ddhm/SRchobP4LtBtwtP9c4DFARORSYp9EWvFRT9BgzYD2tyHA2Gih8T5e7a2cFYH3qp7JCpS+J8EW8iCnAe/3tmv7DhNQG4cvd24+Rj42NzlFTPkBS7tXwUFyAGdf0kqzPRY2rwFmbv1NAYN0KlRtPXygcix8+M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729630040; c=relaxed/simple;
	bh=WGbfdY+8v6niBkG/JBwzSRcDF5KKyq23U0vaS5PS2EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4ATsuGWUPlsIp5eBYMZQkCsHgzAUSk/XgRLj7i6VUMAX9nEDwinkxvnvddQn+kWOlyCsU6daQvcR8uUpqMDw5kFcWRp3moBbrqMgxGievFwDZW5JoqXSAEYMN0pyFqtCqr5qSbMRMelGEEo2YIoZNj3MNrQpigthIZeTGNvnC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tYsiZIIg; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3a3075af2so24184875ab.3
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729630037; x=1730234837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REcxKj0HFYz/TQHkjuvtOnhI4V/jweJNyX3uiZ0WyP4=;
        b=tYsiZIIg5uPRoa7Tf6q4J2MyaLQCM1VU4kXzYGu4kY2M6W42ykr41pvfjt4bvi6DgP
         cLagmaqUpwwckoWbMbsr3BnmM2NgmMj2qqAX3Z68kdYnDsZx4kp5iVaxSbcE8V8geiGM
         5iOpqrxrCs6YUvf+m84QUer6uFAHhgJDIZ66bDMl+D1DAa2lDhGsqSiR8DOddUakeBzD
         W7heSBYl6hUGMYxSfnXxNLPBuBfJIDY5xlInTGbSVt7/b1Mpbto7TCmNnjFp+PLPcdNF
         QM7act7xIp+6q3LcBUbIiMvz+0DVxhuE51F+v38SDzYr6fdr9w2nTOlLUVBnzNQdEk3c
         qPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729630037; x=1730234837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REcxKj0HFYz/TQHkjuvtOnhI4V/jweJNyX3uiZ0WyP4=;
        b=Cf7ldF89asxryRqWtApsdwpTwiJG7dVzNUCSy8zz7ux5wEecZ9s9tF7Xxioplu53AR
         RHrzI8UAG0MvACqy+BNyNaRJZEMNRnj/odSpwCdmuk6Hbo9wibXEiWrGm64cMFyCBWv7
         UdO/IVa30fyTb2LlbxsY7EhIldjk2Ac1GXIb39byCJFAjlFv8m/JBp24ivLSpuEpn4Mb
         uvrM0VaHJ61wwcl4r45XXolTfhXyausHP/Pf3zhLmCEtdMUwJmGcG5+cZiKGHbfSy8xg
         qi7/Ky7AVjQQ4a8S475E6HKpZYKXBRtUrjq1uSMhdnc7NFCfrkT3R5S93pF9222aXSIb
         gHdQ==
X-Gm-Message-State: AOJu0YzD/zzYWD/D4ucq7Q8V1lMdpSRm69dCZEEt/MSKksDBnCRAH8V6
	Z0MI6Fz7zst53Hz4X6WrO08jvUF4RqgsePo2QOJkByAIyiQtT/qEfLDb5J2uW7WdiypVVKR5ZZO
	n
X-Google-Smtp-Source: AGHT+IGsKXqrSLG2+/LkNoceGH5nfPxgagnSQC75nMFbJYMcUsWQvcnRqmbn+WZtHxo4Kfxy8rDu3Q==
X-Received: by 2002:a05:6e02:2184:b0:3a0:92b1:ec4c with SMTP id e9e14a558f8ab-3a4d59ea678mr4610825ab.23.1729630036776;
        Tue, 22 Oct 2024 13:47:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a5571d1sm1697385173.52.2024.10.22.13.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 13:47:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for fixed wait regions
Date: Tue, 22 Oct 2024 14:39:04 -0600
Message-ID: <20241022204708.1025470-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022204708.1025470-1-axboe@kernel.dk>
References: <20241022204708.1025470-1-axboe@kernel.dk>
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

In network performance testing with zero-copy, this reduced the time
spent waiting on the TX side from 3.12% to 0.3% and the RX side from 4.4%
to 0.3%.

Wait regions are fixed for the lifetime of the ring - once registered,
they are persistent until the ring is torn down.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  7 ++++
 include/uapi/linux/io_uring.h  | 18 +++++++++
 io_uring/io_uring.c            | 72 ++++++++++++++++++++++++++++------
 io_uring/register.c            | 48 +++++++++++++++++++++++
 4 files changed, 134 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6d3ee71bd832..40dc1ec37a42 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -327,6 +327,13 @@ struct io_ring_ctx {
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
 		struct wait_queue_head	cq_wait;
+
+		/*
+		 * If registered with IORING_REGISTER_CQWAIT_REG, a single
+		 * page holds N entries, mapped in cq_wait_arg.
+		 */
+		struct page			**cq_wait_page;
+		struct io_uring_reg_wait	*cq_wait_arg;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
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
index 612e7d66f845..0b76b4becda9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2735,6 +2735,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
+	if (ctx->cq_wait_page) {
+		unsigned short npages = 1;
+		io_pages_unmap(ctx->cq_wait_arg, &ctx->cq_wait_page, &npages, true);
+	}
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -3223,21 +3227,44 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
-static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t argsz)
+static struct io_uring_reg_wait *io_get_ext_arg_fixed(struct io_ring_ctx *ctx,
+			const struct io_uring_getevents_arg __user *uarg)
+{
+	struct io_uring_reg_wait *arg = READ_ONCE(ctx->cq_wait_arg);
+
+	if (arg) {
+		unsigned int index = (unsigned int) (uintptr_t) uarg;
+
+		if (index >= PAGE_SIZE / sizeof(struct io_uring_reg_wait))
+			return ERR_PTR(-EINVAL);
+		return arg + index;
+	}
+
+	return ERR_PTR(-EFAULT);
+}
+
+static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
+			       const void __user *argp, size_t argsz)
 {
-	if (flags & IORING_ENTER_EXT_ARG) {
-		struct io_uring_getevents_arg arg;
+	struct io_uring_getevents_arg arg;
 
-		if (argsz != sizeof(arg))
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
@@ -3251,6 +3278,28 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
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
@@ -3289,7 +3338,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER |
+			       IORING_ENTER_EXT_ARG_REG)))
 		return -EINVAL;
 
 	/*
@@ -3372,7 +3422,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 */
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
-			ret2 = io_validate_ext_arg(flags, argp, argsz);
+			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
@@ -3382,7 +3432,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		} else {
 			struct ext_arg ext_arg = { .argsz = argsz };
 
-			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
+			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
diff --git a/io_uring/register.c b/io_uring/register.c
index 8fbce6f268b6..edf6c218b228 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -520,6 +520,48 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
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
+	int nr_pages;
+
+	if (ctx->cq_wait_page || ctx->cq_wait_arg)
+		return -EBUSY;
+	if (check_mul_overflow(sizeof(*arg), nr_args, &len))
+		return -EOVERFLOW;
+	if (len > PAGE_SIZE)
+		return -EINVAL;
+
+	pages = io_pin_pages((unsigned long) uarg, len, &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+	if (nr_pages != 1) {
+		io_pages_free(&pages, nr_pages);
+		return -EINVAL;
+	}
+
+	arg = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
+	if (arg) {
+		WRITE_ONCE(ctx->cq_wait_page, pages);
+		WRITE_ONCE(ctx->cq_wait_arg, arg);
+		return 0;
+	}
+
+	io_pages_free(&pages, 1);
+	return -ENOMEM;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -714,6 +756,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
-- 
2.45.2



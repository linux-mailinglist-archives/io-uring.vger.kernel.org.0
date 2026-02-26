Return-Path: <io-uring+bounces-12431-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAn/JXdBoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12431-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E1A1A5E52
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5D803038A53
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4133D2D8DC3;
	Thu, 26 Feb 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAeCcE8K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D32D0C89
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110131; cv=none; b=TEAPFy72G6B8tLvROXonhyZoIfKsoI6sJPh/vSCRuBvuycDgqQVWzVgBJugnnkwqdEJAgROvpjIQKiykxpC+skojPAUwgBqSS5Et0HCnuYHRq21y+qYCoW8yrUQu9KGuFd/u3sMlSGvYDOuZ9fLxHvf4XnRSFaI31Xf7pLJ2z7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110131; c=relaxed/simple;
	bh=pBBbIZUN1/m/N/NYLuUiyjOE2sO80obRenxPfME8EG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHTFM9jYEicZfowBzYqjT3T7s0GeNNhHhLhdWFi73Y/ex9F+XJFx5IQclLZoT4cMIe6hb2qfED3dO5mXCcHbG2hl7fTlIxx+tBCtg7FhmV6pQi47ri/P9a/IRadOqbnR/7CmGfiOtOSSKuY2WsARo6VU8fFtslqdYAx2M0kjWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAeCcE8K; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4327790c4e9so560957f8f.2
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110128; x=1772714928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hEMRujnY9aeTag17RfzVfnfC0LCLy/GFfQdi7IlJWqI=;
        b=JAeCcE8KXoc/DQ3ZCvoByeGWzTn06Gi0mN0UKb3D7hmt6MnbPDGb6mvUDwV1xQVWQk
         ZObo/SmTatx75c5vrzOQGtGausqhoRugkp2KWsQBbFn6aFqcFwUj8vla8aSdF0rJ98dt
         7Qj/z62jlLR3SFhAXhmxjPM/N6FKAf10bw6RlTh46Lfz7NGNCehwS0o8wGwFhJKTEMDt
         npXLJoijV+Yx010Ie8VUjQER0Upn6k2iyMaq62Zel7+ZprnttA2uB9yajRlMWgmfzuw5
         TTCWYbiM0VyxM7hwX+HCaY77RZwlNi6cGbtuRlMUKKvnudWi9s2Weu/PTf+m8ohz2vOO
         xIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110128; x=1772714928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hEMRujnY9aeTag17RfzVfnfC0LCLy/GFfQdi7IlJWqI=;
        b=YBG0Zv+84AqxrVaqAhvPqV/fgQlKLXSgwQ6VtVnpFgTdYno9Mi6ZDt9DsPOdfyF0S0
         QA3uz5hXZAf7rErLBNogltUBMP+ld4fG3Ar4oBX6b3yjZH/TxPZ4L8zLfFtHCuI5Y1fH
         ZcspImE+hmt/kvIiQTioK8P7PtHz4iWwUOvDFF9tiVMj2l02Ijx18i82LTcSKYLXwURm
         GlXZht5CUGzC4HbViL2PMKCfo7qH6puNtDadGufQgRQot/0McEvC7K5kx1cZ4ZJJhnbU
         UWwy761vPiqWanVNMeao9EtHIM+bGi9tRfGocvDh0ZlE20m9NbJrUptnx0TlnClvPa4X
         9COA==
X-Gm-Message-State: AOJu0YwYTzax4QEpQ7OYNt+5wID7h1DRnbdb1Fw/wVYDjWp97ljN7IsU
	yiNvO+mWS51J0GrQ1dWOJdWrmkcNZJhAGtNasHBFgGpvcFMOZWRiadXZEXItIw==
X-Gm-Gg: ATEYQzzYpECo2PFZXdG+ZIFuvssU/ahljbTPyAhwo15MsPums5YNUbKvlI4oogn37D9
	6+LbvFfgiATZh6gS4yE5Pn74zcYeHZceU48smWUUWNU39IJK+zAmNAt6UrNdbSghdzVJFXBiRj1
	eUHheEhP+zMDEz1SKmWY3LVlJc0/AP8GZR2zgqoqBtC/4a5CRUroGVPE0+/oYWSOPtq0SBLVxDJ
	dBp+QeWG3fts0GYdfazqlfwm3voIxDg5baAQWMqxTAb6e/yEXewjQc1/Xy+4q0BNOgRSrz5mtF0
	dZkzrnrWglyvZcJ+O79b3zFOAqsVm/DdCu3Oy/bJwHv4gewzNKp12EtEyT+D7cALgElZeM2uK+j
	QIs3scZHFI60c1XdCVLDNEGuX/VW3FxCUbCZaGkFfazXq34A2WokeVNJmiJaRDKyj5hZclBzrVL
	hWZm8NWGivfl6v98IKcebV2uFOid+ykWF61ccDqmL34+nYNTZD4DXPU7mS7KXKg2zBKpQfwXGIc
	oQEefU+0Q==
X-Received: by 2002:a5d:518c:0:b0:439:8704:e751 with SMTP id ffacd0b85a97d-4398704e7dcmr13902147f8f.40.1772110127519;
        Thu, 26 Feb 2026 04:48:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c977sm43734576f8f.32.2026.02.26.04.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:48:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v10 1/4] io_uring: introduce callback driven main loop
Date: Thu, 26 Feb 2026 12:48:38 +0000
Message-ID: <a2d369aa1c9dd23ad7edac9220cffc563abcaed6.1772109579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772109579.git.asml.silence@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12431-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 38E1A1A5E52
X-Rspamd-Action: no action

The io_uring_enter() has a fixed order of execution: it submits
requests, waits for completions, and returns to the user. Allow to
optionally replace it with a custom loop driven by a callback called
loop_step. The basic requirements to the callback is that it should be
able to submit requests, wait for completions, parse them and repeat.
Most of the communication including parameter passing can be implemented
via shared memory.

The callback should return IOU_LOOP_CONTINUE to continue execution or
IOU_LOOP_STOP to return to the user space. Note that the kernel may
decide to prematurely terminate it as well, e.g. in case the process was
signalled or killed.

The hook takes a structure with parameters. It can be used to ask the
kernel to wait for CQEs by setting cq_wait_idx to the CQE index it wants
to wait for. Spurious wake ups are possible and even likely, the callback
is expected to handle it. There will be more parameters in the future
like timeout.

It can be used with kernel callbacks, for example, as a slow path
deprecation mechanism overwiting SQEs and emulating the wanted
behaviour, however it's more useful together with BPF programs
implemented in following patches.

Note that keeping it separately from the normal io_uring wait loop
makes things much simpler and cleaner. It keeps it in one place instead
of spreading a bunch of checks in different places including disabling
the submission path. It holds the lock by default, which is a better fit
for BPF synchronisation and the loop execution model. It nicely avoids
existing quirks like forced wake ups on timeout request completion. And
it should be easier to implement new features.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++
 io_uring/Makefile              |  2 +-
 io_uring/io_uring.c            | 11 ++++
 io_uring/loop.c                | 91 ++++++++++++++++++++++++++++++++++
 io_uring/loop.h                | 27 ++++++++++
 io_uring/wait.h                |  1 +
 6 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e4a82a6f817..cceac329fcfd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -41,6 +41,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct iou_loop_params;
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -355,6 +357,9 @@ struct io_ring_ctx {
 		struct io_alloc_cache	rw_cache;
 		struct io_alloc_cache	cmd_cache;
 
+		int (*loop_step)(struct io_ring_ctx *ctx,
+				 struct iou_loop_params *);
+
 		/*
 		 * Any cancelable uring_cmd is added to this list in
 		 * ->uring_cmd() by io_uring_cmd_insert_cancelable()
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 931f9156132a..1c1f47de32a4 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					advise.o openclose.o statx.o timeout.o \
 					cancel.o waitid.o register.o \
 					truncate.o memmap.o alloc_cache.o \
-					query.o
+					query.o loop.o
 
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e627b7a2f3a..0c8bb4e8480a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "eventfd.h"
 #include "wait.h"
 #include "bpf_filter.h"
+#include "loop.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -589,6 +590,11 @@ void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+void io_cqring_overflow_flush_locked(struct io_ring_ctx *ctx)
+{
+	__io_cqring_overflow_flush(ctx, false);
+}
+
 /* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct io_kiocb *req)
 {
@@ -2582,6 +2588,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED))
 		goto out;
 
+	if (io_has_loop_ops(ctx)) {
+		ret = io_run_loop(ctx);
+		goto out;
+	}
+
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
diff --git a/io_uring/loop.c b/io_uring/loop.c
new file mode 100644
index 000000000000..31843cc3e451
--- /dev/null
+++ b/io_uring/loop.c
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "io_uring.h"
+#include "wait.h"
+#include "loop.h"
+
+static inline int io_loop_nr_cqes(const struct io_ring_ctx *ctx,
+				  const struct iou_loop_params *lp)
+{
+	return lp->cq_wait_idx - READ_ONCE(ctx->rings->cq.tail);
+}
+
+static inline void io_loop_wait_start(struct io_ring_ctx *ctx, unsigned nr_wait)
+{
+	atomic_set(&ctx->cq_wait_nr, nr_wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+}
+
+static inline void io_loop_wait_finish(struct io_ring_ctx *ctx)
+{
+	__set_current_state(TASK_RUNNING);
+	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
+}
+
+static void io_loop_wait(struct io_ring_ctx *ctx, struct iou_loop_params *lp,
+			 unsigned nr_wait)
+{
+	io_loop_wait_start(ctx, nr_wait);
+
+	if (unlikely(io_local_work_pending(ctx) ||
+		     io_loop_nr_cqes(ctx, lp) <= 0) ||
+		     READ_ONCE(ctx->check_cq)) {
+		io_loop_wait_finish(ctx);
+		return;
+	}
+
+	mutex_unlock(&ctx->uring_lock);
+	schedule();
+	io_loop_wait_finish(ctx);
+	mutex_lock(&ctx->uring_lock);
+}
+
+static int __io_run_loop(struct io_ring_ctx *ctx)
+{
+	struct iou_loop_params lp = {};
+
+	while (true) {
+		int nr_wait, step_res;
+
+		if (unlikely(!ctx->loop_step))
+			return -EFAULT;
+
+		step_res = ctx->loop_step(ctx, &lp);
+		if (step_res == IOU_LOOP_STOP)
+			break;
+		if (step_res != IOU_LOOP_CONTINUE)
+			return -EINVAL;
+
+		nr_wait = io_loop_nr_cqes(ctx, &lp);
+		if (nr_wait > 0)
+			io_loop_wait(ctx, &lp, nr_wait);
+		else
+			nr_wait = 0;
+
+		if (task_work_pending(current)) {
+			mutex_unlock(&ctx->uring_lock);
+			io_run_task_work();
+			mutex_lock(&ctx->uring_lock);
+		}
+		if (unlikely(task_sigpending(current)))
+			return -EINTR;
+		io_run_local_work_locked(ctx, nr_wait);
+
+		if (READ_ONCE(ctx->check_cq) & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+			io_cqring_overflow_flush_locked(ctx);
+	}
+
+	return 0;
+}
+
+int io_run_loop(struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	if (!io_allowed_run_tw(ctx))
+		return -EEXIST;
+
+	mutex_lock(&ctx->uring_lock);
+	ret = __io_run_loop(ctx);
+	mutex_unlock(&ctx->uring_lock);
+	return ret;
+}
diff --git a/io_uring/loop.h b/io_uring/loop.h
new file mode 100644
index 000000000000..d7718b9ce61e
--- /dev/null
+++ b/io_uring/loop.h
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_LOOP_H
+#define IOU_LOOP_H
+
+#include <linux/io_uring_types.h>
+
+struct iou_loop_params {
+	/*
+	 * The CQE index to wait for. Only serves as a hint and can still be
+	 * woken up earlier.
+	 */
+	__u32			cq_wait_idx;
+};
+
+enum {
+	IOU_LOOP_CONTINUE = 0,
+	IOU_LOOP_STOP,
+};
+
+static inline bool io_has_loop_ops(struct io_ring_ctx *ctx)
+{
+	return data_race(ctx->loop_step);
+}
+
+int io_run_loop(struct io_ring_ctx *ctx);
+
+#endif
diff --git a/io_uring/wait.h b/io_uring/wait.h
index 5e236f74e1af..037e512dd80c 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -25,6 +25,7 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		   struct ext_arg *ext_arg);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx);
+void io_cqring_overflow_flush_locked(struct io_ring_ctx *ctx);
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
-- 
2.53.0



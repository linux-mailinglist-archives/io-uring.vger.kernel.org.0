Return-Path: <io-uring+bounces-11936-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOl1MVmReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11936-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E3A192A72
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A160309998C
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9D633CE84;
	Tue, 27 Jan 2026 10:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MatjPdoh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F722EAD09
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508878; cv=none; b=UOvgJU21zZJHk6orj7f1k/m0EgPc+QzfkwTIXXo3EKZU64oikQ5edRpPMrUfCDuofAEnwGqgFOK2wbQmXec8VVrNuIQNhvtjG5zBZU7fGyhR4l8LQFePuWqRZmE/PZEq+1YRhrGn7p7R1H/gKWeRUwMt+Wba2HmhcAYHdlR2uH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508878; c=relaxed/simple;
	bh=PmLa2E/qa9vx+3T7sbbzNQ3iNQeuhouOCpLOpTlYoqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRNhuW4d/1tWseRrJE9DPT71Luux/aAxRNcgxc1b2UGXzBAh+rHJwnYwmLY9vyKwAZZtHXSXehI/CXAOawn2GAfTG8TCXvIW6FnTXo/X2n2gB8RfwDr8GUztULlSb9YIXWq7rz6QcOdHprnMk2Yu6VPY/H+7V85gzOJCqbEZZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MatjPdoh; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so41207625e9.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508874; x=1770113674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KE2SkxLTZslRj/svpD5iSf0B3A+oiEa6juQ6HgBYPtM=;
        b=MatjPdohHHLyWh95s0o6NBo8ip32EgsthHo1E6PliT1nkA7xK09MMH3JCzi6xeq9jE
         7Ze1yXicusAoAbBGAg6yWFkXmggOw90yBjD6NmaXE0LH825dErUehmjdkO/dGtcg8ig3
         hXtY3CFpMbFZShKpu+RsiP6lAff7AvUcx3B+5b8CZRiNmL8zCFktxhVtXu1mmarD/A2A
         lBDlcB3KbE5QvCVjf/VQuiwHHUlOy+WCW1l/M06I6f41dfUfQKLnSRXKg0261vGLPzPP
         uitWE8+j0GFoYj4dKX7k6RCOJMqxIvQT91H8QR6Rz1CXw2h5F7+31eo/rnl/WPPV0u96
         jaHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508874; x=1770113674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KE2SkxLTZslRj/svpD5iSf0B3A+oiEa6juQ6HgBYPtM=;
        b=WCPFJH1krTotouGqu5Dj1Cp1F5wfpiA5ZdfOw0xm0nbXBD6axAFWwouKrsbZgMC4Jr
         GTbd6Smsuq96uUQgz+DxIVbtg6JF6cEPSwFTLuq3Su2XGpznzA8VLukqFJga7Anw/MQ6
         lVrDRLdEuIZuFGJKOkyn7ClmR4x5dpx/qrvB/9Yzf4ky3ftKprEgCv7gtdYwcLB2TGcb
         jpefzBGL9w5r4HxfniwkSgeUKwFVAhnLuXFhiR/HofZR3TZs1slq3j7bEDyUF1Y5mtDb
         +NOpks/ZHFp2ugWFE96EcO6PfN0FpIajpPanETMdr45p5pf/dzysTsjCcuiSKbBl3eGp
         cvmQ==
X-Gm-Message-State: AOJu0YyM45ykXTmPzGClk5Xnx80GKHOo/kbhZO+w4Uc+4jNyquhqbDuk
	iWZZWF7T0nVlUKvrV7X66VY4VCYIo3PUbn3HC63n7x4670764coG25+oIvSni1wr
X-Gm-Gg: AZuq6aLkFTVAbVS1jl+tasJOOOKoRQxMKA0UoxhR6/dwRnynIzK+slxFlCOsBjxx3y0
	tlZWhrcoxuVz1siw782xIy0KS5ZmimXraLgBEX9wL/UyTwvDjc8d1yQ7gZ4WdRSAWuARxv7CSp/
	BEjZxqKyR3S8sFdKFGUuA9uZWikPv/ibo54jntN6CZWkVCWFIHpfrrLj01wgF4ts9Ot1o0gmN6r
	m/YYwu3r2ktz0ymk5dPGFvpbIbUIrDsyZMIWB1+DGRBaH6wNpewTDJ6ThnAIqxT7qsw+sxd2lkK
	k0Md0EKv6bEsJjnvEyAVoC+XmUr7xvefCY+ZXRLOLOhVvVQqUX/33kbILalyQJlKwEmEL/hPIVK
	65jT0nGZVymHelu6MSI6Wwbg7b/za+Rmjkr7NwdAkQOBNnMf703Kho0NYlzJnci4bpzkeQLZXK9
	HJPGIeMWe8D8Y5SDcFdK0f72TKVLPku7dTWldlxYTMV2VAHCP+2PJvSFR++yixr0VEau540JZCr
	q82UB2DftlcoGB5zoVRJr+cPhgt
X-Received: by 2002:a05:6000:1a8f:b0:435:db6e:e3b2 with SMTP id ffacd0b85a97d-435dd090a39mr1700488f8f.27.1769508873839;
        Tue, 27 Jan 2026 02:14:33 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 1/6] io_uring: introduce callback driven main loop
Date: Tue, 27 Jan 2026 10:14:05 +0000
Message-ID: <20968b8f501a4ca8801f38f1b2cf052f32d03e40.1769470552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769470552.git.asml.silence@gmail.com>
References: <cover.1769470552.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11936-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4E3A192A72
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
 io_uring/io_uring.c            |  6 +++
 io_uring/loop.c                | 88 ++++++++++++++++++++++++++++++++++
 io_uring/loop.h                | 27 +++++++++++
 5 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dc6bd6940a0d..9990df98790d 100644
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
@@ -342,6 +344,9 @@ struct io_ring_ctx {
 		struct io_alloc_cache	rw_cache;
 		struct io_alloc_cache	cmd_cache;
 
+		int (*loop_step)(struct io_ring_ctx *ctx,
+				 struct iou_loop_params *);
+
 		/*
 		 * Any cancelable uring_cmd is added to this list in
 		 * ->uring_cmd() by io_uring_cmd_insert_cancelable()
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bf9eff88427a..d4dbc16a58a5 100644
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
index 5c503a3f6ecc..aea27e3538bb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -94,6 +94,7 @@
 #include "alloc_cache.h"
 #include "eventfd.h"
 #include "wait.h"
+#include "loop.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -2557,6 +2558,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
index 000000000000..bf38f20f0537
--- /dev/null
+++ b/io_uring/loop.c
@@ -0,0 +1,88 @@
+#include "io_uring.h"
+#include "napi.h"
+#include "wait.h"
+#include "loop.h"
+
+struct iou_loop_state {
+	struct iou_loop_params		p;
+	struct io_ring_ctx		*ctx;
+};
+
+static inline int io_loop_nr_cqes(const struct io_ring_ctx *ctx,
+				  const struct iou_loop_state *ls)
+{
+	return ls->p.cq_wait_idx - READ_ONCE(ctx->rings->cq.tail);
+}
+
+static inline void io_loop_wait_finish(struct io_ring_ctx *ctx)
+{
+	__set_current_state(TASK_RUNNING);
+	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
+}
+
+static void io_loop_wait(struct io_ring_ctx *ctx, struct iou_loop_state *ls,
+			 unsigned nr_wait)
+{
+	atomic_set(&ctx->cq_wait_nr, nr_wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	if (unlikely(io_local_work_pending(ctx) ||
+		     io_loop_nr_cqes(ctx, ls) <= 0) ||
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
+int io_run_loop(struct io_ring_ctx *ctx)
+{
+	struct iou_loop_state ls = {};
+	int ret = -EINVAL;
+
+	if (!io_allowed_run_tw(ctx))
+		return -EEXIST;
+	mutex_lock(&ctx->uring_lock);
+
+	while (true) {
+		unsigned nr_wait;
+		int step_res;
+
+		if (unlikely(!ctx->loop_step)) {
+			ret = -EFAULT;
+			goto out_unlock;
+		}
+		step_res = ctx->loop_step(ctx, &ls.p);
+		if (step_res == IOU_LOOP_STOP)
+			break;
+
+		nr_wait = io_loop_nr_cqes(ctx, &ls);
+		if (nr_wait > 0)
+			io_loop_wait(ctx, &ls, nr_wait);
+
+		if (task_work_pending(current)) {
+			mutex_unlock(&ctx->uring_lock);
+			io_run_task_work();
+			mutex_lock(&ctx->uring_lock);
+		}
+		if (task_sigpending(current)) {
+			ret = -EINTR;
+			goto out_unlock;
+		}
+
+		nr_wait = max(nr_wait, 0);
+		io_run_local_work_locked(ctx, nr_wait);
+
+		if (READ_ONCE(ctx->check_cq) & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+			io_cqring_do_overflow_flush(ctx);
+	}
+
+	ret = 0;
+out_unlock:
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
-- 
2.52.0



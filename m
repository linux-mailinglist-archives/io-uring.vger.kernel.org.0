Return-Path: <io-uring+bounces-11572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EDDD0BF79
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 19:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B7E93009F00
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 18:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F311E5201;
	Fri,  9 Jan 2026 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lOSEkE9q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF32D9481
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 18:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984724; cv=none; b=pezqSThIQoSEXJ2r6qlLMAvSgZMeOWUm76K1vOWa8zB07Hb82ODqzL/mcnWWKgD3TS4UBmmLF3pHQdS4eWKe5T1VVS3LK90LMY4ZgZPhC9Hd0Epr0e5uoXrXPy4sFeLL78bn5t2sdHYHCdw4jcnSd79Kyf4SWA3dWWG48vF2bB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984724; c=relaxed/simple;
	bh=6eCqFoniJMitoWa7t6GqVAFx+LbP+QVNHRaXIldx4H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Syj8GreuQX6eNjcGJIISedKOuZSHwyQwVTX/c5kDjjaz8MJKmECGcsQyb2Y2ZQ9hTqwXPfiWUT0e3rLlmuF3fIkqWuTF4ox7wTKOC6TBDgvH58OScAo7X7sUFE8x8LZhAf4n3GUdnoFlO6U7HqpzRjfmkmPT9bVEf7K7aH8TzUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lOSEkE9q; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-455af5758fdso2906367b6e.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 10:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767984720; x=1768589520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2oGigyOsAggWlikYWB4OSNEdR0A3hDYMqYlRZpTMgY=;
        b=lOSEkE9qw/en2XrSnOm5gbyQwgfzMVK/SEV556EMjticnfzB40gFe9/yOiWQ6QQesk
         6MrlGBUl/i9cYn+OiJAlsC2EfQHy9Ghj2hsYMk4NZFLyF8sqN5v3MQ50DNlvZwSzjh9N
         Sf0SbuxSVD0HIURrWk/pJUV6NRGxBt7n8L4bU9fWfdnVjjIYZ8mUFnsCuTSVVyJBNiUl
         J8kYgyYx0yhO6tsn71Wre5Ytj+pFfd+/0ZZqbScvIJu+LWz04dnBx53fN+IOi7GvHwk4
         21JsXImGnQbJjOpoJJ9ZYlH/PcL1W3QFUL2yYsjkiGrzNuFEgEOFmDAHrbIY40Wrfb95
         tgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984720; x=1768589520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2oGigyOsAggWlikYWB4OSNEdR0A3hDYMqYlRZpTMgY=;
        b=fk7enQXyI4Cp6HmRPze8vbxDm1vEp1dhFF6a1qaYNknEwWcs+T6uPrOUnXJ8YY55k+
         bhiayJDi1Pkqn8s6xuHOlLQn8v+JGEcw/UO41jypft4g20L69jGNvwoTLjnVT1BjMvgf
         Nd7oYekLwNvTd8yp6HwBSK4VE/MJ8a5N4CFimjvQZnNLGK+JHMXGIKdZR9HBzv0fMDX1
         UeXjTGRr+NuM7PY68p453yTugzTQ4isxfkCHrw76VlIrfB3MgL60dDo9JFP9fyT6v3Pa
         jUwzd9JxAYZW9TaqzjqPKltvKkYvcD2Fi78D248ZexRD9WsUjxJdSBeVQ5Z0fu1KzjlR
         sjFw==
X-Gm-Message-State: AOJu0YxPN9Ul2qmd9Q4ittqz1SYCUzSus8c/lSGK0DBlQiqCKk/B7yzb
	vV4xIxjkBtoS7Q773o1fAF6TOI740xzbrVH0twhQ0iUVDhE1oCJYD/OoHZk65hvobJ8hF/JBH93
	k/cWy
X-Gm-Gg: AY/fxX5j2pVQZzkO9MfAGEPl/PVL62bv0OsF7bXKsuwL472Nk97XSx+ubQ0LQCSEANU
	nASE1dKfh0H+hMkRkbGbyaOXWoX5pLltey8cO2RpeAEmJgNj2NBkMzUECRL6W1X+/rSR0sHzjUP
	kIgYcifHCG/GUQN3Gz/NhRg6u2M9nLQrFTdK5MqwremROUMhBciTnqzcZ1kLd5W3vQVkjCoztTD
	JINMpN1cgQgy+jKdVbNWaT0m7WmSUwhD+KMvGAvtD/F7FDNhZ4AI32pNPIo3mFPQEulmjDZ5UMh
	NG78uidrJi8BBGIMqyQUtdbOasT1REGjTGc/EFKPRYfitvxXEg6V5Hg3SIsz17/CjVQpummZcJc
	1wHdM8Iz8eVqJvcFaGPo0NZ+MHeDsKOa+l1anOThW0sNPJdXMqqlZpf1KX+O1TGqmQUeIx25zSK
	jhv+Ld
X-Google-Smtp-Source: AGHT+IHzqS/mDPg//9Eenk1OCslQ16nTzlBS3IrTDJIrC9/FQm/o3JjEa+s+kWgpOhrAyz6vFyMnFA==
X-Received: by 2002:a05:6808:4fe8:b0:45a:4189:d2cf with SMTP id 5614622812f47-45a6bd38e86mr5629083b6e.8.1767984719619;
        Fri, 09 Jan 2026 10:51:59 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm5371868b6e.12.2026.01.09.10.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 10:51:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: allow registration of per-task restrictions
Date: Fri,  9 Jan 2026 11:48:25 -0700
Message-ID: <20260109185155.88150-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260109185155.88150-1-axboe@kernel.dk>
References: <20260109185155.88150-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently io_uring supports restricting operations on a per-ring basis.
To use those, the ring must be setup in a disabled state by setting
IORING_SETUP_R_DISABLED. Then restrictions can be set for the ring, and
the ring can then be enabled.

This commit adds support for IORING_REGISTER_RESTRICTIONS_TASK, which
allows to register the same kind of restrictions, but with the task
itself rather than with a specific ring. Once done, any ring created
will inherit these restrictions.

If a restriction filter is registered with a task, then it's
inherited on fork for its children.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h       |  2 +-
 include/linux/io_uring_types.h |  1 +
 include/linux/sched.h          |  1 +
 include/uapi/linux/io_uring.h  |  9 +++++++++
 io_uring/io_uring.c            | 10 +++++++++
 io_uring/register.c            | 37 ++++++++++++++++++++++++++++++++++
 io_uring/tctx.c                | 25 ++++++++++++++---------
 kernel/fork.c                  |  4 ++++
 8 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c..cfd2f4c667ee 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -25,7 +25,7 @@ static inline void io_uring_task_cancel(void)
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-	if (tsk->io_uring)
+	if (tsk->io_uring || tsk->io_uring_restrict)
 		__io_uring_free(tsk);
 }
 #else
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 54fd30abf2b8..196f41ec6d60 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -222,6 +222,7 @@ struct io_rings {
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	refcount_t refs;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	bool registered;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d395f2810fac..9abbd11bb87c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1190,6 +1190,7 @@ struct task_struct {
 
 #ifdef CONFIG_IO_URING
 	struct io_uring_task		*io_uring;
+	struct io_restriction		*io_uring_restrict;
 #endif
 
 	/* Namespaces: */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..3ecf9c1bfa2d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -700,6 +700,8 @@ enum io_uring_register_op {
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
 	IORING_REGISTER_ZCRX_CTRL		= 36,
 
+	IORING_REGISTER_RESTRICTIONS_TASK	= 37,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -805,6 +807,13 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_task_restriction {
+	__u16 flags;
+	__u16 nr_res;
+	__u32 resv[3];
+	__DECLARE_FLEX_ARRAY(struct io_uring_restriction, restrictions);
+};
+
 struct io_uring_clock_register {
 	__u32	clockid;
 	__u32	__resv[3];
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1aebdba425e8..044da739ed0b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3608,6 +3608,16 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	else
 		ctx->notify_method = TWA_SIGNAL;
 
+	/*
+	 * If the current task has restrictions enabled, then copy them to
+	 * our newly created ring and mark it as registered.
+	 */
+	if (current->io_uring_restrict) {
+		memcpy(&ctx->restrictions, current->io_uring_restrict, sizeof(ctx->restrictions));
+		ctx->restrictions.registered = true;
+		ctx->restricted = true;
+	}
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..89254d0fbe79 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -175,6 +175,41 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_task_restriction __user *ures = arg;
+	struct io_uring_task_restriction tres;
+	struct io_restriction *res;
+	int ret;
+
+	/* Disallow if task already has registered restrictions */
+	if (current->io_uring_restrict)
+		return -EPERM;
+	if (nr_args != 1)
+		return -EINVAL;
+
+	if (copy_from_user(&tres, arg, sizeof(tres)))
+		return -EFAULT;
+
+	if (tres.flags)
+		return -EINVAL;
+	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
+		return -EINVAL;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res);
+	if (ret) {
+		kfree(res);
+		return ret;
+	}
+	refcount_set(&res->refs, 1);
+	current->io_uring_restrict = res;
+	return 0;
+}
+
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
@@ -889,6 +924,8 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 		return io_uring_register_send_msg_ring(arg, nr_args);
 	case IORING_REGISTER_QUERY:
 		return io_query(arg, nr_args);
+	case IORING_REGISTER_RESTRICTIONS_TASK:
+		return io_register_restrictions_task(arg, nr_args);
 	}
 	return -EINVAL;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..1ec71d5cf3f0 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -54,16 +54,23 @@ void __io_uring_free(struct task_struct *tsk)
 	 * node is stored in the xarray. Until that gets sorted out, attempt
 	 * an iteration here and warn if any entries are found.
 	 */
-	xa_for_each(&tctx->xa, index, node) {
-		WARN_ON_ONCE(1);
-		break;
-	}
-	WARN_ON_ONCE(tctx->io_wq);
-	WARN_ON_ONCE(tctx->cached_refs);
+	if (tctx) {
+		xa_for_each(&tctx->xa, index, node) {
+			WARN_ON_ONCE(1);
+			break;
+		}
+		WARN_ON_ONCE(tctx->io_wq);
+		WARN_ON_ONCE(tctx->cached_refs);
 
-	percpu_counter_destroy(&tctx->inflight);
-	kfree(tctx);
-	tsk->io_uring = NULL;
+		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx);
+		tsk->io_uring = NULL;
+	}
+	if (tsk->io_uring_restrict) {
+		if (refcount_dec_and_test(&tsk->io_uring_restrict->refs))
+			kfree(tsk->io_uring_restrict);
+		tsk->io_uring_restrict = NULL;
+	}
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..da8fd6fd384c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -97,6 +97,7 @@
 #include <linux/kasan.h>
 #include <linux/scs.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
 #include <linux/bpf.h>
 #include <linux/stackprotector.h>
 #include <linux/user_events.h>
@@ -2129,6 +2130,8 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_IO_URING
 	p->io_uring = NULL;
+	if (p->io_uring_restrict)
+		refcount_inc(&p->io_uring_restrict->refs);
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
@@ -2525,6 +2528,7 @@ __latent_entropy struct task_struct *copy_process(
 	mpol_put(p->mempolicy);
 #endif
 bad_fork_cleanup_delayacct:
+	io_uring_free(p);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
-- 
2.51.0



Return-Path: <io-uring+bounces-11767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF527D3896D
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02F463016CDF
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCED270540;
	Fri, 16 Jan 2026 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xP/HW2ED"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AF30EF7B
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603446; cv=none; b=nSvJoO917CbuAhBQTHK15O4MkyD9ip1ArivTAXOREHVtEJm+fAHr4rOK6F8/ZG+G36dzi0zo+v9NZkwgy71OGnDY+412y2z9IwOexLKVQyfCZtoyFU63Xf3oArQbe9kreWZX5WZ+trirrx59Fe0UzQWNlyAEmZ1oTxbkxhhuSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603446; c=relaxed/simple;
	bh=ud58tnDEWG+y1C80VzdbNt1eRNV7t3hI24hjEBbfkbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcdIhic1XfZG5tZz8U5TCzxHsLp4kUkN667VG1qmiAhQxr3KS5n84p/SfpSA8rbdEH7dBBtoXxavA5oaJXmqjeBhAndSBJxwDiM2n0Bl0XE6sf0xR6gJ/pCcPfdEGNqc6UPjqUQ6xy0cDrV/H+eVDbyMPQCWcgOTrnael8n1AjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xP/HW2ED; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45c86087949so963394b6e.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603443; x=1769208243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tL203V7A8Uu/WZU8RHMoV3QXvq0tN6yRVrJWl5NJz0=;
        b=xP/HW2EDQda/krSsiUbEqMaeKPDZ4mR7qz36AISAqCAuhaJ4G2xfIZjL6mzTfqgHKS
         BQyprpS3IHcSW08QXV45R4BOnqAqF8+6CKYIXJ86Bc2gEHvcFHmk6sV6pDbzpaF7z0u8
         9WUXfloB2z0ubc7Z/ExKBMu7hO/70hOtkxFcZ6oYueE+lyfbnLLOA7ltc2rql3EklPNF
         MAMCGhcqIT1uCEXmLZBqmLZu6BJhmwh9ahWirhMr72eMbB7/P/ZcK2hzr3u0hjK+UwZm
         tioBDQC979lSKzb/gDvyVPW99jBQhIFgCp0oE+ZkLNYcFgOX7amRkQcFy4N416gq6JSx
         Zctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603443; x=1769208243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0tL203V7A8Uu/WZU8RHMoV3QXvq0tN6yRVrJWl5NJz0=;
        b=FhSe2ygwM7lU8okA0UGOfN5vIUvGitxq9U4HELrbM209ma0NMqxnJsNp/VGxrjttqh
         EPrPzBMXyiFBBlY1hYiYmojSzVFScKyojG2NNGMcxe1dTjByDl/KxeQSMm8u4i23tvu2
         wH0zCz4Oy2PjCz/KFLUKfzbmdiGTAdNdyeIPuelfU5+cdst1GqEoefCEs/Ca0//a0N3C
         Hthtt/LgGXQ6gvncQ65r9bp4pCn2MXmMNo4xeG5S08ZPX9YEjukaj+x2fXnusjeR4TDN
         31zUGWR6UXglrzPvbJSG8r3U0Cvhr6qH4YQrsLY6zkg4xlVlIhqSMkqD8hW87I5Bnnxs
         q2Zg==
X-Gm-Message-State: AOJu0YyXFK1pgcwLJHaNctvqh16DizOO4iffMc0Gnh5xu6KKsdvBx2S7
	dIGlPcro9hkaptnsnZurLkwjziM2OVvArDrPPtLKdh9YPVzgj0fT2RyWSWVdAjfryx/QZTZecUj
	VA4un
X-Gm-Gg: AY/fxX7XMu8yyY+zXbNzPJB8l5TpFabJ7KtcvyAORcIKaE+6jHBkTdCCDj4R195i1SI
	/3qfjXnaBLcWfho2LBtkYEY8rFpjCJdjjE6QIjBTc5n3RX9Ojwwvt5yQncztkvcCV9J7j65xQr2
	GydrSYsi4zlo/aYPWQHuPuaYMaDPnWvOpKgTyUkv9hDPFTNaxzXPayJ24i27KtobMGI3/1RU/vQ
	q+JrFeRWYKrnHZbx5/4Wu3tWgH0wfyxYoN/oy7LekjQEB4DpTAfPpoP5dqI8aw7gQPYy5cImRct
	AHJ41cZ+35TMr53qOe7Dp4J6xR9Nb0abTweBPRWVmSFlYQ4CFCJIGLFQrhj9uzGviHR/kazQgAY
	OS+k8RhW1exxiZROnpePf8D99ySqkf+1XAVD7ADyA88eqJqNbpetOz3Qbo+nizOLM4Y+wrqSooP
	f9X1OHDz9UznHeWx3R81+AVJ6BNbNxOzJxc5zNDOgOZGmwkuH5yQc/NjCJ
X-Received: by 2002:a05:6808:15a9:b0:450:275b:d942 with SMTP id 5614622812f47-45c9d6fc240mr1621110b6e.10.1768603443608;
        Fri, 16 Jan 2026 14:44:03 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:44:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: allow registration of per-task restrictions
Date: Fri, 16 Jan 2026 15:38:42 -0700
Message-ID: <20260116224356.399361-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260116224356.399361-1-axboe@kernel.dk>
References: <20260116224356.399361-1-axboe@kernel.dk>
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

This commit adds support for IORING_REGISTER_RESTRICTIONS with ring_fd
== -1, like the other "blind" register opcodes which work on the task
rather than a specific ring. This allows registration of the same kind
of restrictions as can been done on a specific ring, but with the task
itself. Once done, any ring created will inherit these restrictions.

If a restriction filter is registered with a task, then it's inherited
on fork for its children. Children may only further restrict operations,
not extend them.

Inheriting restrictions include both the classic
IORING_REGISTER_RESTRICTIONS based restrictions, as well as the BPF
filters that have been registered with the task via
IORING_REGISTER_BPF_FILTER.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +
 include/uapi/linux/io_uring.h  |  7 ++++
 io_uring/bpf_filter.c          | 70 ++++++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h          |  6 +++
 io_uring/io_uring.c            | 19 +++++++++
 io_uring/io_uring.h            |  1 +
 io_uring/register.c            | 65 +++++++++++++++++++++++++++++++
 io_uring/tctx.c                | 35 ++++++++++++-----
 8 files changed, 196 insertions(+), 9 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1e91fa7ecbaf..f4a55c104825 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -236,6 +236,8 @@ struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	struct io_bpf_filters *bpf_filters;
+	/* ->bpf_filters needs COW on modification */
+	bool bpf_filters_cow;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	/* IORING_OP_* restrictions exist */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 27839318c43e..419bdfb48b9c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -808,6 +808,13 @@ struct io_uring_restriction {
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
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 8ed5b913005a..30a9d7355cd7 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -215,6 +215,70 @@ static struct io_bpf_filters *io_new_bpf_filters(void)
 	return filters;
 }
 
+void io_bpf_filter_clone(struct io_restriction *dst, struct io_restriction *src)
+{
+	if (!src->bpf_filters)
+		return;
+
+	rcu_read_lock();
+	/*
+	 * If the src filter is going away, just ignore it.
+	 */
+	if (refcount_inc_not_zero(&src->bpf_filters->refs)) {
+		dst->bpf_filters = src->bpf_filters;
+		dst->bpf_filters_cow = true;
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * Allocate a new struct io_bpf_filters. Used when a filter is cloned and
+ * modifications need to be made.
+ */
+static struct io_bpf_filters *io_bpf_filter_cow(struct io_restriction *src)
+{
+	struct io_bpf_filters *filters;
+	struct io_bpf_filter *srcf;
+	int i;
+
+	filters = io_new_bpf_filters();
+	if (IS_ERR(filters))
+		return filters;
+
+	/*
+	 * Iterate filters from src and assign in destination. Grabbing
+	 * a reference is enough, we don't need to duplicate the memory.
+	 * This is safe because filters are only ever appended to the
+	 * front of the list, hence the only memory ever touched inside
+	 * a filter is the refcount.
+	 */
+	rcu_read_lock();
+	for (i = 0; i < IORING_OP_LAST; i++) {
+		srcf = rcu_dereference(src->bpf_filters->filters[i]);
+		if (!srcf) {
+			continue;
+		} else if (srcf == &dummy_filter) {
+			rcu_assign_pointer(filters->filters[i], &dummy_filter);
+			continue;
+		}
+
+		/*
+		 * Getting a ref on the first node is enough, putting the
+		 * filter and iterating nodes to free will stop on the first
+		 * one that doesn't hit zero when dropping.
+		 */
+		if (!refcount_inc_not_zero(&srcf->refs))
+			goto err;
+		rcu_assign_pointer(filters->filters[i], srcf);
+	}
+	rcu_read_unlock();
+	return filters;
+err:
+	rcu_read_unlock();
+	__io_put_bpf_filters(filters);
+	return ERR_PTR(-EBUSY);
+}
+
 int io_register_bpf_filter(struct io_restriction *res,
 			   struct io_uring_bpf __user *arg)
 {
@@ -247,6 +311,12 @@ int io_register_bpf_filter(struct io_restriction *res,
 		filters = io_new_bpf_filters();
 		if (IS_ERR(filters))
 			return PTR_ERR(filters);
+	} else if (res->bpf_filters_cow) {
+		filters = io_bpf_filter_cow(res);
+		if (IS_ERR(filters))
+			return PTR_ERR(filters);
+		__io_put_bpf_filters(res->bpf_filters);
+		res->bpf_filters_cow = false;
 	}
 
 	prog = bpf_prog_get_type(reg.filter.prog_fd, BPF_PROG_TYPE_IO_URING);
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
index a131953ce950..3f117a4c8752 100644
--- a/io_uring/bpf_filter.h
+++ b/io_uring/bpf_filter.h
@@ -11,6 +11,8 @@ int io_register_bpf_filter(struct io_restriction *res,
 
 void io_put_bpf_filters(struct io_restriction *res);
 
+void io_bpf_filter_clone(struct io_restriction *dst, struct io_restriction *src);
+
 static inline int io_uring_run_bpf_filters(struct io_restriction *res,
 					   struct io_kiocb *req)
 {
@@ -35,6 +37,10 @@ static inline int io_uring_run_bpf_filters(struct io_restriction *res,
 static inline void io_put_bpf_filters(struct io_restriction *res)
 {
 }
+static inline void io_bpf_filter_clone(struct io_restriction *dst,
+				       struct io_restriction *src)
+{
+}
 #endif /* CONFIG_IO_URING */
 
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 67533e494836..8e9d300b8604 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3562,6 +3562,18 @@ int io_prepare_config(struct io_ctx_config *config)
 	return 0;
 }
 
+void io_restriction_clone(struct io_restriction *dst, struct io_restriction *src)
+{
+	memcpy(&dst->register_op, &src->register_op, sizeof(dst->register_op));
+	memcpy(&dst->sqe_op, &src->sqe_op, sizeof(dst->sqe_op));
+	dst->sqe_flags_allowed = src->sqe_flags_allowed;
+	dst->sqe_flags_required = src->sqe_flags_required;
+	dst->op_registered = src->op_registered;
+	dst->reg_registered = src->reg_registered;
+
+	io_bpf_filter_clone(dst, src);
+}
+
 static __cold int io_uring_create(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
@@ -3622,6 +3634,13 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	else
 		ctx->notify_method = TWA_SIGNAL;
 
+	/*
+	 * If the current task has restrictions enabled, then copy them to
+	 * our newly created ring and mark it as registered.
+	 */
+	if (current->io_uring_restrict)
+		io_restriction_clone(&ctx->restrictions, current->io_uring_restrict);
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c5bbb43b5842..feb9f76761e9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -195,6 +195,7 @@ void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
+void io_restriction_clone(struct io_restriction *dst, struct io_restriction *src);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/register.c b/io_uring/register.c
index 30957c2cb5eb..12164b4e03aa 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -190,6 +190,67 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	return 0;
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
+	res = kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
+	if (!res)
+		return -ENOMEM;
+
+	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res);
+	if (ret < 0) {
+		kfree(res);
+		return ret;
+	}
+	current->io_uring_restrict = res;
+	return 0;
+}
+
+static int io_register_bpf_filter_task(void __user *arg, unsigned int nr_args)
+{
+	struct io_restriction *res;
+	int ret;
+
+	if (nr_args != 1)
+		return -EINVAL;
+
+	/* If no task restrictions exist, setup a new set */
+	res = current->io_uring_restrict;
+	if (!res) {
+		res = kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
+		if (!res)
+			return -ENOMEM;
+	}
+
+	ret = io_register_bpf_filter(res, arg);
+	if (ret) {
+		if (res != current->io_uring_restrict)
+			kfree(res);
+		return ret;
+	}
+	if (!current->io_uring_restrict)
+		current->io_uring_restrict = res;
+	return 0;
+}
+
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
@@ -909,6 +970,10 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 		return io_uring_register_send_msg_ring(arg, nr_args);
 	case IORING_REGISTER_QUERY:
 		return io_query(arg, nr_args);
+	case IORING_REGISTER_RESTRICTIONS:
+		return io_register_restrictions_task(arg, nr_args);
+	case IORING_REGISTER_BPF_FILTER:
+		return io_register_bpf_filter_task(arg, nr_args);
 	}
 	return -EINVAL;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index cca13d291cfd..2c05e8f66172 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -11,6 +11,8 @@
 
 #include "io_uring.h"
 #include "tctx.h"
+#include "register.h"
+#include "bpf_filter.h"
 
 static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
@@ -54,16 +56,23 @@ void __io_uring_free(struct task_struct *tsk)
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
+		io_put_bpf_filters(tsk->io_uring_restrict);
+		kfree(tsk->io_uring_restrict);
+		tsk->io_uring_restrict = NULL;
+	}
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
@@ -354,5 +363,13 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 
 int __io_uring_fork(struct task_struct *tsk)
 {
+	struct io_restriction *res, *src = tsk->io_uring_restrict;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
+	if (!res)
+		return -ENOMEM;
+
+	tsk->io_uring_restrict = res;
+	io_restriction_clone(res, src);
 	return 0;
 }
-- 
2.51.0



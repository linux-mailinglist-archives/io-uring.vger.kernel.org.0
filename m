Return-Path: <io-uring+bounces-11830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB713D3BC32
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2FB6E309FC7D
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F2D2D1916;
	Mon, 19 Jan 2026 23:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GN4llX0C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99532D9798
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866921; cv=none; b=VDS509HtNBUrxmIQyt5815sKGd+UvLstT6wOTHKeZS2xjkEOEaNL45YZSbNtsZtFTDVjlGIv+4mlS5iC6kunnCyx0iL91JI9g/aJM8iiuOXbnc8KbF8CQBIVLbReSibO2+ygmpj/8P9e1dC0tmKCrW77RG8MXpsLp0+D7h4eUSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866921; c=relaxed/simple;
	bh=bksw2niFcCrT7c0gceqWTC5yq6enLQSYHe29a0kRA+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecqe5rnlhwtzMg4ELf+Cun1/kuOk3idzscHl2rbp72nII/LYgAvuTsImvW4AnafoDjpk3NyEMCsD+ylTNWFBqzl6GDyXEWIkJzEvFUuJreAzKMDz8uMqFyPgaL45RReboGhxvZ9cwSMEzQnOwBoFU+ZAV/1uwR4pEv7rKPx9U9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GN4llX0C; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfd6f321b5so2833330a34.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866907; x=1769471707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7S1TySZtEeLRo+yqB9n/LULirxwPr2avhtff77m5a8=;
        b=GN4llX0C7OvdQ5GJi++joMK/03GmwTsMkEmdKK+g13Jp5uYmc/pffQfHXQgK+Me99A
         m7ccyqN9XfnDObIOjVdyh/dW8cpN6hZlw+a+qtjhOy6Ue8Zdp86Pjk9ymWzxlxiziAGa
         kmDLrklaJwgyolOorOtKgYhQTJiAj8oMMmqXOedcP/zM8/yzU25Gm1ZrLyUNBhW3Zh2k
         VhNZioJAquXlVyrUFfS03UNINuEq9uwyvzLKJIDoebqWsam3hjhh3ZmKndva6QFKs+yg
         qq1Ck33VBo5fSokE39g4RMnrlpFPmlyjzsPAJeiPt7SQZ48DUhNCiU0QT2zcqDoKK3S0
         8seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866907; x=1769471707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y7S1TySZtEeLRo+yqB9n/LULirxwPr2avhtff77m5a8=;
        b=m7gNWlN7BcQYKyMfFf2zufL01KrT3d/DOg0fd+8T/mrvNe/UI0K97k86yzP6PQEDCx
         UivQ8E9XjgS3XaRAjM8R0SktTBEHWvw30Vs/ybCpAXPh/B5JyUJsZOh4fKsZtCVxbhM7
         Z++0xDxUgFXXluOkLAFbdbnG5TNQgZT27tL0Zmt74ysFOEyJfBfqN4gwO6obrtX9YuX9
         W1Phq4/Jz6IFfFSaTFsoIvsiK0ST4WsRaqdRojAy+OposI0HET6+J8hGD0pTW1JTgEef
         1sB6h/cKRemWfp6KQAMqCKC7PbxQ1KKGzT5CtCj9nlzoLTq/fdfQI6t+g/nynmwx0uyE
         qqhg==
X-Gm-Message-State: AOJu0YyU5ZLP9oSh9H+PaZom3dMiuxMID3PZW9qulJKj1qliFlRr3/oM
	tV3fiFrbibgHibc2qebFHP47pKV6WlB7Q3MRLhBKx+RQFRthYhFfk005ATDGe/pWudjgvg4C3U0
	WSx6Z
X-Gm-Gg: AY/fxX5unJXk8o6Psg5MzOEVSLeA7iVh76pmcOgdw0SAQ4UBsvgxymgXXYkcasto1ll
	F4ueaY3uHbbpUQn56agQa8E3pCm/up47IONyehtNeSC8LB5S+Bj73Zg3F6sxwRAekNR7eVH2g8Z
	WZjUx3T/ZI3NVtvM396NDt+XTR4P9TtHb5LTjj2KZs2rnflPNgAlX4jFhmOlMzsYeNJ+zKGzmsC
	B/+hjo0/giGCT0zq4vLZ0aGivoHZUTxxppbM2TEbAnjPGO3H0Oo3zBHpbJBSdN0taxEuR20xzUq
	aO1p/xyAVQ0KE3Ohn0uL4ty2irLh2Tc1t8FVOQglOLBNdEYYdZwHD+rJuqS2NWTV5WkOfWNbdsM
	4FjSzxr6dLd5XA0acQlQlmdg42Riahpxv8VNHo4gNMOmJ6r6m16HSGgDHbySLC/tGW3afYP5jo1
	opg2BWPXt3OKd+wbb7e0NSH20RYfSaQCfmJwEasInSV1A6vXisDuEnlV8V
X-Received: by 2002:a05:6830:440a:b0:7c5:3a34:994a with SMTP id 46e09a7af769-7d140aae72amr104332a34.17.1768866907300;
        Mon, 19 Jan 2026 15:55:07 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring: allow registration of per-task restrictions
Date: Mon, 19 Jan 2026 16:54:30 -0700
Message-ID: <20260119235456.1722452-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
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
 include/uapi/linux/io_uring.h  |  7 +++
 io_uring/bpf_filter.c          | 86 +++++++++++++++++++++++++++++++++-
 io_uring/bpf_filter.h          |  6 +++
 io_uring/io_uring.c            | 33 +++++++++++++
 io_uring/io_uring.h            |  1 +
 io_uring/register.c            | 80 +++++++++++++++++++++++++++++++
 io_uring/tctx.c                | 17 +++++++
 8 files changed, 231 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 366927635277..15ed7fa2bca3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -231,6 +231,8 @@ struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	struct io_bpf_filters *bpf_filters;
+	/* ->bpf_filters needs COW on modification */
+	bool bpf_filters_cow;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	/* IORING_OP_* restrictions exist */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 94669b77fee8..aeeffcf27fee 100644
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
index fc9eaf29fcbf..fb5394afc19f 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -255,13 +255,77 @@ static int io_uring_check_cbpf_filter(struct sock_filter *filter,
 	return 0;
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
 #define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
 
 int io_register_bpf_filter(struct io_restriction *res,
 			   struct io_uring_bpf __user *arg)
 {
+	struct io_bpf_filters *filters, *old_filters = NULL;
 	struct io_bpf_filter *filter, *old_filter;
-	struct io_bpf_filters *filters;
 	struct io_uring_bpf reg;
 	struct bpf_prog *prog;
 	struct sock_fprog fprog;
@@ -303,6 +367,17 @@ int io_register_bpf_filter(struct io_restriction *res,
 			ret = PTR_ERR(filters);
 			goto err_prog;
 		}
+	} else if (res->bpf_filters_cow) {
+		filters = io_bpf_filter_cow(res);
+		if (IS_ERR(filters)) {
+			ret = PTR_ERR(filters);
+			goto err_prog;
+		}
+		/*
+		 * Stash old filters, we'll put them once we know we'll
+		 * succeed. Until then, res->bpf_filters is left untouched.
+		 */
+		old_filters = res->bpf_filters;
 	}
 
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
@@ -312,6 +387,15 @@ int io_register_bpf_filter(struct io_restriction *res,
 	}
 	refcount_set(&filter->refs, 1);
 	filter->prog = prog;
+
+	/*
+	 * Success - install the new filter set now. If we did COW, put
+	 * the old filters as we're replacing them.
+	 */
+	if (old_filters) {
+		__io_put_bpf_filters(old_filters);
+		res->bpf_filters_cow = false;
+	}
 	res->bpf_filters = filters;
 
 	/*
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
index 9f3cdb92eb16..66a776cf25b4 100644
--- a/io_uring/bpf_filter.h
+++ b/io_uring/bpf_filter.h
@@ -13,6 +13,8 @@ int io_register_bpf_filter(struct io_restriction *res,
 
 void io_put_bpf_filters(struct io_restriction *res);
 
+void io_bpf_filter_clone(struct io_restriction *dst, struct io_restriction *src);
+
 static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 					   struct io_kiocb *req)
 {
@@ -37,6 +39,10 @@ static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 static inline void io_put_bpf_filters(struct io_restriction *res)
 {
 }
+static inline void io_bpf_filter_clone(struct io_restriction *dst,
+				       struct io_restriction *src)
+{
+}
 #endif /* CONFIG_IO_URING_BPF */
 
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 62aeaf0fad74..e190827d2436 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3569,6 +3569,32 @@ int io_prepare_config(struct io_ctx_config *config)
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
+static void io_ctx_restriction_clone(struct io_ring_ctx *ctx,
+				     struct io_restriction *src)
+{
+	struct io_restriction *dst = &ctx->restrictions;
+
+	io_restriction_clone(dst, src);
+	if (dst->bpf_filters)
+		WRITE_ONCE(ctx->bpf_filters, dst->bpf_filters->filters);
+	if (dst->op_registered)
+		ctx->op_restricted = 1;
+	if (dst->reg_registered)
+		ctx->reg_restricted = 1;
+}
+
 static __cold int io_uring_create(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
@@ -3629,6 +3655,13 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	else
 		ctx->notify_method = TWA_SIGNAL;
 
+	/*
+	 * If the current task has restrictions enabled, then copy them to
+	 * our newly created ring and mark it as registered.
+	 */
+	if (current->io_uring_restrict)
+		io_ctx_restriction_clone(ctx, current->io_uring_restrict);
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
index 40de9b8924b9..af4815bc11d6 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -190,6 +190,82 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
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
+	/*
+	 * Similar to seccomp, disallow setting a filter if task_no_new_privs
+	 * is true and we're not CAP_SYS_ADMIN.
+	 */
+	if (!task_no_new_privs(current) &&
+	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
+		return -EACCES;
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
+	/*
+	 * Similar to seccomp, disallow setting a filter if task_no_new_privs
+	 * is true and we're not CAP_SYS_ADMIN.
+	 */
+	if (!task_no_new_privs(current) &&
+	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
+		return -EACCES;
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
@@ -912,6 +988,10 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
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
index d4f7698805e4..e3da31fdf16f 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -11,6 +11,7 @@
 
 #include "io_uring.h"
 #include "tctx.h"
+#include "bpf_filter.h"
 
 static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
@@ -66,6 +67,11 @@ void __io_uring_free(struct task_struct *tsk)
 		kfree(tctx);
 		tsk->io_uring = NULL;
 	}
+	if (tsk->io_uring_restrict) {
+		io_put_bpf_filters(tsk->io_uring_restrict);
+		kfree(tsk->io_uring_restrict);
+		tsk->io_uring_restrict = NULL;
+	}
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
@@ -356,5 +362,16 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 
 int __io_uring_fork(struct task_struct *tsk)
 {
+	struct io_restriction *res, *src = tsk->io_uring_restrict;
+
+	/* Don't leave it dangling on error */
+	tsk->io_uring_restrict = NULL;
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



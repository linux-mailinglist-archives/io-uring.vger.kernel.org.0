Return-Path: <io-uring+bounces-11803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 028EFD3986F
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C77F3300B288
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4ED6A33B;
	Sun, 18 Jan 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GullalSy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7559204C36
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757022; cv=none; b=lpDIpFjQPTcY5Iun/qU8m+RPhleafz3LigOC1iKhu7kwOS+e06f4ZxLyJS57rNEKi5igbaPvkKBgCSyK/YpmO0F/xCxIiG26UiZ5qzLtfuw4ym54F3LYBIuiTqp6FpAyYTo4g43ctgqm3CY9Qb1QoGXw+Ut1h3NcK64f5OrZjVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757022; c=relaxed/simple;
	bh=2KXrJuEjMO1wUxYFWEdJkoNithAEzv5/s1NJDLbitkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6hvxGhX0VAFZLwuW2LFxSE/GgWveBsTjVzqlDAY6AyB6LeRMVL2z0JPDuNZbrc5kqz6A6qkrnPvTi0NvEB2eGU3VhZHTu8A4uzPlzgXjLboYK2nmMvYP98ZuI6M3i15GWM1aESj4jX2b9jO03DRXkWufOTux4Onvg7OY88nlls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GullalSy; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfd10887d5so1479298a34.1
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757019; x=1769361819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrBEAaiwlF3qjbU0NJzG9RMWmWGpZ3jE5HAAJGJn3Bc=;
        b=GullalSyCGo8UdGUQp/QRxq0F3CCtkkUnxIXAHO34PVdA1Sa7SYyN/+w2+361AQiS4
         Dh79q2QOC4XuqMwcjKbwyC8EuPo1OThpCeG41U8vCrgA5XU+OeeA53wjsxNSgynyJ1iZ
         Cn7hkXMagTGwWcBwBPMKUAaNTJ+o/HKdw1vbcKDLphafeXLL1vkKPoG2MykZ+HJQM6Oh
         uX3pykczc75HgItQXDD1wV0zD43TYY13+AJXjNiqIdwpmL2zFapKs1ymgVjsC9y8auP6
         xsCOYaQ6dy1kyRrN17qD1ukV/HBl1gNkVGpYxyRv+kSv+a+slKLG2cdXHiUMH2hMk2Ja
         fQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757019; x=1769361819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zrBEAaiwlF3qjbU0NJzG9RMWmWGpZ3jE5HAAJGJn3Bc=;
        b=Qo6U771L3lcrHy9bCPkuBPi16FEgc5NHTFowNjt3k/IfsKwg2b/nS3mcRUi0gbU4xs
         IX5poQzw8Xjhbc4kTGtFhq2ODogJRs39JwF5Rg2heo2P90kD0G0GhZCmm6Xpfm3f7DAn
         D5zs8nlG4tJ8ALez7iNT60LvPO+LxWoSqprbglr6KA+THJQHFwmSkbV1oy+ZBtJql66m
         O+mEneSzMotcc2BxesKXe1sxWYqRPkeRtbuTopkQxyp+1AZB68DkRXosDxbhp46DN5Li
         NBc8qum/jCo/SNI1ppKgEbzNrnE6nlhBPnjsIRiTAs+JljdDYSQDLwLVS3IjR6D74YKM
         sULw==
X-Gm-Message-State: AOJu0YwRAjIv5deeiB+B7VDMtuxBlizTju6tH7FXaEcQQsJGsZGy3x0l
	X4+REQ7Km+8NI19+vY6JHFcM9gKRzjFO9HaU2eEOqPnaKrAu9lvKn4gHZgMjBKZvv4vllbD2T5i
	SASmS
X-Gm-Gg: AY/fxX47ZLT6ntTex0aozTZyPtcVF6epcCCYWsshruLk0FGoEbguSqNg+hUPraV19bu
	Ue51ivkrpodBj9B48dTPExHlQxPYmimYsqt1s0+f7YF0KHIka9I+8TqzPhpluKAR19w3v+B+IXc
	PjkL6nKquPexEBx2dtFcedYT/lr0osnxgSX8ll3CEmsRA1Vd4TfLgwK/msmoorTcN0rpl2pqyrv
	YkDd4xkTFRNsFxI9TbrjHSN3TM4EoDIIhh5LYRB3ztVLVIQfhPPIxUGkydtRaVFA91DsYhJkE2c
	ld8mGOIzfs0f/oTrTr8/Xnatn6VbzYtwB3yZfVeftwIXxP6jQtDyIjAdHK8qNZ8BaanNvya27le
	QyOIp6fez0ZEhQt6SGwrLcD8TkSQtLs99EJcDrRT+eLCQa0ZuNrkkg7ownHxYNBUVT+9708LNQj
	SXVS1df3IR3ni1Y0eUvdrUAwHFIRGPNyPjSoZf6GaTV5fyheAXHT8dJF7W
X-Received: by 2002:a05:6830:67d7:b0:7cb:125d:2a43 with SMTP id 46e09a7af769-7cfe024b75cmr4002909a34.28.1768757019129;
        Sun, 18 Jan 2026 09:23:39 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: allow registration of per-task restrictions
Date: Sun, 18 Jan 2026 10:16:56 -0700
Message-ID: <20260118172328.1067592-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
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
 io_uring/register.c            | 65 +++++++++++++++++++++++++
 io_uring/tctx.c                | 17 +++++++
 8 files changed, 216 insertions(+), 1 deletion(-)

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
index 545acd480ffd..b3a66b4793b3 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -249,13 +249,77 @@ static int io_uring_check_cbpf_filter(struct sock_filter *filter,
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
@@ -297,6 +361,17 @@ int io_register_bpf_filter(struct io_restriction *res,
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
@@ -306,6 +381,15 @@ int io_register_bpf_filter(struct io_restriction *res,
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
index 40de9b8924b9..e8a68b04a6f4 100644
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
@@ -912,6 +973,10 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
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



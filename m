Return-Path: <io-uring+bounces-11951-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aH2NFPEFeWlcugEAu9opvQ
	(envelope-from <io-uring+bounces-11951-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:37:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC86499350
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 502DA30CE2ED
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6C02E9EDA;
	Tue, 27 Jan 2026 18:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bFfLpgio"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6133D6F6
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538817; cv=none; b=uCpXUSeKv+Nm45Tk/VaAu3/hb/XhPDWcQUx7oJ5Ku3zoWGJfvh8CBD64d3iSXGsWh+L/4l5iO3ux1TDW/AJ7pvI5rGemE47+qtzm65B7K9C7gRclyymtyIPhq+dmbgR8Cd8P9zdoeRG/XrX0wicGdezQvH+KiNyfjmB58O9A8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538817; c=relaxed/simple;
	bh=mAJX4N4L1eEWf5KvjA1JLGxSc02QgQtKhwJIY4sd0wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRuDAN9NDPoQOBRTeoHZCk+Sh96fpE/weJpNcZEVcAhBGmFa/YXc5pGFTsGyHGWMIkqbbHt/zEhYTuFu/+4++3rhJiEfkg5pCuWqjPcFsICrv3nEHbRGTiEf+aRFfQr6Z9h3QrP1hDTzfmhKq8SKUh+m9/okSA+rYook8wuXff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bFfLpgio; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-11f36012fb2so8545532c88.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538804; x=1770143604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0mnzNeLgING5/d5o4TZKjmBVOMK309nRfmzoAtJJLk=;
        b=bFfLpgioucYKXKPi0LMsJzl45wGTjhypB3HzTVBx4G0rq7SCGLb69cRH7+PLSXzYrH
         9DkIY5w6NmMlN+i4IK6vDsWFNIHhwakUKgd7ZK0BnFj3svsGTNahi/PrNauffaq/ekjX
         QF6rPOJFdRP7NMjAiZvQVoxYXyu87KKdZzUH24zEOQNBGZf5B5b/1qTKvPE61xNWEBRO
         t6iEObD0MDKsQYtyvhaOA/rFfpSvIQxUT9rE9e7RuhkFtjwt4zq00FBnWIR9yBekkmX+
         oLO6e+u0FVreDaUmNFteTU+nwXwYNQYFN7xskaKjzHMDf+8ttBd9PiitQjRDQd3GgkI1
         ZgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538804; x=1770143604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y0mnzNeLgING5/d5o4TZKjmBVOMK309nRfmzoAtJJLk=;
        b=coO8m72vlhD5WJ5to0MGmXEZDTmmmP+Cg5N5tqT+k7yzjZcht4ZIPDgbS/l8/WuXrg
         bkBLgAmwK7wV9PLDO3/RzKS8PoBaZpkEIceTvRPw4PCYsOlYqj9Mous44sdg59sF8LKO
         +49bhB3sM5KfdQcJR1+WMT3TX+jAcm5E1WdLqdGY7zTWZQ965PfZy3DPCe1V+E70MUvC
         J4GSf2JuxQ7wDJ+xuByYhWAhTLM7jkpRi9cCdYs5gY4qmkSijumCqOGydbcPyjFClpQ4
         eMUsphKV0FWuQFyUfAXIbpJPXFPf/ga4jbQQtepZ+SoJwdy5hlnsalt8sVdI/xK8pwlN
         OBaw==
X-Gm-Message-State: AOJu0YwlLFXiKMD7zzwBeMVaABdVB/SsPyLSvZOT9qxAW4gs6+qouKFj
	DEfo6HXrq0w4+H3J1VaEiOdcZPqHqB8FhDzi2i7UCpjEU2jhygjuOfiqIA1DEjEI1S2tKIW8kkm
	xjCOI
X-Gm-Gg: AZuq6aKKUg7Sldh2S7NxsxnG6wd6vybAyS/dJrN8B3UEXaEot7gKrb16N8Did1sVvWu
	XSQmHOEYM0rsJCOvOl/Ne6vyphD4K9tBCQ6oecUFHKzuN6TbriszmHxnsRv8T745xw6CoYpnkAI
	f1CtnrVV42JcRSVWU0b6JvUH6OJ4EiuFxFMnnFA3/ZrT/k3n2EdTY/rn+QPXiZjEk5GovfZpN9n
	H4DUst0RzKVKS7mnkpY4LMSQYcqIyb/cvT3v+Hzez7KOawJbPyuuXpr0YrEHbFDVM7MNFZoJTxR
	NqzqVm+qUy3mw/W9kbGDSqiuDhQSiwsTQe6uxM8e7e2i9oAiWmmbaMvL3Ethz1ZqQ2LcwHCCuS5
	rixrNSZaZjrdmOgGTiZ6YId0ToheLQIW6ZFoPvR59QvTxpC6/2YqjUiO5J6WPtVGXUmcbMjJIva
	PGh9gpql6MpmfsiT4z66XhZC+smsHDuJeZndT2cR2k+ePetuH5uIWaN2X3Oyo17R35iCQ6GoTN
X-Received: by 2002:a05:7022:608d:b0:11b:9386:825b with SMTP id a92af1059eb24-124a00e85camr1467809c88.48.1769538804145;
        Tue, 27 Jan 2026 10:33:24 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:23 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring: allow registration of per-task restrictions
Date: Tue, 27 Jan 2026 11:30:02 -0700
Message-ID: <20260127183311.86505-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127183311.86505-1-axboe@kernel.dk>
References: <20260127183311.86505-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11951-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AC86499350
X-Rspamd-Action: no action

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
index 7617df247238..510d801b9a55 100644
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
index b94944ab8442..3816883a45ed 100644
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
index 049454278563..e43c5283b23a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2880,6 +2880,32 @@ int io_prepare_config(struct io_ctx_config *config)
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
@@ -2940,6 +2966,13 @@ static __cold int io_uring_create(struct io_ctx_config *config)
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
index 29b8f90fdabf..a08d78c716f8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -197,6 +197,7 @@ void io_task_refs_refill(struct io_uring_task *tctx);
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



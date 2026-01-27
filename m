Return-Path: <io-uring+bounces-11948-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNTDOIIFeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11948-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:35:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 403F39929A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1EC40309B15B
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783F6329368;
	Tue, 27 Jan 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IXc9KC7y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC50628030E
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538804; cv=none; b=Bst8ab4jgU63iCL1CFOWgSfnRE7RHkiGrTDJ4xSY1tngaw1SarUBbW1gsgR1KJUcswEHeet8KZpCnuM6eAx1mvBvzj1Zj/rDj/NOxG/hVgc9b/tuJnzyTwtOuSURsdhRi3trtv7h2wGIARx3cAvJUgscrOwaAruAywzuuc4NoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538804; c=relaxed/simple;
	bh=IexT8NDlSlqKb7LdqL6WLdkXG2g0pW7IlnZbI+E/ISE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlDREkYkXSnzLlAEQBDkUEUtRXVf475tY60v73DJUnm7tRazFXaGy35dv8U3PB7n3oyPewKGG1LimRJmgjLQIkiiwEO4Bz7R+d6oIcIJ/JlezJxuA7+Rs0jNPF4ngU88iazwJ4jnRWBFc+djlGES+sQe7gL2jDCQCbRsehorVpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IXc9KC7y; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12331482b8fso361543c88.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538800; x=1770143600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIooepxIy0CNVR6vppBs5znUknXdkfhKe/Ui2VDFSVQ=;
        b=IXc9KC7ywT14BOSvPPQJ9oFHGJExLCUjy1Ae3oSgbjSxdOIwj0a4ltueTTbbWfBNdh
         1QKBfW1OcKMaxcTWE+4/5ZaSklcwtu7ybUN40jelR7Op3mpX1Q6pFcBD8a6FcQ6FGQjf
         0AXrcex9ZerSy1BiYH7Ji7fYKjYnTBGf51dZi3G0WGBq5DZe6aSer4al7e4ZK8qFELnv
         KI0yLXpjeLhlVekS5LwwAHeIAQgeYLOTHKsetCT2cqse+sMjDidRhEavWLhje4mbkyUT
         9zEEWEpI0UMNwXVsO3DDJr0jamg7JPlhAXM5rX0jZSgBZat2wl7pputYJlY9UUQd7o7S
         pbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538800; x=1770143600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LIooepxIy0CNVR6vppBs5znUknXdkfhKe/Ui2VDFSVQ=;
        b=idA/9TZFMKCf993WlEb3+niI/phLdeePCSeTQ0EKUk9gY6NORCGCBP7kUV+h9s11Hx
         LIuPp21sRQ51mzmr0OxRu6ShdLcN5neaQDm+toVCvCc8DV0vmoCGliStrktRJLe/rCnp
         VJdsNfwgQ309amdqmM3UUex75AwoJr6VkEprpaF37XOSZktbcA65OEMkkPm2iTUeQFoY
         7W7YjGL+1SEm/DTE5nZNtr21mtoD4GJU+4fc5aI9rLX3I2LK3HNDqogaVb/mP1rKpQMt
         TKRKUGolx5UdbmetMH1iA6Axy7sFTpZDwPpTKobYBomDMGdSPhtHGmsxtzjHla/LZlU0
         tyZg==
X-Gm-Message-State: AOJu0YyMvm8ew3hWHuv3avDXNb6SOud9memMISjj1tCSYWoqa+4TNVsQ
	fEe1mf/+/79ARIg+IneRAMG+CWXeDVgvd2Fv1trYVAdQCJPRY+XGHZGkhvCMVkHzuYNFrCTnQej
	qoMyr
X-Gm-Gg: AZuq6aLbDpFhK0YGHaXnZNL0O91lVkRBHRPye9SMWqo3nNOAdi0KTToQ+xvs7NwDLpd
	NQK9ePAOTnwwDpy0OllnNb2VKpHyv0IGHllP0TjWAccyTpwAjcZ1Xq3dOMcOiYqwE4XlXd6SNqS
	Rs+DniphsCDovwdFPAbBFGLt74/X3XqaMe/L9lIPsg0yZ888lB1j+xPHy8sezYxRtyAHZ2NtcRS
	P4c/uoNryUKdtPky+QtLLHLOeM1IzNf3m8CdSyR/fL7qPtG6ReaCLx2R9XDwUEt/DqipEKEoeme
	MTD0XOonuKtcE01FoEydBvcGXPhGFRd8va9qaGZ3Pwc8n1w8TLQAMLGjw5bB+ncpBtnSINVx/5J
	MVyUvVAZjZIqo4WGeB6KhNuW0VmTZRuQt+1rHj82hJTP7ukmIRn2JWEuPl/0QomlE7U9hwVI7Gp
	eJa48cTi7PoCBRimIlgN5aqesIfoOdS6UiBkG3OijqHJ0z9szDfmurrsw0mWuC9PQBXc8O6Leg
X-Received: by 2002:a05:7022:488:b0:121:a01a:8e2f with SMTP id a92af1059eb24-124a00c50e3mr1752868c88.42.1769538800409;
        Tue, 27 Jan 2026 10:33:20 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/bpf_filter: cache lookup table in ctx->bpf_filters
Date: Tue, 27 Jan 2026 11:29:59 -0700
Message-ID: <20260127183311.86505-5-axboe@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-11948-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 403F39929A
X-Rspamd-Action: no action

Currently a few pointer dereferences need to be made to both check if
BPF filters are installed, and then also to retrieve the actual filter
for the opcode. Cache the table in ctx->bpf_filters to avoid that.

Add a bit of debug info on ring exit to show if we ever got this wrong.
Small risk of that given that the table is currently only updated in one
spot, but once task forking is enabled, that will add one more spot.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/bpf_filter.c          |  7 ++++---
 io_uring/bpf_filter.h          | 10 +++++-----
 io_uring/io_uring.c            | 11 +++++++++--
 io_uring/register.c            |  3 +++
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 74bf98362876..7617df247238 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -287,6 +287,8 @@ struct io_ring_ctx {
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
+		/* cache of ->restrictions.bpf_filters->filters */
+		struct io_bpf_filter __rcu	**bpf_filters;
 		struct percpu_ref	refs;
 
 		clockid_t		clockid;
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index ff723ec44828..1409d625b686 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -58,14 +58,15 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
  * __io_uring_run_bpf_filters() returns 0 on success, allow running the
  * request, and -EACCES when a request is denied.
  */
-int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
+int __io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
+			       struct io_kiocb *req)
 {
 	struct io_bpf_filter *filter;
 	struct io_uring_bpf_ctx bpf_ctx;
 	int ret;
 
 	/* Fast check for existence of filters outside of RCU */
-	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
+	if (!rcu_access_pointer(filters[req->opcode]))
 		return 0;
 
 	/*
@@ -73,7 +74,7 @@ int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
 	 * of what we expect, io_init_req() does this.
 	 */
 	guard(rcu)();
-	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
+	filter = rcu_dereference(filters[req->opcode]);
 	if (!filter)
 		return 0;
 	else if (filter == &dummy_filter)
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
index 27eae9705473..9f3cdb92eb16 100644
--- a/io_uring/bpf_filter.h
+++ b/io_uring/bpf_filter.h
@@ -6,18 +6,18 @@
 
 #ifdef CONFIG_IO_URING_BPF
 
-int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req);
+int __io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters, struct io_kiocb *req);
 
 int io_register_bpf_filter(struct io_restriction *res,
 			   struct io_uring_bpf __user *arg);
 
 void io_put_bpf_filters(struct io_restriction *res);
 
-static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 					   struct io_kiocb *req)
 {
-	if (res->bpf_filters)
-		return __io_uring_run_bpf_filters(res, req);
+	if (filters)
+		return __io_uring_run_bpf_filters(filters, req);
 
 	return 0;
 }
@@ -29,7 +29,7 @@ static inline int io_register_bpf_filter(struct io_restriction *res,
 {
 	return -EINVAL;
 }
-static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 					   struct io_kiocb *req)
 {
 	return 0;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9b9794dfc27a..049454278563 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1875,8 +1875,8 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
-	if (unlikely(ctx->restrictions.bpf_filters)) {
-		ret = io_uring_run_bpf_filters(&ctx->restrictions, req);
+	if (unlikely(ctx->bpf_filters)) {
+		ret = io_uring_run_bpf_filters(ctx->bpf_filters, req);
 		if (ret)
 			return io_submit_fail_init(sqe, req, ret);
 	}
@@ -2168,6 +2168,13 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+
+	if (ctx->restrictions.bpf_filters) {
+		WARN_ON_ONCE(ctx->bpf_filters !=
+			     ctx->restrictions.bpf_filters->filters);
+	} else {
+		WARN_ON_ONCE(ctx->bpf_filters);
+	}
 	io_put_bpf_filters(&ctx->restrictions);
 
 	WARN_ON_ONCE(ctx->nr_req_allocated);
diff --git a/io_uring/register.c b/io_uring/register.c
index 30957c2cb5eb..40de9b8924b9 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -837,6 +837,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (nr_args != 1)
 			break;
 		ret = io_register_bpf_filter(&ctx->restrictions, arg);
+		if (!ret)
+			WRITE_ONCE(ctx->bpf_filters,
+				   ctx->restrictions.bpf_filters->filters);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.51.0



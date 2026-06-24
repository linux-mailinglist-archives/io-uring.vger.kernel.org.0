Return-Path: <io-uring+bounces-13824-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id RVntGHWdO2qeaQgAu9opvQ
	(envelope-from <io-uring+bounces-13824-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 11:03:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5DFA6BCC98
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 11:03:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=fmmr.tech header.s=selector1 header.b=x4vVjX+p;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13824-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13824-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3DA72301345E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 09:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E89305669;
	Wed, 24 Jun 2026 09:03:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE53019AA
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 09:03:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291826; cv=none; b=E2+NnfDzZ++Oo93WEAuBy7/hN2fumd/7NONt5EoF89IFz2N8/FYVrhXS+IzVKPrT7obroE9AFnj90OtB2I6fJWL2ia/CAADBkpSsrC+ubTbeok7e9NI/yDkURIZB7gIYs1qZEllhoC9mfaF6u1iB4Q99bD+NCfCPRuJPEJL764o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291826; c=relaxed/simple;
	bh=ovsJQUBJ8jRZEq+YSh6IYmSvkT0g0q4+ZW+VQ4xzV5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc1TBB/dPIOJuqX1CU5BN4UjKY1dqRdLwLn1MUUX1soXkeM0NY0hsf8PMTESw3q8BEV5muZf0/HwhJ1jRKdUjI44enHnKf5mNUSNxaRa0taPGNp00wR073ebyFU1aCnbytHe05XJ8sWQpUxBN9PozPZb9fEvGVwAYo0GwRgVugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech; spf=pass smtp.mailfrom=fmmr.tech; dkim=pass (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b=x4vVjX+p; arc=none smtp.client-ip=185.226.149.38
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <robert@fmmr.tech>)
	id 1wcJWF-005Pfc-VH; Wed, 24 Jun 2026 11:03:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fmmr.tech;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-ID:Date:Subject:Cc:To:From;
	bh=8pXT4AvvqAqFvMZBfQKI0l28nAErHE64FdXGhG7F878=; b=x4vVjX+pv/7QBlBWwBcbgeMoAl
	bi+hihjaa6bViUJtd8WmTvl0OZ0Ub4Kpw/pr7uQbS+NUF/kKSiZQcg5+T1RuaWX3t4XBowwNEJ7qS
	dWvfaqHTwU4bskbF0AU85e1e+uWJfjBzRyn/cwDAxZx5rkGxVLC8h/IpBaFaN4ag5A30Vlwd6IMq2
	mZL8AMFyvqakmUt9Pk/5LUmtpJ2EV2bD6WegszR0QP41R7su78bg0mGtmheVISsLHgJpPRxz1cowL
	of4mx7VbPFqIfLpg3F7TU4LdF6ztkIuremFYq+EVOW0Z785GprQ329lfSp118sEkB2bnmlpswXO5+
	PWgKMGag==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <robert@fmmr.tech>)
	id 1wcJWF-0004Yi-5g; Wed, 24 Jun 2026 11:03:39 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1125095)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wcJW5-000ZmA-8v;
	Wed, 24 Jun 2026 11:03:29 +0200
From: Robert Femmer <robert@fmmr.tech>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Jann Horn <jannh@google.com>,
	Robert Femmer <robert@fmmr.tech>
Subject: [PATCH v4] io_uring: annotate remote tasks for kcoverage
Date: Wed, 24 Jun 2026 11:01:46 +0200
Message-ID: <20260624090145.1715865-2-robert@fmmr.tech>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
References: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[fmmr.tech:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13824-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:dvyukov@google.com,m:andreyknvl@gmail.com,m:kasan-dev@googlegroups.com,m:jannh@google.com,m:robert@fmmr.tech,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[robert@fmmr.tech,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[kernel.dk,google.com,gmail.com,googlegroups.com,fmmr.tech];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[fmmr.tech];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robert@fmmr.tech,io-uring@vger.kernel.org];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[fmmr.tech:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E5DFA6BCC98

Fuzzers use coverage information to guide generation of test cases
towards new or interesting code paths. Syzkaller, specifically, makes
use kcoverage (CONFIG_KCOV). Coverage information is not collected for
kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
This patch annotates io-uring's work queue and sqpoll tasks.

Depends-On: 20260430-kcov-refactor-common-handle-v1-1-23a0c7a0ba38@google.com
Signed-off-by: Robert Femmer <robert@fmmr.tech>
---
 include/linux/io_uring_types.h | 2 ++
 io_uring/io-wq.c               | 5 +++++
 io_uring/io_uring.c            | 2 ++
 io_uring/sqpoll.c              | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 244392026c6d..b6590b2b350c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -504,6 +504,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
+
+	struct kcov_common_handle_id	kcov_handle;
 };
 
 /*
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 8cc7b47d3089..173299dfc9c2 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -19,6 +19,7 @@
 #include <linux/mmu_context.h>
 #include <linux/sched/sysctl.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/kcov.h>
 
 #include "io-wq.h"
 #include "slist.h"
@@ -639,6 +640,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		/* handle a whole dependent link */
 		do {
 			struct io_wq_work *next_hashed, *linked;
+			struct io_kiocb *req;
 			unsigned int work_flags = atomic_read(&work->flags);
 			unsigned int hash = __io_wq_is_hashed(work_flags)
 				? __io_get_work_hash(work_flags)
@@ -649,7 +651,10 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			if (do_kill &&
 			    (work_flags & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
+			req = container_of(work, struct io_kiocb, work);
+			kcov_remote_start_common(req->ctx->kcov_handle);
 			io_wq_submit_work(work);
+			kcov_remote_stop();
 			io_assign_current_work(worker, NULL);
 
 			linked = io_wq_free_work(work);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 103b6c88f252..ab7c3e45e238 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -59,6 +59,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/jump_label.h>
+#include <linux/kcov.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -293,6 +294,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
+	ctx->kcov_handle = kcov_common_handle();
 
 	return ctx;
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 46c12afec73e..aafb640d3b2f 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -13,6 +13,7 @@
 #include <linux/cpuset.h>
 #include <linux/sched/cputime.h>
 #include <linux/io_uring.h>
+#include <linux/kcov.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -342,10 +343,12 @@ static int io_sq_thread(void *data)
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			kcov_remote_start_common(ctx->kcov_handle);
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
+			kcov_remote_stop();
 		}
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
-- 
2.54.0



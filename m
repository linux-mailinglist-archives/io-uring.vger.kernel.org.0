Return-Path: <io-uring+bounces-13507-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMBEGYXRFWrwcQcAu9opvQ
	(envelope-from <io-uring+bounces-13507-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:59:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C28925DA43B
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B64783009B33
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 16:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8BC285C8B;
	Tue, 26 May 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b="UVXiPdeA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03938C412
	for <io-uring@vger.kernel.org>; Tue, 26 May 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814236; cv=none; b=N47X1shrPt5Yc9MCZTtTx0jpvHtYa+6FJxJNTqXGyAh+itQtRU0dW83NSnFKUeIlAxqBl1stb0+7N2JmC+cGykB/syR4uBiOyn6ERSYgaSrUlxaXaSLeBd60XYZIEWxFhQ3v4Qf9FzkPRYu/HUK2xpEFpmCM+Mmb20jh06AelbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814236; c=relaxed/simple;
	bh=LyhAuZyBNjCVPpSmEUZxBC0lbOERPHlAs3FzYI6JGFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH9nO79r8V8C2aNc8k02om9wX9BpaXLvV9ZBNZc3Yy0TO02mAA3L3+WY36NTe752LF91pbzNbLrAsQZm/fgJoQZeHOt2MZjjEKNpLJtoo5WUKCYijbQL1EK9Q8YU/6ziG4yVijjnaf8JPq3XohT3rfW7hG4DDQww50F14mU7hwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech; spf=pass smtp.mailfrom=fmmr.tech; dkim=pass (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b=UVXiPdeA; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fmmr.tech
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <robert@fmmr.tech>)
	id 1wRuz1-001Hnp-MJ; Tue, 26 May 2026 18:50:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fmmr.tech;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-ID:Date:Subject:Cc:To:From;
	bh=wQFjOzaWHi6FynNYotPoMmijq2eMjlCYQDUv20KCtPU=; b=UVXiPdeAUjLOJdtEN4JDY5ITgk
	hNmx6OY/w56gpoBXpOn19LXqROeUVvk1deG+I/fqDiJzHfQ9LdT15LFeTXWuonDFAzeCvHmvgKtiQ
	OQgJVyFSfOMvHCyk7Dj7anJpa21XKyVY1atHXDV76btPV2ag1h3xyDvUWbC5HssNDUAmxTLbnAYOj
	C4hq3pMMLeLntbnQDRJ4xnGd5EFIh564pXIvQajZ4SpW6T+zC+hbpIPKgFDKrLw3aylqLE4PzEGYL
	DXcRxy+Dqz3ALbD4N10ewrso6m5oKPCVJRhqGiNHr6RKAP7Ebk3ffAgNhVYSgQewTl1AJ1we6HE4H
	v66LettA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <robert@fmmr.tech>)
	id 1wRuz1-0000sQ-DG; Tue, 26 May 2026 18:50:23 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1125095)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wRuyj-00AjAH-7w;
	Tue, 26 May 2026 18:50:05 +0200
From: Robert Femmer <robert@fmmr.tech>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Robert Femmer <robert@fmmr.tech>
Subject: [PATCH v3] io_uring: annotate remote tasks for kcoverage
Date: Tue, 26 May 2026 18:49:49 +0200
Message-ID: <20260526164948.831543-2-robert@fmmr.tech>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
References: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[fmmr.tech:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13507-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.dk,google.com,gmail.com,googlegroups.com,fmmr.tech];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[fmmr.tech];
	DKIM_TRACE(0.00)[fmmr.tech:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robert@fmmr.tech,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,fmmr.tech:email,fmmr.tech:mid,fmmr.tech:dkim]
X-Rspamd-Queue-Id: C28925DA43B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fuzzers use coverage information to guide generation of test cases
towards new or interesting code paths. Syzkaller, specifically, makes
use kcoverage (CONFIG_KCOV). Coverage information is not collected for
kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
This patch annotates io-uring's work queue and sqpoll tasks.

Depends-on: 20260430-kcov-refactor-common-handle-v1-1-23a0c7a0ba38@google.com
Signed-off-by: Robert Femmer <robert@fmmr.tech>
---
 include/linux/io_uring_types.h | 2 ++
 io_uring/io-wq.c               | 4 ++++
 io_uring/io_uring.c            | 1 +
 io_uring/io_uring.h            | 2 ++
 io_uring/sqpoll.c              | 4 ++++
 5 files changed, 13 insertions(+)

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
index 8cc7b47d3089..9ade4c4f4983 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -639,6 +639,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		/* handle a whole dependent link */
 		do {
 			struct io_wq_work *next_hashed, *linked;
+			struct io_kiocb *req;
 			unsigned int work_flags = atomic_read(&work->flags);
 			unsigned int hash = __io_wq_is_hashed(work_flags)
 				? __io_get_work_hash(work_flags)
@@ -649,7 +650,10 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
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
index 103b6c88f252..89cb649944d9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -293,6 +293,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
+	ctx->kcov_handle = kcov_common_handle();
 
 	return ctx;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e612a66ee80e..7226fbbbf9f0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -7,6 +7,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/poll.h>
 #include <linux/io_uring_types.h>
+#include <linux/kcov.h>
 #include <uapi/linux/eventpoll.h>
 #include "alloc_cache.h"
 #include "io-wq.h"
@@ -581,4 +582,5 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 46c12afec73e..c7b78ea98587 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -342,19 +342,23 @@ static int io_sq_thread(void *data)
 
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
 
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			kcov_remote_start_common(ctx->kcov_handle);
 			if (io_napi(ctx)) {
 				io_sq_start_worktime(&ist);
 				io_napi_sqpoll_busy_poll(ctx);
 			}
+			kcov_remote_stop();
 		}
 
 		io_sq_update_worktime(sqd, &ist);
-- 
2.54.0



Return-Path: <io-uring+bounces-13457-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sF7zB2riDWop4gUAu9opvQ
	(envelope-from <io-uring+bounces-13457-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 18:33:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E227592140
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 18:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 814B8308604E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 16:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516DF372690;
	Wed, 20 May 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b="4CPvwknh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46C53D810C
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294418; cv=none; b=Qza6yqwrTXu+q104SfzJEuJc3d3XgjZkLQHqhPOgDRKV11jX0/TUqFMxqmOHV23/zEBrPm2IX8n9lgz6l7e9HcGMJGK7rpJEfwvb2vubibF4LKeZHDj6O4SII80sLggnBDm+gVc38VS/CVCRFmiCcRe7F1FftQqkzQ25TGTwrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294418; c=relaxed/simple;
	bh=+7Cq6AMsh4qnLD3l2/Ma1haV+ZQz1pUj/856yt19Jz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oYZ1aDofqJCWgaN7tYCt1oW1cvJTlJdp4Q5vHw/xftSZ2ZXT2DJbUvgQav6JRlgIQ/Gn5TL8QVQgXLB2gLCgtSziTXAugvKOfRmrVpst8EFvix+IacOYP8Fg8oT9DSRTqP+UBc3W+/ZeA80Qixknh+Yz3I6c00fwN/VBoIYLz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech; spf=pass smtp.mailfrom=fmmr.tech; dkim=pass (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b=4CPvwknh; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fmmr.tech
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <robert@fmmr.tech>)
	id 1wPj3N-002XIt-OZ; Wed, 20 May 2026 17:41:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fmmr.tech;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
	Subject:Cc:To:From; bh=ixqyo2EcRd1Q19UOCnOri5Eyj3SDZ3ht88XbTvNop0s=; b=4CPvwk
	nh37EhEYQSJ49roHmp9y9fNL9K7zYx42sqDdlkdrFmAQ/pA5fsxyUVijGZfz6BLG5P8gmCoCgNyfy
	t7HQBkNDBAXz79qCy8uxy3z2zPCev8BrnyJBxnEyWJscrr2kKb3eDetuoOLGIfaHIGRZfXaywjd6J
	jGS2Tiqz+1pkwtgVz/QsIMMNspMtEa1YtYpXEKVwNzMNSe/zSxn17RWMl8hjl1fVTyhpr+RUQQDkf
	mfkVq/PrILjUqatKzrqXXXs2AREccxpbV8LQDXwaMj2OX1eJPjSBEPhlBtrAS/QtUslidh+2GR+1x
	soipmYx3+QnkSnF3Q2r1cmODRmdg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <robert@fmmr.tech>)
	id 1wPj3N-0005MA-B2; Wed, 20 May 2026 17:41:49 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1125095)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wPj3A-00E8Ai-Oh;
	Wed, 20 May 2026 17:41:36 +0200
From: Robert Femmer <robert@fmmr.tech>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Robert Femmer <robert@fmmr.tech>
Subject: [PATCH] io_uring: annotate remote tasks for kcoverage
Date: Wed, 20 May 2026 17:39:03 +0200
Message-ID: <20260520153902.538206-2-robert@fmmr.tech>
X-Mailer: git-send-email 2.54.0
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13457-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,google.com,gmail.com,googlegroups.com,fmmr.tech];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[fmmr.tech];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robert@fmmr.tech,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[fmmr.tech:+];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 9E227592140
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fuzzers use coverage information to guide generation of test cases
towards new or interesting code paths. Syzkaller, specifically, makes
use kcoverage (CONFIG_KCOV). Coverage information is not collected for
kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
This patch annotates io-uring's work queue and sqpoll tasks.

The value of the handle needs to be passed by userspace when enabling
remote coverage collection. I chose the cgroup ns inum, because it is
predictable and flexible enough for consumers to control which group of
processes should be included for remote coverage collection, should they
create an instance of io-uring.

Signed-off-by: Robert Femmer <robert@fmmr.tech>
---
 include/linux/io_uring_types.h |  4 ++++
 include/uapi/linux/kcov.h      |  1 +
 io_uring/io-wq.c               |  4 ++++
 io_uring/io_uring.c            | 18 ++++++++++++++++++
 io_uring/io_uring.h            | 22 ++++++++++++++++++++++
 io_uring/sqpoll.c              |  4 ++++
 kernel/kcov.c                  |  2 ++
 7 files changed, 55 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 244392026c6d..b92b8e7169ea 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -504,6 +504,10 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
+
+#ifdef CONFIG_KCOV
+	u64				kcov_handle;
+#endif
 };
 
 /*
diff --git a/include/uapi/linux/kcov.h b/include/uapi/linux/kcov.h
index ed95dba9fa37..15bbce4569b1 100644
--- a/include/uapi/linux/kcov.h
+++ b/include/uapi/linux/kcov.h
@@ -49,6 +49,7 @@ enum {
 
 #define KCOV_SUBSYSTEM_COMMON	(0x00ull << 56)
 #define KCOV_SUBSYSTEM_USB	(0x01ull << 56)
+#define KCOV_SUBSYSTEM_IOURING	(0x02ull << 56)
 
 #define KCOV_SUBSYSTEM_MASK	(0xffull << 56)
 #define KCOV_INSTANCE_MASK	(0xffffffffull)
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 8cc7b47d3089..bb89d3f4b3dc 100644
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
+			io_kcov_remote_start(req->ctx);
 			io_wq_submit_work(work);
+			io_kcov_remote_stop();
 			io_assign_current_work(worker, NULL);
 
 			linked = io_wq_free_work(work);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 036145ee466c..71478e6ccae4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -222,6 +222,21 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_rsrc_cache_free(ctx);
 }
 
+#ifdef CONFIG_KCOV
+static __cold u64 io_ring_get_kcov_handle(void)
+{
+	struct nsproxy *ns_proxy = current->nsproxy;
+	struct ns_common *ns;
+	u64 inst = 0;
+
+	if (ns_proxy) {
+		ns = to_ns_common(ns_proxy->cgroup_ns);
+		inst = ns->inum;
+	}
+	return kcov_remote_handle(KCOV_SUBSYSTEM_IOURING, inst);
+}
+#endif
+
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -293,6 +308,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
+#ifdef CONFIG_KCOV
+	ctx->kcov_handle = io_ring_get_kcov_handle();
+#endif
 
 	return ctx;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e612a66ee80e..cb03df877456 100644
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
@@ -581,4 +582,25 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
+#ifdef CONFIG_KCOV
+static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
+{
+	kcov_remote_start(ctx->kcov_handle);
+}
+
+static inline void io_kcov_remote_stop(void)
+{
+	kcov_remote_stop();
+}
+#else
+static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
+{
+}
+
+static inline void io_kcov_remote_stop(void)
+{
+}
+#endif
+
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 46c12afec73e..b244abd37a27 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -342,19 +342,23 @@ static int io_sq_thread(void *data)
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			io_kcov_remote_start(ctx);
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
+			io_kcov_remote_stop();
 		}
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			io_kcov_remote_start(ctx);
 			if (io_napi(ctx)) {
 				io_sq_start_worktime(&ist);
 				io_napi_sqpoll_busy_poll(ctx);
 			}
+			io_kcov_remote_stop();
 		}
 
 		io_sq_update_worktime(sqd, &ist);
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 0b369e88c7c9..6df04581a126 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -585,6 +585,8 @@ static inline bool kcov_check_handle(u64 handle, bool common_valid,
 			common_valid : zero_valid;
 	case KCOV_SUBSYSTEM_USB:
 		return uncommon_valid;
+	case KCOV_SUBSYSTEM_IOURING:
+		return uncommon_valid;
 	default:
 		return false;
 	}
-- 
2.54.0



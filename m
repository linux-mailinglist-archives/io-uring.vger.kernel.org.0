Return-Path: <io-uring+bounces-13460-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aH8COUwdDmro6AUAu9opvQ
	(envelope-from <io-uring+bounces-13460-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:45:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBF559A0B8
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C3D1B3082F6F
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8318E374756;
	Wed, 20 May 2026 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b="QaxK6M6V"
X-Original-To: io-uring@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3736A34D
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779309878; cv=none; b=LQmaKt//YJZOBmQRyav/7+87QqhJspXUpLWUkDZhSTcm/lFGR6t86A+K1y9I0lgBv1GruiSIZSTIbbG7rFRlXZdeumbPHX6XwFq2HJA9/GG09Y+mMIP3dQw8CfUzRS7kWbeO/lvsNu4X/+nDIKuHBq5FbvryWK6hGs0ESq63c/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779309878; c=relaxed/simple;
	bh=JA4oajjjfzv/jShp9a0EdZWx9s4yuYdeynOXUADoypM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed0sBP0py2hK1jE9kOG/GEoph0nJf4YpiekUZzfKgU1nKXbmE4EeZZqi7IW8t41wCQt4DmClCsRJt/ipooAlsScxGms+Vl76wci4XiBJI70P1Qzu7/jHc+SppOSh2Rcp3oO4TxbVC6O+gpBj2C2R+T1eiVKBdNRBkagyZxm10Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech; spf=pass smtp.mailfrom=fmmr.tech; dkim=fail (2048-bit key) header.d=fmmr.tech header.i=@fmmr.tech header.b=QaxK6M6V reason="signature verification failed"; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fmmr.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fmmr.tech
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <robert@fmmr.tech>)
	id 1wPnmJ-0039ar-2f; Wed, 20 May 2026 22:44:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fmmr.tech;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-ID:Date:Subject:Cc:To:From;
	bh=efk02pEZUCJC1+M1yFwDpmrjykp88X3o7rpxIWwWT14=; b=QaxK6M6VB6h/EsQ4u94I7Z2miC
	YrgUi8sPB+y7QgAt1o4caUuXzDMA4KuarOhPBAHSjv+qFPfQzR8/rg2IIiu6YAq8HZEjg8QjLynGP
	jKFbi9IpDxJx3t2/lOTpGxmYG3032ZsqOEC+4E6jPeGxViV5LEnl5c2kKfbCY/FuogAuMr86lX1JT
	LoRX1S6bcJOOUOx+ANJB2hkTCY/FNkaTqE9Uh4zotvQZZPX2iwMTP4Yvgh6jaKkeLoQLcAYKWDE7V
	7ZgdyeWh3mD0RgQPnUl8QzXab5p64VC7E5v6VROer0wNd/engIwKr4ZuwZc4glWBqC6IaQQdyxCuA
	9q0gyxZA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <robert@fmmr.tech>)
	id 1wPnmI-00061E-PW; Wed, 20 May 2026 22:44:30 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1125095)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wPnmI-00EbZa-7a;
	Wed, 20 May 2026 22:44:30 +0200
From: Robert Femmer <robert@fmmr.tech>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Robert Femmer <robert@fmmr.tech>
Subject: [PATCH v2] io_uring: annotate remote tasks for kcoverage
Date: Wed, 20 May 2026 22:43:04 +0200
Message-ID: <20260520204303.558392-2-robert@fmmr.tech>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CA+fCnZcHbkT=knNbOnAAmrbhx+8+WdcshLty84S_0UbYWVL-=A@mail.gmail.com>
References: <CA+fCnZcHbkT=knNbOnAAmrbhx+8+WdcshLty84S_0UbYWVL-=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [1.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[fmmr.tech:s=selector1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,google.com,gmail.com,googlegroups.com,fmmr.tech];
	TAGGED_FROM(0.00)[bounces-13460-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[fmmr.tech];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	NEURAL_SPAM(0.00)[0.981];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robert@fmmr.tech,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[fmmr.tech:-];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5FBF559A0B8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fuzzers use coverage information to guide generation of test cases
towards new or interesting code paths. Syzkaller, specifically, makes
use kcoverage (CONFIG_KCOV). Coverage information is not collected for
kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
This patch annotates io-uring's work queue and sqpoll tasks.

Signed-off-by: Robert Femmer <robert@fmmr.tech>
---
 include/linux/io_uring_types.h |  4 ++++
 io_uring/io-wq.c               |  4 ++++
 io_uring/io_uring.c            |  3 +++
 io_uring/io_uring.h            | 24 ++++++++++++++++++++++++
 io_uring/sqpoll.c              |  4 ++++
 5 files changed, 39 insertions(+)

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
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 8cc7b47d3089..16af75b1cfe0 100644
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
+			io_kcov_remote_stop(req->ctx);
 			io_assign_current_work(worker, NULL);
 
 			linked = io_wq_free_work(work);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 036145ee466c..f38b8eca6bbb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -293,6 +293,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
+#ifdef CONFIG_KCOV
+	ctx->kcov_handle = current->kcov_handle;
+#endif
 
 	return ctx;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e612a66ee80e..881d43bd529c 100644
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
@@ -581,4 +582,27 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
+#ifdef CONFIG_KCOV
+static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
+{
+	if (ctx->kcov_handle)
+		kcov_remote_start(ctx->kcov_handle);
+}
+
+static inline void io_kcov_remote_stop(struct io_ring_ctx *ctx)
+{
+	if (ctx->kcov_handle)
+		kcov_remote_stop();
+}
+#else
+static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
+{
+}
+
+static inline void io_kcov_remote_stop(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 46c12afec73e..8d2876e31acb 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -342,19 +342,23 @@ static int io_sq_thread(void *data)
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			io_kcov_remote_start(ctx);
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
+			io_kcov_remote_stop(ctx);
 		}
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			io_kcov_remote_start(ctx);
 			if (io_napi(ctx)) {
 				io_sq_start_worktime(&ist);
 				io_napi_sqpoll_busy_poll(ctx);
 			}
+			io_kcov_remote_stop(ctx);
 		}
 
 		io_sq_update_worktime(sqd, &ist);
-- 
2.54.0



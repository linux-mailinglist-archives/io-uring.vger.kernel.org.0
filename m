Return-Path: <io-uring+bounces-2652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3785946B79
	for <lists+io-uring@lfdr.de>; Sun,  4 Aug 2024 01:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED248B209E2
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 23:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C4257C8E;
	Sat,  3 Aug 2024 23:27:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E42D14A84
	for <io-uring@vger.kernel.org>; Sat,  3 Aug 2024 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722727621; cv=none; b=LVGfa4zlLlAuM7Qya8S3kpbb7mBeTb8oOHfeLJqFYzdPYPdbJWa2266iBUOk+WFg31GCm30SiiI5lvlSdljr+29gBGjy737OQgFyfE566YXk1LlMrzeJl6eWUqd0vxJ048azAZf6nv8m28bxIfFBCUWti6/WAdbGjci04QSdwbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722727621; c=relaxed/simple;
	bh=ZiBasLhYh9pbbWg4k2coB6FAHbk/501iUEW5dt6NqME=;
	h=From:Message-ID:To:Date:Subject; b=mLdmuUozkXgt6o4uMbmEJ8CxodR7sSCvD2MKe5n7iJkoM9D/D9LmFe7am40KPvEBGnb53p09pbTmITDmbx/z8vNeeXkxOg5Vacl9Kv8v+H7uCWra+CRlEiTcR9c6T98Tg12B3uALBC9GnfohOUaXRbcPsqfiQKWJ8uiFbLL7Qiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=59906 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1saO9J-0002TO-1y;
	Sat, 03 Aug 2024 19:26:57 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 17:10:21 -0400
Subject: [PATCH v2] io_uring: do the sqpoll napi busy poll outside the
 submission block
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

there are many small reasons justifying this change.

1. busy poll must be performed even on rings that have no iopoll and no
   new sqe. It is quite possible that a ring configured for inbound
   traffic with multishot be several hours without receiving new request
   submissions
2. NAPI busy poll does not perform any credential validation
3. If the thread is awaken by task work, processing the task work is
   prioritary over NAPI busy loop. This is why a second loop has been
   created after the io_sq_tw() call instead of doing the busy loop in
   __io_sq_thread() outside its credential acquisition block.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.h   | 9 +++++++++
 io_uring/sqpoll.c | 6 +++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/io_uring/napi.h b/io_uring/napi.h
index 88f1c21d5548..5506c6af1ff5 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -101,4 +101,13 @@ static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 }
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
+static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
+{
+	int ret = 0;
+
+	if (io_napi(ctx))
+		ret = io_napi_sqpoll_busy_poll(ctx);
+	return ret;
+}
+
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index cc4a25136030..7f4ed7920a90 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -195,9 +195,6 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
-		if (io_napi(ctx))
-			ret += io_napi_sqpoll_busy_poll(ctx);
-
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
@@ -322,6 +319,9 @@ static int io_sq_thread(void *data)
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			io_do_sqpoll_napi(ctx);
+		}
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
 				io_sq_update_worktime(sqd, &start);
-- 
2.46.0



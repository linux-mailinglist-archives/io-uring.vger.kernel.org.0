Return-Path: <io-uring+bounces-2618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F5A9422B8
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 00:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1881F250E9
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B044C190070;
	Tue, 30 Jul 2024 22:23:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF437157466
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 22:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378201; cv=none; b=JXU5+0OHC4ORUPGwo0Ysl0rPgHQiOrHJjqFQLp5dFV7VPY3CPYcO3/+aCuAI48rtlWJbgensM7vBtlkJt90cFojIAniar+fsm0wkQ+Nw5+DcfdQ4xgZt2znspNJEF/DQAMLAZa7B0Pwkg0XQWDTkK8fV4etQhKcFPWfviNbB+Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378201; c=relaxed/simple;
	bh=4uEjqQbrkXQmYjlfc1tmg283eC47zFkxhYqVkhg2VL8=;
	h=From:Message-ID:In-Reply-To:References:To:Date:Subject; b=GaefjbVPyKoand5K53UEvgTdbbtLKhulp9v7E/PMnNA75X0a/XjMZzB9d8ES5fyybWpxaEtHj1LpsWtpy1TxWeX6YpMsWwXTSrZdFMxFXv1UVCkR4T6yB/uqZiSinQsG9mT/O/lTwaXOeGIjVmUTEPNxheJvyu/LnbGxKaSZr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=44412 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYvFV-0000rc-1P;
	Tue, 30 Jul 2024 18:23:17 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com>
In-Reply-To: <cover.1722374370.git.olivier@trillion01.com>
References: <cover.1722374370.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 17:10:21 -0400
Subject: [PATCH 2/2] io_uring: do the sqpoll napi busy poll outside the
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
 io_uring/sqpoll.c | 7 ++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

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
index cc4a25136030..ec558daa0331 100644
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
@@ -322,6 +319,10 @@ static int io_sq_thread(void *data)
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			if (io_do_sqpoll_napi(ctx))
+				sqt_spin = true;
+		}
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
 				io_sq_update_worktime(sqd, &start);
-- 
2.45.2



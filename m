Return-Path: <io-uring+bounces-3634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5743299BAD9
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CC3528196C
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE7F13D52C;
	Sun, 13 Oct 2024 18:29:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EE813AD22
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844155; cv=none; b=mZLpIAlF5tpaZPejEc/7kkhYICvJCC3+izKOvPF/qvc5WNZj1zmhKlac/NVUywlgw12d9Tvz0vNBGLLKp4dbFeqbv/lOXJv0M1aSUTKt1n/DePeQs2ARzFAJTI2bT1TsU1PrcIu/ej6KNqLP4ROWkRdMliBpx0dgWfd/lZyHx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844155; c=relaxed/simple;
	bh=9K1K3OinQUqDyqLpGtddE97QiTGQ15zmQSnMbYZfJm4=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=mVes/mlf05peVJORg7NsbVpmNrvUvcjn5Q11+LG55UFN4hK2D6zREWTlTFcOv14tvb+84U+xMcdW2fZPVJE69+gWFSdSCvOKjemqJCPI77660+s9JWQYIVkynkh25zX/EGWaX1Dzt3ZOvdNPQWoSjc3F0kZZGDcy3eC9IxebaKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=36810 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03L7-0002mW-0D;
	Sun, 13 Oct 2024 14:29:13 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:29:12 -0400
Message-ID: <d5b9bb91b1a08fff50525e1c18d7b4709b9ca100.1728828877.git.olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 5/6] io_uring/napi: clean up __io_napi_do_busy_loop
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

__io_napi_do_busy_loop now requires to have loop_end in its parameters.
This makes the code cleaner and also has the benefit of removing a
branch since the only caller not passing NULL for loop_end_arg is also
setting the value conditionally.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 6d5fdd397f2f..1de1543d8034 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -137,15 +137,12 @@ static bool io_napi_busy_loop_should_end(void *data,
 }
 
 static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
+				   bool (*loop_end)(void *, unsigned long),
 				   void *loop_end_arg)
 {
 	struct io_napi_entry *e;
-	bool (*loop_end)(void *, unsigned long) = NULL;
 	bool is_stale = false;
 
-	if (loop_end_arg)
-		loop_end = io_napi_busy_loop_should_end;
-
 	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
 		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
 				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
@@ -161,18 +158,22 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
 	unsigned long start_time = busy_loop_current_time();
+	bool (*loop_end)(void *, unsigned long) = NULL;
 	void *loop_end_arg = NULL;
 	bool is_stale = false;
 
 	/* Singular lists use a different napi loop end check function and are
 	 * only executed once.
 	 */
-	if (list_is_singular(&ctx->napi_list))
+	if (list_is_singular(&ctx->napi_list)) {
+		loop_end = io_napi_busy_loop_should_end;
 		loop_end_arg = iowq;
+	}
 
 	scoped_guard(rcu) {
 		do {
-			is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+			is_stale = __io_napi_do_busy_loop(ctx, loop_end,
+							  loop_end_arg);
 		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
 			 !loop_end_arg);
 	}
@@ -308,7 +309,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 		return 0;
 
 	scoped_guard(rcu) {
-		is_stale = __io_napi_do_busy_loop(ctx, NULL);
+		is_stale = __io_napi_do_busy_loop(ctx, NULL, NULL);
 	}
 
 	io_napi_remove_stale(ctx, is_stale);
-- 
2.47.0



Return-Path: <io-uring+bounces-2692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0576894E2B3
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 20:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FA65B20E15
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADF114D444;
	Sun, 11 Aug 2024 18:36:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF1D14B95B
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 18:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723401395; cv=none; b=I/YXoRQwuIMsvGEepdlpT7+CH8M7Py/8XfhdHSkZ8Q+juDEQlK44fPAUtVKQB/ruouyYVERA9zQ2HH7XxYKrtauJobSi/YhpO1B9sRhJIShuH8A9Xu0XuYN5iEANfNRvVuQv5UaHPb5inEVfS8NOqxMrL5fWrQN8tjJJX2RH7YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723401395; c=relaxed/simple;
	bh=YdhOf3u3PXNk6xGNmdjwECMvnHlzwmNzImcdgbpe+ww=;
	h=From:Message-ID:To:Date:Subject; b=jb2S8wLFXwvFdJLwPXjxD7tiv7Yj4N4tMWuiz0s0j9hYFMCtfRNLUaCUjuJM5UP+13Gl6OlXE+JgjtSq6suAfWl7Lewoc48BQ5U+qm/ubAAITf5pOgc2P2RHsBvmmhMkeBxtNYEAh0fmrBBcItgZHCLn9KXvWc179oAIf120Xc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=50676 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdDQK-0001NA-25;
	Sun, 11 Aug 2024 14:36:12 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <bd989ccef5fda14f5fd9888faf4fefcf66bd0369.1723400131.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Sun, 11 Aug 2024 14:07:11 -0400
Subject: [PATCH] io_uring/napi: check napi_enabled in io_napi_add() before
 proceeding
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

doing so avoids the overhead of adding napi ids to all the rings that do
not enable napi.

if no id is added to napi_list because napi is disabled,
__io_napi_busy_loop() will not be called.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Fixes: b4ccc4dd1330 ("io_uring/napi: enable even with a timeout of 0")
---
 io_uring/napi.c | 2 +-
 io_uring/napi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index a3dc3762008f..73c4159e8405 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -302,7 +302,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
 	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
 
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
 
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 88f1c21d5548..27b88c3eb428 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -55,7 +55,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_dt))
+	if (!READ_ONCE(ctx->napi_enabled))
 		return;
 
 	sock = sock_from_file(req->file);
-- 
2.46.0



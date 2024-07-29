Return-Path: <io-uring+bounces-2595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BB39403FA
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 03:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FD0B28330C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 01:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF724683;
	Tue, 30 Jul 2024 01:46:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206D829AF
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 01:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303974; cv=none; b=KhhN2MKGAiP9+xArgW+LPVdJGuBcrFPx16uOqVPEMy9gIZ1fkz5BD+xi09iDmyHn0QqXQNk1DP9ghYvRdXRcFfB0PYjpaXX2BTgHXl+clMhagahFzwBuH30DLE9oREDCc5daS7/FuafvRHq5tb/U0whbGoEYmsZfl8h1O0ecFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303974; c=relaxed/simple;
	bh=6iwhVKoZzNTduhQqzHcOrq5LyyOLnhmZQeyqro3XkK4=;
	h=From:Message-ID:To:Date:Subject; b=gvz7OVHsBw4pmmF6xzwFXB+HbuczBJrIr9UzuQrmz9eZjUYLVSJ/87FuqUv8GJOzMitauFHD97pQBFZZV+q+Yw+6NwfPlzVD7dyX+FNWTHGBthQ0nVEJ9Fe32Q8eMu7AtUCzezEst5s2fR9OToG/WY4xUgZcYfPItG6T6GE1oY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=51612 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYbwK-00045O-06;
	Mon, 29 Jul 2024 21:46:12 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <0a0ae3e955aed0f3e3d29882fb3d3cb575e0009b.1722294947.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Mon, 29 Jul 2024 19:13:35 -0400
Subject: [PATCH] io_uring: remove unused local list heads in NAPI functions
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

remove 2 unused local variables

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4fd6bb331e1e..a3dc3762008f 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -205,7 +205,6 @@ void io_napi_init(struct io_ring_ctx *ctx)
 void io_napi_free(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
-	LIST_HEAD(napi_list);
 	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
@@ -315,7 +314,6 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
  */
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 {
-	LIST_HEAD(napi_list);
 	bool is_stale = false;
 
 	if (!READ_ONCE(ctx->napi_busy_poll_dt))
-- 
2.45.2



Return-Path: <io-uring+bounces-2731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2652094F9C2
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 00:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 592841C21522
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 22:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2C31953B9;
	Mon, 12 Aug 2024 22:38:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAC1192B8A
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502339; cv=none; b=ezWfBidR7gHOrrA4WlnPaSk5c/JivCDAuZfsBnifC0Zg8LaKtmr9cKQrraiQxptCoEe0ZC8tTbLl6pG4KGFc9ZenFhuuuVxCEpuV+TWOy1d7JUG1+ORD6VQfRi+nPXecBOd+RQf2i+CoTk8D4x2oZ6Rl9G6DD3OnxecWQ2z3e5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502339; c=relaxed/simple;
	bh=ALCSyRtqC6uRSLbvognVyjKmLOPtBQ9hOTRhX83w4Eg=;
	h=From:Message-ID:To:Date:Subject; b=nP0H3xr0ChCiuaCa1fD00vrx1aNHyOAtSCye+SbtDj4/uSOW55ASBKKU3iNghBVikVqO5zfWbjUAiexb+pcC9hNzUoSpP5ie4QdVyU+Uo/E6Jd+Ad08q4IVoaJ0K7icH07U9cm+PoYwVKXNyeDGA91Djao1tUDxySTjR1xVYgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=55702 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sddgl-00022X-2S;
	Mon, 12 Aug 2024 18:38:55 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <19905713556ad4195d1bf8c8c1e38fc2683b592b.1723502167.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 17:10:21 -0400
Subject: [PATCH v3] io_uring: do the sqpoll napi busy poll outside the submission
 block
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
 io_uring/sqpoll.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index cc4a25136030..b74db3988b7f 100644
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
 
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			if (io_napi(ctx))
+				io_napi_sqpoll_busy_poll(ctx);
+
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
 				io_sq_update_worktime(sqd, &start);
-- 
2.46.0



Return-Path: <io-uring+bounces-3629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B14C199BAD2
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1EB11C208D0
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDDB83CD6;
	Sun, 13 Oct 2024 18:28:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE3213D52C
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844111; cv=none; b=gBR3SUJA0lTdzn5tvAIB9MNys335LlYUJ9XmPj8ROrHKk9DSajnrftiR+qnxVmfPVVwiYoccZb/vMrRX6qoAWh75/bLgQMUnai6weEma5zz4pejCwMinQ314ZoDDvmMmPAJ8nW7OLsYf5irjfpxM1/fnPLB7Ov6PVPiwsuIxdoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844111; c=relaxed/simple;
	bh=XgzkacEd4557jf4FkMMAuQ38R4t1u+ouZTB6TqAUfhE=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=AKIsHeMHnydpmvcI9cf6tx8dQtKBHOcD0ZbA1F0K+UIcDe/fzAUGV2ViXfCV7SBtUNss+VEiywd0eFtbfayNgLHBo7w8rWhOmmLPDhS7Jfs+HIjOpoJya+Oo+ZHGAjpmeCFIufJA+BGKLjIuIAMiR2WUiihM1+xEsAQlyxiIEkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=48014 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03KL-0002hy-1i;
	Sun, 13 Oct 2024 14:28:25 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:28:24 -0400
Message-ID: <3de3087563cf98f75266fd9f85fdba063a8720db.1728828877.git.olivier@trillion01.com>
In-Reply-To: <cover.1728828877.git.olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 1/6] io_uring/napi: protect concurrent io_napi_entry
 timeout accesses
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

io_napi_entry timeout value can be updated while accessed from the poll
functions.

Its concurrent accesses are wrapped with READ_ONCE()/WRITE_ONCE() macros
to avoid incorrect compiler optimizations.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index d0cf694d0172..dda2e083fb5d 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -60,7 +60,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	rcu_read_lock();
 	e = io_napi_hash_find(hash_list, napi_id);
 	if (e) {
-		e->timeout = jiffies + NAPI_TIMEOUT;
+		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
 		rcu_read_unlock();
 		return;
 	}
@@ -92,7 +92,7 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 
 	spin_lock(&ctx->napi_lock);
 	hash_for_each(ctx->napi_ht, i, e, node) {
-		if (time_after(jiffies, e->timeout)) {
+		if (time_after(jiffies, READ_ONCE(e->timeout))) {
 			list_del(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
@@ -150,7 +150,7 @@ static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
 				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
 
-		if (time_after(jiffies, e->timeout))
+		if (time_after(jiffies, READ_ONCE(e->timeout)))
 			is_stale = true;
 	}
 
-- 
2.47.0



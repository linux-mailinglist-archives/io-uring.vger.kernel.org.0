Return-Path: <io-uring+bounces-11048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC1FCBFB42
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7BCD302A94C
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7013930C613;
	Mon, 15 Dec 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fb261Wwr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD42EFD95
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829430; cv=none; b=RRpumld5EYOirEvB8dh6TyHWywjItafqOrX8Mb005o1pe50Yf5fph/3ebRx/MEgjhgr01oTPzvQOoetVzKW37FfvBRot0f8755Un8kOh8s4hAlwwrBTqc/t8jLTDHvwlXjtCQW6DBLaT0zPKGrnY2pUDsRg9jyygJqybtZjKj+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829430; c=relaxed/simple;
	bh=mCH4UHXC/WywxK2XbUmSCE7uuYnugHpAiJbLAuIlfJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRxMGBdWYQ4t4CiXEQOY5BEV/O7vAtbxzfLtgMQ3XHDsyIrue0nyS/51hCOSvfcr22HrW5n0j/Ob/vtpxY3a/TTTrodiotb56VD3XlRftxRBD3UIKrquQ6HrZzZmNKrRkWHBf6aETDjJZ6jckFlw42UkQXUS47bP/sGiVupgl6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fb261Wwr; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-7c9011d6039so198692b3a.2
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829428; x=1766434228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tc5cAPWLhKrkCI4CYdzzTi0ug0E8D643Rd4mnx3PNyc=;
        b=fb261Wwr26iDMrjN6rRp2/liMKX/YtdRsmRn/uT0qzoM+f2BFZ6ehBwdsrtPeLExcv
         6Yf2gfHdA+qQu3jr5jdvtHmqW34hjOS8oWSiNuLnEOfrcT8xeIIGNs9pqraSxbnmVm5w
         o1npCKyYDGYgC9539CsH5TMYS53k2GnFjhfIdq3N3leWivXy0vq8s7BgAv5Tz36K/oye
         c5/ZiYVT5I+ilu8sWP6fGAvfBpDO+q3Uxo2K/HqKyOdjzS6pMRcBA8T0Lwf1OMUNqiSE
         2MbVbs+FNpl/1FXWT0GYjzCwzryDIyYtwrFDZcgzmTLatIyQL6GHHX7x5fVc9FGFr4QL
         NxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829428; x=1766434228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tc5cAPWLhKrkCI4CYdzzTi0ug0E8D643Rd4mnx3PNyc=;
        b=ljOL6XkJvhWOhxThPZ1NDnyZfh084F/l6nDIkyn8siSHYWbJ9pFxPNBeJ4AA8gGnnL
         eIryqbLsOY0EyWdQM6diEgRYm7hsRz7O8NvVikgNlx843JpCQsnc6jx7xuSXcagxjCho
         A0b6YS6eQwvB0dXow2U3vsN439VKBv2+Hun11R/9Cg2XcZCYTC9IxiV6ZV9iiVaSEAd0
         kdTJj0n+h90gZFodKbLCYb42mfvPPuT7NYAzLohUEl9K9/xmNO7+j4wXC40KtQmuTQ6P
         7grhEINKDFMFQXUshk4a5HC4lpjXTjhCtZM+AICJ/LeqdyKrb0ItO6silac59WyZYFJg
         uHuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyZBUaeVRIg4GBuMvYD/FSqlsQ/asjurfAT6PggS3Z5mdBZOjfbp2r80sn9WciU4A36N9ZOyBxAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YymbOOwheFzQYa78Pw4qp1mY7f3xSAXKJI0F1Iai+zhkww3/B0w
	Di0OM2hliIflR4IPMTWLWsQsOMKTE/HHBi0YXigtl1GNyWdo77l65w2S9YVhml5Cze2JshE8iQr
	rk8FgsGkY1nGvlJDvPYOQlWDO4UM5XhlBiVDbGex2ZHV6Oz1mhDOh
X-Gm-Gg: AY/fxX64prWJPEsnZWK+xl5wf/XPVGlZ3CQZOZUPLES/vyCMXNVRZzL1k2rFX46PkIB
	dpRwovWCQSReuEiMiuGBPE37eDK6xn6+xyr3IwlBOvAz1QUzGdbxHAdaj/zZIQ0OeCT6JiO1Axa
	6UCLGPGnTcoc0xFvU5ONBkLboW4IGfBEcJGMsb5zdI9t5RWB10WTQdpYdi1g1hycUcxjcNwiM+R
	Vf5JGqKg5RnuROAIgblvQPtFPIXUd0wm5qJ+6R3Bx6l4itgi4RIiW4ixwtxeWMJXCgZXoPAfaf0
	IjZvTCc/wm92zK5yEmIViD1D6NSW0YH1gRCrgeSDqdhIyvSb3vDOeh5SswtBBUmhHHWXHNGiG/P
	+EhEfLRcJskoRsmMgEqjrMFiWv2k=
X-Google-Smtp-Source: AGHT+IEGuk3sz77FXrQmCpSJFrQkto4AKlscE81EjDJnI5PpcY4ooIEl2sS/zT/JoK6BwdRaXQJ+J4oVa0Ls
X-Received: by 2002:a17:903:11d0:b0:297:e67f:cd5 with SMTP id d9443c01a7336-29f23ca7d97mr83328505ad.7.1765829427722;
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a0a4a6163fsm11123395ad.38.2025.12.15.12.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 45722341FDC;
	Mon, 15 Dec 2025 13:10:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 4040EE41D23; Mon, 15 Dec 2025 13:10:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v5 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
Date: Mon, 15 Dec 2025 13:09:07 -0700
Message-ID: <20251215200909.3505001-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
References: <20251215200909.3505001-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the io_ring_submit_lock() helper in io_iopoll_req_issued() instead
of open-coding the logic. io_ring_submit_unlock() can't be used for the
unlock, though, due to the extra logic before releasing the mutex.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6d6fe5bdebda..40582121c6a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1670,15 +1670,13 @@ void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
  * accessing the kiocb cookie.
  */
 static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	const bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(needs_lock))
-		mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
@@ -1701,11 +1699,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	if (READ_ONCE(req->iopoll_completed))
 		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
 	else
 		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
-	if (unlikely(needs_lock)) {
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		/*
 		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
 		 * in sq thread task context or in io worker task context. If
 		 * current task context is sq thread, we don't need to check
 		 * whether should wake up sq thread.
-- 
2.45.2



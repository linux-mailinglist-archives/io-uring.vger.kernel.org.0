Return-Path: <io-uring+bounces-5833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D01A0AA2A
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 15:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8397165FAB
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 14:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C5D1B87CF;
	Sun, 12 Jan 2025 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csacxSfm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1608918CBFE;
	Sun, 12 Jan 2025 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736692958; cv=none; b=pey3jpRU9Arm1DRXFPRC3taKf6QWOUQvQGfSAzHr3zGGNy1A4D5/HjV9rC4PKFnLedrECfAN/Nm7R+6BZwnSOAM5Y+zrLLOnagNwJp8YBjjGP18VcxL4hZcnBnfdV/ui+RpVLcFFsLRNcm00V/+V99o+afPj/gk8hCw5yzE/FyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736692958; c=relaxed/simple;
	bh=fSKMELjhIpSJkxRIhRJ45HNeAgaojk93QnHjFE92hiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hYgpVMCLHxstlic6L+QN1NX2Yzok4Z5kl6ho5ETrnF73DRa7CjpwF6vuf45RTM4ECJfSq1jtrC0waMuCbGhYckGnZ8Hc6U+NK2z0V+ZwpAXiEAorYoHCrf+1GwQXhNDrYjIOkMAS7QTVipYEG4L8ep4wUF8cHqjOm2jZd/nCbgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csacxSfm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21628b3fe7dso57108605ad.3;
        Sun, 12 Jan 2025 06:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736692956; x=1737297756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OYve8cC6ukCUO1qum52TOupRw7fl5U7nPi4WFHUX+OM=;
        b=csacxSfmM+AXDEdjFlGrNMSMHwM3SjNy0N75JRA6vK3eEDeXq9VwOD83f2z368bTsj
         gS9rxm797fvKvBI5/VN3CbaGNLksvi+OywmcP3LbyFQ+DGSgfJFkhyMb+AuJ/G3Irmox
         ylpI5NXAkjfxp3AlFT0+jB3n7XPwI8XlWotPb9kUSGi72dN9v8PqoWb0xfQPTB6BRp/x
         EXtdmH5KaYALtQQgceuG/yM4147dNFWyk9UNATC9IAqy9TJ2FIe2VfbRtGucSAvLpEDI
         mf8fRXhq3kOOkPDd6SryuiJyKpPsynA5l6obhFfsjTi6TvASBmA8d5oINLzjZy3G38B1
         Vbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736692956; x=1737297756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYve8cC6ukCUO1qum52TOupRw7fl5U7nPi4WFHUX+OM=;
        b=LY7GCMffWKY7z3BN0Ilw8h/27AXJin/urVPyUedkoR7jF4/rIQcNGVf5Dzah3AC5sw
         KmPGJhOQIeDSP/d0tKsh4M9oh+zjhWObDAUaj6jfm+MpJMhJ01yGZMyCx9H6nWcsYnh8
         vGQW7MJGdle2EveC89Q1akwHB/H5fZOGk6yP9LF7E+ArqOwjkZEjpeBofajui5FyJih2
         mjFyN3/mXRwrl4UZJ3fU/Nze/Ij3WwvBL8WoNGGCVtBuEbMbcG40+aBqy9HxmjZeeFav
         +jg8nvslBNDmHOJ73/V3ATuBwLcmYpEu86ROICSLJsvzhg4W+e2usoq5HYE9U34F4EM+
         vLJg==
X-Forwarded-Encrypted: i=1; AJvYcCV78KXT7AKNs9PVMBluDYOaJe3gvifFpIbsemzQbJGjvfOCmp0twCszziDj9nwZ3ZkG7vThzfGbtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeRXhsFmRYUWR5sTf3YBHe/YR8NbdHgVFuGae3AnAYbG7Pmx/N
	4/Xzl7zbJrfX7Y3jfsDSjVF1dN/j8Wkn/8wQwWcT7TvwCimg2Yxo/DvlSA==
X-Gm-Gg: ASbGncs7aZdzavupr0d0v12vnuBoalrA71nAsWaNItApH9UJT0cnf23vlWWiX+4rSBl
	dhBF8loeLTlzUsghgFD2a69DC3gYyZ43ilNVZCcd3HRRx/gw9Tu9jjZjfjaYWG599hvLWV5amGT
	xx4JxrvLdm1dF0m+tb2RW41sI3dMQZyB0xWFS92PER4T4Gb4lB/e8mgTGpjg7QfketZL3EAMhdy
	puyx2eoTuJUvkbJ+chTQeQxZHZw5qdGQVm0iy0QqsZN7ZU4k9Qpno7bAgs8
X-Google-Smtp-Source: AGHT+IHXaUQhOp8IoKtYWE2XDHJakRUYXW+TnOfQgT2q5tkU5LggzUuE4oZKWPGDNf6D5zk+TcTvdA==
X-Received: by 2002:a05:6a00:9294:b0:725:cfa3:bc76 with SMTP id d2e1a72fcca58-72d21f115b4mr27438802b3a.4.1736692955858;
        Sun, 12 Jan 2025 06:42:35 -0800 (PST)
Received: from local.. ([2001:ee0:4f4c:d5a0:89d7:a19f:c7e1:d3e9])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-72d40680e67sm4507030b3a.139.2025.01.12.06.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 06:42:35 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
	Li Zetao <lizetao1@huawei.com>
Subject: [PATCH] io_uring: simplify the SQPOLL thread check when cancelling requests
Date: Sun, 12 Jan 2025 21:33:58 +0700
Message-ID: <20250112143358.49671-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In io_uring_try_cancel_requests, we check whether sq_data->thread ==
current to determine if the function is called by the SQPOLL thread to do
iopoll when IORING_SETUP_SQPOLL is set. This check can race with the SQPOLL
thread termination.

io_uring_cancel_generic is used in 2 places: io_uring_cancel_generic and
io_ring_exit_work. In io_uring_cancel_generic, we have the information
whether the current is SQPOLL thread already. In io_ring_exit_work, in case
the SQPOLL thread reaches this path, we don't need to iopoll and leave that
for io_uring_cancel_generic to handle.

So to avoid the racy check, this commit adds a boolean flag to
io_uring_try_cancel_requests to determine if we need to do iopoll inside
the function and only sets this flag in io_uring_cancel_generic when the
current is SQPOLL thread.

Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
Reported-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/io_uring.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff691f37462c..f28ea1254143 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -143,7 +143,8 @@ struct io_defer_entry {
 
 static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct io_uring_task *tctx,
-					 bool cancel_all);
+					 bool cancel_all,
+					 bool force_iopoll);
 
 static void io_queue_sqe(struct io_kiocb *req);
 
@@ -2898,7 +2899,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
 
-		while (io_uring_try_cancel_requests(ctx, NULL, true))
+		/*
+		 * Even if SQPOLL thread reaches this path, don't force
+		 * iopoll here, let the io_uring_cancel_generic handle
+		 * it.
+		 */
+		while (io_uring_try_cancel_requests(ctx, NULL, true, false))
 			cond_resched();
 
 		if (ctx->sq_data) {
@@ -3066,7 +3072,8 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct io_uring_task *tctx,
-						bool cancel_all)
+						bool cancel_all,
+						bool force_iopoll)
 {
 	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
 	enum io_wq_cancel cret;
@@ -3096,7 +3103,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 	/* SQPOLL thread does its own polling */
 	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-	    (ctx->sq_data && ctx->sq_data->thread == current)) {
+	    force_iopoll) {
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
@@ -3169,13 +3176,15 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 					continue;
 				loop |= io_uring_try_cancel_requests(node->ctx,
 							current->io_uring,
-							cancel_all);
+							cancel_all,
+							false);
 			}
 		} else {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				loop |= io_uring_try_cancel_requests(ctx,
 								     current->io_uring,
-								     cancel_all);
+								     cancel_all,
+								     true);
 		}
 
 		if (loop) {
-- 
2.43.0



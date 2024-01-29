Return-Path: <io-uring+bounces-496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C3C841459
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 21:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 844681F2559B
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 20:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26091DFF8;
	Mon, 29 Jan 2024 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="J9IUmv5y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4812B86
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706560234; cv=none; b=CIx2xqqimlMFGuQbjqWGG9IecYm88Ck2MEpPKhAZ9AmDiKjJliNzYIQQnD8nD9+bMenbKHqNHY2iUg898IIG4Ec2EwF23pvJBIYk8nlt5WoAUMwPRWUthjtrEp4vbSb9zbzvsm5UGrzY6udiJzng+KwY65HKSqnNRkqolNmRKH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706560234; c=relaxed/simple;
	bh=pR97qf/01SSuJ9StJBQqDjHNrvMuF05pBDnaNBcL02U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDpMmtIql12f74wkxogq/iGLan+DLt/y2d1BqYZD05FaHrt9cb5zKbug2gpI+1aBmKme/thMuPvC8k2pyt/ohXpSErrgSHLGBa8K645HXuoqBxg/nIMa8AR46D/vZ7pYsa1kKc7ajUIqPYCj45iGVTBg1TMM7TMaFD5rfnVOV2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=J9IUmv5y; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso42978439f.0
        for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 12:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706560229; x=1707165029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ux8x8eUe7gD1jQ5pGHo2InXRKpLdO69yR0/M6Q9qck=;
        b=J9IUmv5y6a5J+J0ZHkeCVSeDbvTTPJKY3wG+y/GpXdLrQq/sYWJnF2zPTGhPwBgBYq
         Zg4YhVvnlnLFp1b6Gy8cR0d2QoUBT3G7BnIX1WqADUTtXv9h4ovybYVEyEPJJ7/aO/e5
         IICvLY7lZuk1FrFhk+y/v9KeDD1SvwTKKCpeFn5tDAzktRIbZoNXJoZVwjTImRP6/45u
         hhBLYxWWmKVhOWGqB1wlhHIedqckKJO7B8O6E4fKVIBQLLc4Jr1+mYw1uuxqyDe72Yd5
         VsENIKKhkuAUzmBlVPHMqITciBDp+013AnTuS7XUUen9tOFqjyCzqKKdMI6hlG7HuTj1
         +/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706560229; x=1707165029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ux8x8eUe7gD1jQ5pGHo2InXRKpLdO69yR0/M6Q9qck=;
        b=TstmTkx2BUOzJbrIgzU4D1wAQYfc1lcFXkq4wcBhNqXiUXpbImidyyTtNCiWTDsJFo
         f49O7ZxVmaPFj2sjX1LOGnHLIh4RsZFqGtLHlq4iQkjR2S5wk77voGzd1W6Hg3XC1f65
         AvV/3Df49f/I9asaH9TNL4i6WHh8/hyhT3Gci9Hc6pjLxLXZlKf9GBQ05v9ffmWIHut5
         DFu33Qko1/0C9oLD9WfgFwEtTMHXxA3XPkBhkLdtokgQFUUUWqnvae5CFfET62Yv/b4k
         OJlqm1aK5M2Mg4ocVyu/lXvKQhF2O6Wee/rPzz3/bz712mCRxj0U8vgE/+vKq2rdtZaU
         BxUA==
X-Gm-Message-State: AOJu0YxgnhSlFaLPktviTDap5afI3cEOSqqBYzC1DsibsiDn33+JRLVx
	hI3w19hzD9NSTst17nPhgdqVc9djBm94zrXpaCBK9a6Ss2R00VKnIzZNBRZ0BU7oD03jk4VYYt9
	K1Gw=
X-Google-Smtp-Source: AGHT+IEiFJbTediERcLa3Q9EYApjHSJX2Rq1NXSiJa430u1iLG+hWypjhRk66EeYyl2IRjgyE6Zl0A==
X-Received: by 2002:a5e:870b:0:b0:7bf:b18e:fccc with SMTP id y11-20020a5e870b000000b007bfb18efcccmr7692849ioj.1.1706560229514;
        Mon, 29 Jan 2024 12:30:29 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i8-20020a05663815c800b0046e6a6482d2sm1952510jat.97.2024.01.29.12.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:30:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/poll: move poll execution helpers higher up
Date: Mon, 29 Jan 2024 13:23:44 -0700
Message-ID: <20240129203025.3214152-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129203025.3214152-1-axboe@kernel.dk>
References: <20240129203025.3214152-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for calling __io_poll_execute() higher up, move the
functions to avoid forward declarations.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index d59b74a99d4e..785a5b191003 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,26 @@ enum {
 	IOU_POLL_REISSUE = 3,
 };
 
+static void __io_poll_execute(struct io_kiocb *req, int mask)
+{
+	unsigned flags = 0;
+
+	io_req_set_res(req, mask, 0);
+	req->io_task_work.func = io_poll_task_func;
+
+	trace_io_uring_task_add(req, mask);
+
+	if (!(req->flags & REQ_F_POLL_NO_LAZY))
+		flags = IOU_F_TWQ_LAZY_WAKE;
+	__io_req_task_work_add(req, flags);
+}
+
+static inline void io_poll_execute(struct io_kiocb *req, int res)
+{
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, res);
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -364,26 +384,6 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 	}
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
-{
-	unsigned flags = 0;
-
-	io_req_set_res(req, mask, 0);
-	req->io_task_work.func = io_poll_task_func;
-
-	trace_io_uring_task_add(req, mask);
-
-	if (!(req->flags & REQ_F_POLL_NO_LAZY))
-		flags = IOU_F_TWQ_LAZY_WAKE;
-	__io_req_task_work_add(req, flags);
-}
-
-static inline void io_poll_execute(struct io_kiocb *req, int res)
-{
-	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res);
-}
-
 static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);
-- 
2.43.0



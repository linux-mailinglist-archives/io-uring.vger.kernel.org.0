Return-Path: <io-uring+bounces-5643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 659759FEBEA
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 01:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B431161E33
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 00:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6E463B9;
	Tue, 31 Dec 2024 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rmoSpLS9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0F4C7D
	for <io-uring@vger.kernel.org>; Tue, 31 Dec 2024 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605421; cv=none; b=GSRZYdr1srKuGI9ZWl0mMY3wOiguz5YQQUjpfWDehjsDTLBk/IxLZzj4HqPnhkPw1pLApy8MiaFXo8fy2QOMF8z9ETuJ6gkA9Car/aClH20VHLOhIrIhCLuB7HHEGv91AP19reBus/pD2Psmw7AYb5y7sNa5Ux0oAmB4Ij7LUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605421; c=relaxed/simple;
	bh=cyCduOb9ngrKe9+KdZwEeOeCKexwhaUDrW/2RrVhCWk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bcY/sxMn2GdIndop+r2D7z2RIWHMk1QCkn1dgxHuYlZqGOecHuzu8W8gRWK7rVRW064qRkTb1IMfUZyfwu7vUZ8J0qYkXpiEK30G4H2ROK2JR0L47ynU+UbvW6HetbmShAbjUvtcWOmRBzx3vo8yNP00kApopRrt6HCD5C782v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rmoSpLS9; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21631789fcdso95668745ad.1
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 16:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735605417; x=1736210217; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbOp4xLCRlIScCU4lvZTyaQmOeBQZsF/0po/FyPlVUo=;
        b=rmoSpLS9j57LtxpBIhgpe3aqTjC+Sy9WDwjz5X+Uqyoj0zQSqtbFf74wJn2Rl0ICI9
         5IRYtzj1Zv6IWSXbCq7fmZu0nqamSGCjuXaJGXnLLuei4FrxIZtTeoVFVq0WTm29wwGt
         EWGqU5i6GVqKwGJHB88TZB9uanmbh4r6SHMsz4Q5+tALo4rSLm1jXCPYHDSBz8JveC4D
         tr3ji1b2wQ9aHklDiVZ+GFXVdPBBtG6+X2agS36N6YbI+yuzeawkCspUT9VOsgnu1wMt
         n08I98QkVzhVcQi+IttTzFfj8Km0bpw8qvq7gy1VGQsH0o6dJtICCW547/WTdamg7SqG
         WMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735605417; x=1736210217;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cbOp4xLCRlIScCU4lvZTyaQmOeBQZsF/0po/FyPlVUo=;
        b=XRC3Lu0atay6oYiJjovpkjnrRcLksnCFZLTmqJBSE00uM00NBfs93cHBJseMMsuQ2m
         evAXIqeZ3xzlttpDf5e5F2J5ij/RUVkhEnpDuGTqWDi2tTePKF6yGIGfTBLSqG8eC4WF
         I8Qtfln5rgSNfsccCCobDWDsYHoSXuhf2wvHwvb/dbzBf55QcYuydMMV91FSZaKO87F1
         0i33mm2lIkSumskD1zFIzeUeIUNFedaoj7mpYjppu2GCdBDk5gTzSso1OXxezrltlErE
         zXjcrm8rQNbUTrLGzZQk9x5KGkcv1EHpDt2lADRROaaORd92LnxozyUzJiXJ5w+2gVcy
         XJzQ==
X-Gm-Message-State: AOJu0Yx2Ptkj7qo6BgX3foXPX3qzAivfGWSOYWOObYvKWSiMVhODZhSO
	2bkTVoQT3yXSTVwCsL1C/H0Fbj5BHrYI83fGrBIMlhzkCKUa2om0X6MYbmmzASEOxSd6/T+fsvK
	C
X-Gm-Gg: ASbGncuurjXcQlPF3G3ORl6nyEadzIS+pdTdBPMtw4ZqSxKNgFvGG3VwGra+WiaTx7c
	feqDEyUI8atoGN5AAY1SjXLTD65MS7ki3VKytWcX8dDqGWrOGtL1ajzlOpVsMvWVdu3twSWJnhp
	6woQf3pQOFiuFCb8/bFOLtFVL1RBjtsZS2to6THyEvR23kTI4i4Tc7ikRwzpBCfvOMDl6pKBvCu
	7VM6hyNqq1aMHJue+sfRRL4uAnBM0vENXqL6zqD8Vihs2/HY570oA==
X-Google-Smtp-Source: AGHT+IEL6f7ej0rQuqZaeHaYxD5wpDorInVus7EpcoWfo6KPUFvoLuMIV54T6WAv+A3AqEB1GJHJMA==
X-Received: by 2002:a05:6a00:858b:b0:725:f359:4641 with SMTP id d2e1a72fcca58-72abdab904fmr58263703b3a.1.1735605417332;
        Mon, 30 Dec 2024 16:36:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbc01sm20413113b3a.125.2024.12.30.16.36.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 16:36:56 -0800 (PST)
Message-ID: <c1596f5f-405b-4370-997d-f42c8303c58c@kernel.dk>
Date: Mon, 30 Dec 2024 17:36:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: ensure io_queue_deferred() is out-of-line
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is not the hot path, it's a slow path. Yet the locking for it is
in the hot path, and __cold does not prevent it from being inlined.

Move the locking to the function itself, and mark it noinline as well
to avoid it polluting the icache of the hot path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 42d4cc5da73b..db198bd435b5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -550,8 +550,9 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
-static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -562,6 +563,7 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 		io_req_task_queue(de->req);
 		kfree(de);
 	}
+	spin_unlock(&ctx->completion_lock);
 }
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -570,11 +572,8 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_poll_wq_wake(ctx);
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
-	if (ctx->drain_active) {
-		spin_lock(&ctx->completion_lock);
+	if (ctx->drain_active)
 		io_queue_deferred(ctx);
-		spin_unlock(&ctx->completion_lock);
-	}
 	if (ctx->has_evfd)
 		io_eventfd_flush_signal(ctx);
 }

-- 
Jens Axboe



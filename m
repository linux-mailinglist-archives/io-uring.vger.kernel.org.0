Return-Path: <io-uring+bounces-10804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD6AC877B1
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B3B0354406
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 23:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CE82F3608;
	Tue, 25 Nov 2025 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KZscNG0l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0CA2F25E0
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113984; cv=none; b=Hf8vryn4Zhl2SZxWYRraaQNBptkDrBja4+ssMIx/xF7j70kC/mHq5UnJ2jn+QCIBttFdVKp+blAXWl7VICErP841fxIDgXq+w8wuROszyfZa1fdNKrvDRvdcQvGEvAQ2TsgJbaIsijo/WA6PcuQbkzni82MRvSrCXY/kWvoVPJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113984; c=relaxed/simple;
	bh=mgPhKwAnmtPP9Wj/BsLLAsVvewiMBMYtCRp0h5FCiVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpyRKoIJWfKX4TT+NG1jEN/oXj1Oqbm2HudDGibJi4ibwwGKXAzjuSGF+woqSrpAreprO9bqhspZ6COnRSHIFl3oU/5wv32QAciMQ9fJH3GQ1LS9rTU8wxUahj9mEY/eegsY6FygdkTA0GBbjU3Y7b+VEQjtklzcCsfUe4kUSEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KZscNG0l; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-43324dd107cso2559075ab.0
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 15:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764113981; x=1764718781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFHAjnVVu+TK64nKRWtxECUF1AnC7SKDeYJZioBUuxI=;
        b=KZscNG0lYtIfBR6CMm/GV4sJy2rcQKMKcUCixG00wSN7no6vLAHLkeMkxtuEQP8UAE
         afD1W5dU8oKmdep0bBnQRNp6dGMvoHOP8KMxiQRuIe0Da4MQ1+cpZQGy6zL1VwWSaEL9
         Sz1RUpTkcT3ClUWKy/wPla5P+Lrjh9NikfMz6ctwpwQ18TcSX7YdgYZ5onEpdV74btDx
         wRXfThDp2dhcd5fj3wuVr2ohcBb0A1iELWds3CwwYerEjC3z12D/kBuaS8qanpL+MtaV
         nP1WnhvkjgkyC0gRFXwps/RrJZf6hceXUYOAj647++coQ0ZLGL7xPDFzkgGupMthSVc4
         6YZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113981; x=1764718781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KFHAjnVVu+TK64nKRWtxECUF1AnC7SKDeYJZioBUuxI=;
        b=cMtvma3B79xJG37aR6ReYdKbjeT/0Z9YAj/Rj/Z01oYz5ie9wIZP1aus/ZqVkm1Gr1
         65SzwUWV/uiCaDZ1nP2uJ1dSelcKXykI8CrPsFKTKiWlryVX4v0Vtb6i6wbgns9hRXli
         VYxXZR1GlK8zTYo/WuyOfkdsIPEVcxlZ9/5fWu4Ol/Dzf3w+hu57brqK0vLkRgk5QuP9
         z9O6QXsPxU9Ed51gQn+NSY/M+wKMMx+DDk968dvwMtZ4pkj2kj3M36gEZCWtZw6O4OnS
         Ha0wP8QVYAzGNwnwNCcAwSgreqp2UcuQv+1Ba0mzE5j6DtILmoUWu+Occivo8l9MdSkv
         +ClQ==
X-Gm-Message-State: AOJu0YwiyyhH3Q0MJbl3WNWgQjb/Y6EgqixdSnprhOMHCwQPrsy020NY
	hazAzguSEX+60cV0ShM7IDJJJV4d+45rLdtSoaqj/USWNEfPGLJcgPiUB3r44bFPX+nah5f4yn+
	XoWhZnaKniu6miw4JsDk3qHgZWTd7fsXZNQE2HxwVrz6vzDdxOJCz
X-Gm-Gg: ASbGncvMOlk+WRJuSSqYwuhBvO6nzD8Pp4mpIJLBl5FEDbcLvH3mwLZ5xywXC9oUibL
	TSzBHlQwDvuIJFvIX/BgzeYqLXan1+Aflt0v1qXog7/Bfnq1aKLHBrqBO/KEay02PB2sSrlHdwT
	soqvhkSLYhT82pgVkZh1kWk6GLI1tfoX/FLIw3HUQBSEHp1Ucr7K2JIwG2HayPw/fMWNdq4rhnC
	CwBbXZenFFCulC/fCjXVCfccxw0a79uONLmzxbbOALSZFG57M7AaWTvOe/q2KSSXt2kp68zUjPy
	h1bZA5wHf/ywbhCVWY7u1yeE8BAC0tmvtIPhlpJsx8EPDKN7sWzC67vyjcHJub+XyZV9uFGO7Cq
	pCw8T2eKlatrvahmEOu3bKrIFG3s=
X-Google-Smtp-Source: AGHT+IH/tX/rq3Q2X3Eh+XOimgjJ0hdijdnwQpq75jxvf3kyffpFKnT9Ejd21O5fcbveGv5SUPSnmPLKoauH
X-Received: by 2002:a05:6e02:188e:b0:433:2fe2:9d41 with SMTP id e9e14a558f8ab-435bc9beca3mr60278395ab.7.1764113980755;
        Tue, 25 Nov 2025 15:39:40 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-435a90afcc0sm17207965ab.23.2025.11.25.15.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:39:40 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 0E9C33400AF;
	Tue, 25 Nov 2025 16:39:40 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 0AEAFE42207; Tue, 25 Nov 2025 16:39:40 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 2/4] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
Date: Tue, 25 Nov 2025 16:39:26 -0700
Message-ID: <20251125233928.3962947-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251125233928.3962947-1-csander@purestorage.com>
References: <20251125233928.3962947-1-csander@purestorage.com>
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
index 05a1ac457581..d7aaa6e4bfe4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1668,15 +1668,13 @@ void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
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
@@ -1699,11 +1697,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
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



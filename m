Return-Path: <io-uring+bounces-7913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28472AAF929
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B95A7BB116
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E927D221FCE;
	Thu,  8 May 2025 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4TCovUL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B08223701
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705084; cv=none; b=cwDg1ym6zUW2qD2pzR4KEHVt4euykQKNUmzNmIzjJG757Grpd3qef/Z7tKN2kDP5pWynW3PZkfmhVJtK1GcTHZbgQ8n2+j+PcQZSPKBAngFiMGV7BLiNUL1fwX91kbZBYfOfkVVeNyqulnYIhNF3PRXQC9iohBPTINqcshLO838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705084; c=relaxed/simple;
	bh=PghnhBBeeDISq3emVxBT11jqZCkxaHnD2RmWONq8SHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPIvLftA8I2BvWAHklQB6576YsjHL23JQcfSo1yc0dTTMc9nQlzANQddv10o2Yg1J4Hr7lzi66xZ3JvLUnZRm3g6Saua8tJQ0Sc8nRfZNf7vq11lHjtFXQM09FaOXvEAeYPY7iHMQWi8iS8y1zz/yEbvioz4KLlwRuJ34Mg6m0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4TCovUL; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac2bdea5a38so128397066b.0
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705081; x=1747309881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfwdzqkeGkTKBy5faYVxYTQW9yRlSedUUM9vB6B4sjo=;
        b=C4TCovUL3NJPJkS8jPMTh1Cp4sbjICd0b/0uVDYTrunZVRt7smSq0ofgNAgFMoV6pH
         xhkgu/hR/H371JD7QdF6/iiX6zfUK33C6Iicz7vY72IYPBZoKSNn66jAAHaON+HnkKMG
         rVStva478ZMggZnTkNpuJb1JFHomZpldVQygcANNut/PhALg6nnDllkMI9Fogj6wIkR8
         wAOX3sjopJUQ1XreP8OkLhVZq1kVkrSSYqJc3kT/knEVGzOaS5BBeet9xWgGUEMxiQ3n
         MdZl6Rh80cYsJEXB048Yg/dcaqWewaAYucnX6k+wzw1pqMqY1apHktkwa0R8d7YIdVqo
         m7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705081; x=1747309881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zfwdzqkeGkTKBy5faYVxYTQW9yRlSedUUM9vB6B4sjo=;
        b=kiuTrADKbAht4qWCZ7Q/oG+NmsWyzlZsLqdTSk2Z2cQL/a4nGvJaJ5prce/N8tW02p
         EJrVMl/tS9bxuxOA4K0wZmCApUCEqbNJQ0Yk5eCteIGgASZipqStsg4c4OIF8A7rcgGI
         zdNWvzfaViYhGhUhOvYdfXRsmqb/sw1Y9q/5kettoiQG/eBacR7WVVcpZswZ0uocNHTd
         3I8vONtKS5QmzMu6zTg2lHden7fXDdVJtp8Uxn4Hpox4vBjQFokp2GTzop4X3ZcaPAwo
         K6+jpsLUfLB1iYrBtyo7sV+VqunRNUIOpOnBL0ImHMfEVXsxDoTaWLDCLg9vY4SDnYCT
         S3hw==
X-Gm-Message-State: AOJu0YwbAr87m4MrgdlUjVhvr9qTKh+Ha6xpFx/Qn9P6pPafuGqzz0sQ
	pce0XHbCAvQdmX3YvCnNk9VLIrPOh5WtIVuMvohptBvIIY+4AhiSB+GNEQ==
X-Gm-Gg: ASbGncvhu/e5I0bcIonLbf0KklAtmV1M1Opt0XriBGEo8yGts782PQFuWjjmr5RzdG5
	ESTFf5d/OZCa5dIaX+lYcXZ6wFtwi2+yGpywr4UkZN8M2k8q7qLDddJIvS5ftz1BgMWhrihDPly
	xawGYDT+kPWC+ayK8Tswf+OGQscC5IeHJ9K5klYUh4i8Qhkia6ntkTB+T/RtaT27e+bUVTGhakc
	9U/jD5T+krvJEU7ZqP7LELmFbkCB/sb4Qi58QuiXxcQH6tklRyghsuEWudGMC7pBQSeSyqY+lKf
	/ULWCHypp8BtXdfjDA30FBKv
X-Google-Smtp-Source: AGHT+IH+SPZs5nN9sHyxaXFq5+puvxaMzzAmCMe3puI8zifUs5X6AdhTFRqHDOV6DG2JwOUxhj8Bqg==
X-Received: by 2002:a17:907:9806:b0:ace:c2d4:bf85 with SMTP id a640c23a62f3a-ad1fe9a0611mr279533466b.43.1746705080489;
        Thu, 08 May 2025 04:51:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring: consolidate drain seq checking
Date: Thu,  8 May 2025 12:52:24 +0100
Message-ID: <4fab0c9fc5e785d7c49db39c464455b46aa35872.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746702098.git.asml.silence@gmail.com>
References: <cover.1746702098.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We check sequences when queuing drained requests as well when flushing
them. Instead, always queue and immediately try to flush, so that all
seq handling can be kept contained in the flushing code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 72ae350f4f8b..e50c153d8edc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -559,9 +559,9 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+
+static __cold noinline void __io_queue_deferred(struct io_ring_ctx *ctx)
 {
-	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -572,7 +572,12 @@ static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 		io_req_task_queue(de->req);
 		kfree(de);
 	}
-	spin_unlock(&ctx->completion_lock);
+}
+
+static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+{
+	guard(spinlock)(&ctx->completion_lock);
+	__io_queue_deferred(ctx);
 }
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -1657,29 +1662,24 @@ static __cold void io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
-	u32 seq = io_get_sequence(req);
 
-	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
 
-	spin_lock(&ctx->completion_lock);
-	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
-		spin_unlock(&ctx->completion_lock);
-		kfree(de);
-		ctx->drain_active = false;
-		io_req_task_queue(req);
-		return;
-	}
-
+	io_prep_async_link(req);
 	trace_io_uring_defer(req);
 	de->req = req;
-	de->seq = seq;
-	list_add_tail(&de->list, &ctx->defer_list);
-	spin_unlock(&ctx->completion_lock);
+	de->seq = io_get_sequence(req);
+
+	scoped_guard(spinlock, &ctx->completion_lock) {
+		list_add_tail(&de->list, &ctx->defer_list);
+		__io_queue_deferred(ctx);
+		if (list_empty(&ctx->defer_list))
+			ctx->drain_active = false;
+	}
 }
 
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
-- 
2.49.0



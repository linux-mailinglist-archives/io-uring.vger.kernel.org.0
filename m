Return-Path: <io-uring+bounces-2402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E1591E2C2
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 16:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB14C1C22D55
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 14:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C69516C873;
	Mon,  1 Jul 2024 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WBo9/DRt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826AA16C86F
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845357; cv=none; b=jPR+tMfRUBNPAxetfOTA9kceVxybHXV9ZCHtvN2CM8G9Tme6CFPs8mNLFWBgK++lHudVk2zlT2Zute6zejv9CUMaCOpOm9vmxuZMjYvqCcosZcrmcZ6/2SbqkuJWOIcWToueCfFMRTHa9NnnqFtJp3E9RIgQrg0fcCD+CzxdGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845357; c=relaxed/simple;
	bh=FDzMrJbc6UyLRX1xmxMmLXXYPW2Sy6/WdbgdZvz0xUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BflkOBAjJOYLsNP1zOOVfY50Cgqlmf6t3lRjDzuCC2oA8/VpiQ2uoe3U0Jz+uYNnSYM1+lQwhSCCIZJCNgRc7EPAzOMIBbfVV5yZq9K03Jj2WTxte1O/oCnaPFOzPA9rWngZQ4j29ktrytRUHSiVcPN9p+pO7KYSl/DWSn+ElHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WBo9/DRt; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5c223f2f97bso58340eaf.0
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 07:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719845353; x=1720450153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwgGxGE4PDogVCpOUjWAJFp8QRDqd2JY4jqYpDU8uIY=;
        b=WBo9/DRt8U1f+rxkN9QGm9xD8n4mase4+NglGg7PXWsoVOOTGqzsS0U1fCVu0JNTy6
         rjRWW1io0gmraAgmazxWsnj/06VCuIgHol9Ht70xqsX+TpDDvom4Rh8srQmFAJ/Fg5C5
         GTM81UK2hp6IuDwpbaBnQ0L9L4VfIWNkLMjrK7L1hLP5nJeOm+KixJ3FlYqZWq9TbPyf
         18OTydtW9qTJmJ7R6dh9xNw97LC/lKxLv/2Oht82skjDiSmnJnQzFQWtEuZICy8bTIgv
         QeDJY7c+Ezhw0yUxkoa8BZxFC+biMAEAXK2uvwkwVTE8d7nBAX4NHW7AwAhgbmIU1xnS
         iOiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719845353; x=1720450153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwgGxGE4PDogVCpOUjWAJFp8QRDqd2JY4jqYpDU8uIY=;
        b=tetZ5s2hSKY5/IonNQVO0Hl8q/MArxfYeIhQizVAHgqPtcPBC1DIfNycOkbn9RxmdE
         3Q1b4mELpvQWeIbgx2Nh4rUtC24rluMO5X9pjk84qj3ReoXfzMYjYOXsf4QJDeZNTFtE
         vOaColtftbrgaRWzGy68tDsrVjlX7LfhcV6zWrDIshe8syPIIm/qiBHjVxmP4+P1HlpS
         NDcmtAdJ1yJpLMVAj8KGlmhLH8VzerA4OvawBz4GhDsoQptJE16pn3gGk/MBdMUZXrJn
         MecQJ6+8WkrMrDXHcG5b9kIU9qw6qVhJqUGizGtvSM96CZf23j72bVsrmItxvZzwBfG2
         WN4Q==
X-Gm-Message-State: AOJu0Yw/cMFCvywypLLY+LGRGyX7GxhaFvexm0S3ksIKrGQms+kbTjMp
	ujI0U3n1viq0AJptV6giSL+5GYWkhuf+8wrHDgzPsdHVZCiM3ezDv2zdO2IcGsUq6NsH4qzI7lv
	THbg=
X-Google-Smtp-Source: AGHT+IE27d1KDf/qfmzRXXD7A7tfn3YJYgnlBp2QHvBs6/fYy/vdcZCKs1aE+nzAiIHbRj4ihfnrjQ==
X-Received: by 2002:a05:6820:34a:b0:5c2:1b26:926e with SMTP id 006d021491bc7-5c438d51301mr5597738eaf.0.1719845352986;
        Mon, 01 Jul 2024 07:49:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c4149396basm1025133eaf.21.2024.07.01.07.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:49:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/msg_ring: check for dead submitter task
Date: Mon,  1 Jul 2024 08:47:59 -0600
Message-ID: <20240701144908.19602-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240701144908.19602-1-axboe@kernel.dk>
References: <20240701144908.19602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The change for improving the handling of the target CQE posting
inadvertently dropped the NULL check for the submitter task on the target
ring, reinstate that.

Fixes: 0617bb500bfa ("io_uring/msg_ring: improve handling of target CQE posting")
Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 47a754e83b49..c2171495098b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -86,16 +86,21 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	percpu_ref_put(&ctx->refs);
 }
 
-static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			       int res, u32 cflags, u64 user_data)
+static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			      int res, u32 cflags, u64 user_data)
 {
+	req->task = READ_ONCE(ctx->submitter_task);
+	if (!req->task) {
+		kmem_cache_free(req_cachep, req);
+		return -EOWNERDEAD;
+	}
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
 	req->ctx = ctx;
-	req->task = READ_ONCE(ctx->submitter_task);
 	req->io_task_work.func = io_msg_tw_complete;
 	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
+	return 0;
 }
 
 static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
@@ -125,8 +130,8 @@ static int io_msg_data_remote(struct io_kiocb *req)
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
-	io_msg_remote_post(target_ctx, target, msg->len, flags, msg->user_data);
-	return 0;
+	return io_msg_remote_post(target_ctx, target, msg->len, flags,
+					msg->user_data);
 }
 
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.43.0



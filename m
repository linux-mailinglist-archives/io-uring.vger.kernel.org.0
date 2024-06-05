Return-Path: <io-uring+bounces-2115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28ABF8FD0ED
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7A4DB2D7C0
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BB11B5AA;
	Wed,  5 Jun 2024 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sRgfyWaG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6414F199A2
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597190; cv=none; b=NXv6KBYtBqqKZNiXv7z/udcwntIYs1nuyuAch2RPS0m1S3ZJvSacmlNBBy+SlnwWTQkc+i6lGQfgMYKpN+VLppXcV6FT/mW173AJBGJ3H/AovjmF1Nww6LT0zX8+DukfOIiz4fAdA5V8m0gtQ/xqJ7LnAsyb+3I+iZ9gdMBqoRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597190; c=relaxed/simple;
	bh=eILMDD2M1md0Mdp9L+ODJ6EXRvVNtT3efZfywN1wms0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdVDtWG8ja/MK9971+K87Gg4oyyuQpk0BB+vqTO3b3hmLrV6bWiDwK0Mp2WENvlC0DuKcgqzdAA2BSwRpcj++JYse3nN3V0blDqx8dVHw12CLn80tWOPpuIdERIBBmrb80NrFlNZ4fRfm9KZU81PmbIj8/r5Rk1Wl3ck/GQbSNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sRgfyWaG; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d1ffc2d76aso234479b6e.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597188; x=1718201988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c76WKEiXpJFnCssoMjw+Z6qRfmEcY3UQINBr/vE+k24=;
        b=sRgfyWaGz/FZ6C9W/b58mohhPnyGRR2sCstpxqniHnao8gxDbAkyDlfmj9KU7fuLrf
         K8plQa/pS3rSDy7scKM4T846q0kDrVwVDj4fmtLjaZ3M3keEcttEL9W6Um/uW9BFmvlN
         gfbEVkRepEscexKzrz2vzybesUmCie8v4mwY1LpHR/9sOZgXmvk3DbxJWA4pRyq0PLsT
         Om15ttMKcWtnUw6D3JRGHEcGPnz4SV2wtVPu29xrEDxTp7kxjGuOdQ0aOg8lxeE2Tizs
         p1tOLMyzINkjsrJBWkovM6vJK3kMvG5xrZ1Zz64CXCJu0a3lr1onIWc88/9iR6qn74u6
         g8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597188; x=1718201988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c76WKEiXpJFnCssoMjw+Z6qRfmEcY3UQINBr/vE+k24=;
        b=ra5akSjtcbaKtRGbJ16Y41/8LVupci6e8pgyJXmV4az8jyTVTvonAjDI5ppKAkqiuS
         fcXT4dA4lDVBRhqIydnZ3LNVdJI6wr0j4/ayuvs2UYl1hVVPuIJZZioFNM0CzwGnnGTM
         K6Gk7cEolSyxG8vEp/vn+ya/a3cF1hjg6DpIzh0cPche+jIN7OePETtH3YyzCKf+2ZIr
         /dZcbpMMLb1JjPp2/MobWldzWDLXJ/iXwOt3391+p/mScQac2jdKjtqGGPU9PknEjwo+
         boyLKKbgS9WzXLnYontoSs/1dNNIX26Zl//dp/EuuNAIp93bGkCV/H/xMjVIDUfFmaR8
         B05A==
X-Gm-Message-State: AOJu0Ywprf5CSEQ6g11FpxSU11dCS1F7saI2jioeDopa9vm0lZT1ICaQ
	3teEVyyT6IP51sk/agCMb2+K+D/n+XeuhiverB9FKgmRi/iDlL0Kc+Ll7YMepZbajufLwcKNflC
	Z
X-Google-Smtp-Source: AGHT+IHlGyJXLrHMvgXlt9jdjXGo6JA0KLFJR56Aly6wiQ85+gN66DWS0nroTJlUIn0ts/bNzbJCRQ==
X-Received: by 2002:a05:6870:9689:b0:250:6be3:3406 with SMTP id 586e51a60fabf-2512207ac4fmr2956894fac.3.1717597187245;
        Wed, 05 Jun 2024 07:19:47 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] io_uring/msg_ring: avoid double indirection task_work for fd passing
Date: Wed,  5 Jun 2024 07:51:13 -0600
Message-ID: <20240605141933.11975-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like what was done for MSG_RING data passing avoiding a double task_work
roundtrip for IORING_SETUP_DEFER_TASKRUN, implement the same model for
fd passing. File descriptor passing is separately locked anyway, so the
only remaining issue is CQE posting, just like it was for data passing.
And for that, we can use the same approach.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 57 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 2b649087fe5c..1ee89bdbbb5b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -71,22 +71,6 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 	return target_ctx->task_complete;
 }
 
-static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
-{
-	struct io_ring_ctx *ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct task_struct *task = READ_ONCE(ctx->submitter_task);
-
-	if (unlikely(!task))
-		return -EOWNERDEAD;
-
-	init_task_work(&msg->tw, func);
-	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
-
-	return IOU_ISSUE_SKIP_COMPLETE;
-}
-
 static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
 {
 	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
@@ -227,17 +211,38 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
-static void io_msg_tw_fd_complete(struct callback_head *head)
+static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
+				 struct io_ring_ctx *target_ctx)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
-	int ret = -EOWNERDEAD;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_overflow_cqe *ocqe = NULL;
+	int ret;
 
-	if (!(current->flags & PF_EXITING))
-		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_queue_tw_complete(req, ret);
+	if (!(msg->flags & IORING_MSG_RING_CQE_SKIP)) {
+		ocqe = io_alloc_overflow(target_ctx);
+		if (!ocqe)
+			return -ENOMEM;
+	}
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
+		kfree(ocqe);
+		return -EAGAIN;
+	}
+
+	ret = __io_fixed_fd_install(target_ctx, msg->src_file, msg->dst_fd);
+	mutex_unlock(&target_ctx->uring_lock);
+
+	if (ret >= 0) {
+		msg->src_file = NULL;
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+		if (ocqe) {
+			spin_lock(&target_ctx->completion_lock);
+			io_msg_add_overflow(msg, target_ctx, ocqe, ret, 0);
+			return 0;
+		}
+	}
+	kfree(ocqe);
+	return ret;
 }
 
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
@@ -262,7 +267,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
+		return io_msg_install_remote(req, issue_flags, target_ctx);
 	return io_msg_install_complete(req, issue_flags);
 }
 
-- 
2.43.0



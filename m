Return-Path: <io-uring+bounces-1355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E37F4894495
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C2D2B21BE1
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79584D59E;
	Mon,  1 Apr 2024 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mukxvEVn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51844DA0F
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994289; cv=none; b=MrAqGBbPJTSDnxgzsArG/gw7HARUVCSUMZft1wyKr+FBVFtvieLg/2DQyv756Q9hiXgue/TOOO3smvN1yAoU/eWVUg1MawjU4K6Vl2ttObtejcwvn2GTXzynHimsnvJ2y2fnhzFI8fOO54BYPjyno8POq2RrRv33rf9I5iXhJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994289; c=relaxed/simple;
	bh=+yy1hOVoA103+Gt61MTSfug2WDHcdLrCwUQT1ysOojk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMzQ2GrRx4/sy0hkgLp7fiad6kPx2nH6wxy7S9EdSdS/vVt5aKjW8txpmVh6WeONEWKw128dj3O897E3N4WCPQDOSnlvZSvCXZbH/d2gacWzI8iGuEeZOfSD6nPPOXZr96lFA4Rg2BjDNJb16iC+UKkY8Xxr0vT4fwd2smo87+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mukxvEVn; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7cc67249181so32161839f.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994286; x=1712599086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1okOPpSEoy3//u3IibMnbSt4+ARwzohEO+aaT3jjxyo=;
        b=mukxvEVnM6ErxxL3KuaKoxbIpP4RIKMIlsLTojli9kNMKda6Gg22iXNFScLQ1VXoLa
         0e8NEC73UAlkMV/gLfJKZgOvhBvZlQnnzX5aHLnuG1rnCBAuFrrxR5SdarTTJn5tHN4l
         JIyt1ZgXRhMpTExyCyt/6IN+dvfzwoIk5AeqfFBStZACFO+C28n8WwuROCXz4GDlh66D
         2zX14QAcM249AAHqPicjDeMyTdP+wGK2NyVYUV2zvX6Bl+y475lFl1LI5GXZaFgG7dtc
         iTrWc4pWxROFbxHAdtEVNHGdFXsCCd09sXO6c14acx0eC4Wc44BeXk9g5bgmcCakho6V
         PXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994286; x=1712599086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1okOPpSEoy3//u3IibMnbSt4+ARwzohEO+aaT3jjxyo=;
        b=uwVt79sLrtrJ/qkxH/iT/Ij4dmGrPzRhiiH8wj75ysYX2vidGFlTfZxzBBMSvC6380
         uCoce1SXoaTFEEcbyYM0j59CYOnwEbu938vsrrDaNh7Y0ya/a5fsMC+8CXcilyh19nW9
         Cw872p+8iHwNVbfKV1Kfhkkkzy55hC4Bj22O9ZVlAhM9HFTKoYWxmlWveUObc4ge3dof
         tyjYNcB9CBVM+UKqYieG5Nwtm2RI76gKyj0r165jc1b0FTyH55fiRHfrs4YsGef7wPcl
         t5AMkVQaLS/w7gg7IrTO8jeFqFJYWwpgBuXmnPAy5qZheiAJrhpWETAQpSzTepujc8Yy
         vKKg==
X-Gm-Message-State: AOJu0Ywfum3PqRj63zJxkGYHiR9L+tf+71Syhrcz735XBP09FjP6EKMx
	swY40xf4tX7PfJBH5EYr21Z7QyJKG4Bz//mttpgINgQvjORC6drXygoj1DRVeiggZ3vJmY/FBoC
	l
X-Google-Smtp-Source: AGHT+IHwKk1MMdmvy6uBJgbJ7X+/3CqR613ZHVEk9fpQsCoaFCRutpdyDj8YLkVDpZy9ctb/XA4+/A==
X-Received: by 2002:a5d:9b1a:0:b0:7d0:8461:7819 with SMTP id y26-20020a5d9b1a000000b007d084617819mr9806402ion.1.1711994286645;
        Mon, 01 Apr 2024 10:58:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ge9-20020a056638680900b0047730da740dsm2685669jab.49.2024.04.01.10.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:58:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/msg_ring: improve handling of target CQE posting
Date: Mon,  1 Apr 2024 11:56:29 -0600
Message-ID: <20240401175757.1054072-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240401175757.1054072-1-axboe@kernel.dk>
References: <20240401175757.1054072-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the exported helper for queueing task_work, rather than rolling our
own.

This improves peak performance of message passing by about 5x in some
basic testing, with 2 threads just sending messages to each other.
Before this change, it was capped at around 700K/sec, with the change
it's at over 4M/sec.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 9023b39fecef..3e1b9158798e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -13,7 +13,6 @@
 #include "filetable.h"
 #include "msg_ring.h"
 
-
 /* All valid masks for MSG_RING */
 #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
 					IORING_MSG_RING_FLAGS_PASS)
@@ -21,7 +20,6 @@
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
-	struct callback_head		tw;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
@@ -73,26 +71,18 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 	return current != target_ctx->submitter_task;
 }
 
-static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
+static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct task_struct *task = READ_ONCE(ctx->submitter_task);
-
-	if (unlikely(!task))
-		return -EOWNERDEAD;
-
-	init_task_work(&msg->tw, func);
-	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
 
+	req->io_task_work.func = func;
+	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static void io_msg_tw_complete(struct callback_head *head)
+static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	int ret = 0;
 
@@ -215,14 +205,12 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
-static void io_msg_tw_fd_complete(struct callback_head *head)
+static void io_msg_tw_fd_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
 	int ret = -EOWNERDEAD;
 
 	if (!(current->flags & PF_EXITING))
-		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
+		ret = __io_msg_install_complete(req);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_queue_tw_complete(req, ret);
-- 
2.43.0



Return-Path: <io-uring+bounces-1065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E98087E14C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66D761C213C5
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD561DFE8;
	Mon, 18 Mar 2024 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeYZIBo/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C061DA58;
	Mon, 18 Mar 2024 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722623; cv=none; b=DJLYl7sSPjvcLpHCeNuP6afnVdz/IeXZrB2ikrX8LeRjrpySVYx21bckpuVa40CSzH7fNV2SkFgflFkk1qAHksNJOEhEfAQ5HDVfQnVeB529/xEYXKbp3nysr9c8Ta7hYSXXjYCFIYeKJOvVKVsnVRJeVe3H+kcb/U3a8VoZLyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722623; c=relaxed/simple;
	bh=T/VCekeEwmZ+62RASLtLVFssRRVNurSPBNec8raRGrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QylSmGAyfqZZEOX47CXeh5lvXrehmqtnH/yLeHyiBddMDYN2iG5+JI8veQGvUoQk63DDCmkE6b0KfuOS/Xjr+dumhEAqqkMcymQVn3EIZ7MY5MG4LDiM3VOXn9iyfGBmFFzt1XSN+vZ/4rMt9SEFZNOCoEb3MlxO8+aTsJ1f8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeYZIBo/; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d49f7e5c2cso15010451fa.2;
        Sun, 17 Mar 2024 17:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722619; x=1711327419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2m+aoIuQvYdyvrDDwOXPH4Abav6/EJ7hVeNVD0XZuQ=;
        b=ZeYZIBo/E7Co25iZrfj9fLLF4S5CqmA8Fz79zDaeCBPinFO/SNGjYNvJkj6dPQ8ioH
         ZvcFQMkiLXTaKmmHK6+owsMWKLclaRcevulEWuziDjjEe6m5FWspytr/KjCOrROd7Yt+
         dmILbUniUJR5vZjThq5fVGd6l7gF/22srDOUlQ1cQZ0uofiFZe1Hq0ub3NCjjoL6Sbjd
         jJB20S4arxKSPZCjuMZxVy/MUBkWAwmv7q5ayzmNWotP6WYNeXvmNXRfJ7ojkvqbAT+w
         LeOMpnFmUbiJNYXBLdjJSIrk2AOEAnFPgV09I6PY6MCZS1Ja22uwmR2jJ17mWSNSjfqF
         XcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722619; x=1711327419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s2m+aoIuQvYdyvrDDwOXPH4Abav6/EJ7hVeNVD0XZuQ=;
        b=lXq7+Qro/dBAazoKxDtgzQvgPrOgAJ+uzplaG9L8DIiP7zAe4Zzg7k5n2zDbAWcAD2
         +HWEOFk8kg69AryY1/ceAvvqrPGEOHsq/dizj5lq9dXCVh9VnleLJfjtiNkyk5CjNAsg
         d15vWPabWhYFoioptv/hWNJ55v0vZjQnkQG1hEF5noOOHxu70I5MPC6yNAgXpVK8EcbS
         /T15GpbPek4kFzXeJWoQIydM8gflQRHH/Mmte+2H5A2fMgia2FLX0CuldYTO3B89HZuX
         Oq7YSvkzViiaba2S9AXAExwF9cWDdYn0xwR1vviLyj2zyYtmC/BA4CB3ujqtJkJyD/i2
         y+zg==
X-Gm-Message-State: AOJu0Yydem/MwEgkDlA1q1lJ0foC3MYV/C+u4UyvwDZbxNZdh/ze0KQG
	ud5GSafw4jxQ9mAF6DKRFatAdOlqV9m839/f78wcAgHKkQasq2xNOogzVRR4
X-Google-Smtp-Source: AGHT+IGehzGNRYp3rih/rwWEnYfCQPZojaX2X86xL3RX2J5HAleJS8jrkmATZdPItFfNMTV9B3mbSg==
X-Received: by 2002:a2e:9001:0:b0:2d4:7455:89f4 with SMTP id h1-20020a2e9001000000b002d4745589f4mr5780291ljg.2.1710722619406;
        Sun, 17 Mar 2024 17:43:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 03/14] io_uring/cmd: make io_uring_cmd_done irq safe
Date: Mon, 18 Mar 2024 00:41:48 +0000
Message-ID: <faeec0d1e7c740a582f51f80626f61c745ed9a52.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_done() is called from the irq context and is considered to
be irq safe, however that's not the case if the driver requires
cancellations because io_uring_cmd_del_cancelable() could try to take
the uring_lock mutex.

Clean up the confusion, by deferring cancellation handling to
locked task_work if we came into io_uring_cmd_done() from iowq
or other IO_URING_F_UNLOCKED path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ec38a8d4836d..9590081feb2d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -14,19 +14,18 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
-static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
+static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
 		return;
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
-	io_ring_submit_lock(ctx, issue_flags);
 	hlist_del(&req->hash_node);
-	io_ring_submit_unlock(ctx, issue_flags);
 }
 
 /*
@@ -44,6 +43,9 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL))
+		return;
+
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
 		io_ring_submit_lock(ctx, issue_flags);
@@ -84,6 +86,15 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 	req->big_cqe.extra2 = extra2;
 }
 
+static void io_req_cmd_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+
+	io_tw_lock(req->ctx, ts);
+	io_uring_cmd_del_cancelable(ioucmd);
+	io_req_task_complete(req, ts);
+}
+
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
@@ -93,8 +104,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
-	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
-
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -107,9 +116,10 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
 		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
 			return;
+		io_uring_cmd_del_cancelable(ioucmd);
 		io_req_complete_defer(req);
 	} else {
-		req->io_task_work.func = io_req_task_complete;
+		req->io_task_work.func = io_req_cmd_task_complete;
 		io_req_task_work_add(req);
 	}
 }
-- 
2.44.0



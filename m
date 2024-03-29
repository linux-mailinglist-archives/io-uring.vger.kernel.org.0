Return-Path: <io-uring+bounces-1335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 149258924F9
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 21:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C07B2285D4E
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 20:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B8C13B596;
	Fri, 29 Mar 2024 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HqVfC0OH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997B13B5A4
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711743172; cv=none; b=VOPGPeGLBvOMikhJaopyexDDRqimgcOixEI3rL3TaT/zw2JHbyiH2KtJ64H1V9mCgY8BZUtwm3EuHv7zvSkcrWSDYfgXqLYsnjfh9A9n6kngd2a71DJ5skPq4kKSpE+q33NL5wAXdGYuDzUKQ9AW8dmV7RWqOV/+SrBcKUwl4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711743172; c=relaxed/simple;
	bh=jKKLFWjxNQWTqThGaOZiBEJeDaQD/usM2iI10hkWvuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7HPGYzX0Jg02uixgKD2JX3UHNN7keZ/qE/+tFg54Z61Y5Fkbv1JLV2sItRcn1XUKTIc/lHjQCU3HjnhQXqXXtUQhmBqQ7agusZPfAj7mEe5XRlOJq9zdUlegDnes+QuvAZkIZ1R82gsy7vs5cmNXrQ1imnCCyUxjqXpKz1uWXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HqVfC0OH; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ea895eaaadso450351b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711743169; x=1712347969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvdXlhGVTrVxzlERO6fNQI/6ve5uCwFdRTdehFJpceA=;
        b=HqVfC0OHZLj8A1SDGFvOvDLcB1NoJc30ZOhx9N4r9k42KiA05DEKMD4jHNp9mdRyKv
         HWafFosf3PSggVPLYSun8wDqKNb8g0dAgY/wZK4k38V6moCvwh3ENdPJBtUPp2DXcT+T
         HkRH0Q0uDfDbTsO2/r2Oc7/I4BvfAPadBMtTZnyZ1YBXk3eABaju+X5R/SlqNR0rv4DZ
         lZ97iAKtk7j0fbVgPh/OC1zKB5Q82+h/nIcNnuI1Rj8cjn0/ZcK1Z4UE212sPc9k0pfG
         afPI+r9c+c/nSkFbMRJMR3My/NLmhcdU+6/9QVDpficcw63VZcb6jaODRPyCfldrLHjX
         d7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711743169; x=1712347969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvdXlhGVTrVxzlERO6fNQI/6ve5uCwFdRTdehFJpceA=;
        b=WtlXYm1dDLGpZBvGRoBLAbv2U+WYYbMzJ050lyJbr+OdsWJBP26U2oFzBeLPBkCXhB
         XY79o8AVTOR45GS9yolBa233PqhdIRZ15XGIs03FaGsssNQvgv3eG2j6YrhhsKsqvqhu
         lDnynVud9YH+rDIERrHfxsrx4+UULF/QQxTtdFeDKLz6eBnPQQ5aY7KzqgocRzZaQ33y
         xSf/PU+xroRvbjTZJg7pJaFdvPeG13DjfMRDdErOPosxgf1p7hqoEDksBZnxnAm8rs26
         QQUPU5R/q+Tqs4gxMZ3t1DEHcU+gg2tlEZwQLcEKmkVilgXj02Xb9j/QLgJE4TC2vXJG
         JuRA==
X-Gm-Message-State: AOJu0YwfUBpG1VY3zhm80XsM9xJxcaetOVKCoWX1iXkBUqpclLzXUcIP
	+vQxPj3Q8PW1TDJqzFTDzKvO/0jVW99gUMHdAF1VP2/Dn9gHkKjs7DvR+NoqTqh9Ei3+05bcmPu
	X
X-Google-Smtp-Source: AGHT+IF+bEWA+HrIruhSaF3VIEGK/y7EqMOtlsp/vD952PaDksDWq/t6znUfTFonB6gccOervgiRUg==
X-Received: by 2002:a05:6a21:a593:b0:1a3:c61f:c2d5 with SMTP id gd19-20020a056a21a59300b001a3c61fc2d5mr3073965pzc.6.1711743169569;
        Fri, 29 Mar 2024 13:12:49 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:40c6])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006ea90941b22sm3388728pfi.40.2024.03.29.13.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:12:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE posting
Date: Fri, 29 Mar 2024 14:09:30 -0600
Message-ID: <20240329201241.874888-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240329201241.874888-1-axboe@kernel.dk>
References: <20240329201241.874888-1-axboe@kernel.dk>
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
 io_uring/msg_ring.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index d1f66a40b4b4..af8a5f2947b7 100644
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
 
@@ -205,10 +195,8 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
-static void io_msg_tw_fd_complete(struct callback_head *head)
+static void io_msg_tw_fd_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
 	int ret = -EOWNERDEAD;
 
 	if (!(current->flags & PF_EXITING))
-- 
2.43.0



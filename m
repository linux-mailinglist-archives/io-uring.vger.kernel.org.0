Return-Path: <io-uring+bounces-1961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E35B58CEC95
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 01:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11FBD1C21520
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 23:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B1784FB3;
	Fri, 24 May 2024 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="isYc021G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B5B8529E
	for <io-uring@vger.kernel.org>; Fri, 24 May 2024 23:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716591914; cv=none; b=Ah3LuQjEllmHV0HlBHGd8ygAHrhZMabhNaR9HLLJxLKlAi1BE7RJ1BBSf95u86e7rAgKHa3wWxBe/cNGAgJEGFIvks6bnyihT7acL51b6ZZ+RZUKz158KDJF5CD61R3gWMJAlyisZSs2yrTKlsaEUEQTsZdnCHCEWdekbD19kis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716591914; c=relaxed/simple;
	bh=U2IGbEXXa16a5LAv/By4sPwNPP5H0PGpeF24X++4DSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwI1NqAfac9lh/1+Z4ymZjtno+09vaiU76Pe8rmnVA9iSkRm5AZhcTZoQIqDsyHaI5N0XuGsmyOibGu+ygttUpicQnKSTZQqPjjk4soc5Tj4sOjuHTuBoZVntJtWdRqo5WkQtP0W5J1hfs9x8FmXWPLeb2AUljyf0Ly7T9v6Hr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=isYc021G; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2bdf439c664so388877a91.3
        for <io-uring@vger.kernel.org>; Fri, 24 May 2024 16:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716591911; x=1717196711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uThJqRi9Hnh0v6X3DkxTRbLlnshZaUAZF244xM8v0NM=;
        b=isYc021GQmsNfxLLHtFYh9/iO88Gd5xx/OXM/aSa/Bl34fmSfXHghvXA1K634IOAXx
         E+qezXwNHrOiH4Z0cOVYMaxX8T/6LnYfQ+x2G50LLCQ6DZN3s4293G+l+n4wHIxtr7Uz
         Mq8f9iFFnCtyJK5+3H/cXByqHhBg4XIEKm/xfLfjlB9znx1k9ZCLR5Xc4COFYcyWDW3r
         y76ObY+LrmRdTVrUTpU73FzpvI6ruUUWZY+GvmSuWuJcmI5G3bO8M0VuFfScBdwciTwR
         DDFX6TjA+fRMDQIPCV7aOS/YFZsqX5XWy0pvZsqos/+o/CQg46O3ZNiI1bx/9nV+EIkH
         fZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716591911; x=1717196711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uThJqRi9Hnh0v6X3DkxTRbLlnshZaUAZF244xM8v0NM=;
        b=La8LwdCqeiaVoc463F0LZlI/+VOG6k3PDVxEZDmnsSeXma/TQ4yhlo4v+WSd87Y7os
         qNCw7cYyfIB6ltS5iVg/zNavN3GC0VgMla9fsWGAjKgc/4uTBa4fAWwH1Oc3ZrgfbGWx
         iErRu1do9lh1Y26MBhXktoJd3hs3YHWJLov0Y5aYCbb3ssBBdIA/au0Jznn2jhtteDkd
         dD5PzoafoGNo/H9AZYg8TbuZc232lld+k/QewV+YLOwjNry5YuThadNBXGikbBMXww3a
         PI5OuG6mzBBXfhEb/9oSa1iDLcfIkh0sdyZFktwRXF5sWW/hRKFhCck4fNcCq6n+XTJ+
         RqOA==
X-Gm-Message-State: AOJu0Yw6E7r3IVxHV7V2SWWVLfd3ekaoXI25r1j4QR+/WA+UW49aANXa
	howklIDdsdwFcJqITj6k0Am1Ur31Bju4KwtBLVw4MbkdX/P2em4CZSQXztuahAficl2E0tyMWxC
	c
X-Google-Smtp-Source: AGHT+IHIlnjBN3gV+kcJYKx1KENTg5z1eBzdyN43TVGmGBl0bcwVmxb2ivhKzh0N6JQTTjDClnIx0g==
X-Received: by 2002:a17:902:c94d:b0:1f2:f6ca:fbcb with SMTP id d9443c01a7336-1f4483e8e63mr39972565ad.0.1716591911148;
        Fri, 24 May 2024 16:05:11 -0700 (PDT)
Received: from localhost.localdomain ([2620:10d:c090:400::5:7713])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59besm19147625ad.106.2024.05.24.16.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 16:05:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work for data messages
Date: Fri, 24 May 2024 16:58:47 -0600
Message-ID: <20240524230501.20178-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240524230501.20178-1-axboe@kernel.dk>
References: <20240524230501.20178-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
to the target ring. Instead, task_work is queued for the target ring,
which is used to post the CQE. To make matters worse, once the target
CQE has been posted, task_work is then queued with the originator to
fill the completion.

This obviously adds a bunch of overhead and latency. Instead of relying
on generic kernel task_work for this, fill an overflow entry on the
target ring and flag it as such that the target ring will flush it. This
avoids both the task_work for posting the CQE, and it means that the
originator CQE can be filled inline as well.

In local testing, this reduces the latency on the sender side by 5-6x.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index feff2b0822cf..3f89ff3a40ad 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
 	io_req_queue_tw_complete(req, ret);
 }
 
+static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
+{
+	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
+	size_t cqe_size = sizeof(struct io_overflow_cqe);
+	struct io_overflow_cqe *ocqe;
+
+	if (is_cqe32)
+		cqe_size += sizeof(struct io_uring_cqe);
+
+	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!ocqe)
+		return NULL;
+
+	if (is_cqe32)
+		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+
+	return ocqe;
+}
+
+/*
+ * Entered with the target uring_lock held, and will drop it before
+ * returning. Adds a previously allocated ocqe to the overflow list on
+ * the target, and marks it appropriately for flushing.
+ */
+static void io_msg_add_overflow(struct io_msg *msg,
+				struct io_ring_ctx *target_ctx,
+				struct io_overflow_cqe *ocqe, int ret)
+	__releases(target_ctx->uring_lock)
+{
+	spin_lock(&target_ctx->completion_lock);
+
+	if (list_empty(&target_ctx->cq_overflow_list)) {
+		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
+		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
+	}
+
+	ocqe->cqe.user_data = msg->user_data;
+	ocqe->cqe.res = ret;
+	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
+	spin_unlock(&target_ctx->completion_lock);
+	mutex_unlock(&target_ctx->uring_lock);
+	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
+}
+
+static bool io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
+			       struct io_ring_ctx *target_ctx, u32 flags)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_overflow(target_ctx);
+	if (!ocqe)
+		return false;
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
+		kfree(ocqe);
+		return false;
+	}
+
+	ocqe->cqe.flags = flags;
+	io_msg_add_overflow(msg, target_ctx, ocqe, msg->len);
+	return true;
+}
+
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -137,12 +200,20 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
-	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_complete);
-
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
+	if (io_msg_need_remote(target_ctx)) {
+		/*
+		 * Try adding an overflow entry to the target, and only if
+		 * that fails, resort to using more expensive task_work to
+		 * have the target_ctx owner fill the CQE.
+		 */
+		if (!io_msg_fill_remote(msg, issue_flags, target_ctx, flags))
+			return io_msg_exec_remote(req, io_msg_tw_complete);
+		return 0;
+	}
+
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
 		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-- 
2.43.0



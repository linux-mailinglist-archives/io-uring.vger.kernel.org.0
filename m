Return-Path: <io-uring+bounces-4449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A5C9BC306
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 03:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 047AA1C212C0
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 02:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C1B2C190;
	Tue,  5 Nov 2024 02:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKyl1sOJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625FF1CD0C
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772762; cv=none; b=mjQy903Jih9V2J0CQjfqZh+ey3vNUXgRLBOZToChjz3Zuxm+QMKgHkGhRyIGF40SuFjQIs+qp+HFmyeV+SaGtFELdYwnTHpy+OJsYYFACcfFWEIjuHDrT3tkNwEDYIkH5jsadbpukt7LLqcRueaL2C2FZn5m3hahrz1KYSmA/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772762; c=relaxed/simple;
	bh=aMaufG5zaB1OfzwsGnfmmBYs7i8vvzUcwaXJeoSTV18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gUbhRIZPYsNsUN2mkJM0iOUAc6dJVI5DOzndbmUNhU1znNNwh3zlNaMymGf+lQY5zTMPDD6GUYgHbd8bNAFhJhAw+8sy526N1cjfm/G3YTUeahU6AFBbZgzQwKCP897uROI7OwGn8egIO5AenlEnF5f6Ce8gjoYEjfIlfua6YIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKyl1sOJ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c941623a5aso10425792a12.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 18:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730772758; x=1731377558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9etybDr/htNQeSDgvD3v3IHd73GpthtgTbJHgvJkxAU=;
        b=gKyl1sOJ0hMd1tQXUHgsgMEAuzcxlLlvEgzeNoEICNOS4+YdPlYEIF94oAsuX96Cjz
         CLjf1h0r+UW9ba6zuQnL6GTMTJl1wUBb1uGJA8DHis/By2wvqV7f80a63BJmJONc51ka
         /rtDU8EkSEcKpny+Brt2bOfMfP+Ys8qznZtuZhngDRMYPWtLYFw3PBQkvvtTXn7E+1IW
         +HztRhX2E/GF4Ud183W7/yQAEE/fJqa33r6+bN9sHUr8/dp433pQL66oG/1gVj+IAzOb
         3eQN39jQnWrZXAhyK/bvGWgyj/BlI237gMjZIMWZB5ES+J1t+9pc66RkvNldanJ9LBIg
         2tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730772758; x=1731377558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9etybDr/htNQeSDgvD3v3IHd73GpthtgTbJHgvJkxAU=;
        b=orimb0dimcCTSy/N7tk5Wq3dsuXWTmrZXJkgU9mLKugCx8lN8iMtfhH9JFBexeVpIr
         8hJpqmt8fC00q1wqtLrFifCpPDcx22DczYxGTtbvLXeJxkWwZL8tjXMY9NG7HyizHB65
         RAqPrvaKzhNzmJ/bIJJIcTMpyKPQkim2pxjwT/FRS8E61UFg6Qjvgy6TqMQPuOmt/LNZ
         os9UH/Dit5NbQCdwp0wqd7hS7KJYd35mNtZk4w+6qe8hVWA2Rsd86+2hPPci238X4kWF
         PTB5TtI2H9UMMDTvGJk/qyq2sOYj/3yjc+s0EYSuUfEqVwY4E0VUFR/y02cS0nn829UO
         df/Q==
X-Gm-Message-State: AOJu0Yyrx1Uc6iQRd9gamavouOidWPVeAiyVp9cwL5XA8LEuEPW99ceK
	MYUANdHLabnOf57jgZbbK80NknbXgw+iCBjxL7aE5/+npR2JPKhryG9I/Q==
X-Google-Smtp-Source: AGHT+IGvIw2NvgUJ+eTCjZ2fjpetbfaEsZZjXy12ch7AdUnsH9ubVCFhCJRbwRme6EHYcGCWESQKHw==
X-Received: by 2002:a05:6402:43c9:b0:5ce:d60e:5159 with SMTP id 4fb4d7f45d1cf-5ced60e51c3mr6228710a12.9.1730772758184;
        Mon, 04 Nov 2024 18:12:38 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee69fb5a1sm593094a12.0.2024.11.04.18.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 18:12:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: avoid normal tw intermediate fallback
Date: Tue,  5 Nov 2024 02:12:33 +0000
Message-ID: <d1cd472cec2230c66bd1c8d412a5833f0af75384.1730772720.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a DEFER_TASKRUN io_uring is terminating it requeues deferred task
work items as normal tw, which can further fallback to kthread
execution. Avoid this extra step and always push them to the fallback
kthread.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++++++++++-----------
 io_uring/io_uring.h |  2 +-
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f34fa1ead2cf..219977f8f844 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1199,9 +1199,8 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	return node;
 }
 
-static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 {
-	struct llist_node *node = llist_del_all(&tctx->task_list);
 	struct io_ring_ctx *last_ctx = NULL;
 	struct io_kiocb *req;
 
@@ -1227,6 +1226,13 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	}
 }
 
+static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+{
+	struct llist_node *node = llist_del_all(&tctx->task_list);
+
+	__io_fallback_tw(node, sync);
+}
+
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
 				      unsigned int max_entries,
 				      unsigned int *count)
@@ -1380,16 +1386,9 @@ void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node;
+	struct llist_node *node = llist_del_all(&ctx->work_llist);
 
-	node = llist_del_all(&ctx->work_llist);
-	while (node) {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		node = node->next;
-		io_req_normal_work_add(req);
-	}
+	__io_fallback_tw(node, false);
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 00409505bf07..57b0d0209097 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -137,7 +137,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		 * Not from an SQE, as those cannot be submitted, but via
 		 * updating tagged resources.
 		 */
-		if (ctx->submitter_task->flags & PF_EXITING)
+		if (percpu_ref_is_dying(&ctx->refs))
 			lockdep_assert(current_work());
 		else
 			lockdep_assert(current == ctx->submitter_task);
-- 
2.46.0



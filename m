Return-Path: <io-uring+bounces-2257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BA790DC01
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2AAA1C22F7B
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F46615ECCD;
	Tue, 18 Jun 2024 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jvp9NjoL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A715E5CA
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737003; cv=none; b=lt6JOp1QIKjDIfUi4iGZ9wAgDqAMYuIDupUzjbU/dLd9sWHQZSDgLQuI5Gp17ZJPFqIbijDhyUzXS8/rFssP6kfsPt30c5YTkRZqIoKa5Ylhuvw1gmoe9SMujyHiB2FTUhrODvbzSLaQXpBSwGFKA2Fcq1t8InsKlk1iZyfbc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737003; c=relaxed/simple;
	bh=sUZOHfP9JoKBzBl6ELl7LD1QpDsPwL4mR0POXRW8ipQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8gLfmD2MyA7wBekq6yCfi2sXvTtBHYE7Q/IcqNiAE4F7UPT773KTM7Fsqao+hTZdH1Nl84rLEj8CvLRazbraYL82WG3J4qT2sszyaUD4lowMDxhQ3VqEPmnk0/q30mYzBhE4kYE2DZGe5QuxGI1kvDzPEb7E/xmdpljNYa00jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jvp9NjoL; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-24c582673a5so473447fac.2
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718737000; x=1719341800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hc6I5c736RCR/T+6zHjTPji7tCumWOIEIjK9x9cxQIM=;
        b=Jvp9NjoLIl389vXvIRDd7rehLAq9T2u/n8bXApH23dp8CkXsWZprSp0aPXX39pAS4S
         QthoKzJq0eoz0MH3N6csCH9Cx5v2U65g6SFT7Hno5eTpVfdjOYASnPicreMUezBPrUQG
         KUzH5wjxdHIuv5yOSgjwEIiXldJ/1UWbZddwFb7b0b4hYXKjLBrDtho6dM+CLzeYnu6U
         3ej613Q42dJOWo4VFXqzESIPV+6vhVArsMntO0ieyJfR7YsXLhOLIJmwjzDaX2Gfh+8g
         ToXsM7/JwheopuNZGQ3Wk5XcN/sJwJhDcYrKojHas4KA33OOAY0pDR5HJvWbqRqqkrOx
         Sgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718737000; x=1719341800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hc6I5c736RCR/T+6zHjTPji7tCumWOIEIjK9x9cxQIM=;
        b=APonOjXdQfWoalefxtdkEjT4vrxrwXbmu+ZvKUUqfMGsL52I1ipOqbNGX9ScuncevR
         67IyKcu8Mw1T4etQ9Rnxh2n7PtB+Yxx6fH1rVW+kp5P3YuJ5W2b+TqopMP5y1HHlIwnf
         h0utHl5CemDjkR90dkAe0R1RS7EFJdW2VQy8YuCL6KhSy73Q2eMSW2yWs2BnyxeEi4yD
         3RRBNckWoMNqWlFzj0fgu+LBzzPFp5/od/EQnGr/18uIZ1IuVQerRmDnRZt9mhbIEzxM
         J19S2iU2pYNFkPcnhDtmLeoDUqqSqVt/2a7oKOwxpaYg5E/Cci8tS5JNr2FPN4blwhWw
         RKkQ==
X-Gm-Message-State: AOJu0Yz54OKOixlWXzL7zRwueN6FE1gPMF6Q4C4vOEQg+hX2woAQ2lAz
	phsD7AnAryqtI+UC8mmIkf46k0AY0hATjERaZp8xZZtJRoFd9WleuvesnwzEg5gu6+N/uyJxbGN
	C
X-Google-Smtp-Source: AGHT+IF6zSZm4r5S6oUXuzRMWrKrVuL8PUPNvQEMBVnAOeqRvYwCPaw2xSGB8lfALfbxGYY4laMD2Q==
X-Received: by 2002:a05:6870:148d:b0:258:4dcb:7d48 with SMTP id 586e51a60fabf-25c943e5c01mr809096fac.0.1718736999617;
        Tue, 18 Jun 2024 11:56:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: add remote task_work execution helper
Date: Tue, 18 Jun 2024 12:48:41 -0600
Message-ID: <20240618185631.71781-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618185631.71781-1-axboe@kernel.dk>
References: <20240618185631.71781-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All our task_work handling is targeted at the state in the io_kiocb
itself, which is what it is being used for. However, MSG_RING rolls its
own task_work handling, ignoring how that is usually done.

In preparation for switching MSG_RING to be able to use the normal
task_work handling, add io_req_task_work_add_remote() which allows the
caller to pass in the target io_ring_ctx.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 24 ++++++++++++++++--------
 io_uring/io_uring.h |  2 ++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 438c44ca3abd..85b2ce54328c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1098,9 +1098,10 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
-static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
+static inline void io_req_local_work_add(struct io_kiocb *req,
+					 struct io_ring_ctx *ctx,
+					 unsigned flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
@@ -1114,6 +1115,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
+	guard(rcu)();
+
 	head = READ_ONCE(ctx->work_llist.first);
 	do {
 		nr_tw_prev = 0;
@@ -1195,13 +1198,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
-	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		rcu_read_lock();
-		io_req_local_work_add(req, flags);
-		rcu_read_unlock();
-	} else {
+	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		io_req_local_work_add(req, req->ctx, flags);
+	else
 		io_req_normal_work_add(req);
-	}
+}
+
+void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
+				 unsigned flags)
+{
+	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
+		return;
+	io_req_local_work_add(req, ctx, flags);
 }
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd43924eed04..7a8641214509 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -73,6 +73,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
+void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
+				 unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.43.0



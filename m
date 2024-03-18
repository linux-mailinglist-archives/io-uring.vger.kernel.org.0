Return-Path: <io-uring+bounces-1069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2B287E155
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FAF1F221C9
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCE220315;
	Mon, 18 Mar 2024 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ES5CCecQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AC81EA7E;
	Mon, 18 Mar 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722629; cv=none; b=nq0+J+xLUO1g6mfcfLCZuZYsn9Hw6I3thM+Rtj9QQ0L3SjdNNHcz4e1oOWegxLU6nkdG0WVHR5kIbbUCG/pY3n6OpwoYJaHbrmxrnwT3/CFaeoK9+BW/x4H1Ttj6nSRcFtq/ORZxmjK265h9/TFrC74+hOM3+h0l2/illjw84vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722629; c=relaxed/simple;
	bh=JHMPfBFEnuALZqDa0moFr296ertczTzbv2NG2KcqXD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq9wELDQZV8myDOX8rcdPmgiYJTz1hwxSmVGssiUQwgmQH5z1e5yWuE1BVjVhpjbDaiBZby8wq1mbEV4ciHo30C0QMuGU0W+GHc/Aw0qQdnVUyjPpB6Ajp/uFg2oBWsiDCLngqgCYDJaI0A5cvkPiBw8eUBCxgyP4dqZI/GIFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ES5CCecQ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a465ddc2c09so276140666b.2;
        Sun, 17 Mar 2024 17:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722625; x=1711327425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfQZGoJZoDIJgsr2a2vsleYuSq2cLitr4Li2kyTmpxg=;
        b=ES5CCecQlCu7bL7GMrweirTp8DsqfuGP+/ttH2NiXsVvftFpVwhBzxwCtDzIkoO2nP
         nGPet2UmA/wMZa+9pvueMsROQUjTGbRHtFpBmhHinV9T4qTJdbFIrNKOt9KMRpKiMZvY
         rxJd1k3pacVDtq0TM/yJd+XmXZDh1QaPB6+hyS9pOAh+XlvToeoQt/HXgqu41frSB40e
         OujjvogrTkrVQ3LE1qYl437M1/WIM8sZ4eqX974NuLdAzKyoJPJC4N6IE6zqo5Qq+I2t
         VknN+wCspgaVgD2MxzpZW1ZCxLT8m0tVUzxNz5UWRkQcjdQ/R139V6HI7kaELG6nHoGL
         BDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722625; x=1711327425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfQZGoJZoDIJgsr2a2vsleYuSq2cLitr4Li2kyTmpxg=;
        b=o8Ib4J56RAsT+6jM165imRJANi0b8ZK/bu9qt/fmYLTU1cs4o6JRLljkHefT07SZ43
         Mt6MapPf2aPlnbrc9UpF1GMLGCOOZkdf10X3TuecQbpghR6cC5Wf/U+4iFmfRrbK/wf5
         ZzfootxP9HWa9AtFeCsBdkWSQ4h1xKT5pAVIaOExxO6Znpw8H08e2KY+D4L4OJVQciA+
         3/5XWJXESZ5U1AQQUsRjVmwwveNhyeilsroPB4esJFr7Rd/bdHDiXq6begC9X5gE3neU
         4u51X3mbjFYLkP7x8wjF8qxpuLlB8HtJLrRUg/SbKOZGQgX+NK189mQzK4DbzaVSjoa0
         v+nQ==
X-Gm-Message-State: AOJu0YwBC5IBchhk+7/f+m2kljrxgqOtcUcwpNJe8Tt1o0HzwkAynT3i
	6hC/MjSaC9Y/wlJ+Cu1edrLr7tlvd4EzcHIAvCKxfJd1uAfk6YZOmMmYlLaU
X-Google-Smtp-Source: AGHT+IF2I7pmyz8EqfxAZqX3ZeYVV5Gb7FAbI8a2E0XYGlwzOZH5yK5Pa/YSA6PwOxR/MoQUZxW9cw==
X-Received: by 2002:a05:6402:1f08:b0:565:f7c7:f23c with SMTP id b8-20020a0564021f0800b00565f7c7f23cmr3765621edb.3.1710722625177;
        Sun, 17 Mar 2024 17:43:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 07/14] io_uring/rw: avoid punting to io-wq directly
Date: Mon, 18 Mar 2024 00:41:52 +0000
Message-ID: <befed053628bf9d0c3c00ff662dbba594dcb6d49.1710720150.git.asml.silence@gmail.com>
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

kiocb_done() should care to specifically redirecting requests to io-wq.
Remove the hopping to tw to then queue an io-wq, return -EAGAIN and let
the core code io_uring handle offloading.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/595021a813bebf0256e80b95bcc594377096e08b.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 8 ++++----
 io_uring/io_uring.h | 1 -
 io_uring/rw.c       | 8 +-------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..9d7bbdea6db5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -498,7 +498,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
+static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1505,7 +1505,7 @@ void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
-		io_queue_iowq(req, ts);
+		io_queue_iowq(req);
 	else
 		io_queue_sqe(req);
 }
@@ -2088,7 +2088,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		break;
 	case IO_APOLL_ABORTED:
 		io_kbuf_recycle(req, 0);
-		io_queue_iowq(req, NULL);
+		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -2135,7 +2135,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
-			io_queue_iowq(req, NULL);
+			io_queue_iowq(req);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276..472ba5692ba8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -79,7 +79,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0585ebcc9773..576934dbf833 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -187,12 +187,6 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 	return NULL;
 }
 
-static void io_req_task_queue_reissue(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_queue_iowq;
-	io_req_task_work_add(req);
-}
-
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
@@ -405,7 +399,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req))
-			io_req_task_queue_reissue(req);
+			return -EAGAIN;
 		else
 			io_req_task_queue_fail(req, final_ret);
 	}
-- 
2.44.0



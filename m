Return-Path: <io-uring+bounces-1120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B9A87F2D4
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E5A9B22114
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7CD59B60;
	Mon, 18 Mar 2024 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpJkYudD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0F859B55;
	Mon, 18 Mar 2024 22:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799341; cv=none; b=r7Lx1McRLGfEeswjNjMPhDOPuarioC27j5AspnwrqXeJ/Y0QZ1gj02qHmOD5dfNwzmgmeXiN4r199eT+fU9oiCuRd8uX0BtIih1luXu3BKmNTKltEaNRNCKv1z/gZGfl+bq9Ab84li2jIMJFIMq0RkVhJ96RW1x17T842AFphvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799341; c=relaxed/simple;
	bh=CqEy9YlnIJxs2HVEo6RpmOFUMTKd1shNymbvV4OtMgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRbBiXJukQI84n7mwBXFvi+mFGHPJQ4enQMGT3KRly96i335cbXxuqn0yyPtootGQvWZvoo4qjb56OH/mRQISTXVCt4bCSzasxnQaxpTh39MHxdDNc1LST7LcNQW56kXiX6Ue0PBoP+61tKYHV/dYOuM19ayFV7MMomWvlrpfaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpJkYudD; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-34005b5927eso1508266f8f.1;
        Mon, 18 Mar 2024 15:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799338; x=1711404138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xk51Ayd0oOL8B8bNip0Qvci6ISd/wlEH/T4TunQP5iw=;
        b=VpJkYudDvTP5T4S04wJUuX7wJL2y9Yw/tIN3ubAvSHW9DOXm+9Wxtt7jNm54ZlaoDV
         lpg05NTOUtLxa/4aKaQVS6GVKwNeuXnHuyLfh5u7OagtO/kDAqO44/wSuw5h+YAJC4SZ
         OgHv3emNtNp8uHURmuoxWnsA0+m32758e/1ticytzzVK99KFKruXKwx0ROex8CQroDTK
         If2+G1fnXEQ6mlT8hvyvKJj6lzqAuartCxGc+u93ZbnOcT1rhySC2hzKJs3S1xS7QXn/
         vnUDRBudUWOZNe7m1m9vfMN6XcDZ5FtUFEDkcteWidpGHmoZTDg30ZbbdGrzq+qKt+Sj
         CL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799338; x=1711404138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xk51Ayd0oOL8B8bNip0Qvci6ISd/wlEH/T4TunQP5iw=;
        b=Ejj1G3XKg0YBaDMQjPN/5cmxkQZcDHekaGCY0EntDCu9iQ/5x3TkE9ZBqq/kSTd+9D
         xfGDLyNZK/2g7j54eXGNv9qk1um+9X/tPCde7+zg3eD5ReZmK8KUoWqZTVAj+USK/VLT
         b4d0m93KZrRFL1WiyU8/v490bdXZFSGI76q318/D31duhVnku4Z1B0rwymp3LkICxv8m
         51lQAFpeqn1dJ6FRmIjcAmzEXUJNjHAUYqwVDMZA+iX8tLp11s5SXupuIvAEQFJAQxjs
         x2ps/tgsyEZ7XAJeDUxWnxVK6J1PqDvYjcKFVzfghynA4TW5058Ucec1v1Y7XABbv+f8
         DQVw==
X-Gm-Message-State: AOJu0YwOyyiwpOTKBdsnrIznGf658XrISH3tTHhUUU6IcIqa1KSLrxVE
	v0q9QPA1cxWzjqWlpCpk7yFu/qI8mmcry5QgpR0D38MrJr8K7+SEwh8fqpvH
X-Google-Smtp-Source: AGHT+IEIrbrIkE/08hBiwsXKc5D/fiNXGxss0DGlADUl8m6/aSQyZCFk6tFuRpKVT0PCVLMNBTXodg==
X-Received: by 2002:adf:f7c9:0:b0:33e:c6a2:7f6 with SMTP id a9-20020adff7c9000000b0033ec6a207f6mr9152664wrq.11.1710799337585;
        Mon, 18 Mar 2024 15:02:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 06/13] io_uring/rw: avoid punting to io-wq directly
Date: Mon, 18 Mar 2024 22:00:28 +0000
Message-ID: <413564e550fe23744a970e1783dfa566291b0e6f.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
---
 io_uring/io_uring.c | 8 ++++----
 io_uring/io_uring.h | 1 -
 io_uring/rw.c       | 8 +-------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6ca7f2a9c296..feff8f530c22 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -492,7 +492,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
+static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1499,7 +1499,7 @@ void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
-		io_queue_iowq(req, ts);
+		io_queue_iowq(req);
 	else
 		io_queue_sqe(req);
 }
@@ -2082,7 +2082,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		break;
 	case IO_APOLL_ABORTED:
 		io_kbuf_recycle(req, 0);
-		io_queue_iowq(req, NULL);
+		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -2129,7 +2129,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
-			io_queue_iowq(req, NULL);
+			io_queue_iowq(req);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 935d8d0747dc..0861d49e83de 100644
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



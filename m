Return-Path: <io-uring+bounces-865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5644A8765CB
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 14:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF5701F22666
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 13:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDAC38DF9;
	Fri,  8 Mar 2024 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNduEvSP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164AD40856
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709906332; cv=none; b=VK6nxNcc7M5C3VtIFhn77mgFTFy417UIw3/tcfqUPTkYlzjx8pQMXGlTTbB0mnWL4nARUcaPJinSFMGt37gw3R42zuz1oErSWbhY2pVn5IB5BtvdhU4k6Z0tRAJxZEwQ8zmv1YYI5Og1iUw/JoL/5Hvhz1qkMo1e97b11cafP2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709906332; c=relaxed/simple;
	bh=qS8MalAQoWV0g80GfTeHW22WyX+rrDzkzwvU/GsWdI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIVvmxpE9DYo43ENC1NWrRuw5UyxXo4uT8njwgXwL+yaJGii1t3YnDsm6JyuhIm5zvy/2KKHPvWE62qvGZqIUyz6CLP+XMlifwJZmD3B6JbJOXX6k7hhUDTirLHM/d4FDVaHJdse2fpzOrwshnfflKD5nZkGrheTw3hPNu76mUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GNduEvSP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-567fbbd723cso1026381a12.3
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 05:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709906329; x=1710511129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk//fNMLELl6slqa+qiyE5ltZQGonksP78x9CswhUW4=;
        b=GNduEvSPRO8DzKe8fXe6D51naH4qD+gnd5M8uUZSxX9+IZD5zSk4SqsmoTUJOyDNry
         Wz87FNE3N8oGq7Xr+uMPEKGBXadpEpAaMqK+UJSuyJOLxlJAvSWCZ494slAiui8GZV2p
         ZihbjUSqBSd73PNrauBGZpum7cbQ+Zie3sXvrOJZELrmtmG/Zj9uaXtD1QXN5cFjEbHG
         sW8pbzs8ssePA1F9tYG+W44h8hR96aMSvFU7wgEzfAjgJ4B2PngXK4mcEaho8Bgy0ct5
         z5IMGrQW/jO1Tg9ZFZnYHRELiJ/nR3uZ5qXw2o9AY/XdhxY/AWDL4EXRslYu9Kym/mCC
         NWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709906329; x=1710511129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pk//fNMLELl6slqa+qiyE5ltZQGonksP78x9CswhUW4=;
        b=TQ9PG/qFx0C8XMJPfYRUB4IZPY5mas3OTBGArAuJUi2ob/xlL3HEouUd8xPH451vTI
         xlECIu4L2enjWKlAvwp+PGsTePLF8ANFo8ublzdfQWAHZ8QGPZqz0qgx8xbUBQPW7+GX
         DEP9ZdQq6f2caaD5ldRw7JB5/OUyGaFh5Nfi72dvMo7hkdTxzQb75L1wPRWLw5Y/5jbI
         O8uGlz+Bw3u299u/KXu0JT/0kXtA2kokUBiFKLqvPinI0miFMtTYt3I82T5W2xwdhnkX
         1gGesMyV7z4ZhL5nYL8WEfWF2GMETQAZJOj9x2qIwDcXVlq4zUMLguokaU++Wrqmwho/
         DoLg==
X-Gm-Message-State: AOJu0Yxk1VUeZF6lN3ch9A3JCy0RIPfE4Vrb/6QwI8c9o1mp3LsCp1mf
	tBBYfMvUvAGtQqJ8W6Kow8uHkaYKzuKJ3CgCJFHD+u5ahDhS9DnNXgg8rsUWQhU=
X-Google-Smtp-Source: AGHT+IE6Gkjq1czsvBw2dQ01+66LsVkndWdaM7rHeqtdSBrd1MJpECu6UV7GM92GCLe8uIlsW+rHHw==
X-Received: by 2002:a17:906:2448:b0:a45:3308:560d with SMTP id a8-20020a170906244800b00a453308560dmr10325316ejb.71.1709906328832;
        Fri, 08 Mar 2024 05:58:48 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:d306])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906229000b00a442979e5e5sm9303189eja.220.2024.03.08.05.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 05:58:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: refactor DEFER_TASKRUN multishot checks
Date: Fri,  8 Mar 2024 13:55:57 +0000
Message-ID: <e492f0f11588bb5aa11d7d24e6f53b7c7628afdb.1709905727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1709905727.git.asml.silence@gmail.com>
References: <cover.1709905727.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We disallow DEFER_TASKRUN multishots from running by io-wq, which is
checked by individual opcodes in the issue path. We can consolidate all
it in io_wq_submit_work() at the same time moving the checks out of the
hot path.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 20 ++++++++++++++++++++
 io_uring/net.c      | 21 ---------------------
 io_uring/rw.c       |  2 --
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..cf348c33f485 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -944,6 +944,8 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 	u64 user_data = req->cqe.user_data;
 	struct io_uring_cqe *cqe;
 
+	lockdep_assert(!io_wq_current_is_worker());
+
 	if (!defer)
 		return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
 
@@ -1968,6 +1970,24 @@ void io_wq_submit_work(struct io_wq_work *work)
 		goto fail;
 	}
 
+	/*
+	 * If DEFER_TASKRUN is set, it's only allowed to post CQEs from the
+	 * submitter task context. Final request completions are handed to the
+	 * right context, however this is not the case of auxiliary CQEs,
+	 * which is the main mean of operation for multishot requests.
+	 * Don't allow any multishot execution from io-wq. It's more restrictive
+	 * than necessary and also cleaner.
+	 */
+	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+		err = -EBADFD;
+		if (!io_file_can_poll(req))
+			goto fail;
+		err = -ECANCELED;
+		if (io_arm_poll_handler(req, issue_flags) != IO_APOLL_OK)
+			goto fail;
+		return;
+	}
+
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
diff --git a/io_uring/net.c b/io_uring/net.c
index d4ab4bdaf845..14d6bae60747 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -78,19 +78,6 @@ struct io_sr_msg {
  */
 #define MULTISHOT_MAX_RETRY	32
 
-static inline bool io_check_multishot(struct io_kiocb *req,
-				      unsigned int issue_flags)
-{
-	/*
-	 * When ->locked_cq is set we only allow to post CQEs from the original
-	 * task context. Usual request completions will be handled in other
-	 * generic paths but multipoll may decide to post extra cqes.
-	 */
-	return !(issue_flags & IO_URING_F_IOWQ) ||
-		!(req->flags & REQ_F_APOLL_MULTISHOT) ||
-		!req->ctx->task_complete;
-}
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -853,9 +840,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
-	if (!io_check_multishot(req, issue_flags))
-		return io_setup_async_msg(req, kmsg, issue_flags);
-
 	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
@@ -951,9 +935,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	if (!io_check_multishot(req, issue_flags))
-		return -EAGAIN;
-
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1403,8 +1384,6 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (!io_check_multishot(req, issue_flags))
-		return -EAGAIN;
 retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7733449271f2..6f465b6b5dde 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -933,8 +933,6 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!io_file_can_poll(req))
 		return -EBADFD;
-	if (issue_flags & IO_URING_F_IOWQ)
-		return -EAGAIN;
 
 	ret = __io_read(req, issue_flags);
 
-- 
2.43.0



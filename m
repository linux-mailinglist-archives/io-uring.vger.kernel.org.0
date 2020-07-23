Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD1C22B4CC
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGWR12 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 13:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGWR12 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 13:27:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B97C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:27:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so5953275wrw.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xZrfI2YxHCqw71VQS3K5Bkvqt1Na8ADW0Wwt5rOMkR0=;
        b=ZjCtGbgeP4gN04QX4XpNOGd6gmJnugHMnXMJDZe0TwBEfNK6K/5BaW1fownjM+5qCb
         JV+zlpqHRqcqiQ9i0OlfczwOV9I46b3d5X53QuKOritQDGpUsaBxSyMxD9KAJ6bb7iD7
         t25fnNCrJWCKnlKkY4Vm+RXRq2B9+JkTd+qi1us4+1i/MFZXJuzz0NenMWCCBQBh9W9S
         WG5PZmF2eWCW9zZ/wY+GHtkBGMcbZjkjPq6JisYGUowj/CEzMIyFcsxx/JpuoQ5AlgOG
         yT7f9W3339fKFtLMPOqi/7ZFp9q8u2h+++da6K/oyX9lhAIIpb63zLhEZDcSaKs/hgNK
         R+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZrfI2YxHCqw71VQS3K5Bkvqt1Na8ADW0Wwt5rOMkR0=;
        b=UNyNwCjh2/qY1wFisFCmvg05SCI6p31FQL0sQm8TQy9GraiAWZ15eLSuRKDLb9GQXf
         buMHaI/JeZ19V6Y/7ZD3QeW4y9+OJHm2Okw+lOTW84H72EPTM0blQ8B/HSq9HtA7yssX
         Ze+expmaQuImFr+2jxJMYR9ZlJ7R5xDKwNF98Z9BCK9Qt8a1dkmY9W+c+UsJDDki7S0J
         8gociD7jb+nDl+BMxuyG1/GnUxGbXoqSY9EC4qt8oQ71xmF7872c/yoOkfQA6ck5vfFc
         FXvI4GYf/rDtV68jnS5AjdYjn/Fg10mRJAcDYuoLH45NkmMSOkXivUcmeX1iJVcGBn5g
         TbEA==
X-Gm-Message-State: AOAM531Zk9uaOP9GixY1yI3jq2XbtXMnDsv7R9vp8MFR/np7FHziAhR1
        /S8npWL9hyzEU+VW9wBlatU=
X-Google-Smtp-Source: ABdhPJxrnDzlIZ8zfftSu+M+vlMnmMrFVTzNzwy2bEyhXG75FGERMAGN5fIssAtbHphpg4DAWYc4/g==
X-Received: by 2002:adf:9463:: with SMTP id 90mr4866539wrq.223.1595525246622;
        Thu, 23 Jul 2020 10:27:26 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id t2sm3976230wma.43.2020.07.23.10.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:27:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: deduplicate io_grab_files() calls
Date:   Thu, 23 Jul 2020 20:25:21 +0300
Message-Id: <ce4d088bd58576505257c7d949cf54591525e51f.1595524787.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595524787.git.asml.silence@gmail.com>
References: <cover.1595524787.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_req_init_async() into io_grab_files(), it's safer this way. Note
that io_queue_async_work() does *init_async(), so it's valid to move out
of __io_queue_sqe() punt path. Also, add a helper around io_grab_files().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb356c56f57c..c22c2a3c8357 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -912,7 +912,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
-static int io_grab_files(struct io_kiocb *req);
+static int io_prep_work_files(struct io_kiocb *req);
 static void io_complete_rw_common(struct kiocb *kiocb, long res,
 				  struct io_comp_state *cs);
 static void __io_clean_op(struct io_kiocb *req);
@@ -5285,13 +5285,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 
 	if (io_alloc_async_ctx(req))
 		return -EAGAIN;
-
-	if (io_op_defs[req->opcode].file_table) {
-		io_req_init_async(req);
-		ret = io_grab_files(req);
-		if (unlikely(ret))
-			return ret;
-	}
+	ret = io_prep_work_files(req);
+	if (unlikely(ret))
+		return ret;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -5842,6 +5838,8 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	io_req_init_async(req);
+
 	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
@@ -5867,6 +5865,13 @@ static int io_grab_files(struct io_kiocb *req)
 	return ret;
 }
 
+static inline int io_prep_work_files(struct io_kiocb *req)
+{
+	if (!io_op_defs[req->opcode].file_table)
+		return 0;
+	return io_grab_files(req);
+}
+
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5978,14 +5983,9 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			goto exit;
 		}
 punt:
-		io_req_init_async(req);
-
-		if (io_op_defs[req->opcode].file_table) {
-			ret = io_grab_files(req);
-			if (ret)
-				goto err;
-		}
-
+		ret = io_prep_work_files(req);
+		if (unlikely(ret))
+			goto err;
 		/*
 		 * Queued up for async execution, worker will release
 		 * submit reference when the iocb is actually submitted.
-- 
2.24.0


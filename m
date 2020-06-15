Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8CA1F9001
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgFOHeu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgFOHet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:34:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62B3C061A0E;
        Mon, 15 Jun 2020 00:34:48 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y17so15919173wrn.11;
        Mon, 15 Jun 2020 00:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/scpk3kR4iex4ERTM3utzKEgc0eR+GVe9poH6YwaP0=;
        b=VHHHozs/xph4kV5lNCnVW2cZ0R2bEeNTlz+sXL6mNB646wm9n/7fEnROvTFIOq1cmY
         DGnpIfaChwgeOSK3Jzui1mKBrLRwOpdqTeITNuYsEFvjIh4d4eAGlTPjxGVrUeCMot91
         OFg9YEwJYgV1RHvHHC6rWMMpwxIEeYww3+NOpD5gjNPrsYCNARiVK87Q+CFjqXLls9Af
         MXWvtqTA8grQNVhiJmCzF7TFB1povvY1/1UsqPItry8wAMyDR2VznMYZRdPqSUU6Zmxu
         tjCuEfirIjfhtnOffzSyFwBNTJcHlbji1KrW2PCZGwhMqgZLmZE7r6/NuwBVru6C6TU4
         FqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/scpk3kR4iex4ERTM3utzKEgc0eR+GVe9poH6YwaP0=;
        b=neN5DQVn0NV7LthWpRTkO2aHxGnTj3cdDdAAOLgrjbqW+2Lf1Mkkrsujt4q6CruBpW
         YNIDHY5xQvxybL3fMEYrfWsjMaz57ZnPqP7Zp/lyYtQxOyf71y1peTEgXXDvw1nX+/hI
         225YW9B/uqa8gC+n5ICxlIkns3mpR2xxzmsF/eDl2sqSVwaNmaGSY5PSy0qbXbAtSpez
         +9Yrsu5IRcCWWGGgk0vWoDBMRQol81p+zbXaYc+CswPsmRFGhpFWHPpIqS6Ep+EcAcjP
         vsz17C90s+qeBmFsEY5yr67Z6nOpUrUd3NirSU0y73RHw4I3IKQFxbBLQ8sh4dayDL3k
         SpmA==
X-Gm-Message-State: AOAM531m5UkLODaTAI2BlndayzU56E2/0X9dloZEUI9NCshrh5DqrNcW
        BsIaLjwnDUnHkclUXMvAHjM=
X-Google-Smtp-Source: ABdhPJxotSJ15l+OVBaATNGacY+Zs+4rd2S3Y/VYQmcmRWdTf0aw6aFFI3zUVsOU0uQJH8+VEdI3xA==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr26646674wrn.373.1592206487675;
        Mon, 15 Jun 2020 00:34:47 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l17sm20271324wmi.16.2020.06.15.00.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:34:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com
Subject: [PATCH 1/2] io_uring: lazy get task
Date:   Mon, 15 Jun 2020 10:33:13 +0300
Message-Id: <2185c03aec46afef0a914674f0e2904ede6bbbba.1592206077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592206077.git.asml.silence@gmail.com>
References: <cover.1592206077.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There will be multiple places where req->task is used, so refcount-pin
it lazily with introduced *io_{get,put}_req_task(). We need to always
have valid ->task for cancellation reasons, but don't care about pinning
it in some cases. That's why it sets req->task in io_req_init() and
implements get/put laziness with a flag.

This also removes using @current from polling io_arm_poll_handler(),
etc., but doesn't change observable behaviour

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b5cab6691d2..f05d2e45965e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -543,6 +543,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_QUEUE_TIMEOUT_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
+	REQ_F_TASK_PINNED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -602,6 +603,8 @@ enum {
 	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
+	/* req->task is refcounted */
+	REQ_F_TASK_PINNED	= BIT(REQ_F_TASK_PINNED_BIT),
 };
 
 struct async_poll {
@@ -912,6 +915,21 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+static void io_get_req_task(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_TASK_PINNED)
+		return;
+	get_task_struct(req->task);
+	req->flags |= REQ_F_TASK_PINNED;
+}
+
+/* not idempotent -- it doesn't clear REQ_F_TASK_PINNED */
+static void __io_put_req_task(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_TASK_PINNED)
+		put_task_struct(req->task);
+}
+
 static void io_file_put_work(struct work_struct *work);
 
 /*
@@ -1400,9 +1418,7 @@ static void __io_req_aux_free(struct io_kiocb *req)
 	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	if (req->task)
-		put_task_struct(req->task);
-
+	__io_put_req_task(req);
 	io_req_work_drop_env(req);
 }
 
@@ -4367,8 +4383,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		memcpy(&apoll->work, &req->work, sizeof(req->work));
 	had_io = req->io != NULL;
 
-	get_task_struct(current);
-	req->task = current;
+	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
 
@@ -4556,8 +4571,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
 
-	get_task_struct(current);
-	req->task = current;
+	io_get_req_task(req);
 	return 0;
 }
 
@@ -5818,7 +5832,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = 0;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
-	req->task = NULL;
+	req->task = current;
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
-- 
2.24.0


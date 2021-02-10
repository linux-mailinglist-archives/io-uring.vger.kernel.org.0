Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74050315AEB
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhBJASs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhBJAIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:08:31 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB47C061786
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id z6so385356wrq.10
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sKMLVopEZHjWEr80aEt8ViZ5c4ITYCW/Nusd6asGtUA=;
        b=IyNjukaE+zdPzHKWmSiq7cgnDkGrwZxt2EIWyJiL0duVE7eyD7jompi0e2oPg/bb3Y
         vs5gUvpgJU2OJW4gf8c1YYNs+JfyQm/lsLv7bui6MMcsHFn8u1ncGY2nfqa3gSbJzAk1
         fGbleejAMYxKV+rzzyzcqe/+gFV4mStCArjohLucFrLJvi0ZLut5eliJ+KIAAxu0QBwv
         GnEihzy7uEansGlDT1LgUyxAO+SrHctSfLMtEOb+MXW4hBEX8m/vgGBafaSS6S+MkS5x
         YuGCCbX4aDyVm7PWEe0fNMvJ22txKG2c+3BsLNfm+6fVpxUFDDKp4ooLLWvEapaQtPx+
         +zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sKMLVopEZHjWEr80aEt8ViZ5c4ITYCW/Nusd6asGtUA=;
        b=bUL0PEcGf18adJFk5n6mrHbpOoXhLJoPHvMWY1v7VFhVlXL4uXaKzzijD0bBdEnILN
         5HMGpsD8ecXO5pydZs0oYgjvtcU1+oJIy1WaCiGL9KuVjGi6snMy2wk/5Wis6EaZvywi
         vgJT0GUA28jZoI1zNAyzqyhWbg4BFhWhRCGli0C1mjfnXqhU8rK0iPdwzg15f027w6Wr
         VJ8g2rHoVXuYX9rQ0D4HePqvUXaluPHc/2aCJJF40Z0QhYZQ40ghc/609M+APuuUqm6N
         4FYUt6CeDgcR7T3HgwLiAW3VMFPfEqXmHfpDIHlqU40zwYsrdES4iwu2IYqgXY1ewHJs
         Ai0Q==
X-Gm-Message-State: AOAM532dv3u7FYKmOa9AKNyVWxBugRlYTNJFnt4NK3WHBPMISdEEH7H4
        iVPuBWolzuqK6tOu6rsPeVz7MCUyDH8b0g==
X-Google-Smtp-Source: ABdhPJx5imKnuuimoJOT3eFk2Udtl+TILWIFfU6bncCfr8ot52gm8BKHdUJFZNRkeTo9lRX/eFqDRQ==
X-Received: by 2002:a5d:6404:: with SMTP id z4mr531772wru.103.1612915637049;
        Tue, 09 Feb 2021 16:07:17 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/17] io_uring: make op handlers always take issue flags
Date:   Wed, 10 Feb 2021 00:03:08 +0000
Message-Id: <c468cae68ecd34d884adf92ef253e6575dd4874b.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make opcode handler interfaces a bit more consistent by always passing
in issue flags. Bulky but pretty easy and mechanical change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 862121c48cee..ac233d04ee71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3917,7 +3917,8 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
-static int io_nop(struct io_kiocb *req, struct io_comp_state *cs)
+static int io_nop(struct io_kiocb *req, unsigned int issue_flags,
+		  struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -5581,7 +5582,7 @@ static int io_poll_remove_prep(struct io_kiocb *req,
  * Find a running poll command that matches one specified in sqe->addr,
  * and remove it if found.
  */
-static int io_poll_remove(struct io_kiocb *req)
+static int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5632,7 +5633,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req)
+static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5772,7 +5773,7 @@ static inline enum hrtimer_mode io_translate_timeout_mode(unsigned int flags)
 /*
  * Remove or update an existing timeout command
  */
-static int io_timeout_remove(struct io_kiocb *req)
+static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_timeout_rem *tr = &req->timeout_rem;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5828,7 +5829,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_timeout(struct io_kiocb *req)
+static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = req->async_data;
@@ -5951,7 +5952,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_async_cancel(struct io_kiocb *req)
+static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -6211,7 +6212,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		ret = io_nop(req, cs);
+		ret = io_nop(req, issue_flags, cs);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
@@ -6227,10 +6228,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_fsync(req, issue_flags);
 		break;
 	case IORING_OP_POLL_ADD:
-		ret = io_poll_add(req);
+		ret = io_poll_add(req, issue_flags);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove(req);
+		ret = io_poll_remove(req, issue_flags);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
 		ret = io_sync_file_range(req, issue_flags);
@@ -6248,10 +6249,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_recv(req, issue_flags, cs);
 		break;
 	case IORING_OP_TIMEOUT:
-		ret = io_timeout(req);
+		ret = io_timeout(req, issue_flags);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove(req);
+		ret = io_timeout_remove(req, issue_flags);
 		break;
 	case IORING_OP_ACCEPT:
 		ret = io_accept(req, issue_flags, cs);
@@ -6260,7 +6261,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_connect(req, issue_flags, cs);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel(req);
+		ret = io_async_cancel(req, issue_flags);
 		break;
 	case IORING_OP_FALLOCATE:
 		ret = io_fallocate(req, issue_flags);
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF328A3E5
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389454AbgJJWzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731281AbgJJTFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E3EC08EADD
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:14 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t9so13691186wrq.11
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mNqyUVuBRUjy8pup0Bn6iZ1YAfsBuj5rf1sXpOpsSk0=;
        b=UZavmsYdme2rRzU4b8ZAXKj5TI1pY7pnbjS8mLvbZA+CNpEFy++gpjI0gcpeddA0bV
         gBQrUeyhlXDJT1um97qI1gpGrYTFooddPxj/qm8xxO2mEqEEvg7uVI7kr5KHnRW3BQnA
         UzZwRwZTBFAFLRtoRvBYk3q6pMfF71q/8sBXg8k+mR5emzAjkkVyCC52mw8jt1j3x7Ha
         nq31yB2D3RiXOJtcZEM1+BF+z+mtUZh3Z3CEQsO5ajzzvUzwutF1sonl/Li4pgudipF5
         qGdKSVYwBRcsEx57J5K8T3FoBtZNGr+L8PMQZBMglUuZ62yqil6bjw75BnB8W5f1+UVb
         u8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNqyUVuBRUjy8pup0Bn6iZ1YAfsBuj5rf1sXpOpsSk0=;
        b=aj9+fFqlQQ5/6J3Fzi5CH/GJKTUeL7wuazBf/uxnDsdr9dcXrQ+J3LcAbEiAYJy6Ew
         eNpEOAFxvJpAMyWUqKnsSforJ/7wEIF6PkdfCemLS2Nkiay3MKAx7BhIbKVodz8OekT7
         kkMl7LNOj+xqiFihVPV05u3zyLMXsOIY9kgAUuJVzyx8/4TkMaCdobb6QqV87UdM89x2
         nLtTGWXUxMFABNtErGp8qgKLmUgpKVpeaKGezylyT4PE4e/CoY8pKHEwyMrm9fEa60S3
         ioE/+9QjMs0R/q8rw5ODzgi7s/kU2GRIWRgK/JIdjL/oqjZACiwAO+54kHCWtFyXy+qF
         wr2w==
X-Gm-Message-State: AOAM531TVhuJN7kKQZsRCMYyXwatsFRzrFMBtaIeyHn5jEwhovZ1p497
        QwxV68KUuNbw5jxjRGf7zsU1ctMo207Xmw==
X-Google-Smtp-Source: ABdhPJwEaVAafJiNUBGc/6aAo5kFvJee7AcVDEmUW/VnaBEdHiKg4sRSSOPWpC2y5syKhi3OF6/vpg==
X-Received: by 2002:adf:a48c:: with SMTP id g12mr11752419wrb.382.1602351433372;
        Sat, 10 Oct 2020 10:37:13 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/12] io_uring: clean up ->files grabbing
Date:   Sat, 10 Oct 2020 18:34:06 +0100
Message-Id: <10823dc626299fef433d15a6dfe76c447e7ef9ee.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move work.files grabbing into io_prep_async_work() to all other work
resources initialisation. We don't need to keep it separately now, as
->ring_fd/file are gone. It also allows to not grab it when a request
is not going to io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 39 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 272abe03a79e..3a65bcba5a7b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -967,7 +967,6 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
-static int io_prep_work_files(struct io_kiocb *req);
 static void __io_clean_op(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
@@ -1222,16 +1221,28 @@ static bool io_req_clean_work(struct io_kiocb *req)
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_ring_ctx *ctx = req->ctx;
 
 	io_req_init_async(req);
 
 	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file || (req->ctx->flags & IORING_SETUP_IOPOLL))
+		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else {
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
+	if (!req->work.files && io_op_defs[req->opcode].file_table &&
+	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
+		req->work.files = get_files_struct(current);
+		get_nsproxy(current->nsproxy);
+		req->work.nsproxy = current->nsproxy;
+		req->flags |= REQ_F_INFLIGHT;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		spin_unlock_irq(&ctx->inflight_lock);
+	}
 	if (!req->work.mm && def->needs_mm) {
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
@@ -5662,16 +5673,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_req_defer_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	int ret;
-
 	if (!sqe)
 		return 0;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
-
-	ret = io_prep_work_files(req);
-	if (unlikely(ret))
-		return ret;
 	return io_req_prep(req, sqe);
 }
 
@@ -6015,33 +6020,6 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	return io_file_get(state, req, fd, &req->file, fixed);
 }
 
-static int io_grab_files(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_req_init_async(req);
-
-	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
-		return 0;
-
-	req->work.files = get_files_struct(current);
-	get_nsproxy(current->nsproxy);
-	req->work.nsproxy = current->nsproxy;
-	req->flags |= REQ_F_INFLIGHT;
-
-	spin_lock_irq(&ctx->inflight_lock);
-	list_add(&req->inflight_entry, &ctx->inflight_list);
-	spin_unlock_irq(&ctx->inflight_lock);
-	return 0;
-}
-
-static inline int io_prep_work_files(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].file_table)
-		return 0;
-	return io_grab_files(req);
-}
-
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -6153,9 +6131,6 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		if (!io_arm_poll_handler(req)) {
 punt:
-			ret = io_prep_work_files(req);
-			if (unlikely(ret))
-				goto err;
 			/*
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
@@ -6169,7 +6144,6 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	}
 
 	if (unlikely(ret)) {
-err:
 		/* un-prep timeout, so it'll be killed as any other linked */
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 		req_set_fail_links(req);
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7472B853A
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 21:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgKRUAn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 15:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgKRUAn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 15:00:43 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB3C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 12:00:42 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id o15so3423700wru.6
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 12:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NBubo3O76ADyDAjB3kRBuP00hYefnhmqNodZ9mrBEh8=;
        b=b0l8EliH4tbGnLfRFqP9Khz1h/TgIRZbespQB13tNgZySIyiuhj7Di4RT42VqW7AEZ
         4csN3TjnTo1f1eoVBtc5vEVsh7lNUIfx52y0mRURWWb+6sbQju0SOlSfDuqFLd41PexI
         i1ghEHG3Uw/jwVhXG9sdLlm9OatbrgfT9Iwwl7GeCDAwiHNmrabpBs/v+5ZIjcxeSaD9
         rqQprm8lAnP1KWD56b42YHuMgWA3LgzwKXyoqDL/nJ50NimdOQbEQ/U0KILsbBpdVIMY
         EzMNt0XthktANMTA+Ddw9oyGQl3Im1huatrbVxI1/fq4a1RmKLKcqlFjpFnhSYpJyNpd
         RtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBubo3O76ADyDAjB3kRBuP00hYefnhmqNodZ9mrBEh8=;
        b=WRVQZvPhctnemKqSXiQxhw8m9jJdGcE0WHOl2Xt/BAPQ9eFjdaN0Sh5Xmzrsiz5xAT
         ftvrBYJZF3/7py3/faMxwQtkKD8HlEYmKM1Lq2WK4VK6qJaLqDtT153mNfFQaBZ4FZQm
         GsX+TYFKyTpEQkapDEiAS8jnCuCp0CslgazzuaR33QBZ5LJWi/QJmS0uYZd5kYuXDmYE
         +A+QO+NNvCKwvoE4W1FKFPFw9emDXRlPhCKbqWUgcYKSB3fYOxWQ+OZe+sLXx9+kt6ZX
         UOQnv5726/fOErS0ofdwnVpjYLMI+JdvArIWhfe5vAtdg1xIP9GkpyyGYCvGRV+z39Jf
         VhDQ==
X-Gm-Message-State: AOAM531o3A7A20+ZdH4ahwB+SgE67k/A6FwUPyjEFOIea32g7X/DCZOs
        6akQ2eJde0+pOwqIaUpiG984FZ++5InJCw==
X-Google-Smtp-Source: ABdhPJxBevH1UldqoHUsD7UOe8p1KAIuFtWV3OM3H39kVVT469NedkM05Cb6z4FTvdkFXfBbgGEsjA==
X-Received: by 2002:adf:9d44:: with SMTP id o4mr6946723wre.229.1605729641339;
        Wed, 18 Nov 2020 12:00:41 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id h17sm30549828wrp.54.2020.11.18.12.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 12:00:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        bijan.mottahedeh@oracle.com
Subject: [PATCH 5.11] io_uring: share fixed_file_refs b/w multiple rsrcs
Date:   Wed, 18 Nov 2020 19:57:26 +0000
Message-Id: <b5c57cd24e98a4fae8d9fd186983e053d9e52f37.1605729389.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605729389.git.asml.silence@gmail.com>
References: <cover.1605729389.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Double fixed files for splice/tee are done in a nasty way, it takes 2
ref_node refs, and during the second time it blindly overrides
req->fixed_file_refs hoping that it haven't changed. That works because
all that is done under iouring_lock in a single go but is error-prone.

Bind everything explicitly to a single ref_node and take only one ref,
with current ref_node ordering it's guaranteed to keep all files valid
awhile the request is inflight.

That's mainly a cleanup + preparation for generic resource handling,
but also saves pcpu_ref get/put for splice/tee with 2 fixed files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e052011a186..8e769d3f96ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1039,6 +1039,16 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
+static inline void io_set_resource_node(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!req->fixed_file_refs) {
+		req->fixed_file_refs = &ctx->file_data->node->refs;
+		percpu_ref_get(req->fixed_file_refs);
+	}
+}
+
 static bool io_match_task(struct io_kiocb *head,
 			  struct task_struct *task,
 			  struct files_struct *files)
@@ -1927,9 +1937,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
 			  bool fixed)
 {
-	if (fixed)
-		percpu_ref_put(req->fixed_file_refs);
-	else
+	if (!fixed)
 		fput(file);
 }
 
@@ -1941,7 +1949,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-
+	if (req->fixed_file_refs)
+		percpu_ref_put(req->fixed_file_refs);
 	io_req_clean_work(req);
 }
 
@@ -6344,10 +6353,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		if (file) {
-			req->fixed_file_refs = &ctx->file_data->node->refs;
-			percpu_ref_get(req->fixed_file_refs);
-		}
+		io_set_resource_node(req);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
@@ -6725,6 +6731,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->ctx = ctx;
 	req->flags = 0;
 	req->link = NULL;
+	req->fixed_file_refs = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
-- 
2.24.0


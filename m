Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF0342353
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCSR1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCSR1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F61C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:04 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so9902170wrd.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1EBVCwgwpUQ5v/D1itVIudgrzIc+y8MCriiQQMsNYog=;
        b=ILYdvcPcypnw1hCm1bli17i6SVjZ7ENaamjA47aeJs4pIJSeW1eER2uS1Sx2EXeKEv
         VabxAo9hpJ/e6cBdCOIckjRmhGEBpc/Eg9vaEY+Hmu8oO7Tnb+gndWjKYKSBJ5xIF1QG
         VrX5TwoqsXoTvnXPn+els+wwzw1AvSUwpK+KimoRF/b74x3NIZHjZhh+xkDWimAvRu4C
         4yu6xgg8+cUNukwqb7czvil42zg0jhLqdityunw6kulPhFWtnC+YQ2l/7SNoUzPRQBKZ
         5PnNG0jcvCBPIwGem+EnR2S/q4ACKh7iZ1FG63op5186JySJXgbc8fYK1Lk/7ZK+0APb
         XyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EBVCwgwpUQ5v/D1itVIudgrzIc+y8MCriiQQMsNYog=;
        b=Y2EGGcjF64DT6M3wOs04Lp4HvX35Zj0Wr8nOakxNEOsV1hTgw9VwvrXfDpt6jygWWs
         2sqrWdEH03BoR+hPM7Ln1a2X5Q5ijaj8/G9uyp7tymUpYBn+PFuKEqHYpC2IEfoaOJYb
         sGKTcsuaYXdIrLpEcUR8kgV0AmdWyhq4EWmd+QV3XufV0n2Zbu3bSCclImohBj7XSaoZ
         ZtHD/liRCfdZyN3Uxu3uQaR1A9/Uw9tYJzxDLN2PiNK2oQEOWRea80Ssoi6OVt5uZLiE
         m2OZ5gDbLVXvJ8wGuxGVj2FfFIYCKvLqzBfR2G94GjYNR3CRuguCFY5Hoqwgl2bUQGEw
         zaPw==
X-Gm-Message-State: AOAM5307g5c9njl0CkonQqKiZspR/zDZzugP6ZxxDVNKPsjNpkSj9zED
        slGtQ7chB1klpgzgzem240D3IUF0XQ7ZTA==
X-Google-Smtp-Source: ABdhPJxKLJWA2WqrHAcv3x/hxFy81wIrgFJrYJ3BuTdHg51sHvD6wtx/yXaa3Vg493sCCMyX89FqTw==
X-Received: by 2002:adf:e391:: with SMTP id e17mr5596403wrm.285.1616174823095;
        Fri, 19 Mar 2021 10:27:03 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/16] io_uring: inline io_clean_op()'s fast path
Date:   Fri, 19 Mar 2021 17:22:41 +0000
Message-Id: <8522cae2c63bf73f6fd4c544a04830bece981ae5.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_clean_op(), leaving __io_clean_op() but renaming it. This will
be used in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e46e4d5c3676..afc08ec2bc6e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1030,7 +1030,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
-static void __io_clean_op(struct io_kiocb *req);
+static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req);
@@ -1061,12 +1061,6 @@ EXPORT_SYMBOL(io_uring_get_socket);
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-static inline void io_clean_op(struct io_kiocb *req)
-{
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
-		__io_clean_op(req);
-}
-
 static inline void io_set_resource_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1564,7 +1558,9 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 			set_bit(0, &ctx->cq_check_overflow);
 			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
-		io_clean_op(req);
+		if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+			io_clean_op(req);
+
 		req->result = res;
 		req->compl.cflags = cflags;
 		req_ref_get(req);
@@ -1620,7 +1616,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
-	io_clean_op(req);
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+		io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
@@ -1728,8 +1725,8 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 
 static void io_dismantle_req(struct io_kiocb *req)
 {
-	io_clean_op(req);
-
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+		io_clean_op(req);
 	if (req->async_data)
 		kfree(req->async_data);
 	if (req->file)
@@ -5927,7 +5924,7 @@ static int io_req_defer(struct io_kiocb *req)
 	return -EIOCBQUEUED;
 }
 
-static void __io_clean_op(struct io_kiocb *req)
+static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		switch (req->opcode) {
-- 
2.24.0


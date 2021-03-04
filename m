Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2F832D9C5
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhCDS5Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhCDS5L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:11 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ED6C061761
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:31 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u14so28846190wri.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9xE/it47CNXTLn4sIXkrcZxVqfb+TdGgv7ElAzp2SSE=;
        b=UnzXdYrDWWX4bRzQQQxs2DbPlVtYg0yzs3yBEk8AdyAqZOwTdonZzJfIx/xFJBnIm4
         WkhmltAOD+eyCvBa78ToMkblc5ROZE81t4wTebo/RIgQCE1tGHb6ofOG+Ngjgn924hfI
         yWhcAdnb0VyB/EbQbljZq7ibZsQyEWhNY5PYbyKUkTLqEXeQmYYIVsPhvbxhaI1FLsR/
         4/9EOtQklziUVy3IGnlt+2EsG3c3WdWjHhk/6UC6PH3uH+t+aRbKr0jgQaGytGdWFGOy
         IaBIrXYRQdTueHxAsMtHvgrtMNriDoA8x4mNK4+5i0uni2oLHnqthbjg6BQerhx0iB7Z
         lzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9xE/it47CNXTLn4sIXkrcZxVqfb+TdGgv7ElAzp2SSE=;
        b=ATg3DVFtt8q7V7mBsjgvY1nlY5RpTqnBh4w8KngMlbUgPSi9xykRtyrac+HX/4Odnp
         GG46UV65FkE8QANGbhAAQMWyjG3qbp2Y8nbwNPOqlSFNo8AQhN4A1ETl+/CsWIf5+HlX
         vXmpZfLCwCxp41z4Ks/3ah8KYHWUEnrgZwCfBvIsAq7mas6Y/foXNrDtsLUrW8luliZ8
         e6RjMtuoNU57YOeyp2QHhil2T7PrU3m0SzbjsdPMLEXD8afTX34ZtPYF3SO2cMM7g2II
         hLuaapSE+swzhgkojPrt0oO0DX2gd9vHw7FiVIJJGuvz+2sOdiqUDWvWkAiQJQOFxJHa
         EHfA==
X-Gm-Message-State: AOAM533AzsC242xkFep2kEavkaLKcFz/c250GsPJIJsvIsfs17Hsbjrh
        RBLD5N/FKs8RA2ah0wL6RHc=
X-Google-Smtp-Source: ABdhPJzSdYjoWcIt3c5DUowgXV+BKDTH2COWM3Zd2Z8WBuFMsOsyykt3OpuQRF/lx8Hr8AihnIPkeg==
X-Received: by 2002:a05:6000:1363:: with SMTP id q3mr5543767wrz.74.1614884189797;
        Thu, 04 Mar 2021 10:56:29 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/11] io_uring: inline io_clean_op() fast path
Date:   Thu,  4 Mar 2021 18:52:18 +0000
Message-Id: <ea095975590b3ae822572606291b79944fb9f805.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
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
index 869e564ce713..d50d0e98639b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1000,7 +1000,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
-static void __io_clean_op(struct io_kiocb *req);
+static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req);
@@ -1031,12 +1031,6 @@ EXPORT_SYMBOL(io_uring_get_socket);
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
@@ -1527,7 +1521,9 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
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
@@ -1574,7 +1570,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
-	io_clean_op(req);
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+		io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
@@ -1673,8 +1670,8 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 
 static void io_dismantle_req(struct io_kiocb *req)
 {
-	io_clean_op(req);
-
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+		io_clean_op(req);
 	if (req->async_data)
 		kfree(req->async_data);
 	if (req->file)
@@ -5812,7 +5809,7 @@ static int io_req_defer(struct io_kiocb *req)
 	return -EIOCBQUEUED;
 }
 
-static void __io_clean_op(struct io_kiocb *req)
+static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		switch (req->opcode) {
-- 
2.24.0


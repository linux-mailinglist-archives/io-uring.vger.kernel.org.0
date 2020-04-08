Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E431A1BBA
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDHGAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 02:00:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53046 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgDHGAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 02:00:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id t203so3883001wmt.2;
        Tue, 07 Apr 2020 23:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G6WvhC+hLx+3fIEi91fNw0FdlNcxoEn+fi468tTSdAQ=;
        b=SJJNR4ctvIgUv+WdIn5W6KW3yaOG814VSb3pIr0+O3Q8k1g+xzBWEaNMASG7dmMTrQ
         WJBX548T+un7tw+C1jS90LbTTF4CPHVWZwOGfmHRB4+7SB3Z4uh8QWye3+TuW6HE+6h7
         jz74PK57x+8iIPx4ntd39czAxda0See2GAaZuBEE5qQPJc6s4iCQtDr8guYOgZdWssHJ
         NAHFr/1CZetr3QwhMF34VHUNCHifLAHsCdmjUdFVXv1E8gLXPpHgYzi7/eKa0UKV6IPo
         BxpZJhgAiZJUXzSjvpYB07pPY9GV6XLzgbgO3HEgK+iMywJ3bUVUExNGucePP1smxzQp
         voTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6WvhC+hLx+3fIEi91fNw0FdlNcxoEn+fi468tTSdAQ=;
        b=BS0zV4svhM1UzhpnqI8FksD7jOKfh90JzJaFLR+T0Zj4AHxmrTFESbi370dq6XVDek
         fOuL6TU0I0ufsvEaUNlxcQL/enlGuLK+qtdWG9W6+/w0e9DTSrVvF1Fi3/38msWjucue
         Ox7LOwrigZpKruUObvnmxbAI/8Mz9Tgq0mZvWEUCjlmVLf138q7NwN3tgFELwW5tvrnA
         yoKusHtdk+dW9V77j64ViHIFILcT3HXKkv2qCcZ+UEvafE2tqtTzpIYOxHT5lCZMdNWS
         tRfARvOCTSL4XomgGLO6A2+Nvmi5/tZrOvz5bD5M7zeJ62kUp5a3QKPZQF7rd4cbClC6
         eRcg==
X-Gm-Message-State: AGi0PuZ1gmH8eCgS4kqFDrYeJP9L/jhReHcZ99QqY18C3wSKAjHsMTUj
        E9vaLqpfP8dRVPND12YUTkXzI5tB
X-Google-Smtp-Source: APiQypJ2uh8qINLBjl/1LJg0a9yT0VX2xInOlK01Xlb7bcP8dVT1XEXdIK8krxCWeEJB5ViZ/aBgnw==
X-Received: by 2002:a7b:c3cb:: with SMTP id t11mr2792517wmj.40.1586325601400;
        Tue, 07 Apr 2020 23:00:01 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b15sm33454986wru.70.2020.04.07.23.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 23:00:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring: don't read user-shared sqe flags twice
Date:   Wed,  8 Apr 2020 08:58:46 +0300
Message-Id: <d4f7cf7ff796e3cfdd54db36153dac29ea9f3a56.1586325467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586325467.git.asml.silence@gmail.com>
References: <cover.1586325467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't re-read userspace-shared sqe->flags, it can be exploited.
sqe->flags are copied into req->flags in io_submit_sqe(), check them
instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 072e002f1184..f8173a77434c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2930,7 +2930,7 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (sqe->flags & IOSQE_FIXED_FILE)
+	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2961,7 +2961,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (sqe->flags & IOSQE_FIXED_FILE)
+	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -3315,7 +3315,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (sqe->flags & IOSQE_FIXED_FILE)
+	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -3392,7 +3392,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
-	if (sqe->flags & IOSQE_FIXED_FILE)
+	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
@@ -5363,15 +5363,10 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
+			   int fd, unsigned int flags)
 {
-	unsigned flags;
-	int fd;
 	bool fixed;
 
-	flags = READ_ONCE(sqe->flags);
-	fd = READ_ONCE(sqe->fd);
-
 	if (!io_req_needs_file(req, fd))
 		return 0;
 
@@ -5613,7 +5608,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int sqe_flags;
-	int ret, id;
+	int ret, id, fd;
 
 	sqe_flags = READ_ONCE(sqe->flags);
 
@@ -5644,7 +5639,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 					IOSQE_ASYNC | IOSQE_FIXED_FILE |
 					IOSQE_BUFFER_SELECT);
 
-	ret = io_req_set_file(state, req, sqe);
+	fd = READ_ONCE(sqe->fd);
+	ret = io_req_set_file(state, req, fd, sqe_flags);
 	if (unlikely(ret)) {
 err_req:
 		io_cqring_add_event(req, ret);
-- 
2.24.0


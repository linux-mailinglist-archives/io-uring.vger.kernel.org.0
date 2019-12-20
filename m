Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61A91281A1
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLTRrs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:48 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40363 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfLTRrs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:48 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so10203883iop.7
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Nn5p181q86/g/6fP6feiYYJjedDp6onNrnjkykO+ns=;
        b=aJVtD57k4rLYWM268Yy9EbZC/1EPn26TMhIKRlaao5cXIUcsfd1qPY6ebXsVwjAigs
         I6A5v65EgIZebnqI010ov8OqdrC+BAdjMF9qO0q4QWelSn5NnlDgitgIh6T1TYBM+wbM
         jEjwB7KpEMcoUD245osElGqX3GLBEwRLxK0LNJL9bcEQvCRnJWipn6Ms9cGP8Lpf++Ld
         ER9pv7qyRCE3O7lzI04IL8dxFhlF9oFcKpNtdUpJl0qUSwhG0a7pf1b0put6hC1j23Aw
         Zqasvga+VFm4oGHmvpJ1Xd+zXhhJ/qqGO6A8uKLm/p6FfmjpP9y843NbllhvzoxMj799
         piPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Nn5p181q86/g/6fP6feiYYJjedDp6onNrnjkykO+ns=;
        b=OIbvzGs62rMrF+TQs4Ry8wzbf6Z3QJVuyvMoOZ6M5quo8nk+TcK3Gw3enB9grp9vJA
         cH54zsUVzeGjAf/n+E88tfx5ie79A56mo8RX/VoelN4pdJFzJqtjCUl1844vdH4wj7yF
         EEI9Epc5axepC2sIKwZxyPkTlSDHK0TnvxG9LwJL7HsHo6N+pTKI00nIMjcwZFVhaho7
         ipV4E9r4z2f/jfPM8ZZH6Ic1jOSWlT5KpZugIiqA3JrulKRPCIRlhZhZ3VFltd8IOO0y
         wzIwW1xY+LQNbOTnJBZkYJO/azfamKG0p4GppOn3kA5ds0cG1LA9pJCDB2Tj06mtivkv
         GCqg==
X-Gm-Message-State: APjAAAVAb0bX4sPAYOA+cm6U52GWMTRcI4zi+nXY6uHfHAkAl+1u7cLn
        kDa7/St3VgzCBwAe0yhKQKE6r6M4bPXMDA==
X-Google-Smtp-Source: APXvYqxEuPOdzeOmkOUXHcwt95HGzlxl2BZKLc8AMiUrEKu6q8Zq2JviCQnYlOdBm4tbLcLCWRENTw==
X-Received: by 2002:a05:6638:618:: with SMTP id g24mr13042117jar.87.1576864067304;
        Fri, 20 Dec 2019 09:47:47 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring: move all prep state for IORING_OP_CONNECT to prep handler
Date:   Fri, 20 Dec 2019 10:47:38 -0700
Message-Id: <20191220174742.7449-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add struct io_connect in our io_kiocb per-command union, and ensure
that io_connect_prep() has grabbed what it needs from the SQE.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b5f91d21fd04..2a173f54ec8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -339,6 +339,12 @@ struct io_rw {
 	u64				len;
 };
 
+struct io_connect {
+	struct file			*file;
+	struct sockaddr __user		*addr;
+	int				addr_len;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -382,6 +388,7 @@ struct io_kiocb {
 		struct io_sync		sync;
 		struct io_cancel	cancel;
 		struct io_timeout	timeout;
+		struct io_connect	connect;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -2406,14 +2413,18 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
 	const struct io_uring_sqe *sqe = req->sqe;
-	struct sockaddr __user *addr;
-	int addr_len;
 
-	addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	addr_len = READ_ONCE(sqe->addr2);
-	return move_addr_to_kernel(addr, addr_len, &io->connect.address);
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+		return -EINVAL;
+
+	req->connect.addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->connect.addr_len =  READ_ONCE(sqe->addr2);
+	return move_addr_to_kernel(req->connect.addr, req->connect.addr_len,
+					&io->connect.address);
 #else
-	return 0;
+	return -EOPNOTSUPP;
 #endif
 }
 
@@ -2421,18 +2432,9 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
-	int addr_len, ret;
-
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
-		return -EINVAL;
-
-	addr_len = READ_ONCE(sqe->addr2);
-	file_flags = force_nonblock ? O_NONBLOCK : 0;
+	int ret;
 
 	if (req->io) {
 		io = req->io;
@@ -2443,8 +2445,10 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 		io = &__io;
 	}
 
-	ret = __sys_connect_file(req->file, &io->connect.address, addr_len,
-					file_flags);
+	file_flags = force_nonblock ? O_NONBLOCK : 0;
+
+	ret = __sys_connect_file(req->file, &io->connect.address,
+					req->connect.addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
 		if (req->io)
 			return -EAGAIN;
-- 
2.24.1


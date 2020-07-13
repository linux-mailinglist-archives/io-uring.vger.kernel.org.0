Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EF021E116
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGMUBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGMUBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:01:23 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52837C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:23 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so18761085ejd.13
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Iq6G150s1t0Cc847vgc4OXMtR5WyUYVdBaqDm3auWC0=;
        b=jtq1B6urTyDD0FUqYAUvmltRtK56Guzsn7JfXBYTRv7Jpz4UDgbTJYEhy5BRy5SPYp
         9q+JFL6L81Ynvv5k/yJaoTha19Z1wZ2Twur42oQ3/512wh0fztAuVIuTIxvOPu3fPJzD
         NYtLJy1AGgpWAceksNB94xH/DRhBk0F6u7YsL82cvOf5pm4/R/45H7icMMp3TsBH9AbC
         mOogPcIxpsTTw6mdHSjdH8fhEEdUTMvGvicu4ftcAIWBYl6bBPnax4DJaWd/zWWAa7tA
         vkZ/yXZFi6I8e+qnXLvxwNDg76wu7PAkVcPZk5/AAfTRf3Vl9MB1hWCotECHHHXK5LkV
         0VIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iq6G150s1t0Cc847vgc4OXMtR5WyUYVdBaqDm3auWC0=;
        b=D+qIdTyobLAXpLcFjgTy+RN6vFUu4NLRCT+9ZFhrpbaoE0dxirYYoCyzlFNvyaIddf
         laAaJzXNtHthvs6+aA/x3+jkrMn29gYw5MSicNqpsxeO18lXCwqF/yFezjVXkdEIJSKJ
         55sDJ1FtAwsgpjgFQ4e4RflDqk5x+PJm6N+pBWlJpm3ihWtdPOqf+a6vKQoDDCnXbsoC
         RQgNE+adzyJ1Roxii0CrRrlOlLs823tcvPq/4gUy9C3IiEUdvz6WzahSP+10swdVahQ4
         P25EA0qDjpmlD+CZ+Yk0DA6VX/sNODpENdC2t4W7iEt7I8QnPOEQmfhhjip0GCTFRh/K
         oPSA==
X-Gm-Message-State: AOAM533CnrMn6YFZ2f3zbe7goikaNFszB3kGhNUyeNEaD0HQJaB41pqB
        y8UYh3p/V+Dvb6Sdi5lzlVc=
X-Google-Smtp-Source: ABdhPJxwY72TkwK3Sx830BTOwsmRCfhrmAYSf0Id9fAmsvdFgll+j+C9/tCx5xdHuIrzWfHzenXWHg==
X-Received: by 2002:a17:906:e215:: with SMTP id gf21mr1319806ejb.310.1594670482068;
        Mon, 13 Jul 2020 13:01:22 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm10520408ejp.51.2020.07.13.13.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:01:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: add a helper for async rw iovec prep
Date:   Mon, 13 Jul 2020 22:59:19 +0300
Message-Id: <a55aaddefb237194a8670ce750d15c5e3e421e3b.1594669730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594669730.git.asml.silence@gmail.com>
References: <cover.1594669730.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Preparing reads/writes for async is a bit tricky. Extract a helper to
not repeat it twice.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9c10070dcba..217dbb6563e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2871,11 +2871,27 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 	return 0;
 }
 
+static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
+				   bool force_nonblock)
+{
+	struct io_async_ctx *io = req->io;
+	struct iov_iter iter;
+	ssize_t ret;
+
+	io->rw.iov = io->rw.fast_iov;
+	req->io = NULL;
+	ret = io_import_iovec(rw, req, &io->rw.iov, &iter, !force_nonblock);
+	req->io = io;
+	if (unlikely(ret < 0))
+		return ret;
+
+	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	return 0;
+}
+
 static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			bool force_nonblock)
 {
-	struct io_async_ctx *io;
-	struct iov_iter iter;
 	ssize_t ret;
 
 	ret = io_prep_rw(req, sqe, force_nonblock);
@@ -2888,17 +2904,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
-
-	io = req->io;
-	io->rw.iov = io->rw.fast_iov;
-	req->io = NULL;
-	ret = io_import_iovec(READ, req, &io->rw.iov, &iter, !force_nonblock);
-	req->io = io;
-	if (ret < 0)
-		return ret;
-
-	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
-	return 0;
+	return io_rw_prep_async(req, READ, force_nonblock);
 }
 
 static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
@@ -3042,8 +3048,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			 bool force_nonblock)
 {
-	struct io_async_ctx *io;
-	struct iov_iter iter;
 	ssize_t ret;
 
 	ret = io_prep_rw(req, sqe, force_nonblock);
@@ -3058,17 +3062,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
-
-	io = req->io;
-	io->rw.iov = io->rw.fast_iov;
-	req->io = NULL;
-	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter, !force_nonblock);
-	req->io = io;
-	if (ret < 0)
-		return ret;
-
-	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
-	return 0;
+	return io_rw_prep_async(req, WRITE, force_nonblock);
 }
 
 static int io_write(struct io_kiocb *req, bool force_nonblock,
-- 
2.24.0


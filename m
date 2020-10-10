Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC22828A238
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 00:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbgJJWzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731228AbgJJTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:04:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C8BC08EBAF
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:18 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e18so13699039wrw.9
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=k6TnWPFmoy/MO2vLaAPWVoXiXBth4LJ72rq5rnRmF/0=;
        b=GP7YqMCC355Sby+usCMH4MaWGSPP3T5Lu5nX9fmLCk1HA3blBd75ML+CrqMrX9fEnD
         TFvyY/4tmjOd5n5807bwHxNJASTiH7cXItrJ4qVx+NUwJgo6FyDQRB2b3MqX2PYLyZcN
         xml5/nPX0VULQy51zkqJN4F8bonPZBsS7gi7wee97e+eXVAdwDbadf/Z0cK29jntjTdF
         sBBb8xNUQSuIOwEcGDXIkvREw53IZJCYUktK1O4stK9QadkUEvIDtOYPutKa+Qg+hI0+
         SSvD0cdiZb6HpBq8qxLP5XTzR4YVq/pxdjJWfafLh5J8cXQYtZIdUi1fuJCOpFZU8GkZ
         4OUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6TnWPFmoy/MO2vLaAPWVoXiXBth4LJ72rq5rnRmF/0=;
        b=uEywHr5bEHH4FEONEIHNI0YJv6gVJTweKYZ5+QW+hp9p/lqgJOUesv726Xks7crSjm
         rCbtw2dabkAqIvXz+o5fkx/rrdFHl4KoOKXckCAKZ3G0H19or3uZTm8WLcuPjUaR2wq7
         vnOzLpRJWk5Jucxj5YORnE+rdMF+ce4HbNMbM+VjCJ1ekE+nZZlpf58khTlBM2OUAQpp
         OhZ7A9n9vc9sXKU6CuDoulToYPh05t85GyFC10IRpoDnO5/sfDCcLlReQI5AbkaA8zFN
         dTDuXTz6ODKnIeYlHi04A1aV/84RRAxCr57/qRSMsbiIhswLgNK2+fBHI0RR2p3TbdXM
         Y+tQ==
X-Gm-Message-State: AOAM530BWjiemT8P8ZnGffGReFHayJE72u/a2//7ij6fduQD9lSJf5qx
        BpMoYBX97JbBLN2479afQOA=
X-Google-Smtp-Source: ABdhPJysktjxwTnZ9Z5AMRGDLuVkrD9R/WYctVwPGv2agNIhWHBjKy0wWmoH6rT7C7lm0uFt4nmVPw==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr21441162wrk.263.1602351437260;
        Sat, 10 Oct 2020 10:37:17 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/12] io_uring: use a separate struct for timeout_remove
Date:   Sat, 10 Oct 2020 18:34:10 +0100
Message-Id: <eef0f94bc079ff4135e0903286dc7d897b662867.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't use struct io_timeout for both IORING_OP_TIMEOUT and
IORING_OP_TIMEOUT_REMOVE, they're quite different. Split them in two,
that allows to remove an unused field in struct io_timeout, and btw kill
->flags not used by either. This also easier to follow, especially for
timeout remove.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 250eefbe13cb..09b8f2c9ae7e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -434,13 +434,16 @@ struct io_cancel {
 
 struct io_timeout {
 	struct file			*file;
-	u64				addr;
-	int				flags;
 	u32				off;
 	u32				target_seq;
 	struct list_head		list;
 };
 
+struct io_timeout_rem {
+	struct file			*file;
+	u64				addr;
+};
+
 struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
@@ -644,6 +647,7 @@ struct io_kiocb {
 		struct io_sync		sync;
 		struct io_cancel	cancel;
 		struct io_timeout	timeout;
+		struct io_timeout_rem	timeout_rem;
 		struct io_connect	connect;
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
@@ -5360,14 +5364,10 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len)
-		return -EINVAL;
-
-	req->timeout.addr = READ_ONCE(sqe->addr);
-	req->timeout.flags = READ_ONCE(sqe->timeout_flags);
-	if (req->timeout.flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
 		return -EINVAL;
 
+	req->timeout_rem.addr = READ_ONCE(sqe->addr);
 	return 0;
 }
 
@@ -5380,7 +5380,7 @@ static int io_timeout_remove(struct io_kiocb *req)
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_timeout_cancel(ctx, req->timeout.addr);
+	ret = io_timeout_cancel(ctx, req->timeout_rem.addr);
 
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
-- 
2.24.0


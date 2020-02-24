Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9E716A008
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBXIbY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:31:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53567 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXIbX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:31:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so8035593wmh.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 00:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wV4WyY7dHz29Sb2l29fN2iI7Y0Jmz9uVJPy2YZJPBAY=;
        b=IGFfSQ0sF5y3Brn+IRG0ULCpZBtP6G1/uG3/z04hSv8meOzTKN/Gv+Dl7A9SHPOWRw
         pFMCwd1wO+1KH9ajXaRIwu4PZ5r+ZixePWPwHtsCdEMBEplfctRDzx9ewk6qobpIiRxv
         aIuSabcssuC4vTcqX5zj1J5F1hxB0yOoB6b2M0ygmW87FfoH0F3WaQjs/z/nJfvrC/7g
         lJ54wpIEO40ZeWr6A4axETLD8EEFn2Xca1JkILbkXwdviXVdxy37LmBMtHxbSCK4FhRe
         3L0/x6vNz+53bwcu+Pl19BkrQiESg4JNOK+MrCt7wk+F3b3o2XBd1SOolB0cGGKfEeZz
         Sm8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wV4WyY7dHz29Sb2l29fN2iI7Y0Jmz9uVJPy2YZJPBAY=;
        b=Xxl7vzkr0JmTg0VI3IDNDNbHxlPGcPtbSCX+JhwGtFNeaZZBtT7nZMrrX0F3r7aCyU
         75Uh5G6S1f31YdvGVzrHQ9gj+90fX03xMPnHn0dfwwOHwJbYvsG7QMttrduacf6mYUSD
         gfUC2o8G+kgFXzYPIMoTuBQQHAGlsyMynQ9fc8YGiDUluoNIUY2mDSSQIU+C1yGYz3bv
         TAvhFEGqBMwUKvfGUAT39EJe9FVGMAR2cp7OsIs2i4NoCYow5KS3Te/jzldQ5uM0GJgs
         KR4HINPTvr/jvs1OwOomLf/+Pz8QqwQM8CsmILX8aBehzC++D6BGvHY4CYE1eicuTnKr
         CAFA==
X-Gm-Message-State: APjAAAVyXKi8k840ECUhbSNeMcl6a1zRcARnPhL0ZB24EU9rIKyFOR1Q
        FvxW+BN5YI/NG0W+OLzSYpA=
X-Google-Smtp-Source: APXvYqyPd33Brch3pGGtHVIukIDmtzyArv8sNANSaofgkzkcfkoEz8IDeYX+nCgGzoT8UGrakYE8oA==
X-Received: by 2002:a1c:e3c2:: with SMTP id a185mr20770823wmh.27.1582533079423;
        Mon, 24 Feb 2020 00:31:19 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id a16sm17946265wrx.87.2020.02.24.00.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:31:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 2/3] io_uring: don't do full *prep_worker() from io-wq
Date:   Mon, 24 Feb 2020 11:30:17 +0300
Message-Id: <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530396.git.asml.silence@gmail.com>
References: <cover.1582530396.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_prep_async_worker() called io_wq_assign_next() do many useless checks:
io_req_work_grab_env() was already called during prep, and @do_hashed
is not ever used. Add io_prep_next_work() -- simplified version, that
can be called io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 819661f49023..3003e767ced3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -955,6 +955,17 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
+static inline void io_prep_next_work(struct io_kiocb *req,
+				     struct io_kiocb **link)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+
+	*link = io_prep_linked_timeout(req);
+}
+
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -2453,7 +2464,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
 
-	io_prep_async_work(nxt, &link);
+	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
 	if (link) {
 		nxt->work.flags |= IO_WQ_WORK_CB;
-- 
2.24.0


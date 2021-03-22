Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89AB343681
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhCVCDU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCVCCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6917BC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:48 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z2so15011304wrl.5
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IUsrzBta+NsYGRnyko4u4l6df3OhHkD33vikmWXJeQA=;
        b=jBLMil1cM8pDKF/joHCnVxk1TxYxZChhNxOxx3jrW+i2t7VwlcT2MMwrcch9hyulp+
         P0MYfXg6FlUxbsI1cWfZNtZip0CEKRFfYiCZgVkqnOQ8fW3GS4ZfeHMWrvn41jHaIVWO
         l7fCjs8ry1idOVS7Z3991fOWXnFmYErBxD+zx9BgcY0zrGNvUTGKZgTiP9yjNcj2Nwxd
         VH5M5aNawPgKSkrSARugPI93KFvlTb5dQ48Cyv34gEtY/9JzRY1I9rgpAMr/q2LWZCwQ
         6aQMfpBzHuXVNVXx52QCjyeHmQqOfRmqubPDncp5xT+SZzYraLnerejMU4y/N10VtOKd
         hf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IUsrzBta+NsYGRnyko4u4l6df3OhHkD33vikmWXJeQA=;
        b=oabLCg6SKKag2vRIWt22HcIS4vThD2QwjGsxUJYH5fTRYEBgyzs2mF2nrDVh4WVzjm
         SajsPPd1L0DXEPIIktyBgi+iLexYIbSb+VkU/TfW4spgF5D29MF4Mp3lorSDmzBjv0IF
         tfdiTTTR+aSh8Ocl3ZtfqGJOxcNiVuNOWG7lGBk+8PtIMySmud/5OKPaOJE7+nkGyskz
         3KMfFBn/SR01IqCP2NctO2eFMDjWV9AmE9uTXmq4LTvpXr+uI39ZgCBeZVeYkZpd27D3
         L4x/STtEhKG8cPTGgAqBlaVbAiBZkN8ouPmM68cMy3nY67vwLOtxuPcgrQ131VM35tm2
         hdNg==
X-Gm-Message-State: AOAM531ka/bUTv7lrxQ7MNVoYEgaI0mPuQWWgbQLQWmsQvpAOO42IzDQ
        P9/2gTN6ZIQ9t/U0aBUZPgQ=
X-Google-Smtp-Source: ABdhPJxWLLHaIFzeblf6FAluNLQV1DeX3CT4uYJ2B4/C0y4S+3EwNZJzt7bieghNBASBlsE53jTuVw==
X-Received: by 2002:adf:ec0b:: with SMTP id x11mr15363986wrn.175.1616378567189;
        Sun, 21 Mar 2021 19:02:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/11] io_uring: don't init req->work fully in advance
Date:   Mon, 22 Mar 2021 01:58:29 +0000
Message-Id: <16a059a4fbc00cd5021efd9722c4ddea921f8500.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->work is mostly unused unless it's punted, and io_init_req() is too
hot for fully initialising it. Fortunately, we can skip init work.next
as it's controlled by io-wq, and can not touch work.flags by moving
everything related into io_prep_async_work(). The only field left is
req->work.creds, but there is nothing can be done, keep maintaining it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff238dc503db..8609ca962dea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1199,6 +1199,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
 
+	req->work.list.next = NULL;
+	req->work.flags = 0;
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -1209,6 +1211,18 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
+
+	switch (req->opcode) {
+	case IORING_OP_SPLICE:
+	case IORING_OP_TEE:
+		/*
+		 * Splice operation will be punted aync, and here need to
+		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
+		 */
+		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+		break;
+	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -3601,15 +3615,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (!sp->file_in)
 		return -EBADF;
 	req->flags |= REQ_F_NEED_CLEANUP;
-
-	if (!S_ISREG(file_inode(sp->file_in)->i_mode)) {
-		/*
-		 * Splice operation will be punted aync, and here need to
-		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
-		 */
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
-	}
-
 	return 0;
 }
 
@@ -6381,9 +6386,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	atomic_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
-	req->work.list.next = NULL;
 	req->work.creds = NULL;
-	req->work.flags = 0;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
-- 
2.24.0


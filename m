Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C73E4535
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhHIMFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMF3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:29 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D59C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so11350229wmd.3
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PaTirdyC7WRro17lMzks1mFzztbFR+j9fJ3ywAYy8C8=;
        b=nc3Itq5hXkiAoI3vTUfQMa0uPcZDYJSDDH2AY4g6cK9SPJ5BPtzza5TMGKQQ97abkY
         NqndZS+/rUoxTeHM3rfGXLzK7kZO1VdvlrO6jRYmtTD9bd142WgXHvSx0TWZvgQjZRxF
         LMRNifV39m/SBuo4kEzVUV9+P5n4djzrNE/umFBSRx6Smpbcaixyo/6ltJM/Png0X0hi
         DEOvp+sHeP5bkFB0DJc8nBZ1gbKP0IUrYNWTDPy4CV7xEmCcX4Qfud16I5UTtPEBpuDK
         cEtd9PXv9UefpMMTIOMt3itZBnDNO46YVqnwKhb2Ohot36NKr/fCXfgiiGgRxweN4Zsl
         qcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PaTirdyC7WRro17lMzks1mFzztbFR+j9fJ3ywAYy8C8=;
        b=HRe6MSkZSX8kDqfqeLMAyx12koodfDVmt/2A3DMw/UXzaVoqWF57FRTfIu+7/kvEki
         Nxw6t3WvjRMnEYriAl5MARY/7+XVqnTl8zJo6fYvZ6heMV2fCUHLTfk0yhn+96VhwGXd
         ieq15eOaR7I/QWY0xwIofZKpQWXrMVco5ntqaEJA7h6+1YDQaonS9PBIKFWYuVGfRtAh
         m97nCwkZFedRHBX1fudMbvo8kZBB66txf4TE1v7CWZArmataFkJ5HG1aFGwx9+ILSB/G
         HD1rrU7eEyIlnj1hiuirJ7m6zFOL6L4yMVU7wo1Qb30ESQ8NTmh/f7oOLP/lUjvD8wfn
         y+tw==
X-Gm-Message-State: AOAM530nsx3TZVAlWppcEJFVV7pvo6//Wnm91YufPGc9iu46iy1cDp7R
        Lt8f16HfOcfW8B6pElc35EA=
X-Google-Smtp-Source: ABdhPJxGaHUiC+8sSmInQLmqhfqa3UNeA4STjg3+Yaw+YPl8pErMGr7g9hzN2ptpKLNbjueQu/xTeg==
X-Received: by 2002:a1c:9dd5:: with SMTP id g204mr7694846wme.74.1628510708188;
        Mon, 09 Aug 2021 05:05:08 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/28] io_uring: clean io-wq callbacks
Date:   Mon,  9 Aug 2021 13:04:05 +0100
Message-Id: <851bbc7f0f86f206d8c1333efee8bcb9c26e419f.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io-wq callbacks closer to each other, so it's easier to work with
them, and rename io_free_work() into io_wq_free_work() for consistency.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42cf69c6d9b6..8f18af509afd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6299,6 +6299,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	req = io_put_req_find_next(req);
+	return req ? &req->work : NULL;
+}
+
 static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
@@ -7936,14 +7944,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static struct io_wq_work *io_free_work(struct io_wq_work *work)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	req = io_put_req_find_next(req);
-	return req ? &req->work : NULL;
-}
-
 static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
 {
@@ -7967,7 +7967,7 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 
 	data.hash = hash;
 	data.task = task;
-	data.free_work = io_free_work;
+	data.free_work = io_wq_free_work;
 	data.do_work = io_wq_submit_work;
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
-- 
2.32.0


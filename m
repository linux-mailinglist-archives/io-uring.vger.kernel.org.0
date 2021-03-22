Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CEE343683
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCVCDW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCVCCw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D888C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:51 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so8257930wmc.0
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=79y+qk/txdO63xfByobP0FV664vQd0LN+5y7zNxZLcY=;
        b=nBKDPBdU98rbZJ26QcLKag2CVlt13rzj1AV8NiNrFGp4Ft/FMenFxrxBfOFjhwaRFl
         oG5438qTklqYDE/tusZkjrtP7RenGrsAxa0nx8kx6ey0IWwwqf2GAtaJl4cFbPx25Geu
         SD8K9msieF4dElR48v3R/YdTkf9og8yjO2fDJ6uUxpN2odaZn+/9TQmm7/bdvk9ETZ5I
         6AbxsO4RBJzMtzHwoeKITOGEqYMKD2KVUZGWmJkT5uN5LqabxjTtZlyesz8+edElzaQi
         fZNPsnI/AtAuEOMlXOZj4VZcQvG046/0wGr8d6//HKFl9vlab5N8c+G++Hwy3ImxfyM8
         KwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79y+qk/txdO63xfByobP0FV664vQd0LN+5y7zNxZLcY=;
        b=SM9O4QEkPhzIzjm7HJhyNCchaHrShZTcqseEjC8fBWcAzNQ9NWywDgaLAG52Xkz+yN
         jhWQO/iAqONnEO+SC//oNaR/+3mE34F1en14iPRHfGj5KfirLdUuYlQS/cx7HTyfUNsd
         EcEJ9CWKIdieTe3gKWBtxZq6BsaigdRWIMHRIQA+h8rZ6SzYZO2f/xgeJFhilrT5ofkO
         85s8jOD519yWgkEdMlApPTFWhNRsYgYXLnTaQm6jOAdGiIloF4ZiXWKbCPK3kzZM7J4j
         H5hmMu/GIbO1BSy9sqzTTQnM5BtcRCZXQA1fuLsY7rGPOA4cRjLIaOoksfcYU9EtIpm3
         icsA==
X-Gm-Message-State: AOAM530hPeqdrb/S5FmSJUpwQqmYSIlcli5sIp6QErKIl0ZvXcG+n0hO
        hLQs9n+ifS0EfF11tigbJJY=
X-Google-Smtp-Source: ABdhPJwO50r5S0eBri0jJwRYHc1gvkRJmUw1ExXTcn86LA8daUVZJCZA8rsnDHds4EFLJS5nleGFPw==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr13529790wmq.60.1616378570300;
        Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/11] io_uring: hide iter revert in resubmit_prep
Date:   Mon, 22 Mar 2021 01:58:33 +0000
Message-Id: <2795b82e6f2b1c94872d42f9b4556548b87cb89d.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move iov_iter_revert() resetting iterator in case of -EIOCBQUEUED into
io_resubmit_prep(), so we don't do heavy revert in hot path, also saves
a couple of checks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cccd5fd582f2..775139e9d00f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2475,8 +2475,13 @@ static void kiocb_end_write(struct io_kiocb *req)
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
-	/* either already prepared or successfully done */
-	return req->async_data || !io_req_prep_async(req);
+	struct io_async_rw *rw = req->async_data;
+
+	if (!rw)
+		return !io_req_prep_async(req);
+	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
+	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
+	return true;
 }
 
 static bool io_rw_should_reissue(struct io_kiocb *req)
@@ -2546,14 +2551,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 #ifdef CONFIG_BLOCK
-	/* Rewind iter, if we have one. iopoll path resubmits as usual */
 	if (res == -EAGAIN && io_rw_should_reissue(req)) {
-		struct io_async_rw *rw = req->async_data;
-
-		if (rw)
-			iov_iter_revert(&rw->iter,
-					req->result - iov_iter_count(&rw->iter));
-		else if (!io_resubmit_prep(req))
+		if (!io_resubmit_prep(req))
 			req->flags |= REQ_F_DONT_REISSUE;
 	}
 #endif
@@ -3310,8 +3309,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
-		if (req->async_data)
-			iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		goto out_free;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
@@ -3444,8 +3441,6 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
 	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
-	if (ret2 == -EIOCBQUEUED && req->async_data)
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
-- 
2.24.0


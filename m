Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD44930F468
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbhBDN71 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbhBDN45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:57 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B468C0617AB
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:09 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q7so3537477wre.13
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PJaKFrT21lsGDpJ/SAeHllDzmSUJ5V17en8CIYJJJ58=;
        b=RQn7HdP9k22D1U8gkCvtwvnzAkDl5y/yocJi8H1CinhPvSdp+A5DmO2DQ71m/lwsQw
         aGUzX+kVrhQ0ctMk2ftPpw7nQ3IpXHE39Op5/0PiwsSE7jx76nlWGYkpijmG8o+DLv46
         YMl4M+0m/W2yQiaqQ+83is+0nT8uMvfVklrosSvsis57bp1kK774jRGzUmcZkE1X1E4T
         RhgSv2ejmIKbrRcKzMYP1pj2UNo4qij/n8zrOlMHve9c+YlpmuJfLT86Nd1iVANPu+CS
         CVizS2g7iVNiHyuog53S21UBQS/pC70eB57pc6gPLjLt+nZwxjORY/evWkyfSzJAjFHl
         4D+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJaKFrT21lsGDpJ/SAeHllDzmSUJ5V17en8CIYJJJ58=;
        b=EYsPNmr+jlQBxl5mYR2UMsrBnoyQkMIslaDcARa/3v5+B5rgWaJpEaLP9UjA/Is++X
         yIyf/STlvIm4Q5xpy32Ym5amjg+wHjmIbfdufRWopM1lUCY0rtRGKEaDzFtsSB2zhtCV
         2vCw8W+rqghxZahWE7C4B4hOGKQaOLfxmvnM4BfPD878A+5NoxbtmfR1GCNWPzSQXZKz
         6udJx6NvG0Cq5h7xxmqWyEQXTcGeiNKMVDjAtmNOjM2DMmxVz4qm9wVI6mFvaGsyTF8l
         4/+cKtWFnOtFF7DrzfadSKnWHSy2utHtzD/ohCT3NKaf8QxlhgdrMwAjeWYFpYyCZFHk
         NzRA==
X-Gm-Message-State: AOAM531l/5U9DKctg6+bwShq72n5zYFDfEhzITW6hs1I+4WJGPxYrLLn
        WEDbyTx75osWpHzrWlbBD4Usp1uqwKJJJw==
X-Google-Smtp-Source: ABdhPJw8IpdTqbOjsOpuEEnG4MkW5nxb6DedXTIIqNip9VjSg1zcBj/ANdqrdFM2dGkQ4P6eryqaEg==
X-Received: by 2002:adf:f843:: with SMTP id d3mr9424259wrq.172.1612446968320;
        Thu, 04 Feb 2021 05:56:08 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 08/13] io_uring: inline io_read()'s iovec freeing
Date:   Thu,  4 Feb 2021 13:52:03 +0000
Message-Id: <1d9c617d54657299adcdb40e4e2b638f7a64cb19.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_read() has not the simpliest control flow with a lot of jumps and
it's hard to read. One of those is a out_free: label, which frees iovec.
However, from the middle of io_read() iovec is NULL'ed and so
kfree(iovec) is no-op, it leaves us with two place where we can inline
it and further clean up the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25fffff27c76..35ad889afaec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3530,14 +3530,18 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
-	if (unlikely(ret))
-		goto out_free;
+	if (unlikely(ret)) {
+		kfree(iovec);
+		return ret;
+	}
 
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
-		ret = 0;
-		goto out_free;
+		/* it's faster to check here then delegate to kfree */
+		if (iovec)
+			kfree(iovec);
+		return 0;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3560,8 +3564,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		return ret2;
 
 	rw = req->async_data;
-	/* it's copied and will be cleaned with ->io */
-	iovec = NULL;
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
 retry:
@@ -3580,21 +3582,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	 * do, then just retry at the new offset.
 	 */
 	ret = io_iter_do_read(req, iter);
-	if (ret == -EIOCBQUEUED) {
-		ret = 0;
-		goto out_free;
-	} else if (ret > 0 && ret < io_size) {
-		/* we got some bytes, but not all. retry. */
+	if (ret == -EIOCBQUEUED)
+		return 0;
+	/* we got some bytes, but not all. retry. */
+	if (ret > 0 && ret < io_size)
 		goto retry;
-	}
 done:
 	kiocb_done(kiocb, ret, cs);
-	ret = 0;
-out_free:
-	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
-	return ret;
+	return 0;
 }
 
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.24.0


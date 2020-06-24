Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B901520798D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 18:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405228AbgFXQvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 12:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405222AbgFXQvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 12:51:53 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D73DC061573;
        Wed, 24 Jun 2020 09:51:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f139so3180615wmf.5;
        Wed, 24 Jun 2020 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tL+FccFFqTcjb6bX8W92TsCzve7bd5pnKbHcClrHQeo=;
        b=nnJbg9BwB2MDzp+XFIl6Y0inVMl+qLwVAqt3Yk/thT3bpIHsZChRhB2RPcWdjuJ088
         ZupJe/xGzNOWjXKswEWZvLeIUqSoh+2HfnluEeh3kyXMAmZmncI7qb5UAqI2ap3yPTws
         tfHjgE1mHLbppxXp3jEmAo5CKUIsbnH3sKWQKlPAjxg4L8Si5/Nr6o5u8LIKaqzHl/SQ
         /wMdarhNNgdsjy59n70NpGQoktrUH5glsKLWlh5eljxL1NsJyzyvguzV610Wq/b0/Ly2
         jfDLLo2U0Yt9q+1JI6RdpyUob2hE7s2JNF5B13yfoJpMzN86P1HjPSBYvNcwdLmQj92z
         9dMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tL+FccFFqTcjb6bX8W92TsCzve7bd5pnKbHcClrHQeo=;
        b=oyZSLLMnuMZxzx0k9nzfXW8nI+YRyMDY9RnUhzFpkObZESVLEEoiZ+gDJHJ056qcew
         hi9g2ZL6z0vqw38+SeCcS2WAqhDXmvHYaN8RlPbltpnU5UWulnT19z0HvcbNh9BKExtv
         rbUXfYOdxdETt/qre/0Glc/ML06S3h9dUbQKsNR9PnQAgTySYJ7te/g78gKF2hRPGrta
         jzSrX0X49m18Mk290B8B1d+4fhPCb6y0rccivuxa6V97y8yoSePPDRty9nc+8SK6ABgO
         BuhwzZsHglbjBCbutaJuwQfD3h/L8sQcHzVfK4qONFk7d/kQ2uaoOzvx84dACOlcoqG5
         /gFw==
X-Gm-Message-State: AOAM532Vqqh21huP8q2QZ1TwgWq31XnSQ16yMgpw3vmF5OnksJF1U60/
        5BSotZHi2qK4dX+QkklJSPCnYb4Z
X-Google-Smtp-Source: ABdhPJxTJXfYP902VI5+AR3tlUf5MufajhaM3ibZnApzolBSYbtbU7XYycnPlyaM6oYDlZLbUFlORQ==
X-Received: by 2002:a1c:9acf:: with SMTP id c198mr30746114wme.172.1593017510071;
        Wed, 24 Jun 2020 09:51:50 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id z16sm18138182wrr.35.2020.06.24.09.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:51:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix hanging iopoll in case of -EAGAIN
Date:   Wed, 24 Jun 2020 19:50:07 +0300
Message-Id: <22111b29e298f5f606130fcf4307bda99dbec089.1593016907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593016907.git.asml.silence@gmail.com>
References: <cover.1593016907.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_do_iopoll() won't do anything with a request unless
req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
it, otherwise io_do_iopoll() will poll a file again and again even
though the request of interest was completed long time ago.

Also, remove -EAGAIN check from io_issue_sqe() as it races with
the changed lines. The request will take the long way and be
resubmitted from io_iopoll*().

Fixes: bbde017a32b3 ("io_uring: add memory barrier to synchronize
io_kiocb's result and iopoll_completed")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..fb88a537f471 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2104,10 +2104,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_poll_complete() checking ->result */
-	if (res != -EAGAIN) {
-		smp_wmb();
-		WRITE_ONCE(req->iopoll_completed, 1);
-	}
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
@@ -5592,9 +5590,6 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file) {
 		const bool in_async = io_wq_current_is_worker();
 
-		if (req->result == -EAGAIN)
-			return -EAGAIN;
-
 		/* workqueue context doesn't hold uring_lock, grab it now */
 		if (in_async)
 			mutex_lock(&ctx->uring_lock);
-- 
2.24.0


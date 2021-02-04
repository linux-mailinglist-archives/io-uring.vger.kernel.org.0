Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE030F46E
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhBDN7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbhBDN5P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:15 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45749C0617AA
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u14so3625035wri.3
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u2sZsuA1gwqrwzhYkW+iThgq2wcXwxju3aV6Q0zgH9g=;
        b=XPqO4K2XEyxS9Ekdp4M6phq3E8MHK6vSe7CRZxfXPCZrN/DKEBOSZ3rY/JBywEwzL/
         +dHPHf2wRPHZH8RrnuG/KMtxW0Ljh+R8aysU58f9BW2KHrpfC1OX2gLYIzeaMz4jUkQj
         aAijDBSqJ8+6y/aCKql0iBa9Dj8ECV92WGinraUCOrVu3yBqrdCt4lv5lecQ/EUy5c1B
         8UUDOoSWrDZtV3Ozocid/b0YlHjNFqP1SqXXvfx6ehMBLFtG5CyenvnQ9r2BTEQ5U+KJ
         Z48d0BDtZ29Hptv6nmb05as216ww6RtEklSzlumY90YwgdLS0oIrX9y4WPVObIfwwLh+
         0Y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2sZsuA1gwqrwzhYkW+iThgq2wcXwxju3aV6Q0zgH9g=;
        b=gaU9n/FDpz6QfDhK9yQ1vnFBi56tbgw6xELXNVGZS83ywjKaPXTejSuhvpM7Fajof/
         p/Uh4aOyCi3h/gLnvUNwpSDkl1Zb1/yZrBin+tSrB+GQbJ1WSUEb3yHUwhCm/J9qs60R
         xWN2GcT6jtR74eeZ0vCXDk7zV/Gnha48oZazIjYtRCF4IYTNRm8jUJU7gL7z5ub2EzT9
         VleatRtKBMKmtATqFU5GgmcfKqROWphuTWcSRUz9nMQMdaQ/OVKUCCehP/0dkwLXieME
         TxeMCvxE7/SdIMHksbfc7s9n0nvGTuE/8Fwi4lCFOZYsqAoJgFyNTN5P3KaGV1Hq9bMO
         HHWw==
X-Gm-Message-State: AOAM5305ponUrHlEbE7eHyJFLorMnHSEvPt635rZOy7RTXx8G0SSwtj4
        iNsLOb+X0ONDQt1DMyZVj3E=
X-Google-Smtp-Source: ABdhPJwq5ewpWQsFWp1FCglyhDxohGlX+4tJqurXM32MamGLWWD3nI3geZa60yCXb9bRmZNfFPK+7Q==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr9278377wrv.319.1612446967046;
        Thu, 04 Feb 2021 05:56:07 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 07/13] io_uring: don't forget to adjust io_size
Date:   Thu,  4 Feb 2021 13:52:02 +0000
Message-Id: <d681bfe1971f9034e9b381df4da3e9016fe81a64.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have invariant in io_read() of how much we're trying to read spilled
into an iter and io_size variable. The last one controls decision making
about whether to do read-retries. However, io_size is modified only
after the first read attempt, so if we happen to go for a third retry in
a single call to io_read(), we will get io_size greater than in the
iterator, so may lead to various side effects up to live-locking.

Modify io_size each time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8492d62b6a1..25fffff27c76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3548,16 +3548,11 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
-	} else if (ret <= 0 || ret == io_size) {
-		/* make sure -ERESTARTSYS -> -EINTR is done */
+	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
+		   (req->file->f_flags & O_NONBLOCK) ||
+		   !(req->flags & REQ_F_ISREG)) {
+		/* read all, failed, already did sync or don't want to retry */
 		goto done;
-	} else {
-		/* we did blocking attempt. no retry. */
-		if (!force_nonblock || (req->file->f_flags & O_NONBLOCK) ||
-		    !(req->flags & REQ_F_ISREG))
-			goto done;
-
-		io_size -= ret;
 	}
 
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
@@ -3570,6 +3565,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
 retry:
+	io_size -= ret;
 	rw->bytes_done += ret;
 	/* if we can retry, do so with the callbacks armed */
 	if (!io_rw_should_retry(req)) {
-- 
2.24.0


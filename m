Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265C41E291A
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgEZRf4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389298AbgEZRfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4CFC03E96D;
        Tue, 26 May 2020 10:35:49 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y13so2774690eju.2;
        Tue, 26 May 2020 10:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nRX6u3zz0OKwOieaXnEp6XQva7owuarf1QtPzrmJEm0=;
        b=r7uAYESRaZbpTvvm7Ac72vwBgOq1ff8zio0vNtN/HgsNzsD+hbgLsK188U1o+goqWe
         9B64L4dvvK7mPmzQ+oHzbCQQXtmqDtbPn3elAsrB8Q+D3zNJdwG98frOLGctFRVx8WVo
         Z653Gucqvq5qCt0DrTheExkOfOxIZMHJ5r8UEERzyn6FFMInz66ssa1HLl3v97QdJBa2
         yzdQquI18pmdcTgF9c8RwSuMZYhi8lkAxxNvZz+VjzFXo9yD7l0pQq7KdVfSQQz0sgGN
         3o6MBXfmp2KuRjnFuTPXqGissbUzc7ed3vkR8TkiD5wOKmj/UyvkBTs2McVgTOb/OzPk
         qi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRX6u3zz0OKwOieaXnEp6XQva7owuarf1QtPzrmJEm0=;
        b=fDekg661vUgUhNbAVjq9BkzXPX8o7Wd5ztJISZ9fQdQ4EG0RU+rGiuU2nyGf9YvBKB
         gfQDdfTYPrt0GeNLPAJc7f7DqP4szhedKJhosJbElDW1rqVjs41Cx8FezeXHtWTvREIy
         oUI+o5QTWQ+g/y3xiN+50qg7t/QyaLQaQPgpzueDYk5GVRYd//ingm1wyzVRTfW+6MV9
         QgJxemxYoKdIiez44H6SFJP6zeHaOrwETHUf0BieIQ7CRSGOt1VILzcsidKCcUetgj6B
         rUarevEOo75wHNyleSYPk2zr8nQguAa5V0uUA1TlynQsmrUegDloeG11yzIN//fjPtGn
         fmFA==
X-Gm-Message-State: AOAM5314FC3bUHt+GEZXzCTHZRfKlP1qP/hWV6h0++JBH4dyzYm85zPY
        /OAzadiGKsWNOK2BaBG7XqU=
X-Google-Smtp-Source: ABdhPJwabf0+AUmNcf4SEUiDsU8lbmw9CZIYg0rzyQ65tH+Eh9Ip2KxeDmtBqxwbaV3IFWJqQfckfw==
X-Received: by 2002:a17:906:14d3:: with SMTP id y19mr2084886ejc.466.1590514548532;
        Tue, 26 May 2020 10:35:48 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] io_uring: get rid of manual punting in io_close
Date:   Tue, 26 May 2020 20:34:06 +0300
Message-Id: <7ba646691b413f40f1c43d37d4356e451c38395f.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
References: <cover.1590513806.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_close() was punting async manually to skip grabbing files. Use
REQ_F_NO_FILE_TABLE instead, and pass it through the generic path
with -EAGAIN.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index acf6ce9eee68..ac1aa25f4a55 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3492,25 +3492,15 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 
 	req->close.put_file = NULL;
 	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
-	if (ret < 0) {
-		if (ret == -ENOENT)
-			ret = -EBADF;
-		return ret;
-	}
+	if (ret < 0)
+		return (ret == -ENOENT) ? -EBADF : ret;
 
 	/* if the file has a flush method, be safe and punt to async */
 	if (req->close.put_file->f_op->flush && force_nonblock) {
-		/* submission ref will be dropped, take it for async */
-		refcount_inc(&req->refs);
-
+		/* avoid grabbing files - we don't need the files */
+		req->flags |= REQ_F_NO_FILE_TABLE | REQ_F_MUST_PUNT;
 		req->work.func = io_close_finish;
-		/*
-		 * Do manual async queue here to avoid grabbing files - we don't
-		 * need the files, and it'll cause io_close_finish() to close
-		 * the file again and cause a double CQE entry for this request
-		 */
-		io_queue_async_work(req);
-		return 0;
+		return -EAGAIN;
 	}
 
 	/*
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C14213FCD
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGCTRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTRF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:17:05 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3AAC061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:17:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so35304604ejn.10
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=n6C4ECRkxoD5uQ8ns4xUcc1rMSw0MLKt0aSPa8Xwbq4=;
        b=ejouC0VjCjSgM5SigzyORkFsOP1dnQTZ80xeIenJgXoDSY8RHzr/bxHzIeHZPc9CcP
         f9J4vD0bpnl6/hf0YluzOWoSn47bslu7k17hQwOKJK/JsQXJHlghBM4wBaig2Ink4EC9
         za1eyBnMqRRmmMLnnu/U4mxiUZjsJymF+7cENTBhjhEJx3l+CsKE9d9aIF8DKpOPTz2n
         w5LlH2YCbGqPVRZ4HPD2GItFjUXeEnRZIC8ZngmiGo0qFgUJL+cAWV0QAv5wN/b4pnFi
         ES1g4SdaHnDuneD+2EsxKiFes4pfcxbXsag6lzkoe6v6WaluAalkbWe6QV2beVplOn21
         YMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n6C4ECRkxoD5uQ8ns4xUcc1rMSw0MLKt0aSPa8Xwbq4=;
        b=Ss8AMQXU3PTgwwNQbJhdoQYQneTcwPizg3hh7a9XNFGBCSQyZPhFrZZM+y2tsd3MXO
         BN/H/k5+UFHspKpg65f1r8oqeDLRdUe0ZOudpMYuluJGr7A0EJ8ekOuc0n+XeweOUXgw
         tNKWNLLMYFFxrjQ9t7uRYnEkpvjXplkXT6wIZpWCWHpvISYl8vVuxQotXjH4prxZuzUZ
         Z9Fj32EDqboq2YZz7ZZuqj3z1UkZiiBtcpF2JLC4FwZ1Efzgm5WbqZB0KXh5WTF36wKo
         nIRe3ZCmIFywS2hKUBfEfr8gf78gUQz5XKqQs56tjrkLg3+vuw+TNcq4keBiNyklbZTX
         mhSQ==
X-Gm-Message-State: AOAM532iYrf2Jk53i31mljO1qcS9Klx4bHjlypjc3LNb46QIsA0Pa7v1
        K8U/ScJm008hPDLu2vvXuH0=
X-Google-Smtp-Source: ABdhPJxNwF+GyLPMLc4oldBQ5Xa0gezy6v8NIPgxNfi1LSVWvWmCTNrQb1oLINZ3bx/o/obXVORlJQ==
X-Received: by 2002:a17:906:2b92:: with SMTP id m18mr35612694ejg.218.1593803823761;
        Fri, 03 Jul 2020 12:17:03 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id p9sm9907883ejd.50.2020.07.03.12.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 12:17:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix mis-refcounting linked timeouts
Date:   Fri,  3 Jul 2020 22:15:06 +0300
Message-Id: <d5326fa6b1f0b38b24e63425141cb4a7e38d4919.1593803244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593803244.git.asml.silence@gmail.com>
References: <cover.1593803244.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_prep_linked_timeout() sets REQ_F_LINK_TIMEOUT altering refcounting of
the following linked request. After that someone should call
io_queue_linked_timeout(), otherwise a submission reference of the
linked timeout won't be ever dropped.

That's what happens in io_steal_work() if io-wq decides to postpone
linked request with io_wqe_enqueue(). io_queue_linked_timeout()
can also be potentially called twice without synchronisation during
re-submission, e.g. io_rw_resubmit().

There are the rules, whoever did io_prep_linked_timeout() must
also call io_queue_linked_timeout(). To not do it twice,
io_prep_linked_timeout() will return non NULL only for the first call.
That's controlled by REQ_F_LINK_TIMEOUT flag.

Also kill REQ_F_QUEUE_TIMEOUT.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51132f9bdbcc..f0fed59122e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -538,7 +538,6 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
-	REQ_F_QUEUE_TIMEOUT_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
 	REQ_F_TASK_PINNED_BIT,
 
@@ -586,8 +585,6 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
-	/* needs to queue linked timeout */
-	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* req->task is refcounted */
@@ -1835,7 +1832,7 @@ static void io_put_req(struct io_kiocb *req)
 
 static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
-	struct io_kiocb *timeout, *nxt = NULL;
+	struct io_kiocb *nxt;
 
 	/*
 	 * A ref is owned by io-wq in which context we're. So, if that's the
@@ -1846,13 +1843,7 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 		return NULL;
 
 	nxt = io_req_find_next(req);
-	if (!nxt)
-		return NULL;
-
-	timeout = io_prep_linked_timeout(nxt);
-	if (timeout)
-		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
-	return &nxt->work;
+	return nxt ? &nxt->work : NULL;
 }
 
 /*
@@ -5695,24 +5686,15 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_arm_async_linked_timeout(struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
-	/* link head's timeout is queued in io_queue_async_work() */
-	if (!(req->flags & REQ_F_QUEUE_TIMEOUT))
-		return;
-
-	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	io_queue_linked_timeout(link);
-}
-
 static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *timeout;
 	int ret = 0;
 
-	io_arm_async_linked_timeout(req);
+	timeout = io_prep_linked_timeout(req);
+	if (timeout)
+		io_queue_linked_timeout(timeout);
 
 	/* if NO_CANCEL is set, we must still run the work */
 	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
@@ -5886,8 +5868,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 
 	if (!(req->flags & REQ_F_LINK_HEAD))
 		return NULL;
-	/* for polled retry, if flag is set, we already went through here */
-	if (req->flags & REQ_F_POLLED)
+	if (req->flags & REQ_F_LINK_TIMEOUT)
 		return NULL;
 
 	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-- 
2.24.0


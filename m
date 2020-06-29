Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B320E233
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 00:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbgF2VDM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 17:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731143AbgF2TMs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:12:48 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87262C008653
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so15922543wrs.11
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=q+Qkef4bGbBNJwiv+4EzsFQ8aQx2kFKr6I4V03HsYuc=;
        b=RDwOZFU+v/lDxbfwpJRgHq2DOF4A08zajtVK1v32r/RsmvWzUp08S0od8Fv1g1WiTv
         bJonFpsuT8CMLj7vyiNZOBRmRuM2Lz/pH5S8IO2iwu2t2cmyymkxIOUpr4J7BmJ9ZKMe
         HllVBl5UR4KASCpNT046oW0YCuzqLy5UbAG+NXtiwNODPf4HC6+koIIhFpWoIFfJa3EU
         99r2XFFzgPj3dJ/bGCMee+Atl7OWfd66hYRDyB8ZyUId5RKgNEjBtPcKOeozl6l73Qf9
         fapJ5mAVP2KKVIYJR/erzZNdo6JA/cUbnnoyvWppqdHRDjcFxJpvkzoSWy/CBCofmP9O
         TrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q+Qkef4bGbBNJwiv+4EzsFQ8aQx2kFKr6I4V03HsYuc=;
        b=mUqKh9iXqE3HC9hbFO4tFjVIR9zPRWkrSxad3pXDFCHpTq+ZspR6U0ukETZLmluMv4
         QPmZ4AKOYkH4kY7shxkTArFCf5bvatwWWttVIpP1chMAFJJP751kfh3+8HKKyhgsTJbn
         ktN2iPWbC/53DNqotDF+BVX3bY5YZ7jwiHjR1uun+kQju2n+YaUAKwnwsEFFs0HJA1cO
         aUDLTutgpnyLtfcX+27Hugu9zwpWx2zI60wJGPpCKdSWzWYKnRLy+KwlptHMa2H4rtQs
         97OInhjGKDKr4z/5mYEY9+1gfKeKBxf7ZXlAkQJ418uROBUJx9SpbAs3GdEb+i3TvwUx
         9hKg==
X-Gm-Message-State: AOAM532v523buq4lJVOOSsv3+Jjtif5hpuHziYoKJu6uclXfxp/MODOG
        v9KtBH0ygNANg2n9Q8tINmc=
X-Google-Smtp-Source: ABdhPJxOnx0WTJGJL3MVRyTaquRlgeFw+lB8r6H4WFj7QHUBE71KL4srmbPFye8OQxybbKhgTGc6TA==
X-Received: by 2002:adf:fe4b:: with SMTP id m11mr16008315wrs.36.1593425688256;
        Mon, 29 Jun 2020 03:14:48 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: replace find_next() out param with ret
Date:   Mon, 29 Jun 2020 13:13:00 +0300
Message-Id: <1dfd65994ba9c5d72fabc51e3f0a0bdab36bff0d.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593424923.git.asml.silence@gmail.com>
References: <cover.1593424923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generally, it's better to return a value directly than having out
parameter. It's cleaner and saves from some kinds of ugly bugs.
May also be faster.

Return next request from io_req_find_next() and friends directly
instead of passing out parameter.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4cd6d24276c3..52e5c8730dd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1578,7 +1578,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		io_cqring_ev_posted(ctx);
 }
 
-static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
+static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
 
@@ -1588,13 +1588,13 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 	 * safe side.
 	 */
 	if (unlikely(list_empty(&req->link_list)))
-		return;
+		return NULL;
 
 	nxt = list_first_entry(&req->link_list, struct io_kiocb, link_list);
 	list_del_init(&req->link_list);
 	if (!list_empty(&nxt->link_list))
 		nxt->flags |= REQ_F_LINK_HEAD;
-	*nxtptr = nxt;
+	return nxt;
 }
 
 /*
@@ -1620,10 +1620,10 @@ static void io_fail_links(struct io_kiocb *req)
 	io_cqring_ev_posted(ctx);
 }
 
-static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
+static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
-		return;
+		return NULL;
 	req->flags &= ~REQ_F_LINK_HEAD;
 
 	if (req->flags & REQ_F_LINK_TIMEOUT)
@@ -1635,10 +1635,10 @@ static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (req->flags & REQ_F_FAIL_LINK)
-		io_fail_links(req);
-	else
-		io_req_link_next(req, nxt);
+	if (likely(!(req->flags & REQ_F_FAIL_LINK)))
+		return io_req_link_next(req);
+	io_fail_links(req);
+	return NULL;
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
@@ -1701,9 +1701,8 @@ static void io_req_task_queue(struct io_kiocb *req)
 
 static void io_queue_next(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt = NULL;
+	struct io_kiocb *nxt = io_req_find_next(req);
 
-	io_req_find_next(req, &nxt);
 	if (nxt)
 		io_req_task_queue(nxt);
 }
@@ -1753,13 +1752,15 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
  */
-__attribute__((nonnull))
-static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
+static struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 {
+	struct io_kiocb *nxt = NULL;
+
 	if (refcount_dec_and_test(&req->refs)) {
-		io_req_find_next(req, nxtptr);
+		nxt = io_req_find_next(req);
 		__io_free_req(req);
 	}
+	return nxt;
 }
 
 static void io_put_req(struct io_kiocb *req)
@@ -1780,7 +1781,7 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 	if (refcount_read(&req->refs) != 1)
 		return NULL;
 
-	io_req_find_next(req, &nxt);
+	nxt = io_req_find_next(req);
 	if (!nxt)
 		return NULL;
 
@@ -4465,7 +4466,7 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
+	*nxt = io_put_req_find_next(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
@@ -5915,9 +5916,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 
 err:
-	nxt = NULL;
 	/* drop submission reference */
-	io_put_req_find_next(req, &nxt);
+	nxt = io_put_req_find_next(req);
 
 	if (linked_timeout) {
 		if (!ret)
-- 
2.24.0


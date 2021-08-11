Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076AD3E97A6
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhHKS3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHKS3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:37 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B65C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x12so4344948wrr.11
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Me5ETaFy2e8ulxN76hpi3bGyOG7/e7KwQ+wt4g9oXfg=;
        b=rk0fLpYTNcdsi+0jb5gxBG+B2r8CfTkMd/5KgPkfFbmm1ChuI+Td3KmPzQoGhlSXw6
         R9dwhpMveBq2p0fnmXdqQIgpEaa8XSrARZ1zn1XbMlGQ14Mhu86Zz7R2C6hBb2xfMS9S
         ylqvfenBVIbyGOS+RQWQ2liO5avLrE01eH9wwgM2bUQV6MxFunrrb/Us45R5TNdjGEGO
         SHf4ydbTO/XCjYrPVmHAemnNhjlNlWYqii7b6C+PolQWVt1gbI9EcGl8Q36kiULaGNnt
         xHZkThwTFCJ01PK3b9laFU/TXA9OaF9jcf5xKZKdKjBHddGeqRn6mvAf8rkA2okREej9
         wzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Me5ETaFy2e8ulxN76hpi3bGyOG7/e7KwQ+wt4g9oXfg=;
        b=uOcBq3Ob2lTEc00dUtzwYu+Fl4opOB0QXjq7PczQyH33OKsRV3sSJ3A7ZmAtCC/Iri
         rjYghHsqvg8hsWceqTnzhhPbcMBS1IpDnjcYkdZVI3xLYwZDVoEhTa/htydoMIqpX+NN
         T29oh2b3dhGnAXs0qJTZFYtp6UIz/S3WfbpDtyaMO7Spf4ULtgrX1ETzOhYHQe8WAoZ/
         +t07QC88OzW3CARpDWd51Y7TgScXDGqSJXJpl+QuwFlLgZFeWdfjkNgzutBfyHfCBCIj
         pjEg+bc4+mVnxmbWALNr9dwVNRiHzGpgrOyQY085asFJ3HqMb5thtfsjcIU2td3oNwhm
         v7DQ==
X-Gm-Message-State: AOAM532GBmCG6f2WfQPrLROEx8UEirFEJhMc9g7S7crJ49lkiJRW8d9n
        OSjAgfODITGh91m9L7nzQyUbj9Xak/M=
X-Google-Smtp-Source: ABdhPJz8hFDIQBGA6OI4lWcegAqoElqm/ptSUwZJI0qAEedhXd8WJ0AWvq47T7bAlpSa03niuCx54w==
X-Received: by 2002:a05:6000:12cf:: with SMTP id l15mr21804177wrx.381.1628706552013;
        Wed, 11 Aug 2021 11:29:12 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/5] io_uring: skip request refcounting
Date:   Wed, 11 Aug 2021 19:28:30 +0100
Message-Id: <8b204b6c5f6643062270a1913d6d3a7f8f795fd9.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
References: <cover.1628705069.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As submission references are gone, there is only one initial reference
left. Instead of actually doing atomic refcounting, add a flag
indicating whether we're going to take more refs or doing any other sync
magic. The flag should be set before the request may get used in
parallel.

Together with the previous patch it saves 2 refcount atomics per request
for IOPOLL and IRQ completions, and 1 atomic per req for inline
completions, with some exceptions. In particular, currently, there are
three cases, when the refcounting have to be enabled:
- Polling, including apoll. Because double poll entries takes a ref.
  Might get relaxed in the near future.
- Link timeouts, enabled for both, the timeout and the request it's
  bound to, because they work in-parallel and we need to synchronise
  to cancel one of them on completion.
- When a request gets in io-wq, because it doesn't hold uring_lock and
  we need guarantees of submission references.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9529dae2c46e..374e9da26106 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -710,6 +710,7 @@ enum {
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
+	REQ_F_REFCOUNT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -765,6 +766,8 @@ enum {
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
 	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	/* skip refcounting if not set */
+	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 };
 
 struct async_poll {
@@ -1087,26 +1090,40 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	return atomic_inc_not_zero(&req->refs);
 }
 
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
+	if (likely(!(req->flags & REQ_F_REFCOUNT)))
+		return true;
+
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
 	return atomic_dec_and_test(&req->refs);
 }
 
 static inline void req_ref_put(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	WARN_ON_ONCE(req_ref_put_and_test(req));
 }
 
 static inline void req_ref_get(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
 	atomic_inc(&req->refs);
 }
 
+static inline void io_req_refcount(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_REFCOUNT)) {
+		req->flags |= REQ_F_REFCOUNT;
+		atomic_set(&req->refs, 1);
+	}
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5185,6 +5202,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
+	io_req_refcount(req);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
@@ -5375,6 +5393,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
+	io_req_refcount(req);
 	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
@@ -6266,6 +6285,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	struct io_kiocb *timeout;
 	int ret = 0;
 
+	io_req_refcount(req);
 	/* will be dropped by ->io_free_work() after returning to io-wq */
 	req_ref_get(req);
 
@@ -6435,7 +6455,10 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 		return NULL;
 
 	/* linked timeouts should have two refs once prep'ed */
+	io_req_refcount(req);
+	io_req_refcount(nxt);
 	req_ref_get(nxt);
+
 	nxt->timeout.head = req;
 	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
@@ -6542,7 +6565,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->fixed_rsrc_refs = NULL;
-	atomic_set(&req->refs, 1);
 	req->task = current;
 
 	/* enforce forwards compatibility on users */
-- 
2.32.0


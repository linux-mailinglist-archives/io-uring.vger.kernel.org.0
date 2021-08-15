Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946B23EC85F
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhHOJlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhHOJle (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E3AC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u16so2223548wrn.5
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JQvFvTilzsXB6UMnXng6zsnfLOtbOCmZMx8zGVQo23Y=;
        b=flNUkVYJOduQwv3+fA6wbV4Qv+DRwSOI+oOrcifzCXK4Hl/4L3uimdyVTRTnk68Zup
         qMfTOUgGtYBlusx6MUWk5Z6mOGW1ik9Ue5/sBhkBGFRHjA2rL5tkwu4s2XDnQa5iKmxn
         nX7//X5b5l042pkBrqPzd0+6v5E7pgFlmn97Lpb+a76+xHZBvt5mzZFfJGV7VYWsS/BM
         W+SXk5U0xamAbYiI4Tv/VT3xpsSL8IdcG0Tf6Y88RihGTKVdl2fUsK3bEsc1JKgS+AO5
         s6kDhj03Ua+LCNXSZfsI4/uU/WwbBEan40r3R822smVQMJ8KWvbo6RCwhZfYrwj6u1PB
         6XPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQvFvTilzsXB6UMnXng6zsnfLOtbOCmZMx8zGVQo23Y=;
        b=JTy43dcO/Nvb+IdWbSblW+YboJdAs4d4Wi1OpZdnsVrUTyMfshx5jTB/4Xl6NdQvBq
         MY7+SMjm+qbPdMvsgzScxpy1Z0yyJJG6a4AnqjQZtNeB2CzrNmD/te79L7EZem7ouuVa
         9CSHvT8AZrljTuIIQyKEkTkz6p0g2kmBNVGykkAutYFx4+S1oaqyUw+/2p3h5UbWr5xH
         qNoQArFkfXDT6Z9qquJtiVV3+ur0Up2VjFkD2v2BOmbMzhqiF3U1jhXw0SXhNEpz62aw
         TiBtdc2aMCMZ9jhDx1PW/w7mayKyJq9lHVeadXXq+y5IDhSaoK5hEp+vU7GMUtpMSJuK
         U54A==
X-Gm-Message-State: AOAM532U2xLsaw8xN2DTqG5f+kUhqwmS51C6VzcS69wq52Eeqy+wV8Fb
        fONI0mkOxvTIoktslOW3vVk=
X-Google-Smtp-Source: ABdhPJyp1GCD+aADU86BM/sxIRUXZrFgKai4HuPBg8h1MZ3ueAQpEYUzz9isVz+IV1rRRN/yTQrGTg==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr12205550wrp.176.1629020463631;
        Sun, 15 Aug 2021 02:41:03 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/9] io_uring: optimise iowq refcounting
Date:   Sun, 15 Aug 2021 10:40:18 +0100
Message-Id: <2d53f4449faaf73b4a4c5de667fc3c176d974860.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a requests is forwarded into io-wq, there is a good chance it hasn't
been refcounted yet and we can save one req_ref_get() by setting the
refcount number to the right value directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51c4166f68b5..761bfb56ed3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static inline void io_req_refcount(struct io_kiocb *req)
+static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
 {
 	if (!(req->flags & REQ_F_REFCOUNT)) {
 		req->flags |= REQ_F_REFCOUNT;
-		atomic_set(&req->refs, 1);
+		atomic_set(&req->refs, nr);
 	}
 }
 
+static inline void io_req_set_refcount(struct io_kiocb *req)
+{
+	__io_req_set_refcount(req, 1);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1304,8 +1309,8 @@ static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 		return NULL;
 
 	/* linked timeouts should have two refs once prep'ed */
-	io_req_refcount(req);
-	io_req_refcount(nxt);
+	io_req_set_refcount(req);
+	io_req_set_refcount(nxt);
 	req_ref_get(nxt);
 
 	nxt->timeout.head = req;
@@ -5231,7 +5236,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
-	io_req_refcount(req);
+	io_req_set_refcount(req);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
@@ -5419,7 +5424,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
-	io_req_refcount(req);
+	io_req_set_refcount(req);
 	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
@@ -6311,9 +6316,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	struct io_kiocb *timeout;
 	int ret = 0;
 
-	io_req_refcount(req);
-	/* will be dropped by ->io_free_work() after returning to io-wq */
-	req_ref_get(req);
+	/* one will be dropped by ->io_free_work() after returning to io-wq */
+	if (!(req->flags & REQ_F_REFCOUNT))
+		__io_req_set_refcount(req, 2);
+	else
+		req_ref_get(req);
 
 	timeout = io_prep_linked_timeout(req);
 	if (timeout)
-- 
2.32.0


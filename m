Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5203EC865
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhHOJlk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbhHOJlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:40 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EBDC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so12757660wms.2
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NdSDd15AM5EVbkpji+DIEnsICiSok/ZoR20/Hz0P1Oc=;
        b=bT035HzFTPab0spgqdt25KfuuCSThZORpzjxPBBNj91Zv0raVXbHcueuji8Urj28l7
         /6W0AW1GEBAilR0gn+8wWB1DwX6LqubUJR0fP5fa+zL1oYwwV2qe6X4ZZmppSPNxSLWF
         E7wXmc3tLynuPffOxrf1lFmePvCPqdqd5+ji+ebw5h0EzL1uVzAxwHQAVm9mCElQfZ87
         gNpwgMJR0PPcGLMO1m1MXuc+E67puLSrzbIkY8s0U1StqFkaysIHx0I/AAeZoxxXk0El
         RCxanfOiYpIBhzej8siL6Wai/kvuIXAVoDyP199/i+e//ODMouRqq0ko87qcAPFjjoQf
         9rdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdSDd15AM5EVbkpji+DIEnsICiSok/ZoR20/Hz0P1Oc=;
        b=p/2y/h++ZohtMhhUahrolgyo+hN66X5EEWk583mzrB2Axx0VBkX1s+cnd0nITNi/Hd
         9TTVTETRHet7d8d+9Ne2M2sAEpyZb8luKHjAZOINDGeVw7Yt0eyWaVZUndfHLj/BOeZw
         AqB0eRr+Hd7osKYKsDOXcnU9JRhvGt32UGsTZ6Ki66yXLbc02oAkvTWqKgUtQcuEyhHR
         hmzsNYIPdWgeZHyrusbimlkY5uomOFtP7duxhVT3Rk3O9ReFUq3sNvowa9YFKZ/uCFwr
         +D9jU6j4U6hgJO4THSSZkbwjgiACPEcJ99YTxfjkvRpCjCnqEpMsmAqEVX9wbIpLj0Be
         WzhQ==
X-Gm-Message-State: AOAM531CEFFE/j0XocgM1iahhIIQ/i9B9YLnfTmGUBoQaqr7c744JNZ8
        5UawlE7/hTirfuFmdmALlbw=
X-Google-Smtp-Source: ABdhPJxn08dqNsmlvBt4LtdqiOiFYsDO6UsjaQ3uQD5rsetoCPlTmPdhpSRSDPb3oxSoF9lN+phxZQ==
X-Received: by 2002:a05:600c:2e48:: with SMTP id q8mr2691220wmf.38.1629020469206;
        Sun, 15 Aug 2021 02:41:09 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 7/9] io_uring: simplify io_prep_linked_timeout
Date:   Sun, 15 Aug 2021 10:40:24 +0100
Message-Id: <3703770bfae8bc1ff370e43ef5767940202cab42.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The link test in io_prep_linked_timeout() is pretty bulky, replace it
with a flag. It's better for normal path and linked requests, and also
will be used further for request failing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ece69b1217c8..abd9df563d3d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -710,6 +710,7 @@ enum {
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
+	REQ_F_ARM_LTIMEOUT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -765,6 +766,8 @@ enum {
 	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
 	/* skip refcounting if not set */
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
+	/* there is a linked timeout that has to be armed */
+	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
 };
 
 struct async_poll {
@@ -1300,23 +1303,18 @@ static void io_req_track_inflight(struct io_kiocb *req)
 
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt = req->link;
-
-	if (req->flags & REQ_F_LINK_TIMEOUT)
-		return NULL;
+	req->flags &= ~REQ_F_ARM_LTIMEOUT;
+	req->flags |= REQ_F_LINK_TIMEOUT;
 
 	/* linked timeouts should have two refs once prep'ed */
 	io_req_set_refcount(req);
-	__io_req_set_refcount(nxt, 2);
-
-	nxt->timeout.head = req;
-	req->flags |= REQ_F_LINK_TIMEOUT;
-	return nxt;
+	__io_req_set_refcount(req->link, 2);
+	return req->link;
 }
 
 static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 {
-	if (likely(!req->link || req->link->opcode != IORING_OP_LINK_TIMEOUT))
+	if (likely(!(req->flags & REQ_F_ARM_LTIMEOUT)))
 		return NULL;
 	return __io_prep_linked_timeout(req);
 }
@@ -5698,6 +5696,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return -EINVAL;
 		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
 			return -EINVAL;
+		req->timeout.head = link->last;
+		link->last->flags |= REQ_F_ARM_LTIMEOUT;
 	}
 	return 0;
 }
-- 
2.32.0


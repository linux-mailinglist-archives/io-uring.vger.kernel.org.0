Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E987647656E
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhLOWJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLOWJG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E81DC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so78912607edb.8
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pOLap9r+e8iPP2oidvnJd718DT7X9awjIvaFePtKPZk=;
        b=NFmuDkCBz0axKw2TBfRoTMikfkD9Kgj9euUnLoNiMwPxrihYYwCwJJCR4qzlAoUp7K
         RvGm6kr8uHXvYVQpnQmWpVP09/oW3Yb5mjcWJRIps0kM2g+hHbuJKvZ2TBVavYKYGGgn
         nNIbHkiIN5Yz7CUsTRKNLZ3yUq8nwLZwbvKaiY8uTOK1CqdXpxTozyWpjkjj/Y3oW8TB
         EHaGmTdOBzNUFaeINB0AV9EXrmczJ/y8ugJEWNYf2mILpOFiVv1oCAl7ke8WRl62f04a
         4DqBnIX4Ogu1gE+Z8++CQ7rhUVhnqGErCeDmRvolZcNTWqXhGAxXQfGS4QxOqXfJOHMm
         ygIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pOLap9r+e8iPP2oidvnJd718DT7X9awjIvaFePtKPZk=;
        b=BS0sJ26XLFvq2yPlj6Q5r+9t11Zq01V2028/w5pCFStUUT6RhMCkYHTMD5RfjE+kg4
         V6FUnlc5mfeU9b9XOg3nOP9hUz9Pt1hUxcPg0w7MfdNtBPRY98JtR7WEJmhjO9mOccgb
         G6SYDI4As0bhYDYvhJv8qd3EmVPEfs1BDSiheLV4321hp7UUm7SladXPUKQp+FH79cuX
         4ghVRik4ZTP5k7mINgnQy9LaodofJ4wNi7hirwghvcq1zi80n4rz6953qNQDgk1+KGSA
         Hii6ExzEdQ0oN9NalC0j+SClq8KaiiJ9wkKLlIUcv4b3iKqbJGMrocwauc6umvtvEbvW
         iaAQ==
X-Gm-Message-State: AOAM531V5nEUKjwcSxEMEVLJ5PSRVXSaPVhDjF8PTyrEAY6ujQ989Yfd
        LDgtZLK+82Jv4d4hqdcqgmXofyPLXFk=
X-Google-Smtp-Source: ABdhPJx8RQ/ePjAyswAd+1KRHNy3OdaScNfU+zEms/FYKGIl0unbjmLq375mhsucJZciYyyng/SOmQ==
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr17019902edv.159.1639606143887;
        Wed, 15 Dec 2021 14:09:03 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring: refactor poll update
Date:   Wed, 15 Dec 2021 22:08:45 +0000
Message-Id: <5937138b6265a1285220e2fab1b28132c1d73ce3.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clean up io_poll_update() and unify cancellation paths for remove and
update.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 62 +++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 416998efaab8..972bc9b40381 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5960,61 +5960,51 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
 	bool completing;
-	int ret;
+	int ret2, ret = 0;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq) {
 		ret = -ENOENT;
-		goto err;
-	}
-
-	if (!req->poll_update.update_events && !req->poll_update.update_user_data) {
-		completing = true;
-		ret = io_poll_remove_one(preq) ? 0 : -EALREADY;
-		goto err;
+fail:
+		spin_unlock(&ctx->completion_lock);
+		goto out;
 	}
-
+	io_poll_remove_double(preq);
 	/*
 	 * Don't allow racy completion with singleshot, as we cannot safely
 	 * update those. For multishot, if we're racing with completion, just
 	 * let completion re-add it.
 	 */
-	io_poll_remove_double(preq);
 	completing = !__io_poll_remove_one(preq, &preq->poll, false);
 	if (completing && (preq->poll.events & EPOLLONESHOT)) {
 		ret = -EALREADY;
-		goto err;
-	}
-	/* we now have a detached poll request. reissue. */
-	ret = 0;
-err:
-	if (ret < 0) {
-		spin_unlock(&ctx->completion_lock);
-		req_set_fail(req);
-		io_req_complete(req, ret);
-		return 0;
-	}
-	/* only mask one event flags, keep behavior flags */
-	if (req->poll_update.update_events) {
-		preq->poll.events &= ~0xffff;
-		preq->poll.events |= req->poll_update.events & 0xffff;
-		preq->poll.events |= IO_POLL_UNMASK;
+		goto fail;
 	}
-	if (req->poll_update.update_user_data)
-		preq->user_data = req->poll_update.new_user_data;
 	spin_unlock(&ctx->completion_lock);
 
-	/* complete update request, we're done with it */
-	io_req_complete(req, ret);
-
-	if (!completing) {
-		ret = io_poll_add(preq, issue_flags);
-		if (ret < 0) {
-			req_set_fail(preq);
-			io_req_complete(preq, ret);
+	if (req->poll_update.update_events || req->poll_update.update_user_data) {
+		/* only mask one event flags, keep behavior flags */
+		if (req->poll_update.update_events) {
+			preq->poll.events &= ~0xffff;
+			preq->poll.events |= req->poll_update.events & 0xffff;
+			preq->poll.events |= IO_POLL_UNMASK;
 		}
+		if (req->poll_update.update_user_data)
+			preq->user_data = req->poll_update.new_user_data;
+
+		ret2 = io_poll_add(preq, issue_flags);
+		/* successfully updated, don't complete poll request */
+		if (!ret2)
+			goto out;
 	}
+	req_set_fail(preq);
+	io_req_complete(preq, -ECANCELED);
+out:
+	if (ret < 0)
+		req_set_fail(req);
+	/* complete update request, we're done with it */
+	io_req_complete(req, ret);
 	return 0;
 }
 
-- 
2.34.0


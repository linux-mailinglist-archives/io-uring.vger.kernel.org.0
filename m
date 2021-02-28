Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB63274EB
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhB1Wkl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhB1Wkk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:40 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ADCC06178B
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:24 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m1so12674543wml.2
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kk/K+eqDZ9DmyIhzyNlbZoSXo2/sUHm+eJImMtzabG8=;
        b=QQSHgifxy8tAQnsRRNPxjZ5ih1ejj3oH4VcKeyxPJi+BTMsHY1zOINlToi2kxj1DkB
         JK15dmXlnVJXBFgcJZkZBhampWx5v/nz1qFG5HozS4hEFd9AytxkHBNsrhGaB51WefxR
         kqm4LDP2zQzZl/2FybpAJ993ZrmEpTYozVkl/YcXCatSDEetFL9LpCzVrhxOHE0emkV5
         +inWZrSrERolz8Jaa1nKdKl2uBPBu9swBIRLc0cq2+IwS1I+QYZknzH7ZJgiiu8y4XZJ
         x1Kz4kHRnTutgbzFMaIqIZLr8Ugb99WTG6ZpsO1QedIGyB6Bfx5Qft/aahD+ERVtcbMj
         wWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kk/K+eqDZ9DmyIhzyNlbZoSXo2/sUHm+eJImMtzabG8=;
        b=qbnPDehY3lnGB1BNQs9ElqV5Q20GDY07b7vGGsRwHkgsDcWmZBHWj9ntgnOi+paAQG
         hoYN3JBYJG/PQyh/Yd6SUuwb20+i++Bkf1aj9Ve4hCtH/t1Y//eO6litwiow8RCavXGy
         j5Su/Surx7QX97qa13l8E+PHFjOo1diTXLY7cPAKGJABWeUJ0+Ew8yFUelKdwBof9HrD
         YhmoxzZNVBwH4dNZcpqEfNvu97imyM14zKxN1SZrRT6n4lGG9L7yqL3nKDUdgzdtVuKx
         6lXtYaNSqDRBzYls0nksOF1Rc8UH4VOJtuibj0IZ559K5UREgQDiXX+nh2ZuwZz/Q5PB
         IUPQ==
X-Gm-Message-State: AOAM531SrJgxpkkzQfbqyLBcMpVDdfxcqLaieUB57TzTT/T5XiMz+640
        R2NZ8R5NT6DR3/U13ynEEmo=
X-Google-Smtp-Source: ABdhPJwS0vlglq98g+vsZNsP2QiQ/E9Rz1loKTiKoRSMOPzDeHV58bzw1ME1zuSwg7WDuT6cUAZ6SQ==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr7165775wmo.8.1614551963053;
        Sun, 28 Feb 2021 14:39:23 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/12] io_uring: refactor provide/remove buffer locking
Date:   Sun, 28 Feb 2021 22:35:13 +0000
Message-Id: <5faa47941348f99297ca9a813a663362b85298a9.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always complete request holding the mutex instead of doing that strange
dancing with conditional ordering.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75ff9e577592..c40c7fb7fc2e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3893,14 +3893,9 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail_links(req);
 
-	/* need to hold the lock to complete IOPOLL requests */
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, issue_flags, ret, 0);
-		io_ring_submit_unlock(ctx, !force_nonblock);
-	} else {
-		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, issue_flags, ret, 0);
-	}
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
 	return 0;
 }
 
@@ -3987,15 +3982,9 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-
-	/* need to hold the lock to complete IOPOLL requests */
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, issue_flags, ret, 0);
-		io_ring_submit_unlock(ctx, !force_nonblock);
-	} else {
-		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, issue_flags, ret, 0);
-	}
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
 	return 0;
 }
 
-- 
2.24.0


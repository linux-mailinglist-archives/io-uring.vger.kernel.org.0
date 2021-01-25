Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AD302E51
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 22:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbhAYVtA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 16:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732833AbhAYVib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 16:38:31 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA0C061794
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 13:36:28 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 31so8455171plb.10
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 13:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d8wjGfx6VBL20ZT4nFGhgu4zRLg6ZpeJjDuu01CJdF0=;
        b=gOcdnsXidS3ash8MqdQyVE7+0MmiMNyRyaUJsQMLS7dt8oEGCFe5h9p7GEm76JSWCZ
         DWC/I82fTO46Akvtdl2CYpNxlr7d+UFR4uiHvGhhQF1yS06Sq3FFgyRX8cdZhlHiekbx
         t1gnxsyBb5DaQSN6OXeg8JiccqOsqXgHtCMwtrMAfKUIGDeHZf51lRBrEIKbUAebg58K
         w6tjN8ZMaBGRHl+iW5hkNW+DLvmvZ5GCpppJKCbCvQ+SqT4ZKZrN6mI2SnDaeBtz+w4/
         wvsY/Fcer9qj6aTt/vMTAJoOqknvg/V8t0eVpn1SEtJRF/Z6ibpWeODxKRQav+3j5V0i
         dyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8wjGfx6VBL20ZT4nFGhgu4zRLg6ZpeJjDuu01CJdF0=;
        b=osT3Jpihy+0AigTemU+0Z+tjkcy0EFjPstuADLvWLkpbn7INukg/wAt/GEQ20Oco7M
         YJ7D+JMqEQGxnXWyILLlydKW8ibomcbZeHuKmTPCPfFBVFv4wPoQA08C3JG4hZFYgOiv
         VX7scWDSTweDMRZrCa9vT5fEsUx4QF3NGL0wELEZMhI+D5AN/SPdeP8F8VA9eri+PWmu
         VDypb1PwUZX3P1RpFhcwCVT7nlS8aWd1kNhqSxQbw4N3nlkbZ0Ok6CwYhcWs9LMr8Xdh
         W3EXwrO/7mM7E3foJ9LiIYwl1HF0k2T8maJkCnXCQJBTs5Pm7uqYxt0jMJG7p3kHvQNx
         hkBw==
X-Gm-Message-State: AOAM532H7Fu8EBR4J1NJjRTcgLxv149Otshg47QIi5PJQXzJlaGNs4F6
        S680ERLYCejP1Kx7gFfRsoUZ9g==
X-Google-Smtp-Source: ABdhPJxtwEGOltI6AlPmhbLRUVDEPWQPQlh6vKdL9M+quHpeFAAjq+v7+YRNQS9qmOsSV9ywcID8CA==
X-Received: by 2002:a17:902:9f8b:b029:e0:a90:b62 with SMTP id g11-20020a1709029f8bb02900e00a900b62mr2466674plq.70.1611610587617;
        Mon, 25 Jan 2021 13:36:27 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i3sm9638913pfq.194.2021.01.25.13.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:36:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: use AT_STATX_CACHED for IORING_OP_STATX fast path
Date:   Mon, 25 Jan 2021 14:36:14 -0700
Message-Id: <20210125213614.24001-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125213614.24001-1-axboe@kernel.dk>
References: <20210125213614.24001-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of always going async, we can now attempt a cached attempt by
using AT_STATX_CACHED. This turns into LOOKUP_CACHED, and ensures that
we'll only do a fast path dentry lookup for path resolution.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c246df2f95a4..99799cc5a42e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4394,20 +4394,27 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_statx *ctx = &req->statx;
+	bool cached_set;
 	int ret;
 
-	if (force_nonblock) {
-		/* only need file table for an actual valid fd */
-		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
-			req->flags |= REQ_F_NO_FILE_TABLE;
-		return -EAGAIN;
-	}
+	cached_set = ctx->flags & AT_STATX_CACHED;
+	if (force_nonblock)
+		ctx->flags |= AT_STATX_CACHED;
 
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);
 
-	if (ret < 0)
+	if (ret < 0) {
+		/* only retry if nonblock wasn't set */
+		if (ret == -EAGAIN && (!cached_set && force_nonblock)) {
+			/* only need file table for an actual valid fd */
+			if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
+				req->flags |= REQ_F_NO_FILE_TABLE;
+			ctx->flags &= ~AT_STATX_CACHED;
+			return -EAGAIN;
+		}
 		req_set_fail_links(req);
+	}
 	io_req_complete(req, ret);
 	return 0;
 }
-- 
2.30.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7132B2959
	for <lists+io-uring@lfdr.de>; Sat, 14 Nov 2020 00:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKMXvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Nov 2020 18:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKMXvh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Nov 2020 18:51:37 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2223DC0613D1
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:51:37 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q10so8990719pfn.0
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bohmZYb1nCOsUNBSdJCTkj45mCB9iNRujNpEOcDA6II=;
        b=u8cDmBv4/qYmNtGLNQme54d7hb8CKI0acgLtENqnANcoXv6hk5X9qTE9KKsSwJzsq+
         t8XMqtKPD12ISCoZ87OB5X+Q1TiPLL6/dNnffTscl3yum0nkGXJTrIJ4FYSk7y96Aep4
         89/ZczobJ155l4U1tNikkocVzfaxNtUSzgpe9JB1LS0W/nPpRv914BIh1nCqpSy4MJJa
         UsuuKZYduYnN7IT5hc8t2tY8+svSqnX2t6C0GsGbGXUyPKgIgQk6dmbnKtMMVaGrZt7e
         vs6I4GHVSs/C/iIepOP9ceaIXIQygEMVXSyAOXfctl1BkJlgDwC5+yzMMTMp0wvF8C58
         /PQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bohmZYb1nCOsUNBSdJCTkj45mCB9iNRujNpEOcDA6II=;
        b=PPMVb1nJmavKd7JAgBA9aI8QLivD2G287Z2sgKUjD8AwNfKSwSQznhDPXHMVbL3UHT
         0d3fiU9otUNUDRCynb+r/X7DOeXl3n7drYzxqLVjvlyyPN+V/rwcDqAOA3DLbzDJsr9d
         YtkMTUhO8KYbfpagGE3qRffV7lrkt9dZMN6I8pJb2GAhEodWGQxg/29iUdS6tzt6maR0
         9XgrS9kJo9Lo0h8Nj8IQdOlsnugcC4pPWyPn/nqwsl4rUYvbEy6Z3mj/2PrLx44iStK4
         TvZWISKQzElLko2ffDRfhR9z7i2+LLfw7AQt03ngkHR3m9xPc+upiga54s20EckY685l
         yCLw==
X-Gm-Message-State: AOAM533EdJA6h2ztu7AWYHcp83dmY2aZNY5yCbvWoib6WwIOTOxWxv1j
        6OZHONMEnKmfWdaynuTbUy/vDPF/dhUVTw==
X-Google-Smtp-Source: ABdhPJxEhFSTFRUhhARiKh8PDZiD4Ai7ogJrFU/uIsKrgGy2du7L13C4p98vncZtMJjOzihiMvFbhQ==
X-Received: by 2002:a17:90a:16c1:: with SMTP id y1mr5328280pje.168.1605311496407;
        Fri, 13 Nov 2020 15:51:36 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n4sm2634751pgh.12.2020.11.13.15.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 15:51:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: handle -EOPNOTSUPP on path resolution
Date:   Fri, 13 Nov 2020 16:51:30 -0700
Message-Id: <20201113235130.552593-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113235130.552593-1-axboe@kernel.dk>
References: <20201113235130.552593-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Any attempt to do path resolution on /proc/self from an async worker will
yield -EOPNOTSUPP. We can safely do that resolution from the task itself,
so retry it from there.

Ideally io_uring would know this upfront and not have to go through the
worker thread to find out, but that doesn't currently seem feasible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c77584de68d7..90d2f67f0ecd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -586,6 +586,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
+	REQ_F_BLOCK_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -631,6 +632,8 @@ enum {
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* linked timeout is active, i.e. prepared by link's head */
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
+	/* OK to do pass in force_nonblock == false for task */
+	REQ_F_BLOCK		= BIT(REQ_F_BLOCK_BIT),
 };
 
 struct async_poll {
@@ -3854,6 +3857,21 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (IS_ERR(file)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
+		/*
+		 * A work-around to ensure that /proc/self works that way
+		 * that it should - if we get -EOPNOTSUPP back, then assume
+		 * that proc_self_get_link() failed us because we're in async
+		 * context. We should be safe to retry this from the task
+		 * itself with force_nonblock == false set, as it should not
+		 * block on lookup. Would be nice to know this upfront and
+		 * avoid the async dance, but doesn't seem feasible.
+		 */
+		if (ret == -EOPNOTSUPP && io_wq_current_is_worker()) {
+			req->flags |= REQ_F_BLOCK;
+			refcount_inc(&req->refs);
+			io_req_task_queue(req);
+			return 0;
+		}
 	} else {
 		fsnotify_open(file);
 		fd_install(ret, file);
@@ -6198,6 +6216,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 {
 	struct io_kiocb *linked_timeout;
 	const struct cred *old_creds = NULL;
+	bool force_nonblock = true;
 	int ret;
 
 again:
@@ -6214,7 +6233,10 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = override_creds(req->work.identity->creds);
 	}
 
-	ret = io_issue_sqe(req, true, cs);
+	if (req->flags & REQ_F_BLOCK)
+		force_nonblock = false;
+
+	ret = io_issue_sqe(req, force_nonblock, cs);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.29.2


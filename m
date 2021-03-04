Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CAE32C99A
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbhCDBKH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353717AbhCDAeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:11 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E534BC061793
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:24 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id x29so9388423pgk.6
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qVsdHqyA5sRPlDOthTDEy4/N/HIDTBHc2aVguOxt15k=;
        b=B1fkpgNevdigjFLp0PZWRJd4p7O6H9AWHAEG99xNo+tlNDE+32BRuhdTst0c0z/xlu
         i5di/uWkoNNfzVWYtriWpqHC42w4CSltWFcQcxUUhe4GAdMiUar4w3+4YMVNM55DzjCg
         wj5GVmFeVZn/l2/gcFPV2DUVgk0u+mua/s0iXtabpAaZ7650NbdYYiAvAYrlJV/8R6aQ
         5IJOeBvIu6tsV0i9iWPqzGjQl9g8XHMUWuWhtmN5W3pnQ8a1c9yUfc9HALt+8QxWQFCq
         CC3A0xDzSiE1vHKYvBaAU0stQ7M+pSLHHt+CHXSOtldw8m1B3MtB6iRYQy1TMhx8Awe+
         Ju/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qVsdHqyA5sRPlDOthTDEy4/N/HIDTBHc2aVguOxt15k=;
        b=N7p8kUGWS06U6qxk6OK0JeMagqzZqkRSzvrwfoniakiydan0JJP8W2rtPmfRRDxG4o
         h9ixwGtKwu4TIi8mVZvc5BrC8YSZhckAt4Vat7U7Thdx7eRjgeyqACr6dLU3JnJ2Gxf5
         lEPEvl+uAXGHqAv1rURn1Freug5xTdz8Lt4ERS4614xm9b+CBRE5Cu697+ZmWGYGto5o
         fJ2sEnaVQvKkolo76GOOndg4xCxzAfQ5meXf0m2p7X9BDt31dFHbwP4dtNe1SUQIGs/5
         C82CbHqVLxi8FL0QoWkF8W/Vqe6VNWf/ga/GX5Xot2RQm4afJIPMfYJRTsn/OLHPuWPn
         im9w==
X-Gm-Message-State: AOAM533teQt4xKsqnYqktUCH5QBImx6/3TlEutZxJFqZcfLNZQvP8PQ0
        AeVK/cNOA4R3SxWbyQeKrl+nTgeRBZUCGZxj
X-Google-Smtp-Source: ABdhPJyO6QDMBsVgDypdFDykEoy91cy17rgEFR0NYQmuApBF4GJYE6falQiPrsm99lmGxQNoA72NlA==
X-Received: by 2002:a63:1c19:: with SMTP id c25mr1328876pgc.374.1614817644274;
        Wed, 03 Mar 2021 16:27:24 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/33] io_uring: kill unnecessary REQ_F_WORK_INITIALIZED checks
Date:   Wed,  3 Mar 2021 17:26:43 -0700
Message-Id: <20210304002700.374417-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're no longer checking anything that requires the work item to be
initialized, as we're not carrying any file related state there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa5b589b4516..3bd9198c5a86 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1080,8 +1080,6 @@ static bool io_match_task(struct io_kiocb *head,
 		return true;
 
 	io_for_each_link(req, head) {
-		if (!(req->flags & REQ_F_WORK_INITIALIZED))
-			continue;
 		if (req->file && req->file->f_op == &io_uring_fops)
 			return true;
 		if (req->task->files == files)
@@ -1800,15 +1798,7 @@ static void io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link, -ECANCELED);
 
-		/*
-		 * It's ok to free under spinlock as they're not linked anymore,
-		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
-		 * work.fs->lock.
-		 */
-		if (link->flags & REQ_F_WORK_INITIALIZED)
-			io_put_req_deferred(link, 2);
-		else
-			io_double_put_req(link);
+		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
 	io_commit_cqring(ctx);
-- 
2.30.1


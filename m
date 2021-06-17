Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E83ABA5F
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFQRQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhFQRQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1EFC061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:40 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r9so7605487wrz.10
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ppV3vquWSFiQh0W2fGgpu2B6GAf4oj+PuFxMb6lxaJw=;
        b=OtmXwq8hW4lVq/dWfBdTIF9JzPeynwTtEb0xQLKSLwYoyI1jdUmCQrniIW51spDYQ4
         Coss/J0vA1awy94uLds8Y37IplG1UsqNXFlJ+0ETbvR3RT7IsFcYSej7Vf8z+d7xoQi7
         OZVQJEcNKMLguQP2UpeY/YYhsfy6ZVWwVwipKp+Dbz3Wn12+twfcp2vgqPuk7LwMay/b
         NwVfT6DG2SB6EIuU0c66z4LvK0sFrNMEPVQGzBmYlNPqLTQv3u7/HA92ekz/WMQ8DSO9
         874JO1gNi+DjaNh/9ttHkx8LwQ9aQMSPf98pMhsmPO/1HNZy0BrpddYEsdqh/Mxk872t
         KyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppV3vquWSFiQh0W2fGgpu2B6GAf4oj+PuFxMb6lxaJw=;
        b=qR5NWxtKYQ9zZNyJ5OAwgnMAcWldXZcG9ibhrkmWthL4nUJqTwc615sRh2jNCvj+j5
         vD44n6odJdywoSATNN6onO18B+UbcuzG96gBF/cNFunsHiWjUEfcJ2xOON5nYHsdqnwZ
         vl3n4Ocb1aVGnWTxh5SXg1o/BYU1jkMuqEcjiOIGTUpalZ+jkBtsLeGUyoN3XlORfY/R
         W8g5+aXCuda9Rz7GfWc4DYmo3OsPe2bZpm8Adzkg0eTBbc0GQDBPXnEi4C7b8xwnOWg4
         drauGt0IYqcWJHccKc/P5FgchH9YWgQaaHfaLy5jASnTT2ncr8VEcn9t9Z/hvJLUpy2r
         RgXg==
X-Gm-Message-State: AOAM533A7fs24wWLnAFDxn53QkvFImQ7Df0rhCiM3LXD7MNjEgUXUNct
        aJ9sD19gRBnR/MWesyJog35eRw/UqvHpfg==
X-Google-Smtp-Source: ABdhPJwnCHJs6Gq+2351ubk5l8vgITD2QLQ/uwWl9jptMqLKnjZ8AgXfsv6q2YfcCzn+qVEqHlPEWg==
X-Received: by 2002:adf:e80c:: with SMTP id o12mr3388597wrm.425.1623950078733;
        Thu, 17 Jun 2021 10:14:38 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/12] io_uring: clean all flags in io_clean_op() at once
Date:   Thu, 17 Jun 2021 18:14:04 +0100
Message-Id: <b8efe1f022a037f74e7fe497c69fb554d59bfeaf.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clean all flags in io_clean_op() in the end in one operation, will save
us a couple of operation and binary size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f92fcc9a41b..98932f3786d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -109,6 +109,8 @@
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
+#define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -1627,8 +1629,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 
 static inline bool io_req_needs_clean(struct io_kiocb *req)
 {
-	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP |
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS);
+	return req->flags & IO_REQ_CLEAN_FLAGS;
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -6080,7 +6081,6 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(req->sr_msg.kbuf);
 			break;
 		}
-		req->flags &= ~REQ_F_BUFFER_SELECTED;
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
@@ -6121,7 +6121,6 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->unlink.filename);
 			break;
 		}
-		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
 		kfree(req->apoll->double_poll);
@@ -6132,12 +6131,11 @@ static void io_clean_op(struct io_kiocb *req)
 		struct io_uring_task *tctx = req->task->io_uring;
 
 		atomic_dec(&tctx->inflight_tracked);
-		req->flags &= ~REQ_F_INFLIGHT;
 	}
-	if (req->flags & REQ_F_CREDS) {
+	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
-		req->flags &= ~REQ_F_CREDS;
-	}
+
+	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.31.1


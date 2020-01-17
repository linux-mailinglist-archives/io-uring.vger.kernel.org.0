Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006F2140134
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733157AbgAQA6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:58:50 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43465 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbgAQA6u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:58:50 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so17043524lfq.10;
        Thu, 16 Jan 2020 16:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fRCSf2IOoA77e10gK8Ib+9UK9eBjNY5RtJQmOUUp8sI=;
        b=fUt6uxpPvp6K70miMr4/NAm39ZXsOg1k7TRPkDKT9OjjXAhu2WNgNGdsVL2LabEy0d
         W59D59O8ykWjmJlSoSVjlW87eA5YNkxN5kqegYH6JHga60kvtqN4RLGpOjqAUcSbjt5s
         5AgsjfkCwTfAKvfDIcRebZHZLP0uPqvL3DtmJTqAgB+pORujalyfeP9BgRio5Ofqaule
         uu0xNEtQJ+/kFz05LCqkPqkH0WQlCb6EXvM4Oedjwyi+4XKA3ZBmGV+nk1X+QToaZYBQ
         OQEOi6KLkvBNxc4c4xRWk1GV6Cg2uHxH/0/uiy9cVrmJVSW2LevlxjAcGLDpsBGC4jd7
         yz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fRCSf2IOoA77e10gK8Ib+9UK9eBjNY5RtJQmOUUp8sI=;
        b=beGshsBRuQvetu2ZwzDLRSGdYxnXgeiRU3LZ6jirrC4rFUPoC58ZK+KmwdreImXCGQ
         Ahic3fizNbGmWX3KNbvDQElItTzkobHekm+0qgo2108L0ohdi1cTO+21ghhwVTWebMDH
         IlqGUCyRdVWM4eDm6sOwarSrSMCEWPBPHYyKt2noHKbSddngUHdodyzmXUXO5/EGntf+
         UeDOjMl4r8B43BJRcYmvwE0Pm+xu3pPwrIyWmFrMR5ST+tSydTR878/gg0/DhqpwiSDT
         gANz7aLSHOhv6zUySwhxuzKbVMp96rh3AdxBZcNito+BfabB3yXzX7mxqwOP5iZ40D57
         aytA==
X-Gm-Message-State: APjAAAWvTMZFJ1B2aVAUojq8ZeRrD0I/SR87F9elx3uvdJBaqg1nT3Qf
        2Y/2cGfBbI2xFiYB/shcBuyNbAQa
X-Google-Smtp-Source: APXvYqySz36mKaX6aI7zNsuPJ/j5CU7xnYF9siWAveGCc27fYbn9xeFHVsbR4krPyitIp+vtV2i4tg==
X-Received: by 2002:ac2:58c2:: with SMTP id u2mr4023936lfo.206.1579222728101;
        Thu, 16 Jan 2020 16:58:48 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id d24sm11459100lja.82.2020.01.16.16.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 16:58:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: optimise use of ctx->drain_next
Date:   Fri, 17 Jan 2020 03:57:59 +0300
Message-Id: <6063bf6baa6fa1f5ec45272eb7c0b428698ded7f.1579222634.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move setting ctx->drain_next to the only place it could be set, when it
got linked non-head requests. The same for checking it, it's interesting
only for a head of a link or a non-linked request.

No functional changes here. This removes some code from the common path
and also removes REQ_F_DRAIN_LINK flag, as it doesn't need it anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea91f4d92fc0..2ace3f1962ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -506,7 +506,6 @@ struct io_kiocb {
 #define REQ_F_LINK		64	/* linked sqes */
 #define REQ_F_LINK_TIMEOUT	128	/* has linked timeout */
 #define REQ_F_FAIL_LINK		256	/* fail rest of links */
-#define REQ_F_DRAIN_LINK	512	/* link should be fully drained */
 #define REQ_F_TIMEOUT		1024	/* timeout request */
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
@@ -4543,12 +4542,6 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	int ret;
 
-	if (unlikely(req->ctx->drain_next)) {
-		req->flags |= REQ_F_IO_DRAIN;
-		req->ctx->drain_next = 0;
-	}
-	req->ctx->drain_next = (req->flags & REQ_F_DRAIN_LINK) != 0;
-
 	ret = io_req_defer(req, sqe);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
@@ -4615,8 +4608,10 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (*link) {
 		struct io_kiocb *head = *link;
 
-		if (sqe_flags & IOSQE_IO_DRAIN)
-			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
+		if (sqe_flags & IOSQE_IO_DRAIN) {
+			head->flags |= REQ_F_IO_DRAIN;
+			ctx->drain_next = 1;
+		}
 
 		if (sqe_flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
@@ -4640,18 +4635,24 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			io_queue_link_head(head);
 			*link = NULL;
 		}
-	} else if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
-		req->flags |= REQ_F_LINK;
-		if (sqe_flags & IOSQE_IO_HARDLINK)
-			req->flags |= REQ_F_HARDLINK;
-
-		INIT_LIST_HEAD(&req->link_list);
-		ret = io_req_defer_prep(req, sqe);
-		if (ret)
-			req->flags |= REQ_F_FAIL_LINK;
-		*link = req;
 	} else {
-		io_queue_sqe(req, sqe);
+		if (unlikely(ctx->drain_next)) {
+			req->flags |= REQ_F_IO_DRAIN;
+			req->ctx->drain_next = 0;
+		}
+		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
+			req->flags |= REQ_F_LINK;
+			if (sqe_flags & IOSQE_IO_HARDLINK)
+				req->flags |= REQ_F_HARDLINK;
+
+			INIT_LIST_HEAD(&req->link_list);
+			ret = io_req_defer_prep(req, sqe);
+			if (ret)
+				req->flags |= REQ_F_FAIL_LINK;
+			*link = req;
+		} else {
+			io_queue_sqe(req, sqe);
+		}
 	}
 
 	return true;
-- 
2.24.0


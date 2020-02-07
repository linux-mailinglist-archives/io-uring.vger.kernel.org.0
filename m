Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF815601F
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgBGUqQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:46:16 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43096 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:46:16 -0500
Received: by mail-ed1-f68.google.com with SMTP id dc19so929493edb.10;
        Fri, 07 Feb 2020 12:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wo/+8FOkuy/eLOt9Y7FxlHjzQKx2q0L4fL3dmNOe27I=;
        b=qL+CrddyxYkc2XhHQc+mKIYQaBPmzjHo4s7+qptdXrnsFn/RhHwptLlDrJ3iOl+om4
         auWmU7hVKJXjLgub4bfct/OJLslKGcYXw9ActV1yVu70wCGobi4CBzBlFM12n+qQ8uTJ
         LkGk18SVanrag17B7IywgxhK4wb3gm7EaMuQw23Af5i7FY885T7Ejr8kZfFxA2nGVTi4
         GqIRJfFI8I9fN2TmJlglcxgEuwK85IMnro79hZv8p1qYdtAGrnxRJMZyE6FWyF2ufvkN
         CeLyMaQjA1u8hM+cq338gYNkaiMTkGQA4kPetGp2Xgd3zznDiTCMZzhf5ihRUALkvAO4
         t/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wo/+8FOkuy/eLOt9Y7FxlHjzQKx2q0L4fL3dmNOe27I=;
        b=OkjzNF0m4o2QcIJX2cd12b1AkHwFRlRbQqfYaZlQixHE8CVjo4rCVewxvtIwATJilT
         ZMR+JWGzn1wlJPKvT0LSEcv5/AlXgwhx6ZpVl1wrELc0reJA/01SfZRvTxjmzenUjgUH
         NlOO1Mc8tWxDtcElDue0T+5fNQjrcdR13RTc0NHXUYPL3mduzOYOVQRA6dJaczy6SYs5
         QrlJf07yokP/ZYh+mTdcVUOUCtY/qbB3v4qxZ9eZAOvhH0udi8v+ayqnPXpK21J70mte
         ERWI4ReDBdvCT+81eXwhOEAEQcoR5EwvEZNw0kH6tEg8fwTKsWku7n5AZfUW9IhyQm81
         AS9w==
X-Gm-Message-State: APjAAAX9WfnTcK8T9jbUnNtEJJC1DpClIQA+E+h2kLiMDa7VTlVQnWk0
        yvB6FhIKuEx+7H9zyxv815/Fximo
X-Google-Smtp-Source: APXvYqyQWZQ3xxG/z8bPiGmR65ZMlyu2x9gd5Sl95sp23W5Ju2Ku+GLE5onY6+l2i12TXeOvWpzTZw==
X-Received: by 2002:a17:906:260b:: with SMTP id h11mr1050519ejc.327.1581108374981;
        Fri, 07 Feb 2020 12:46:14 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id br7sm462432ejb.13.2020.02.07.12.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:46:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: purge req->in_async
Date:   Fri,  7 Feb 2020 23:45:29 +0300
Message-Id: <3ec455059ef8455418b0fbddf65e35ac9c6cc840.1581108187.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->in_async is not really needed, it only prevents propagation of nxt
in sync context. Remove it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42b7861b534c..2f8359f1d258 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -554,7 +554,6 @@ struct io_kiocb {
 	 * llist_node is only used for poll deferred completions
 	 */
 	struct llist_node		llist_node;
-	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
 
@@ -1946,14 +1945,13 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt,
-		       bool in_async)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (in_async && ret >= 0 && kiocb->ki_complete == io_complete_rw)
+	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
 		*nxt = __io_complete_rw(kiocb, ret);
 	else
 		io_rw_done(kiocb, ret);
@@ -2245,7 +2243,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2351,7 +2349,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -4483,7 +4481,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	if (!ret) {
-		req->in_async = true;
 		do {
 			ret = io_issue_sqe(req, NULL, &nxt, false);
 			/*
@@ -5020,7 +5017,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			*mm = ctx->sqo_mm;
 		}
 
-		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-- 
2.24.0


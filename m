Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2829D5576B3
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiFWJfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiFWJfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A754926F
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z9so10664403wmf.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Uv54uWG/MQ63FNuwpeJRmurx927Ooxj18ye9JB7U1Q=;
        b=bymVe3Lkq4wHfS7JIUNl2WTMmlV4756O4ixQCktLwgXk7glVvUyniCumn13ILngo/9
         E8wxrvOi7e7OtDY/ezL5YAUS7k6VPQksVJcZ/Z8zVTinE8iF8OuFXf/hsaWpZ5TloDYr
         4RrTrXu4ySDjXqdEdmdvZDf1BQ+MD9QN5gBThOngDzgIdw+N0Kb80LBtptkOmdeY8Y9y
         qjAMeCT1mEY9dZ9HGPD/J/i8Fd2l+JCp2khPEhXhtR7syRMJbkqsUMiNurZ4fKWL3p5Y
         f9xL9CoGVLeb9CGZPnhJMuvPC7s2fIVTgfl5zcK72tcmdjSDOXG7a+n5jKIqPpSIhKei
         ilPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Uv54uWG/MQ63FNuwpeJRmurx927Ooxj18ye9JB7U1Q=;
        b=792cK0SHsvlYi3mNdfY/xT8rmgQFZolJFKZbHIncuefkvfs30z5x8hJO8VzPikp+Zk
         qfoOVI4obefYlnnu86CoJjtWiXqlCT7BUuP5RvrnuFZsSQvTyzsvxELgGrFZqRBnr+U2
         fafbmWG94BMGbos6CWeLfi7zuCmtY3cekwNijMtkz69p1/WDkvM2ztR6BA7p+CTaSdFr
         T6DS4hlW0b6johUO9nVWFDA+DPHEYRdtgUvRof/nIUfzWMyPVqL0l8/34z7v+iwMSTeU
         u3UMNVCTNoO8xSGUtaT11egFbDumSBG2xSQ/h4kncSbSvVmDgxG5Nh8FDkZTYvxF5Tdg
         UUFQ==
X-Gm-Message-State: AJIora9SxhuCt/RhBpPv5Yoi4fBjCewQDAXATNxCOZOzlOk/WX3YrFVr
        dH/+VR4Y9LSNDXGH8WH1BP9/EWTN7bAd8ota
X-Google-Smtp-Source: AGRyM1vuGqaQreT5eM8wPF3w0dc+XwkWIapg1Bi1sILGqq60oDRKo+BH/z6gSm+DYZs8osRfLJGeiQ==
X-Received: by 2002:a05:600c:500a:b0:39c:53b8:7414 with SMTP id n10-20020a05600c500a00b0039c53b87414mr3034927wmr.19.1655976909333;
        Thu, 23 Jun 2022 02:35:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/6] io_uring: refactor poll arm error handling
Date:   Thu, 23 Jun 2022 10:34:34 +0100
Message-Id: <6dd4786bca9a3d1609f85865936349cac08ac8e0.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_arm_poll_handler() errors parsing is a horror, in case it failed it
returns 0 and the caller is expected to look at ipt.error, which already
led us to a number of problems before.

When it returns a valid mask, leave it as it's not, i.e. return 1 and
store the mask in ipt.result_mask. In case of a failure that can be
handled inline return an error code (negative value), and return 0 if
__io_arm_poll_handler() took ownership of the request and will complete
it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 80113b036c88..149205eae418 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -435,6 +435,12 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			(struct io_poll **) &pt->req->async_data);
 }
 
+/*
+ * Returns 0 when it's handed over for polling. The caller owns the requests if
+ * it returns non-zero, but otherwise should not touch it. Negative values
+ * contain an error code. When the result is >0, the polling has completed
+ * inline and ipt.result_mask is set to the mask.
+ */
 static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll *poll,
 				 struct io_poll_table *ipt, __poll_t mask)
@@ -461,6 +467,17 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	atomic_set(&req->poll_refs, 1);
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
+	if (unlikely(ipt->error || !ipt->nr_entries)) {
+		io_poll_remove_entries(req);
+
+		if (mask && !(poll->events & EPOLLET)) {
+			ipt->result_mask = mask;
+			return 1;
+		} else {
+			return ipt->error ?: -EINVAL;
+		}
+	}
+
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
 		io_poll_remove_entries(req);
@@ -469,25 +486,12 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 1;
 	}
 
-	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
-		io_poll_remove_entries(req);
-		if (!ipt->error)
-			ipt->error = -EINVAL;
-		return 0;
-	}
-
 	if (req->flags & REQ_F_HASH_LOCKED)
 		io_poll_req_insert_locked(req);
 	else
 		io_poll_req_insert(req);
 
 	if (mask && (poll->events & EPOLLET)) {
-		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries)) {
-			poll->events |= EPOLLONESHOT;
-			req->apoll_events |= EPOLLONESHOT;
-			ipt->error = 0;
-		}
 		__io_poll_execute(req, mask);
 		return 0;
 	}
@@ -582,9 +586,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	io_kbuf_recycle(req, issue_flags);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
-	if (ret || ipt.error)
-		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
-
+	if (ret)
+		return ret > 0 ? IO_APOLL_READY : IO_APOLL_ABORTED;
 	trace_io_uring_poll_arm(req, mask, apoll->poll.events);
 	return IO_APOLL_OK;
 }
@@ -815,16 +818,11 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags &= ~REQ_F_HASH_LOCKED;
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
-	if (ret) {
+	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);
 		return IOU_OK;
 	}
-	if (ipt.error) {
-		req_set_fail(req);
-		return ipt.error;
-	}
-
-	return IOU_ISSUE_SKIP_COMPLETE;
+	return ret ?: IOU_ISSUE_SKIP_COMPLETE;
 }
 
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.36.1


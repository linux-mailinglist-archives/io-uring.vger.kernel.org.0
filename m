Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C8B417CBA
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348480AbhIXVCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348484AbhIXVCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC41C061764
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v10so36290464edj.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=a2osZs0deik7ncKCU+3hU0IQ3kahyIAekjyGMMPO3VU=;
        b=H05lHpy6x0lExiaXe0heJ1xWV+tUevX4jxBb3TknT+Y0nPliMxeciojeI5QKa0Zf6W
         XVPHXnRghcp0K9dPSpxEdCuQAAq8Q7DTOFHx7u3Rd6T6fVs2nZ4nzx/BhpgyREKiTB0x
         hj016VeTvl/CIPirVyAHef/QJqd2S0hOQiVVocOhF73ukW9Eplin/3NP6IylxjPT3S6z
         ErQUSAGL4MHXfaO8nQZ1uIjZSMOCMQwSNpBjS0PONGOHarHk90YeG5k9SyIa5tk6Rq5+
         lX+ojSa0aAxLmqPJm7NTFkk6hgKQgf2xGn6r8IecDMWYLk0cON1Lx2LODCp3zirNF4Sx
         7Q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a2osZs0deik7ncKCU+3hU0IQ3kahyIAekjyGMMPO3VU=;
        b=c8fs4VM9cwq/2JSpy6jgUdJviXyDPyT9+3dlff+JSg2fUAQ+kg4H5fsBfzdVa96UNo
         YzASRkmK0fFrUlh5OgDN1dHYvcp+oBX1VaFY63fjKZMecvbseshxg1V9bmmwtSAgyAsc
         TV/QQ67i6sSOeVTnrp9ySRf70HtLGde3zBwa1veDByM+bgRktLgE3++IZh0uqZMVzXDj
         SKFCuUOLJn6Cn7b85adWYOHyjLB1rQqTxPrieFviPMhtIQ92xPukO88WuYu5BotGwMOF
         jxD1e7Cb79WcDOx3MXgKLgMqII4qrKCfly62wVAQBwh7X2QY5EZQAPjZITse3iHGIi2K
         FJKw==
X-Gm-Message-State: AOAM531T3r+vfix1m5kdwAWAl4B14HvGg5oim5jIyGUH8ZIs8ADGB8KY
        DdPRc6cr2fmh5UzFFZhMWmQPqYBbOww=
X-Google-Smtp-Source: ABdhPJxID+oxhrhxPH1YL5HRzhQXQrOV6524rVLDgjpoEZoak69ryx69CIlarsESVsRkj7TUPLCAlQ==
X-Received: by 2002:a17:906:a018:: with SMTP id p24mr13109746ejy.349.1632517265520;
        Fri, 24 Sep 2021 14:01:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 19/24] io_uring: inline hot path of __io_queue_sqe()
Date:   Fri, 24 Sep 2021 21:59:59 +0100
Message-Id: <f1606864d95d7f26dc28c7eec3dc6ed6ec32618a.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract slow paths from __io_queue_sqe() into a function and inline the
hot path. With that we have everything completely inlined on the
submission path up until io_issue_sqe().

-> io_submit_sqes()
  -> io_submit_sqe() (inlined)
    -> io_queue_sqe() (inlined)
       -> __io_queue_sqe() (inlined)
         -> io_issue_sqe()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54910ed86493..0470e1cae582 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6899,13 +6899,38 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void __io_queue_sqe(struct io_kiocb *req)
+static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
+{
+	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
+
+	switch (io_arm_poll_handler(req)) {
+	case IO_APOLL_READY:
+		if (linked_timeout) {
+			io_unprep_linked_timeout(req);
+			linked_timeout = NULL;
+		}
+		io_req_task_queue(req);
+		break;
+	case IO_APOLL_ABORTED:
+		/*
+		 * Queued up for async execution, worker will release
+		 * submit reference when the iocb is actually submitted.
+		 */
+		io_queue_async_work(req, NULL);
+		break;
+	}
+
+	if (linked_timeout)
+		io_queue_linked_timeout(linked_timeout);
+}
+
+static inline void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout;
 	int ret;
 
-issue_sqe:
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
 	/*
@@ -6920,24 +6945,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		linked_timeout = io_prep_linked_timeout(req);
-
-		switch (io_arm_poll_handler(req)) {
-		case IO_APOLL_READY:
-			if (linked_timeout)
-				io_unprep_linked_timeout(req);
-			goto issue_sqe;
-		case IO_APOLL_ABORTED:
-			/*
-			 * Queued up for async execution, worker will release
-			 * submit reference when the iocb is actually submitted.
-			 */
-			io_queue_async_work(req, NULL);
-			break;
-		}
-
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
+		io_queue_sqe_arm_apoll(req);
 	} else {
 		io_req_complete_failed(req, ret);
 	}
-- 
2.33.0


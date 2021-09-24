Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5156E4178EE
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343605AbhIXQiW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344237AbhIXQh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9C2C0612A9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so38221935edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZTf3ydRwEfaQ3982cdKm0F0XAeil5MdmudzkqrdVpwI=;
        b=ZE5ZHL7CS331YTTz8CZX3l1ZQvGHZELZkZN8Uhh3T2o/YD/mqLUW+doTwa1xQuqreD
         8yNeGJzM++TF3GxklHgLvSFVUf5MBwVr88Htn8vOHVOe71gQRxXlgAGY2o3/cOJGJ7Oh
         U0VF7jxOcXSkp9Q7dDe/4uQ+M3vd4QfuwVSgRRadSEgWWamP1AYdd9m2i192v2WVnUsQ
         qh0F3U5ufgK3HxY8bPvte9VyUfdU7i8IDkBL2Q+OKh5eXpNmhLCU/L9HUoWky8ScPwRp
         coz2719cPSkBezP8hCPzBdJdsVCiACdvj6higjpHUfawFduKWLJxNhKYnDHquE1l4YmZ
         OWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZTf3ydRwEfaQ3982cdKm0F0XAeil5MdmudzkqrdVpwI=;
        b=RFDPV/YR+K5K6/QrlliTqAsY7J/5Xf/7arxtQbYQCghvsV9KFNlsDN6s4/u4fjzhqj
         0aKqKnRsewY88FNkw33wGjFGg0NGuHmVHRZarOoLwHXnTnp/aa6Y+3C63VdPe0yVxiOp
         u3HrBtqUAnub8eMTVXyscGVFKWs5+zWtQ6Akcoc0A0nHVy6XQqi/ii8LCq+4nraifRJX
         O8wCiOJa+t9Ox+p7kQo+JLCtOaLkrQz6yncF1b/0Kir02b0sJG5JQD4t4LsgfOXH9kwZ
         jTX2Jrz20MgE2wsD7ik4vXDEXuoIUf3vUC4EwObEPVvzu9DLDMWkDpe8ox8T4UF1edxU
         FEaA==
X-Gm-Message-State: AOAM532hbEAQXHe3Q2S2yI+VdD+sVqxLTnYItX4HZSKrOKQDM/+HQXUt
        7o5pWDDaHdWBSIFgCEzlRkmRBsQLSPU=
X-Google-Smtp-Source: ABdhPJwVg6+5qAPg3C0UpHzHM18cC7oMWSoAZJxzNY94qFEO0DWVZ1owkjB+UWHh63yzF5wxKdWKng==
X-Received: by 2002:a17:906:fcb0:: with SMTP id qw16mr929213ejb.231.1632501183950;
        Fri, 24 Sep 2021 09:33:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 19/23] io_uring: inline hot path of __io_queue_sqe()
Date:   Fri, 24 Sep 2021 17:31:57 +0100
Message-Id: <942aaba4eebeda4d6e399f05e10e475d3fa5eb65.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
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
index 6d47b5150e80..76838d18493f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6883,13 +6883,38 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
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
@@ -6904,24 +6929,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
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


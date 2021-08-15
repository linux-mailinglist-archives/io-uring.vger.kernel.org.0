Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D349E3EC867
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbhHOJlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhHOJlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:42 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B29C061796
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:12 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u1so9705965wmm.0
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dAqlYZIBQSL21cv2Z7E7b1coJYIbOd+/EJjbnPDqvDQ=;
        b=lQLU5XX5fhAG3jAGl+zaqLTpnKH0zMj6RXqfeI0jTi6O8r1vhbZEkFUWDwjlaoKwMW
         kIGkbBCtemcpvuKGonZqF0qWDW9Jdy2vzdVLm6gaQBkNR0yP7AdMx5uTjPGVvi0ejyT6
         WaDN7YixXqiaunStFRa5khF0ZhOHNfFry2+ls9pZbGWMe7RSaqDxWxzrGlclsVdmox2M
         I5K1y+dB88FQ2sZMC1upGE4smGVwRl+CNk1J143y4+gYMxKDBrkxmpICuPGGy55P1qG7
         Ad08KeKrRMsHWy7o4CTdZ6/7l4lWVxoGt/OLtN16a9+aZ3HsDaUys0yPmIJkPZOnFGfC
         5B8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dAqlYZIBQSL21cv2Z7E7b1coJYIbOd+/EJjbnPDqvDQ=;
        b=OvfikIMats9n88EYojwlk69hPfOzHdc+G1XYfJX9E8BEsv1T25AwotHswc3ACQteXH
         H+UCE/cWWQXK0DdNdzXjZvVxKLQyIlxEvOCfbPzQDKWuuKVgRu0jHvyjF0Oj4ByEC7Yb
         Q5ENfp2fsvsIdkNTLm/3/UZ3psgX8VGmGy1LDyHzo6xVLz8SgLdnzuL+JOsEo8IGzdcD
         1ulFASdf6/YnBQgwCeW9uZ6G5/W4R02qU++/XhhdLcj7op3qT42vQU1XjIW41CypRCV7
         4y8N601eurw5IOziAsXkAd+/p9/m5G8Gy6G1L958cGyGeVBQhkrGFdEX/If7ejTlX2lJ
         8gHQ==
X-Gm-Message-State: AOAM532A+jrmDg87ir96tCty27vKk4cmKpzb1b7B49vqtuxVyIXdhNoR
        X5dL6vpZ81X3nzy3gek00eJnlcLgR6w=
X-Google-Smtp-Source: ABdhPJzcbzNla85el0nw/liJvL8mh96IPqtXIzKigVkFnc/BSSkrO6f3Zm4dqj1vZOBiYiVIf/FDxw==
X-Received: by 2002:a05:600c:22d2:: with SMTP id 18mr10212409wmg.117.1629020470973;
        Sun, 15 Aug 2021 02:41:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 9/9] io_uring: optimise io_prep_linked_timeout()
Date:   Sun, 15 Aug 2021 10:40:26 +0100
Message-Id: <19bfc9a0d26c5c5f1e359f7650afe807ca8ef879.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linked timeout handling during issuing is heavy, it adds extra
instructions and forces to save the next linked timeout before
io_issue_sqe().

Follwing the same reasoning as in refcounting patches, a request can't
be freed by the time it returns from io_issue_sqe(), so now we don't
need to do io_prep_linked_timeout() in advance, and it can be delayed to
colder paths optimising the generic path.

Also, it should also save quite a lot for requests with linked timeouts
and completed inline on timeout spinlocking + hrtimer_start() +
hrtimer_try_to_cancel() and so on.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b6ed088d8d5..2313b39efbbe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1304,6 +1304,11 @@ static void io_req_track_inflight(struct io_kiocb *req)
 	}
 }
 
+static inline void io_unprep_linked_timeout(struct io_kiocb *req)
+{
+	req->flags &= ~REQ_F_LINK_TIMEOUT;
+}
+
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	req->flags &= ~REQ_F_ARM_LTIMEOUT;
@@ -6483,7 +6488,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
+	struct io_kiocb *linked_timeout;
 	int ret;
 
 issue_sqe:
@@ -6501,10 +6506,19 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			state->compl_reqs[state->compl_nr++] = req;
 			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
 				io_submit_flush_completions(ctx);
+			return;
 		}
+
+		linked_timeout = io_prep_linked_timeout(req);
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+		linked_timeout = io_prep_linked_timeout(req);
+
 		switch (io_arm_poll_handler(req)) {
 		case IO_APOLL_READY:
+			if (linked_timeout)
+				io_unprep_linked_timeout(req);
 			goto issue_sqe;
 		case IO_APOLL_ABORTED:
 			/*
@@ -6514,11 +6528,12 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			io_queue_async_work(req);
 			break;
 		}
+
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
 	} else {
 		io_req_complete_failed(req, ret);
 	}
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
-- 
2.32.0


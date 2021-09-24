Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF410417CB9
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346613AbhIXVCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348480AbhIXVCj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D665C061762
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v10so36290374edj.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=b2bBj5tRVfP8MNyQVWdmQVzdfcWPtNZUztWGP2aCSzY=;
        b=oFlbLp0PIwWU2FhHMbF+XJgndKjAiZECQqyOik4iYu2h+uLBH1LQFelf2JUB/T454Z
         jOYvnNZBdmM2SwRmKXJ8KTJSdgaFgn9ZCqCgqxAZUM41UPN+miEF5TPzhjtX9Nl9Oo2L
         pj7NqdsjzMM7RdPjxrE/hh8vH5tMYO2slC1hscSaoscdqPHwtANwv/S9YyRhGEWkmJ+z
         PkikUjAUsRRDu62HpkmEKNeMYa6bOJLcxXrw2ImgBrOK08+fqeHy8w4rE+avkZu3xkgx
         3ABv7+hWbeYYH9nB3wz/gU4ZGEkQ9AXemQHyuOwWHqyfs9I73SzKdh+S6b7mIkqEJW01
         b2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2bBj5tRVfP8MNyQVWdmQVzdfcWPtNZUztWGP2aCSzY=;
        b=PT0oXUQEj4sQL7vfWsYim335Qb6H1aDFS3jezxHbTXLw8IV13ZZBM7SO6QPPyzPtUq
         wOI9a582U3bp89xbzPM0g6dLVmT3mR1mmbKPmLk5Rr1+b3b7wlYKFyl9VILkvgihF+s+
         OAWJGWOXzNYuX98ns1LLP5sE2cBakQYTe7AOhoyOOOd57Wgg0SAZhI+ykCxB/6M8JWXs
         +wyViHehf/6lRK/euvBoQEc7Mw5L3MgHPM0x5kL8Wag8sJ9SWftGToIcnkLiNJq1/8dS
         6MslJ6gjnq81RqZo3g5mQWakG6g++SyuHTxxu7/OhLmmUxWIuwt41Y7BjP6UV9hY1Q2O
         GZIA==
X-Gm-Message-State: AOAM532dRw0+23rbAS5viFn6Z7OnQx2OH4wnoswPiJD61R5vSdk3CWAe
        KsvWVbfj6aRJuZTktQsGjZf8Y+MxS4A=
X-Google-Smtp-Source: ABdhPJzZ/Br+0OaorIZ9L0Dr+LcXeQRXckfjYpwuTc/F2EGQGCO6UGqYvqf+eOsVY7YFWYEhuZc6uQ==
X-Received: by 2002:a17:906:228d:: with SMTP id p13mr13219592eja.526.1632517264608;
        Fri, 24 Sep 2021 14:01:04 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 18/24] io_uring: split slow path from io_queue_sqe
Date:   Fri, 24 Sep 2021 21:59:58 +0100
Message-Id: <fb01253911f8fb374268f65b1ba939b54ca6583f.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't want the slow path of io_queue_sqe to be inlined, so extract a
function from it.

   text    data     bss     dec     hex filename
  91950   13986       8  105944   19dd8 ./fs/io_uring.o
  91758   13986       8  105752   19d18 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25f6096269c5..54910ed86493 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6943,12 +6943,10 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static void io_queue_sqe_fallback(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
-		__io_queue_sqe(req);
-	} else if (req->flags & REQ_F_FAIL) {
+	if (req->flags & REQ_F_FAIL) {
 		io_req_complete_fail_submit(req);
 	} else if (unlikely(req->ctx->drain_active) && io_drain_req(req)) {
 		return;
@@ -6962,6 +6960,15 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
+static inline void io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
+{
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
+		__io_queue_sqe(req);
+	else
+		io_queue_sqe_fallback(req);
+}
+
 /*
  * Check SQE restrictions (opcode and flags).
  *
-- 
2.33.0


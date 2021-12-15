Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA871476570
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhLOWJI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLOWJH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE56C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so80783095edv.1
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CkEVU7XIG1eQ8QRSJpyRf/GLitYv8kcXHmi3gDtDIxY=;
        b=W+yxrQBfsOPww5q5R5zoqD2frWQwgBi0klfgYL3eWZniXqLpCKL7IhoIvohg3m/YYs
         ERP3bg/elrtdNAAY0FPwJ8t9w2zoy3hAb6IUfhGKbOl166RIipyAbPrweWHPRpcJKlpw
         dnJYzYOpOn2I9HB5L6EoGYgojmDiJ4jxF81FFykHByMDv6RoCRBgqkvOlvO0Otp9eOeQ
         PhfslGUVCIceZ3Lp5bxdsSK5Se9D2TzynPel84etY5I/S1wVfwApMNKsgoioc2cPkhTq
         zb11zyygFi1Pfp8jWjTY55n6QOwGttcqnAf2oRpCOvRW1XNFxW24p9C/kg8hEjufdQ2e
         dajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkEVU7XIG1eQ8QRSJpyRf/GLitYv8kcXHmi3gDtDIxY=;
        b=u2qEkKScFaivy9Z6hw128/R25jQwcClNORyIklVMMG1nx9pODASSuTKnrD00Z3umM4
         pCQ1yP5qSCqkezEyG57tUAaYmHEkEMWHwdGmExkshHzlGyAACXV7rLcS15Jop0eIMjn6
         F2uaslHwygm0kqEZ1az0ABr5PRB8UwcO58/T0wVNbW1WPHGKFOlWstySHL9IPXP8lwXf
         pD7hRV8J/2p3i4qoQkyo+oJkG21LKwQk8tzX2DiCPoCNitoOU1FEXq3bCm/XrEG8JC8C
         z0/mf42RW0OV0/kyUp7b+qKqeRreXrzcOpPRcqcKaCBWzRttBoulAUwXQhxe3zU3QN2D
         1NDw==
X-Gm-Message-State: AOAM533ew+M7LL9D2QFaGO49yvaugLoBqK3ncWdn87q+AeEfe4S+QOQC
        +D5VS9IHFkpSy6slmQ05unrmB4hrKzw=
X-Google-Smtp-Source: ABdhPJzOoZmiQUmsqGoLgNWwReexl6Jlyc5PlZi4xX5tCKgWLbCjBLJXHequcoqCjkWWVwAaWuhNNA==
X-Received: by 2002:a17:906:69c5:: with SMTP id g5mr7653418ejs.41.1639606145209;
        Wed, 15 Dec 2021 14:09:05 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring: kill poll linking optimisation
Date:   Wed, 15 Dec 2021 22:08:47 +0000
Message-Id: <15699682bf81610ec901d4e79d6da64baa9f70be.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With IORING_FEAT_FAST_POLL in place, io_put_req_find_next() for poll
requests doesn't make much sense, and in any case re-adding it
shouldn't be a problem considering batching in tctx_task_work(). We can
remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c106c0fbaca2..9a2b3cf7c0c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5485,7 +5485,6 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt;
 
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock(&ctx->completion_lock);
@@ -5509,11 +5508,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
 
-		if (done) {
-			nxt = io_put_req_find_next(req);
-			if (nxt)
-				io_req_task_submit(nxt, locked);
-		}
+		if (done)
+			io_put_req(req);
 	}
 }
 
-- 
2.34.0


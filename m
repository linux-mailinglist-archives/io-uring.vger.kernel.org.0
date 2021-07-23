Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC03D4015
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhGWRTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGWRTS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 13:19:18 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D77C061757
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id a13so3572784iol.5
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wjrJyb643sQQqDleVH/3SoR9O00Zhd8VFH0YN6bKByc=;
        b=pEyK32P40D+PRJTE2h4eml+JBfW9xghXmNjBMDhDznZgFa7ZQGdThOjgoODGcxOavX
         a0RHUp9b7WTdoqLiAp7hxCAHRlCfrZxPsL1Lp2TxUeGWn2xuSpTCIuhVffypRSo/+zXW
         O/7/Xe1dPji6nUkKCg6lI7qwVC1ziQJViU4Votsf9uOuX2L23nQKjkcY9sEyZTGU4Cjh
         Pxq7D1R0jcQLNFi2EAU/3F4ewHxrOmkAdL5i1CALIV1EmpuNhJQiZWkr54NbSGSuhQly
         NAo1rsZe+Xyi+LeHeBHykEHr2Rv1r04CoLfC3E1JaEd6mbcAZAxKhDEmWr6BgQfik9Ks
         PIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjrJyb643sQQqDleVH/3SoR9O00Zhd8VFH0YN6bKByc=;
        b=ptGkOB/Mr9TnbODVHQWfGoOgHjLV5HoxBMOh/OdrooC1/lyfFwWTeSqBGJ9/g/69QC
         QrIERwXAiWTIw1WJ8CMfkQ6zhnqffE2gtK2foHt4B51YCBOcm537PppfDC/lbnl9BxT+
         ZeVITd5/PRoYb3aUvSwBUv9vcfj1oKzZSX6NirUvrPPRMTZkCzaxuV1gSeUMUZZ9+H40
         MCqybAAwRcDgWj0hY0Oe+t8VwwEORO6Y5q+AtidgP+RpA9QoAWTXWuv53qDOf5NxbV1j
         aW5QlYD9Xp42V/Yfv01VupeAZO0/gV3AAGSMN2yw5Vqao3lzfPhncaiLT8/wA+uLkb+4
         /g3w==
X-Gm-Message-State: AOAM530FYUcaHOAClA0rzkvWM/kcj3aghvvz7cI27rfdviYLlpmA25K3
        LUWgTQHA3DKyq/1HcN2OvpEE33eZh0YfHNS1
X-Google-Smtp-Source: ABdhPJzC3Gw3R98tZHXPUOsQdr2AF4+ClWiumbDyzMdV7LhFrgfTZFEfaBL9Euu7NVJ9C6vs5NILjA==
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr4986453jat.102.1627063190107;
        Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u13sm17696533iot.29.2021.07.23.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:59:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: never attempt iopoll reissue from release path
Date:   Fri, 23 Jul 2021 11:59:44 -0600
Message-Id: <20210723175945.354481-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210723175945.354481-1-axboe@kernel.dk>
References: <20210723175945.354481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two reasons why this shouldn't be done:

1) Ring is exiting, and we're canceling requests anyway. Any request
   should be canceled anyway. In theory, this could iterate for a
   number of times if someone else is also driving the target block
   queue into request starvation, however the likelihood of this
   happening is miniscule.

2) If the original task decided to pass the ring to another task, then
   we don't want to be reissuing from this context as it may be an
   unrelated task. This can only happen for pure read/write, and we'll
   get -EFAULT on them anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f2fe4eca150b..117dc32eb8a8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2205,7 +2205,7 @@ static inline bool io_run_task_work(void)
  * Find and free completed poll iocbs
  */
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
+			       struct list_head *done, bool resubmit)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2220,7 +2220,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN &&
+		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			req_ref_get(req);
@@ -2244,7 +2244,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
+			long min, bool resubmit)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2287,7 +2287,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done);
+		io_iopoll_complete(ctx, nr_events, &done, resubmit);
 
 	return ret;
 }
@@ -2305,7 +2305,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0);
+		io_do_iopoll(ctx, &nr_events, 0, false);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2367,7 +2367,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
+		ret = io_do_iopoll(ctx, &nr_events, min, true);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -6798,7 +6798,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
+			io_do_iopoll(ctx, &nr_events, 0, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.32.0


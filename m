Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2DE788321
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 11:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbjHYJLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbjHYJLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 05:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861F1BF2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 02:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692954639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOxXzYAwVk8su+pAQL33hLOQLiZp2L1Fw6EIRqNjBM4=;
        b=CNW8ZCL1xdczWClxW9kvQCEvoII9Z3jzEDRWuZLs9CFQ1m+IqAg5VOubDxyZEnYAQCY4ZJ
        zF1wavjtig++n5TnLaAYohx4y8riJwD9BNUtcQQkHxeMq+tsdu9t4gQylqZwq5PR/ugUT5
        dcc6Q0kb9Zmtgmng3dEg93A11vdzkBE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-hmyKhL_UOX6qMuiVzf9KnQ-1; Fri, 25 Aug 2023 05:10:34 -0400
X-MC-Unique: hmyKhL_UOX6qMuiVzf9KnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B118108BD87;
        Fri, 25 Aug 2023 09:10:34 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58AD66B59D;
        Fri, 25 Aug 2023 09:10:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/2] io_uring: add one helper for reaping iopoll events
Date:   Fri, 25 Aug 2023 17:09:58 +0800
Message-Id: <20230825090959.1866771-2-ming.lei@redhat.com>
In-Reply-To: <20230825090959.1866771-1-ming.lei@redhat.com>
References: <20230825090959.1866771-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare for reaping iopoll events before exiting io_wq, which may depend on
iopoll.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 88599852af82..c4adb44f1aa4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3214,6 +3214,23 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
+static bool iopoll_reap_events(struct io_ring_ctx *ctx, bool reap_all)
+{
+	bool reapped = false;
+
+	/* SQPOLL thread does its own polling */
+	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && reap_all) ||
+	    (ctx->sq_data && ctx->sq_data->thread == current)) {
+		while (!wq_list_empty(&ctx->iopoll_list)) {
+			io_iopoll_try_reap_events(ctx);
+			reapped = true;
+			cond_resched();
+		}
+	}
+
+	return reapped;
+}
+
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct task_struct *task,
 						bool cancel_all)
@@ -3245,15 +3262,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
 
-	/* SQPOLL thread does its own polling */
-	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-	    (ctx->sq_data && ctx->sq_data->thread == current)) {
-		while (!wq_list_empty(&ctx->iopoll_list)) {
-			io_iopoll_try_reap_events(ctx);
-			ret = true;
-			cond_resched();
-		}
-	}
+	ret = iopoll_reap_events(ctx, cancel_all);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
-- 
2.40.1


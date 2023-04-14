Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90036E1D8A
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 09:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjDNHyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 03:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDNHyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 03:54:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D288F1FFB
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 00:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681458811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=649Sni8cABbA1v9JMDztH2SvOlylMAif1+mJCP9JTyI=;
        b=X/CbE51Hbi7pRIGGKmiuJtNcarlTAJpguxjt9orG7lXuESgw5076lvLP7hD7CrjgOVJ9XJ
        kGZpwV5xXa/R80Ewr08zm8PdPgALQSjICMea5MNTVR/rQIGdU70ZSc3pqeu2eIaduyI4LB
        0JmABwro2F1I1nhoiEQST29rC/VtzXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-F6bvYNbXPKCDJ8AFpNOgzw-1; Fri, 14 Apr 2023 03:53:29 -0400
X-MC-Unique: F6bvYNbXPKCDJ8AFpNOgzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 513D085530E;
        Fri, 14 Apr 2023 07:53:29 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EB56BC88;
        Fri, 14 Apr 2023 07:53:27 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] io_uring: complete request via task work in case of DEFER_TASKRUN
Date:   Fri, 14 Apr 2023 15:53:13 +0800
Message-Id: <20230414075313.373263-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So far io_req_complete_post() only covers DEFER_TASKRUN by completing
request via task work when the request is completed from IOWQ.

However, uring command could be completed from any context, and if io
uring is setup with DEFER_TASKRUN, the command is required to be
completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
can't be wakeup, and may hang forever.

The issue can be observed on removing ublk device, but turns out it is
one generic issue for uring command & DEFER_TASKRUN, so solve it in
io_uring core code.

Link: https://lore.kernel.org/linux-block/b3fc9991-4c53-9218-a8cc-5b4dd3952108@kernel.dk/
Reported-by: Jens Axboe <axboe@kernel.dk>
Cc: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9083a8466ebf..9f6f92ed60b2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1012,7 +1012,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (req->ctx->task_complete && (issue_flags & IO_URING_F_IOWQ)) {
+	if (req->ctx->task_complete && req->ctx->submitter_task != current) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-- 
2.38.1


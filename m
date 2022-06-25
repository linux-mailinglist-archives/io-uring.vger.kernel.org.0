Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DF355A91E
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiFYKx2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiFYKx1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471C193C1
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k129so1193940wme.0
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PyXk91LZeup4OW4fOSE9VHxAndTow2OU7Kvxw5VkVlk=;
        b=A+Mxg+7kvJAe23+t/uT20Z3CVMvfJon8AAkYeyf/Am/eQcGcEFkGQsPhxqfBNbSIf6
         5ZD80Cw+R3OHfYGsYoTUZF7essXWEjU/tg8xtKxBgqsPDzXd6gs0YgM/vHoHNGlwenmd
         ZpAhirawy+OZbdgs1frSQ7wHpV+p/a++eAxX59homA4n/i8DEXMkFDfqCj56AxHZ+57e
         m7/OTa+WdpJacVMCgRY36RB32bw8wzz/Wzw//VBcbe5Be8JBZy1JzyUXwbTrk8wlCgW+
         nqC00vPF8j9hu67LkJ8lvnqiPr3Zi+u6RbVkmVrB8pqCPj/SO6qJt+yJphD6L889T5NW
         U/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PyXk91LZeup4OW4fOSE9VHxAndTow2OU7Kvxw5VkVlk=;
        b=dY9jA0Avqbho0TVhkMNMEfCzfvdX5RNgiEOj9iWXIzlsdS0cslcEpO6zsRzlQLF4R+
         6AcYx4puwkNzPvcDqz+UHs/PfoIq28xwapw1jtZSpu6n6zq8dXHbIoQF7Sfa7C/Gq97n
         gHgnZFBV4sMm+KoYklajhRWVD8e2p/bC61+qmdIPdNn5x+SvGgE4JhdfA7R2YdSTlJFR
         oXDe/UeiVRQhdMLYNbCzcFp0ACT12cdv95tamBuzMYe8NFdFxmPtVR95Orqnlbvx6qb5
         tKNFZPeO6sTXVXc+vn9Gkw1dD1RNPlxgQJi0CRsQYOEdNG4mnQ8UzHsdOP9cZeq8sjUT
         u/EA==
X-Gm-Message-State: AJIora8UxgZ1kKexC7ZY4ChUNv8lkRKinZ/BZ8NfwQ3md1cRYzxEfM/b
        bkJvVLPwZgnwiUbqgio4SO7fw7v8Enmz2g==
X-Google-Smtp-Source: AGRyM1s7zhxMYMR/ua6b+2kOLJgPtTnhuT30kChcppHE4l/eWq+3ekkTgH2KSz7OlCPritRw/vMODw==
X-Received: by 2002:a05:600c:1c8d:b0:39c:4db1:5595 with SMTP id k13-20020a05600c1c8d00b0039c4db15595mr8580347wms.175.1656154405123;
        Sat, 25 Jun 2022 03:53:25 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/5] io_uring: improve io_fail_links()
Date:   Sat, 25 Jun 2022 11:52:58 +0100
Message-Id: <a2f68708b970a21f4e84ddfa7b3abd67a8fffb27.1656153285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
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

io_fail_links() is called with ->completion_lock held and for that
reason we'd want to keep it as small as we can. Instead of doing
__io_req_complete_post() for each linked request under the lock, fail
them in a task_work handler under ->uring_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4af074b8f6b7..2f9e56935479 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -101,32 +101,44 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->timeout_lock);
 }
 
-static void io_fail_links(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
+static void io_req_tw_fail_links(struct io_kiocb *link, bool *locked)
 {
-	struct io_kiocb *nxt, *link = req->link;
-	bool ignore_cqes = req->flags & REQ_F_SKIP_LINK_CQES;
-
-	req->link = NULL;
+	io_tw_lock(link->ctx, locked);
 	while (link) {
+		struct io_kiocb *nxt = link->link;
 		long res = -ECANCELED;
 
 		if (link->flags & REQ_F_FAIL)
 			res = link->cqe.res;
-
-		nxt = link->link;
 		link->link = NULL;
+		io_req_set_res(link, res, 0);
+		io_req_task_complete(link, locked);
+		link = nxt;
+	}
+}
 
-		trace_io_uring_fail_link(req, link);
+static void io_fail_links(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	struct io_kiocb *link = req->link;
+	bool ignore_cqes = req->flags & REQ_F_SKIP_LINK_CQES;
+
+	if (!link)
+		return;
 
+	while (link) {
 		if (ignore_cqes)
 			link->flags |= REQ_F_CQE_SKIP;
 		else
 			link->flags &= ~REQ_F_CQE_SKIP;
-		io_req_set_res(link, res, 0);
-		__io_req_complete_post(link);
-		link = nxt;
+		trace_io_uring_fail_link(req, link);
+		link = link->link;
 	}
+
+	link = req->link;
+	link->io_task_work.func = io_req_tw_fail_links;
+	io_req_task_work_add(link);
+	req->link = NULL;
 }
 
 static inline void io_remove_next_linked(struct io_kiocb *req)
-- 
2.36.1


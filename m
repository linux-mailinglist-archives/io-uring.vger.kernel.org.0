Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3431A35977D
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhDIIRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 04:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbhDIIRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 04:17:49 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F92C061760
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 01:17:36 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p22so2444134wmc.3
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 01:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IBH95+Nh4kZtzWHWb4PICs8jkhyjjHTADzhvH3RFsII=;
        b=GkhO8+QYCrjJiR2j+kwolEclGTnRczq5UCyWZXGytJIqseKvNloacFaI+3foKI25y7
         ZDMHKrVDblxpGDYmuExoYPTJMAJiOfv3Ix4izJgBuGfklEHD0ZPO6Ue2E33HKPNIAIyx
         jb6B38iM3GTWNZAdT5lz8NKfJ2B/6AzfzZqw9JCqAIvFyUitFncQbcnOnc7GW6agNaME
         W9ukSlWAqEu2cfAPyx/InHtpL2QTuWkrg3yy4QcRnL1j8xnT8GkKQZ8F7wDVmx7zlQxh
         kwdpMhVk/tbzH+fx+HniTrzNzU2Kb7yf6fO/GMk9DmWUTQTdzycnWUQdpvGel90rJbLx
         G8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBH95+Nh4kZtzWHWb4PICs8jkhyjjHTADzhvH3RFsII=;
        b=jLfr7vDh0VAo0S3ilzC9VKMY4RnP4MDXm3A1ZRgl1BlaIfuwYCnoW6vnGhLZ//qmkl
         L9ZnJa6ha4x9VhAH3aj30Psyt1QLUJlKDfGZXW3HzLty6pKTFBcf45C2tkBLEOIS6vc3
         qa54SJzuOmeP2H2b2KplB5HNVjBnQTk61TvRYzsltc0fPNA9ee+6q7Dpc7GlO2JRO9W1
         btFGScNXJQ78+/50FEeqUPEpRZpIZd/3D1gPJmhwDcUQ0BjqfOKG7AYgHzE47KzYGA9s
         KzzN143HZ1bKPlF09lbmwJweBt58V1n3Zw50iBCsouvMjX3qqjEyHM6kqDWRht4XSrHG
         JAQQ==
X-Gm-Message-State: AOAM531oZiIGcQKHBKSytjYYY65q9zjwBCkpnPvtcboPQRtK2WXY8ye7
        2B7O7w0M3gQrW/LPoUxBR9U=
X-Google-Smtp-Source: ABdhPJxelgbRydUPmAhlfeBxnVm/bLktCml9QTgWhtyHHLdSkUl3eTknsb9K6DNOUjE5GDTooqWqEw==
X-Received: by 2002:a05:600c:9:: with SMTP id g9mr13016921wmc.134.1617956255331;
        Fri, 09 Apr 2021 01:17:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id d2sm3262133wrq.26.2021.04.09.01.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:17:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: refactor io_poll_complete()
Date:   Fri,  9 Apr 2021 09:13:20 +0100
Message-Id: <beb0f934268dc7e619367118e8e59afd7047f9f5.1617955705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617955705.git.asml.silence@gmail.com>
References: <cover.1617955705.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove error parameter from io_poll_complete(), 0 is always passed,
and do a bit of cleaning on top.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f662b81bdc22..c5a0091e4042 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4875,18 +4875,19 @@ static void io_poll_remove_double(struct io_kiocb *req)
 	}
 }
 
-static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
+static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags = IORING_CQE_F_MORE;
+	int error;
 
-	if (!error && req->poll.canceled) {
+	if (READ_ONCE(req->poll.canceled)) {
 		error = -ECANCELED;
 		req->poll.events |= EPOLLONESHOT;
-	}
-	if (!error)
+	} else {
 		error = mangle_poll(mask);
+	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
 	if (!__io_cqring_fill_event(req, error, flags)) {
@@ -4909,7 +4910,7 @@ static void io_poll_task_func(struct callback_head *cb)
 	} else {
 		bool done;
 
-		done = io_poll_complete(req, req->result, 0);
+		done = io_poll_complete(req, req->result);
 		if (done) {
 			hash_del(&req->hash_node);
 		} else {
@@ -5395,7 +5396,7 @@ static int __io_poll_add(struct io_kiocb *req)
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		io_poll_complete(req, mask, 0);
+		io_poll_complete(req, mask);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
-- 
2.24.0


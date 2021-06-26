Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78023B5018
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhFZUnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUnh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B809C061766
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o35-20020a05600c5123b02901e6a7a3266cso5770839wms.1
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g/COLhNE1jeCgNlbiKFi10kTctLdXTeN2XVdpJLCEmQ=;
        b=RDqvyOr3hOpjO+f0U/FXj623blnJspxpQQ56vCgDZncUxjAsR92K6BwvgIHHNgqPoc
         Qnz4Usb9Yr4iwJ1X083hl26Ij20H9bmW/sWgXhP2oifUXsxhTHfNuCe3RKxCzIpVg/sM
         BVlLyGuT1QEPKhPD9G+NvJvUpG3tKt1xgdW7Wn3s8uHnLyVXd04MxwOCiMochs0mL54O
         N12LCyfypqtg0nRGqPHSKQNDBnzVrE3IxCSyAgSAIRfe9fYDDzjKFGOWtzkNVo+42P47
         1gT4YHjTH5Tt++g7FWpoFm3mRSRET4mbYHwWjLLH4jmySN1Z/YXf52KQxZqXiocey5VI
         T/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g/COLhNE1jeCgNlbiKFi10kTctLdXTeN2XVdpJLCEmQ=;
        b=LBblAuoim+9c2YjMvK65Sp/JRVeRdlL1QAFfxyVVkXDi3dlguFCm8qlw7/FcQpEODN
         hEnUoe0pq7lncfqErQYcqXaDONrXA7OSobiYnGn8oyszKjjglwW3+OIunJA+vuVM7eI/
         IbniJPfS0G9Mg0ankm0CEcZXFh7/rNdJvUfrtw+SaNciWewhZD37x19mKzxzTGVWbwMX
         z9B6I3d40AHdzmFyJY1flVxJMnZ0WCjYk9ZAKtP+5YgkWs7ALYjzvzEV4hLsn4LBmgPq
         liVlJHTwGojgKsTzPeholvFQ35jLBpG9BTJtjG6bYCDiLXt7gO47k+iwkeyYgtmum9me
         i41w==
X-Gm-Message-State: AOAM533Itm7LEz1swmotHr3hD8/dO97nbVEHw19q8m18z3L/3ar3dg51
        0zAfbBhlbQa4ZUTKn0Ox4XU=
X-Google-Smtp-Source: ABdhPJxfZM244PxgoEy+zv7vkDCdPeaXOAsYYxYXHvldfaedL00Z8JVYDx5geCp6xK7s7b/x+0GwYw==
X-Received: by 2002:a1c:4c0c:: with SMTP id z12mr18472450wmf.0.1624740072189;
        Sat, 26 Jun 2021 13:41:12 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/6] io_uring: refactor io_arm_poll_handler()
Date:   Sat, 26 Jun 2021 21:40:44 +0100
Message-Id: <1deea0037293a922a0358e2958384b2e42437885.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

gcc 11 goes a weird path and duplicates most of io_arm_poll_handler()
for READ and WRITE cases. Help it and move all pollin vs pollout
specific bits under a single if-else, so there is no temptation for this
kind of unfolding.

before vs after:
   text    data     bss     dec     hex filename
  85362   12650       8   98020   17ee4 ./fs/io_uring.o
  85186   12650       8   97844   17e34 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23c51786708b..0822e01e2d71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5342,19 +5342,29 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask, ret;
+	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
 	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
 	if (req->flags & REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
-	if (def->pollin)
+	if (!def->pollin && !def->pollout)
+		return IO_APOLL_ABORTED;
+
+	if (def->pollin) {
 		rw = READ;
-	else if (def->pollout)
+		mask |= POLLIN | POLLRDNORM;
+
+		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+		if ((req->opcode == IORING_OP_RECVMSG) &&
+		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
+			mask &= ~POLLIN;
+	} else {
 		rw = WRITE;
-	else
-		return IO_APOLL_ABORTED;
+		mask |= POLLOUT | POLLWRNORM;
+	}
+
 	/* if we can't nonblock try, then no point in arming a poll handler */
 	if (!io_file_supports_async(req, rw))
 		return IO_APOLL_ABORTED;
@@ -5363,23 +5373,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
-
-	req->flags |= REQ_F_POLLED;
 	req->apoll = apoll;
-
-	mask = EPOLLONESHOT;
-	if (def->pollin)
-		mask |= POLLIN | POLLRDNORM;
-	if (def->pollout)
-		mask |= POLLOUT | POLLWRNORM;
-
-	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
-	if ((req->opcode == IORING_OP_RECVMSG) &&
-	    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
-		mask &= ~POLLIN;
-
-	mask |= POLLERR | POLLPRI;
-
+	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
-- 
2.32.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF53508858
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352877AbiDTMoY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352501AbiDTMoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:44:24 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021B7205E1
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so3591723wml.2
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZWYODZste/5KLswXvQQQujOO1gF+p66BDpclwjqZFnQ=;
        b=AN+K+GvREa7AJ/UvQrnn32I134pip8wO701pnfyXiqBywpwCPHO1ERkRZLL2islFns
         p87bAGEfzxTMd8eq0docT+S1uBEywEQO+0EDzxbFDhVVczrpq37+zXL8FEgFEgXWMPlE
         rfGJxcGIb3rQKwr6Bs+CAaaaWWlCN+sIGr9lEiP0XBTHxAXnT5EQxLRxRMGf+jYIPMtR
         wfVwFYUkoMtITdccCn0bJbf/Xh56DIaa0rnxFKGocRULUZcKRDG9U2VTAoBwAzNQPQMP
         lBec2K1e+/n4tDLllrY5Q/h8bwrTR1NcIqKxN9CM4rhczLcMaF/H5DYr6dC7SCaM8V0A
         NBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZWYODZste/5KLswXvQQQujOO1gF+p66BDpclwjqZFnQ=;
        b=7seeHkdSg+v/M0/PUFxWErDAFIz06WiwN9Nw3ZIXSg5zayhfnHJmn8uhmGVEu56u94
         6VfDg5aRDez6JaQhGr/oykL6SCVixNjBxMgjSgLpPakU7vBSKw073qKrAvWC1dJHgsd0
         n92lxHA5cT6btEHg4gYUza/oOT0gV3Ecs4w7Wzum+TnLaTU+DzEsBvq3ASPM17LaIoZP
         HCubwAEh4fU/XoapAwp+RZo0Y1ej7V/NjZUOt3nPLIUGVOE06GjjQW6n1A+IOFRbXW1L
         /Tq52ZmUAtZVE6BAlgCDgh63uZZ0ngSyi+SaNxK80iRjqg9Jcf6VlR7+0RTk2Ddm5DVf
         11Ig==
X-Gm-Message-State: AOAM533wdJG2qJfDxEQ5LSBGkpuvgbxAcFD+kLA53q0rZdNBV/QiWOWr
        zHGH4gnNshwy9DirgB/STl0stgOav+Y=
X-Google-Smtp-Source: ABdhPJxH+ufyC63gnUUmmkVKqDRHGxXaHpbaedsyJ19wkniJnR6mxCynfkKIQsxdvaqMeTKsDKuVAQ==
X-Received: by 2002:a05:600c:3d96:b0:38f:fbc6:da44 with SMTP id bi22-20020a05600c3d9600b0038ffbc6da44mr3498517wmb.93.1650458496434;
        Wed, 20 Apr 2022 05:41:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-244-154.dab.02.net. [82.132.244.154])
        by smtp.gmail.com with ESMTPSA id v11-20020adfa1cb000000b0020ab21e1e61sm971322wrv.51.2022.04.20.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:41:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: refactor io_disarm_next() locking
Date:   Wed, 20 Apr 2022 13:40:55 +0100
Message-Id: <0f00d115f9d4c5749028f19623708ad3695512d6.1650458197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650458197.git.asml.silence@gmail.com>
References: <cover.1650458197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split timeout handling into removal + failing, so we can reduce
spinlocking time and remove another instance of triple nested locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce5941537b64..1572edf97c06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2355,7 +2355,7 @@ static inline void io_remove_next_linked(struct io_kiocb *req)
 	nxt->link = NULL;
 }
 
-static bool io_kill_linked_timeout(struct io_kiocb *req)
+static struct io_kiocb *io_disarm_linked_timeout(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 	__must_hold(&req->ctx->timeout_lock)
 {
@@ -2368,11 +2368,10 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_req_tw_post_queue(link, -ECANCELED, 0);
-			return true;
+			return link;
 		}
 	}
-	return false;
+	return NULL;
 }
 
 static void io_fail_links(struct io_kiocb *req)
@@ -2406,11 +2405,11 @@ static void io_fail_links(struct io_kiocb *req)
 static bool io_disarm_next(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
+	struct io_kiocb *link = NULL;
 	bool posted = false;
 
 	if (req->flags & REQ_F_ARM_LTIMEOUT) {
-		struct io_kiocb *link = req->link;
-
+		link = req->link;
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
@@ -2421,8 +2420,12 @@ static bool io_disarm_next(struct io_kiocb *req)
 		struct io_ring_ctx *ctx = req->ctx;
 
 		spin_lock_irq(&ctx->timeout_lock);
-		posted = io_kill_linked_timeout(req);
+		link = io_disarm_linked_timeout(req);
 		spin_unlock_irq(&ctx->timeout_lock);
+		if (link) {
+			posted = true;
+			io_req_tw_post_queue(link, -ECANCELED, 0);
+		}
 	}
 	if (unlikely((req->flags & REQ_F_FAIL) &&
 		     !(req->flags & REQ_F_HARDLINK))) {
-- 
2.36.0


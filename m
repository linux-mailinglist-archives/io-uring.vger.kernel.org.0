Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDCD5531F7
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 14:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350008AbiFUMZm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 08:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350078AbiFUMZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 08:25:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06BE26110
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 05:25:38 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q9so18695753wrd.8
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piYf61c1MxXynroadp8q+j+sNjCiSes4RSzNriPuopQ=;
        b=k7Z0wmUO4n+7zAqfQtqgHw59IhJOFdmp8I8ZcbqrBr8rLH6DZ4JhsaBZRgZq0S01dC
         yyyMYgL+WpHjmNE/Aea+RiTcM0KxC/NNygLfLG/U5d1ETtklHhxtXYtDzRWWJGxBbvGA
         G3OxmHiSzWc1m5hIit1/S7+Gm1YuepvjQ+hMheY6LRTJjzvYIuC09o+9OpC0Il1zvYJL
         lcB5gDHWBm+6qU81Zz6rAEG/1NMggCEkk04KQa9GGj2ivHERibclio4LU2VoIwbA1WGc
         qBC7U8xG0HuFslbf9qfuIue2UmDoM6JuvCXoyTJmsbrkc3P1pCALVSE5eplUOe6UXLq9
         etHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piYf61c1MxXynroadp8q+j+sNjCiSes4RSzNriPuopQ=;
        b=A5sFkyo0mXFubwcQUp2Rv3ypu8mrg1ouj1+IJZwtnY+ZRL4DFNGxdsxfUPsojVFWjk
         EBRj1cRc6ljXWftrVVEDDWBEv21RVf8Eh3iR9aH/rOkATCyIbV2aJLXBbf9MJkNkIJAY
         Gp3lAVcyA96aJQJEtbWclelxCIee/StxJEHrz2znhKs9MEzXUc1wPir9UmmED0TYh0xe
         m4ITnXKU/bEaejO4Oi5+2Cy4KZ2dzv3pH1KEi2+WDreQrlVzuWyxOj4kehUraZ8D2fC6
         Z3B6RuoXMJUNiHCu8JrmOzmyivXzA5SaHiz0pF+xpNo6AHOjzfUQvSyX+vCjlyfPznSU
         58bA==
X-Gm-Message-State: AJIora/WGSywtykWmZTGUS70AFXMNzLeDjx5Vls1Q2sG0bC4Lhq7eQNE
        FvB3q8A+PqQqmbsYhOs2zLhFTIkHU6cJEg==
X-Google-Smtp-Source: AGRyM1t1YOhGkUlPgkKux+wwKLSo0NCoS/LcoQVW1BnFxpfGE6bzYL2OU1RrHm58LHKl6wE0NUj9fA==
X-Received: by 2002:a5d:6209:0:b0:21b:9c52:9cf1 with SMTP id y9-20020a5d6209000000b0021b9c529cf1mr433738wru.47.1655814336559;
        Tue, 21 Jun 2022 05:25:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-235-103.dab.02.net. [82.132.235.103])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c3ac500b0039c457cea21sm17301614wms.34.2022.06.21.05.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 05:25:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19] io_uring: fix req->apoll_events
Date:   Tue, 21 Jun 2022 13:25:06 +0100
Message-Id: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

apoll_events should be set once in the beginning of poll arming just as
poll->events and not change after. However, currently io_uring resets it
on each __io_poll_execute() for no clear reason. There is also a place
in __io_arm_poll_handler() where we add EPOLLONESHOT to downgrade a
multishot, but forget to do the same thing with ->apoll_events, which is
buggy.

Fixes: 81459350d581e ("io_uring: cache req->apoll->events in req->cflags")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87c65a358678..ebda9a565fc0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6954,7 +6954,8 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
+static void __io_poll_execute(struct io_kiocb *req, int mask,
+			      __poll_t __maybe_unused events)
 {
 	req->cqe.res = mask;
 	/*
@@ -6963,7 +6964,6 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 	 * CPU. We want to avoid pulling in req->apoll->events for that
 	 * case.
 	 */
-	req->apoll_events = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
@@ -7114,6 +7114,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
+	req->apoll_events = poll->events;
+
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = 0;
@@ -7144,8 +7146,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask) {
 		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries))
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
+			req->apoll_events |= EPOLLONESHOT;
+		}
 		__io_poll_execute(req, mask, poll->events);
 		return 0;
 	}
@@ -7392,7 +7396,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
+	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
-- 
2.36.1


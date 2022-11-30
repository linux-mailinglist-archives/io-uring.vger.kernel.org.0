Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BBF63D94F
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiK3PX1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiK3PXZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:25 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E7E74639
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:24 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bx10so15549425wrb.0
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLJAaEfpJqzQKuaMa6gQqKCdtBAxlAHoBY9FLqBsiKY=;
        b=Ftg2V87aTsXhEdtSmHIMr+4tpTnj8KgXgCcxSCQPqotod0qDi4e0N7luoSul+U23XQ
         Pn0mFZG+lvQFViL41nzzwxROkg1S5bXi6tdIzkc21Ugm3e9HvpRz8hsi3pDPZ9/wZHJw
         yT6Lyben+btYVB4yOSPVxRzKqDZmmt38x0a8eJ7HJ0JzW/PAQxAi9UbNhT66GXcixetJ
         /KuMyN7BCiBIwzCleqNDPfwZ/AOLEXtvSzMPqgz42yDrN5fntZCTgfBr+OAFrxpe2VXo
         Sgv8Ao+xsx/rv/zv+GTGtVosqknux2jIIMj6FvO5kE+ViAPXrge+4bjszHhKfom9jngd
         M7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLJAaEfpJqzQKuaMa6gQqKCdtBAxlAHoBY9FLqBsiKY=;
        b=YgDm90uyXdKoXPZaQNS+6X1n4NUvQd3GnhL+Jj1O5fnNsmqxGAPwAJIjHRDmmZy1i8
         I53aiX5KnHvAamrUeaBsfh6Drs3bMAoNL6MPEV55AEswDcDOYrWZ1xjgA/79Tr4GIptH
         M4MW8Qyfm/jSV5P5NLl5VkBpEZ8mBJcraGh0hZoARcgkVse32MNJjwXtWmcJX/6XVBDb
         sI4FJC77u5zDLCnc8V0PaN9ARJHtCxavkoEK2ZfalmzSAkxg47ZtBrHXB1XatspcTmeA
         qyVB4dfcmFxTOWOnMqUSuVfze8+3fktiOJyDbjGFQma8/uUYz4zg6CT7mBg+znD1qITQ
         DcMQ==
X-Gm-Message-State: ANoB5pnh6BSyv23MoxkRy8WSdGIKlIUBnNy/ShyAnuyhqVslx+87p0ul
        trOg2i7TQyoeB6b8OddB1x9WX5fSKjw=
X-Google-Smtp-Source: AA0mqf523G64JKnzlmWh3Roci90fRnTbvzrU67YmJaEeDc8hg1nISBJwtvTJBX3n/7F0Mn+ZuLreFA==
X-Received: by 2002:a5d:44c8:0:b0:242:2a46:6ff9 with SMTP id z8-20020a5d44c8000000b002422a466ff9mr2618642wrr.371.1669821802895;
        Wed, 30 Nov 2022 07:23:22 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/9] io_uring: carve io_poll_check_events fast path
Date:   Wed, 30 Nov 2022 15:21:52 +0000
Message-Id: <8c21c5d5e027e32dc553705e88796dec79ff6f93.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
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

The fast path in io_poll_check_events() is when we have only one
(i.e. master) reference. Move all verification, cancellations
checks, edge case handling and so on under a common if.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 599ba28c89b2..8987e13d302e 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -247,27 +247,30 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 	do {
 		v = atomic_read(&req->poll_refs);
 
-		/* tw handler should be the owner, and so have some references */
-		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
-			return IOU_POLL_DONE;
-		if (v & IO_POLL_CANCEL_FLAG)
-			return -ECANCELED;
-		/*
-		 * cqe.res contains only events of the first wake up
-		 * and all others are be lost. Redo vfs_poll() to get
-		 * up to date state.
-		 */
-		if ((v & IO_POLL_REF_MASK) != 1)
-			req->cqe.res = 0;
-		if (v & IO_POLL_RETRY_FLAG) {
-			req->cqe.res = 0;
+		if (unlikely(v != 1)) {
+			/* tw should be the owner and so have some refs */
+			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
+				return IOU_POLL_DONE;
+			if (v & IO_POLL_CANCEL_FLAG)
+				return -ECANCELED;
 			/*
-			 * We won't find new events that came in between
-			 * vfs_poll and the ref put unless we clear the flag
-			 * in advance.
+			 * cqe.res contains only events of the first wake up
+			 * and all others are to be lost. Redo vfs_poll() to get
+			 * up to date state.
 			 */
-			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
-			v &= ~IO_POLL_RETRY_FLAG;
+			if ((v & IO_POLL_REF_MASK) != 1)
+				req->cqe.res = 0;
+
+			if (v & IO_POLL_RETRY_FLAG) {
+				req->cqe.res = 0;
+				/*
+				 * We won't find new events that came in between
+				 * vfs_poll and the ref put unless we clear the
+				 * flag in advance.
+				 */
+				atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+				v &= ~IO_POLL_RETRY_FLAG;
+			}
 		}
 
 		/* the mask was stashed in __io_poll_execute */
-- 
2.38.1


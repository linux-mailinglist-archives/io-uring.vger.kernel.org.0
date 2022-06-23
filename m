Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC769557CD8
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiFWNZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiFWNZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:25:27 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E25649C9C
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:26 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q9so27954707wrd.8
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OpnL0/Edc6qwJvOc9mzgGZ0HMTdXfCTcomSoBlCvR7Q=;
        b=m/YlUxZc6sv21dQYx+9gNcGEBbQs5n5oiXyViRGxylSJfyJWOTpm+wtzBzIiRrgzXC
         9rDMLFepxP17UUV0x499fYS4OMPaOVz++npIy6d0Hj/X+QhvxZDJqLQGhoRjduGurIuw
         CDSmO2UgTSajFmA2c9OaCEhUt/F9g0LC/GwwTgplSXPVz/2Vqdp+XBWJP+mkF3BXgmiu
         5vQO8ucx3woy1Web6n8LSQfl9j7mm9skwg67aol586YmGRMs6+f0Iz8OcCzNfQV7RZ3I
         essoKyhlr1s0cAGBPP6DgM29pxK9pxioBzEZOwNqWlojVBh/EHaYvuhLSr3c6bylsKhR
         0m/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OpnL0/Edc6qwJvOc9mzgGZ0HMTdXfCTcomSoBlCvR7Q=;
        b=asTxSVobGLmDeEc2hiBwGfJFtCMfNhecKyVrywizfKWhEW/2ZmiMfKlkAz3p+9vQjv
         97k7ba0iPi8H1sCJjn4/H7LR/hVx/8PSC9YTohBK5oFqwzrYOrEek4LLOd+cfmCo+/7k
         feb7fS/FrntpppWukdBSlMtfbvP0m75eUdF4vd5v3WpaLn1KhoGLx0PfDfWtGZxpsAJ2
         QI5uhUwApNEuCtdO4gFuc43zlXykEbVIb+GNRg07eNRZfYMsw/3yr6KcXoUby/x7myiQ
         0+Ms2lRtOmbHRw5xh+PdzCu7evmrqzGcZjV9Vt8B9UyREeAl9ZwRO0iPi+owOYL3VsCQ
         KYJw==
X-Gm-Message-State: AJIora9Rsg5uhC4diN9xz0f8xQr87CBeMrw68oci9kVXK4Dxfhx8lvTu
        5XuDaHmCKnPYNzAn3ay/zP24PvIlNLyUp3rz
X-Google-Smtp-Source: AGRyM1ulVIx6pCqksBSkkOYjc7iOKMrD3HkqLryo+wDpTGv3ilcleIfZDZPEq1eN/VuJ2L5xKuTs4Q==
X-Received: by 2002:adf:ea43:0:b0:21b:9243:be8c with SMTP id j3-20020adfea43000000b0021b9243be8cmr8075054wrn.650.1655990724769;
        Thu, 23 Jun 2022 06:25:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b0039c5a765388sm3160620wmk.28.2022.06.23.06.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:25:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 1/6] io_uring: clean poll ->private flagging
Date:   Thu, 23 Jun 2022 14:24:44 +0100
Message-Id: <9a61240555c64ac0b7a9b0eb59a9efeb638a35a4.1655990418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
References: <cover.1655990418.git.asml.silence@gmail.com>
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

We store a req pointer in wqe->private but also take one bit to mark
double poll entries. Replace macro helpers with inline functions for
better type checking and also name the double flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bd3110750cfa..210b174b155b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -39,6 +39,22 @@ struct io_poll_table {
 #define IO_POLL_CANCEL_FLAG	BIT(31)
 #define IO_POLL_REF_MASK	GENMASK(30, 0)
 
+#define IO_WQE_F_DOUBLE		1
+
+static inline struct io_kiocb *wqe_to_req(struct wait_queue_entry *wqe)
+{
+	unsigned long priv = (unsigned long)wqe->private;
+
+	return (struct io_kiocb *)(priv & ~IO_WQE_F_DOUBLE);
+}
+
+static inline bool wqe_is_double(struct wait_queue_entry *wqe)
+{
+	unsigned long priv = (unsigned long)wqe->private;
+
+	return priv & IO_WQE_F_DOUBLE;
+}
+
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
  * bump it and acquire ownership. It's disallowed to modify requests while not
@@ -306,8 +322,6 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 	io_poll_execute(req, 0, 0);
 }
 
-#define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1))
-#define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
 #define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -392,7 +406,7 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 			return;
 		}
 		/* mark as double wq entry */
-		wqe_private |= 1;
+		wqe_private |= IO_WQE_F_DOUBLE;
 		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
-- 
2.36.1


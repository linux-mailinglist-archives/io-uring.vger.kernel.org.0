Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85775576B0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiFWJfJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiFWJfI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:08 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0E24925E
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g18so1262584wrb.10
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OpnL0/Edc6qwJvOc9mzgGZ0HMTdXfCTcomSoBlCvR7Q=;
        b=cLh03/UGM4nwBvgwSxTqLRtmwY/fAz9pHBV8NxUN7G6DTcPZmwJE6co9ZHiuSfpLFg
         ci1Re6DXOC8ujigAYaN0/V/dD7eJ6nwoiI1yvH/neqrsT61LL3MDEsTpPWNUMygn02CZ
         8Pkuw6Kw7ZR+D/qdn6pZLbbXr/EqGzjkcMyf1Z0l7anSc6ClgWi1DSyb8TjruPo3Sm71
         UUKVHTnNVc0KphSFWJCcXdMO61uzpO9CVYDp8Oblh7/Ilc1tbMhEFrX8dU0pcCQDZZa/
         1epmwNHHfRsgdVDwi2fEyAqEF9McCPl2AvnGSmALye16TFbbIv0VCwIvBQtfxr28VDzU
         8KeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OpnL0/Edc6qwJvOc9mzgGZ0HMTdXfCTcomSoBlCvR7Q=;
        b=d32N+vHdgNto2XQBy8q3HliXjSZKbdkKGlsPtYEodl12GyzFphKn2BNmS1VXpJosZ/
         4UXLfTjSeKNr0RAVI1ctAmDEqVpyH4vQaGUQn6KkxzXUXyPODXPC5YtuzHxzkve9uLsO
         vlx054+tzO40ib8+g0S53Y8YfeAZ5Slr6r+59aTczCxUoAg4RQPLTLJlPjBxMuNcIiR1
         gTadmJNAMm74uxuGTG5i7KjKG122zitDQHZAm9vLa+mD4KatICvmant+5QHO4p6PMQCW
         e7HxCz8I3agxt/y9opY0RBaA6eKMNvUX9M935VzPU2vNDmWm/NHYHXfer8B0jhfPbAtv
         fMlA==
X-Gm-Message-State: AJIora9oH0ljJriKEcwyhLb2ii7dquFmvk2d6sCJs+UehEqP2GDyFXa2
        4ZjOArN7DXae6QVg6BjUamgSP3lNaMp36eMn
X-Google-Smtp-Source: AGRyM1sVV85kge9JSE+wHtTwfPT3X7SQH6Rnd5Ge7ntCCWYIPSccO9HXttWuEyI7cjTJupCEBoO7kg==
X-Received: by 2002:a05:6000:1869:b0:21b:933c:7e2 with SMTP id d9-20020a056000186900b0021b933c07e2mr7314511wri.252.1655976905524;
        Thu, 23 Jun 2022 02:35:05 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/6] io_uring: clean poll ->private flagging
Date:   Thu, 23 Jun 2022 10:34:30 +0100
Message-Id: <9a61240555c64ac0b7a9b0eb59a9efeb638a35a4.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
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


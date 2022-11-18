Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC82562FCE4
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 19:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiKRSlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 13:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiKRSlE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 13:41:04 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FB41E701
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 10:41:01 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t25so15115624ejb.8
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 10:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ejKvKVpxJrg3Cwq4Nm19XfMU6u6D2+DBY338FTVR5hM=;
        b=GpgUn6+DtusbadLCZM0WgVHBV/59CBRLDh3n12OlVQrjVxs5ioUSnI96WK8y7DtSTd
         DWxi1vyCAVlaR3qqxO3ZxXulwtuiFsSbqaBrMpffqDNuMuLOik5miXh1fIhGKlYONhpW
         AMGGson7kEmLMi+LTTO8RezEph/b9d5orW5fB4dFXhIoTW+5W1/JFcSumAZHKQm7m3VD
         6ynmiDWA+EwNUQIZCXOgyqJYvKOKhY5k9EKsNE/5Hpn0eIACx0ZmiArgx74GgPsfhMPe
         LvOCInHasUOWUnnHhtDyw8+5C0iPY7F7TtqABJcYxQVkacywxQwdfNp0Pa7QCdelCyTX
         Z4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejKvKVpxJrg3Cwq4Nm19XfMU6u6D2+DBY338FTVR5hM=;
        b=tnyYR55TsZO7mer2jSqKv1DaiTTMBh/lHY7i2o0Xt7E3JBQM8xM54Uzs+T3ntBDMZM
         KyZfCF22/jPqyeYC6fuFzBJybVcDqSU1h/4eTtcOv+KqAZn+nSDLyuBH96eUuiBNWbHc
         JDReZfQGck/iiTYxw8Pq1p2g/6V97sh93ImzjvmSDTUv45ZHe9AOdUA7oe1BcAJE6xs2
         NgQNKEKh/k6hrEXycKHopMcds9zq2+4z6zniCp0hm6xt1U8rzzQgtwXuJSmZvw8q1wgF
         qiVCuRW8J7QHLdgZn4uCXp5ruepFTMfYVIylfxPLUzvEOEuiQpBql0iVrqceqhxr7mtg
         c8UQ==
X-Gm-Message-State: ANoB5pkDdwPMkK6ao5d3QRhx65ZX1QV9ExlFggKv11mg3yFHftHbbeJF
        wnQO2kLtk0q5gYRM8FXhBpkjlzndDL0=
X-Google-Smtp-Source: AA0mqf5zGr1UyaWHG5vCplUNi7E34NHtWxwLjVFq5IfyGvZLkUK8SLKdyua2OoFLuQ++1JYf1qOZag==
X-Received: by 2002:a17:906:a1cb:b0:781:fcf6:e73a with SMTP id bx11-20020a170906a1cb00b00781fcf6e73amr6880614ejb.352.1668796859721;
        Fri, 18 Nov 2022 10:40:59 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:38ce])
        by smtp.gmail.com with ESMTPSA id q24-20020a170906541800b007add28659b0sm2046529ejo.140.2022.11.18.10.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:40:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Lin Horse <kylin.formalin@gmail.com>
Subject: [PATCH for-6.1 1/1] io_uring: make poll refs more robust
Date:   Fri, 18 Nov 2022 18:39:24 +0000
Message-Id: <47cac5a4cb6b2e8d2f72f8f94adb088dbfd9308c.1668796727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is large and if so set a retry flag without attempts to
grab ownership. The gap between the bias check and following atomics may
seem racy, but we don't need it to be strict. Moreover there might only
be maximum 4 parallel updates: by the first and the second poll entries,
__io_arm_poll_handler() and cancellation. From those four, only poll wake
ups may be executed multiple times, but they're protected by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Horse <kylin.formalin@gmail.com>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..63f152332bf6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -40,7 +40,15 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+#define IO_POLL_RETRY_MASK	(IO_POLL_REF_MASK | IO_POLL_RETRY_FLAG)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
 
 #define IO_WQE_F_DOUBLE		1
 
@@ -58,6 +66,21 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (!(v & IO_POLL_REF_MASK))
+		return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+	return false;
+}
+
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
  * bump it and acquire ownership. It's disallowed to modify requests while not
@@ -66,6 +89,8 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -233,7 +258,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 * and all others are be lost. Redo vfs_poll() to get
 		 * up to date state.
 		 */
-		if ((v & IO_POLL_REF_MASK) != 1)
+		if ((v & IO_POLL_RETRY_MASK) != 1)
 			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
@@ -274,7 +299,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (atomic_sub_return(v & IO_POLL_RETRY_MASK, &req->poll_refs));
 
 	return IOU_POLL_NO_ACTION;
 }
@@ -590,7 +615,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		 * locked, kick it off for them.
 		 */
 		v = atomic_dec_return(&req->poll_refs);
-		if (unlikely(v & IO_POLL_REF_MASK))
+		if (unlikely(v & IO_POLL_RETRY_MASK))
 			__io_poll_execute(req, 0);
 	}
 	return 0;
-- 
2.38.1


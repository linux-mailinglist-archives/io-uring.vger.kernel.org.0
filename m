Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D724E5116
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 12:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiCWLRX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 07:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbiCWLRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 07:17:22 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676C87891C
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 04:15:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id w4so1579251wrg.12
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 04:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PXKcpgRPh91JNlDv0HzmtaxAarJGUMhVxYAWng4Z3NM=;
        b=EuYnlPVOOXKl8bjDs0wHhDHT2QCvTNpsS6d9t21fbFQb0aN2LV1AB3yZrbNxiMT8OB
         fmpI5Fn9lLEVarzUjN87nTiE55rziq2eVK5cotfceX3/Rz14vsZpe+DBUMQ32qZv2Kjv
         XXBDoS9qQNYKG3hr3NJCo1AxvEMcRQ0x21XviwU6rxCARyVcslQMb8lamOwqGoIG6orf
         2rz1bN+oCvuKvADnsXICCQJ84nexWEUDj5qXvzYMSaEF06QvXe8tFMHK7w+sDa147yfp
         g18ymPkDRCN4iKcCImSz7OzXyqm0EUdeFR1KR+k7jXUaDlGqhlk6j8HB5W7emE4cY2xq
         wjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PXKcpgRPh91JNlDv0HzmtaxAarJGUMhVxYAWng4Z3NM=;
        b=EypYQGPPWJS/JNWcSnz/jeQWyQogrx589kdvH/PkkGZ5Vt7meGdOkBo1P0KkbN85W6
         jqoosW328uOQn552G9JTmyEzeiN8tJpTR8MCg/mdCl2I1k6ih2+keU2jK6Ln0lmDwt/U
         m5LxMNUhgwB9Y6FJFgW0ASUiomMYgy3Wb329qRVPt9BC7zz8on1bqpIJwmeuiU0DAXOS
         5lP6nA0Gz5VgRptDGBoFJiQ0ncHWt9H9MTnbfg0F/AU5HViLyLh3WTtt12G8uWTg7gqg
         5MjeR2NxsP+HKtNTnjHzOXydexl8rGVEhZDxd4oPbPWDlDy4DIweTPqlRyevivaUGDsx
         /elg==
X-Gm-Message-State: AOAM532aRtVbUqcrdCJyAybb5+pwb2lHIro+YueASjjcIZOG4FFwnHom
        Bl+wG3lJr1/mU11bHccu55eEw7GwEVMelA==
X-Google-Smtp-Source: ABdhPJw1RON2GXCldbttwM7jNamhaQlCgizVrsFIGkBbsTU9AVk3U7X+b21HBFiGo6nMUaTcHSGXOA==
X-Received: by 2002:adf:f949:0:b0:203:e87d:1d38 with SMTP id q9-20020adff949000000b00203e87d1d38mr25630750wrr.137.1648034151732;
        Wed, 23 Mar 2022 04:15:51 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-253.dab.02.net. [82.132.233.253])
        by smtp.gmail.com with ESMTPSA id 3-20020a5d47a3000000b0020412ba45f6sm8585066wrb.8.2022.03.23.04.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 04:15:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH] io_uring: add overflow checks for poll refcounting
Date:   Wed, 23 Mar 2022 11:14:36 +0000
Message-Id: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

We already got one bug with ->poll_refs overflows, let's add overflow
checks for it in a similar way as we do for request refs. For that
reserve the sign bit so underflows don't set IO_POLL_CANCEL_FLAG and
making us able to catch them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 245610494c3e..594ed8bc4585 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5803,8 +5803,13 @@ struct io_poll_table {
 	int error;
 };
 
-#define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+/* keep the sign bit unused to improve overflow detection */
+#define IO_POLL_CANCEL_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/* 2^16 is choosen arbitrary, would be funky to have more than that */
+#define io_poll_ref_check_overflow(refs) ((unsigned int)refs >= 65536u)
+#define io_poll_ref_check_underflow(refs) ((int)refs < 0)
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
@@ -5814,7 +5819,18 @@ struct io_poll_table {
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
-	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+	int ret = atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK;
+
+	WARN_ON_ONCE(io_poll_ref_check_overflow(ret));
+	return !ret;
+}
+
+static inline int io_poll_put_ownership(struct io_kiocb *req, int nr)
+{
+	int ret = atomic_sub_return(nr, &req->poll_refs);
+
+	WARN_ON_ONCE(io_poll_ref_check_underflow(ret));
+	return ret;
 }
 
 static void io_poll_mark_cancelled(struct io_kiocb *req)
@@ -5956,7 +5972,7 @@ static int io_poll_check_events(struct io_kiocb *req)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (io_poll_put_ownership(req, v & IO_POLL_REF_MASK));
 
 	return 1;
 }
@@ -6157,7 +6173,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll_table *ipt, __poll_t mask)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
@@ -6204,8 +6219,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	 * Release ownership. If someone tried to queue a tw while it was
 	 * locked, kick it off for them.
 	 */
-	v = atomic_dec_return(&req->poll_refs);
-	if (unlikely(v & IO_POLL_REF_MASK))
+	if (unlikely(io_poll_put_ownership(req, 1) & IO_POLL_REF_MASK))
 		__io_poll_execute(req, 0, poll->events);
 	return 0;
 }
-- 
2.35.1


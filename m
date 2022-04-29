Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BFE51468A
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357356AbiD2KW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357354AbiD2KWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04985C6EC7;
        Fri, 29 Apr 2022 03:19:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p6so6746126pjm.1;
        Fri, 29 Apr 2022 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAN5M00tMGCt7cYAHPMykZoZSkRXa9pDaIi7lMh/leU=;
        b=nCJ4F1zjMZ205VIMqHnp0+uw5sid1mgYGfz9ZzzldLc50Dlqi7CKiVbPgnTK9+Yp2r
         6kRJT5LWGQiXolue7vKR2BYbZmC39MjQj9L0uZmoYDZNctNoKcg1FER1A6myWOP4LBZ1
         0iOKKQS8ryqM4l7k6ZZONil0w8HshoPe5xEAEG2795q40NKXa2jusfAyJWcmfvyKDNtJ
         AOCHmqedR3cyhd00na//MxKabJ2LPehq8iPY75WlpMUrCND+eHW9O6CjKU7P5OiH08xn
         WGaegh0LRxyExEnwoI+3SWKFcF4Vm/rRHZdye5gCnVgDQ28pEeR9TstANNJJRGOWGcmH
         5Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAN5M00tMGCt7cYAHPMykZoZSkRXa9pDaIi7lMh/leU=;
        b=ImgJhqpq6tN9K4vgweEt/0LQiobUJgjDrMEjYiKd+9zUQ+7AmIxM6G89drFbTmRkhA
         4IL4vyciPhiAtaLTeA9YsjuOem7vZ7ASG6lXVM78n9ZgbqA1ukvl99dQXbPv+v2TTLOg
         ua8CXXAYXnvKwbul3fzjswwwqx47SwPje45ALWwJt+FAMNVgR2YibqbzbiAg+MJsYtg4
         arSToPuwsTc4sCGtxJ8xUb9PijOdYJBB7ArhFJ0KE2hG+HyaVYpS9zBAZX9RrgqeOp+w
         Fhr0K/rYfiy7Wazho1HndKozndb9V9SNKzN//TIqPrksGS4l/ULsTzvKQmyoS1sHbu6d
         czpg==
X-Gm-Message-State: AOAM532qz8OOTFX+8SitZbbDSgUFZ6pmrOYMEwRxXQf36Q1TyQJpA1xH
        is3WlOFtZvRnCP5i1PwSRUb9abnjoM8=
X-Google-Smtp-Source: ABdhPJzvHPdb+ONPa9BmMrLisZLCOO8kIbFk/sTDGu2BRyrPaCFnVJS6d2bUAfiHMyJeQaJlEhLhgQ==
X-Received: by 2002:a17:90b:3445:b0:1d6:91a5:29fe with SMTP id lj5-20020a17090b344500b001d691a529femr3061966pjb.138.1651227544333;
        Fri, 29 Apr 2022 03:19:04 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:04 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] io-wq: tweak io_get_acct()
Date:   Fri, 29 Apr 2022 18:18:53 +0800
Message-Id: <20220429101858.90282-5-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add an argument for io_get_acct() to indicate fixed or normal worker

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index ac8faf1f7a0a..c67bd5e5d117 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -208,20 +208,24 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound,
+					      bool fixed)
 {
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+	unsigned index = bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND;
+
+	return fixed ? &wqe->fixed_acct[index] : &wqe->acct[index];
 }
 
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND), false);
 }
 
 static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND,
+			   worker->flags & IO_WORKER_F_FIXED);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -1124,7 +1128,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0, false);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-- 
2.36.0


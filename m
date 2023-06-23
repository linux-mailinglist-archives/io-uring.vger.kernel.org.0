Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E627773B60D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjFWLYm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjFWLYk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A701739
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-988b204ce5fso56014366b.3
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519478; x=1690111478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afSlWixgBKf99bh3ReZ4Sy8Z5ib88ed8o5fCVVxdkfo=;
        b=ZRsAP9XdCMyPBM23tofQhp6aF8fpIA9tt/PESgKI5rcCQiDxFtY6nEPFAVK+V0jZRj
         scWDMz1vmeazmcXEEztfPl3Y5P9jlcgZZA6m6baBjQC1pCn8uq4hQvja/msCnsqa7bi6
         zWyFFkqvRKXmeoF/T6VRL/XYGvR6Rytok5Av1BSMapeWOi5t1bUEPBII7bvR9asfnfZm
         tC47efPyDlDm9yyX6xHZc30RqTO8Lzzv2vfT5xkOes1TfqyQdBMesch4QHOJExYugxiM
         p8lMPBBFhmjsfLitYiMBBrdF6WXYqmcwtZXRV1aEU4jun+wuF9dw4ACifHrqGTCHNBm+
         8NfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519478; x=1690111478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afSlWixgBKf99bh3ReZ4Sy8Z5ib88ed8o5fCVVxdkfo=;
        b=fizSGAg6D34GNmNI5xI3B+1L4B/DveR4ke1s48jylyC5F7WVCzprCEl7zLgdyYBF5E
         A08nXAkIhan+sek0dK7rO6f8CeLzWZz0tymkpMdCPih1fBOFE1SeHnLDmp1MduMUxSyh
         UZI7Y9PgPAOF2ZO60I5YynU7lUJKAFNAhyY1pcl/49EIHYhVporr+OboDclGZp4t1wCG
         NY2Pl+u69H2BUZJVzOtDZzqkh/o3Cwi7OQlvEemoa+o2YdfHJybkq4SqKcNunm2+RKQH
         6FyK6LC+X7fdDCKmBCUZfgJ3OGmWrTWWY3l4EXKFdQa2W9WnDsVA9CUMMtwLDKq2SBq/
         /lFQ==
X-Gm-Message-State: AC+VfDxyfVvY6AiJ1zJ2J4XK0Ea8YtBDqabXpoehY1xqD5qCgoPCwqpc
        jjHZWOm+nI/b40R7KNzrO7ItglwieJI=
X-Google-Smtp-Source: ACHHUZ6VYUS5/BHqL2cUcDynLzGMfLrXdDEFf2WKHJxJxKfYDuIrU0Xh3Kf+2FOuhKB/iLvVTEC9yA==
X-Received: by 2002:a17:907:928d:b0:953:8249:1834 with SMTP id bw13-20020a170907928d00b0095382491834mr18049318ejc.16.1687519477983;
        Fri, 23 Jun 2023 04:24:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 03/11] io_uring: inline io_dismantle_req()
Date:   Fri, 23 Jun 2023 12:23:23 +0100
Message-Id: <ba8f20cb2c914eefa2e7d120a104a198552050db.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
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

io_dismantle_req() is only used in __io_req_complete_post(), open code
it there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 43805d2621f5..50fe345bdced 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -146,7 +146,6 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
 
-static void io_dismantle_req(struct io_kiocb *req);
 static void io_clean_op(struct io_kiocb *req);
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
@@ -991,7 +990,11 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 			}
 		}
 		io_put_kbuf_comp(req);
-		io_dismantle_req(req);
+		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
+			io_clean_op(req);
+		if (!(req->flags & REQ_F_FIXED_FILE))
+			io_put_file(req->file);
+
 		rsrc_node = req->rsrc_node;
 		/*
 		 * Selected buffer deallocation in io_clean_op() assumes that
@@ -1111,16 +1114,6 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	return true;
 }
 
-static inline void io_dismantle_req(struct io_kiocb *req)
-{
-	unsigned int flags = req->flags;
-
-	if (unlikely(flags & IO_REQ_CLEAN_FLAGS))
-		io_clean_op(req);
-	if (!(flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-}
-
 __cold void io_free_req(struct io_kiocb *req)
 {
 	/* refs were already put, restore them for io_req_task_complete() */
-- 
2.40.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4387B54B38A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245307AbiFNOh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243978AbiFNOhu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C221903F
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so3306354wma.4
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AUP09+kdqf76IuyEW30/qwEVk2WF201FOd1yA2k7FaI=;
        b=he7/fWcaV1+No50UIKHrqvLOgCFLOGwjPiihIDlhiuAR8tsIcbyw75QcMnSjaJOret
         mt7nqnTyxgYdaAXcpoJoDgBkUan4QBlwQZOJHXDcIWbxxRTZ1C83VlupIrDpHQ9hEjjD
         Yyp+WAMl2iTN3HjaVK7gwRecO5gju641K92XE7WvRjLaYuAuPqUQWlKOG7XsyEanJQcr
         fksF4rh+vgBiyDcv5tvH89uzqAISDHrm5QTJSOKhFg6r6Ti7j0uH7BPwD0viu4DDVw7N
         ixpxybdhx55GTDCUzWUywd5jFJYksLHwlfeM9tUJMoP3T/b5MrxoLZ/VQ7zhNc4XDzgX
         AvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AUP09+kdqf76IuyEW30/qwEVk2WF201FOd1yA2k7FaI=;
        b=PxjL4Y0gXWZ5qXdQaiP17y+XPMy92FOSgd5YzMRHzOzYQ3FPahRlXwJ/5ch1OxVxpA
         0WXJZut8NmE1h6XgmCJXnkvad4tUTiI5ewq5rdHU4DgI87TLU+0oZsTAXaCNPUgJYaxw
         rF97liOLjVTmp5OQf8zxac3dSSjxoVjtsq9dz2XYxJVITPOmsCY0HLmS/epiQmtX2Ore
         zpSs74IUizgWAoESLMNOZpwOUvG/OVwSp9LxxQYlc2Ncw57hDdHP7MmFVCZ4TXePmlnQ
         zywFwPI1gn1oh7bkZFcSIDlSgLEmX7EOzNn3vD26GDTbdXJSGBRV/6EWeUEDi9Xw0KlL
         9UOQ==
X-Gm-Message-State: AOAM532INU6UiyIYP4vxDh9CAhMe+l3DafCjfRQnQI10zswAnqhm7Cpe
        aMXerKJyoo+71SLUfYx+QCvvYGmwZ3wY+A==
X-Google-Smtp-Source: ABdhPJxCCLci1oG2XWY64hbTjrdxnb7J2D1r/BmUWHzzVVTyowVZYr2dtF8xQFglQO2GQ5Ml+AvtHA==
X-Received: by 2002:a05:600c:a42:b0:39c:9086:8a34 with SMTP id c2-20020a05600c0a4200b0039c90868a34mr4385970wmq.169.1655217467985;
        Tue, 14 Jun 2022 07:37:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 08/25] io_uring: don't set REQ_F_COMPLETE_INLINE in tw
Date:   Tue, 14 Jun 2022 15:36:58 +0100
Message-Id: <203d37f8c8ace5c70d3890132c5a3a6cca72ba73.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

io_req_task_complete() enqueues requests for state completion itself, no
need for REQ_F_COMPLETE_INLINE, which is only serve the purpose of not
bloating the kernel.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dbf0dbc87758..d895f70977b0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1864,7 +1864,6 @@ inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	if (*locked) {
 		req->cqe.flags |= io_put_kbuf(req, 0);
-		io_req_complete_state(req);
 		io_req_add_compl_list(req);
 	} else {
 		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
-- 
2.36.1


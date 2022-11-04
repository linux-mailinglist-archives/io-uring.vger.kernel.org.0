Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34377619512
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiKDLDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiKDLCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:32 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44372CCBD
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:30 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so12346157ejc.4
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKAY+S5nt8WWrRARXiiMhTGuuGow8SACAPMNZMPYgB4=;
        b=HRXwUPhRr8rnauN89ZLRf0p7CFtmtqiUNMMeQCC+A1JrWdBTbF5QEGTz7DGsOR+OCb
         JIqSYHAeC2nswwZ//SQ2alK1UWqNjm0Q62Iuc+PrCDoSt2H2y6i50ouqDyDqTPeJG8gI
         6FS5f2TUOyFV+nEELZusZGc/QTIlGY9aT2vYOuZy2xYNm8Xu9vT8kGq2tKHqnowbVwXy
         Q1UuUbJZFtofbMQ9txJWko9IsSaaVdOAj1W/vWKsjZvCEherwgmY1hfwj7NLe6PfR6Oj
         CxvwjqM/UD2VkFRESaKTgKDejUvljw8MhUom89H3tvRudqbJI04x0LDdgjbi3ioraR7v
         Zytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dKAY+S5nt8WWrRARXiiMhTGuuGow8SACAPMNZMPYgB4=;
        b=vtUkKcIz8y1pbg8Ht04qeazrwr7RUSOGdp6/AFn2nS3d/FgrHs0C07CJU8xw4WANgd
         wrhuMWe2d2jOBpleB0lY3YxU22xNWQm5eLr0VlpDon+bA7/oRkf3GxoD0SXgW/z1LVUt
         m1zPiNZOuuSeG5B/9CKk21+vhV72FvHzm1G0hOo/L3RcRL/3T4z4VKzLHG+ooVZTViqa
         qxUb0YCNih+ITg8TfmiR9pbY4xxMe4X1z8EuQgzbrt9P0BV2322T2JsEScnCbjycSIIY
         c55UhfTSJAivxlv4azzbVRQrG+ZSPC9N7RxngSgK6aYIFLRR6oR0JLeHnriYr95avj9f
         Ubxw==
X-Gm-Message-State: ACrzQf1SSNFGH7fuC/giCCne63Hcs9BS18Z/DarIBr+Ym7B88eWreeiM
        OGQ6IGNPIdRo+7rWEJ5Zl6r5ogPhlJs=
X-Google-Smtp-Source: AMsMyM6Ws71iRnbdvv3hUw6JuiXF7ckDo7OErRxJJUeBsMGrtXBQUsv8mLnYvOBwp0K6h7kNzY1rzQ==
X-Received: by 2002:a17:906:d142:b0:7ad:eb7f:bc9a with SMTP id br2-20020a170906d14200b007adeb7fbc9amr19054993ejb.337.1667559748693;
        Fri, 04 Nov 2022 04:02:28 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/7] io_uring: move kbuf put out of generic tw complete
Date:   Fri,  4 Nov 2022 10:59:40 +0000
Message-Id: <94374c7649aaefc3a17808dc4701f25ccd457e25.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
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

There are multiple users of io_req_task_complete() including zc
notifications, but only read requests use selected buffers. As we
already have an rw specific tw function, move io_put_kbuf() in there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 ------
 io_uring/rw.c       | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac8c488e3077..db0dec120f09 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1471,12 +1471,6 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
-		unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
-
-		req->cqe.flags |= io_put_kbuf(req, issue_flags);
-	}
-
 	if (*locked)
 		io_req_complete_defer(req);
 	else
diff --git a/io_uring/rw.c b/io_uring/rw.c
index bb47cc4da713..1ce065709724 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -286,6 +286,12 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
 	io_req_io_end(req);
+
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
+		unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
+
+		req->cqe.flags |= io_put_kbuf(req, issue_flags);
+	}
 	io_req_task_complete(req, locked);
 }
 
-- 
2.38.0


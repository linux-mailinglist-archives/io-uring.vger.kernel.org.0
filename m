Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF19778FF3
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjHKMzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbjHKMzP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:15 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A1C115
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:15 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b962c226ceso31223191fa.3
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758513; x=1692363313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEqAyf8Y7JpC7PfPYXoIYZ/kuhGCFcsqdd0va/xWKGo=;
        b=HZMEQ+EKsFOUJNxzC+oivr0YjH219E1R9AIr8FKq8ofypyJCpdW28vGa9iO7vZA3gh
         yq5OUSoR62Bt2UWuvtp5MtyPIYgY9rkVI4nuSy6KSKKuSBPk1gA5DN0xHsLBxlR6I190
         xC0w4JRqhvknD1lcAODIN6ZE7Zy+dvITCRMq0wgeXsulSK/XGbKU7/kPOML5Cs4tLMG8
         SBycxIOENu9MQT9s12ufjTw9cD7dlh6cfjgiJms5ZK3icJoBkeQYHimDxpgi5OIvXNCT
         8cPNvaFKzuhiHuDaNF7MntCsaSYmNE+2LCU6zc0avkCiuRka7VNToJaeXU+3/8SXwMKE
         ksOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758513; x=1692363313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEqAyf8Y7JpC7PfPYXoIYZ/kuhGCFcsqdd0va/xWKGo=;
        b=j0kGNxmlY7EC+hnIkikGuZz5bzYst6Ig3VqtNCkmvXGpG9IcafZKxW6Oszgub68qll
         ePZ+Cm5WSjzHsY2Df21XuQgKqMcuLLucUXz0DjwqDF7M+xAgE+lgx6Z9QIwqU+S+huNy
         vbSoMNMTW8iSTOk4s9xLNBjYvZGvuWfJ+HUpPD5W64mUzgrwfQhrZrzFXlXvkWDwq1qf
         niqgZWUxo4hHpgMLyBX6mLSv9dVDV+gj/12cMLwFozw4a1yxQX/LlNLWTmByg3PjKJY1
         8L5EdLIDEF3AWAYB2TaPL7YMeKvgdRDeCczmN4dY1BZ8GK7RtNk4d+JZUEurn//A6xa+
         pJwA==
X-Gm-Message-State: AOJu0Yy5ttLs8vcvPkp6rtn7l3HQ2oWeeZKG1Te4v/qHjiORQfXLSJ64
        TincZGLMOU60P+MM1hmLh1M5T4EzUik=
X-Google-Smtp-Source: AGHT+IE5iZj29cY2rtCzaDO1udS3/Ur9Af7ssVsNyJmQSD/heauKKoCS3AP+IKTa6O680bXoTqS+TQ==
X-Received: by 2002:a05:651c:1028:b0:2b9:44c5:ac15 with SMTP id w8-20020a05651c102800b002b944c5ac15mr1599889ljm.41.1691758512959;
        Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring: remove return from io_req_cqe_overflow()
Date:   Fri, 11 Aug 2023 13:53:44 +0100
Message-ID: <8f2029ad0c22f73451664172d834372608ee0a77.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
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

Nobody checks io_req_cqe_overflow()'s return, make it return void.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++----
 io_uring/io_uring.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e969b4ca1c47..7595658a5073 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -813,15 +813,15 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-bool io_req_cqe_overflow(struct io_kiocb *req)
+void io_req_cqe_overflow(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_CQE32_INIT)) {
 		req->extra1 = 0;
 		req->extra2 = 0;
 	}
-	return io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags,
-					req->extra1, req->extra2);
+	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags,
+				req->extra1, req->extra2);
 }
 
 /*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3aa208fbe905..3dc0b6fb0ef7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -39,7 +39,7 @@ enum {
 };
 
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
-bool io_req_cqe_overflow(struct io_kiocb *req);
+void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
-- 
2.41.0


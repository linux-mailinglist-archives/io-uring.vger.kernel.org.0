Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3B662902
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbjAIOva (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbjAIOvK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:10 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59385C92A
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:29 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id fc4so20635828ejc.12
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgLLMema6cbOOELLEJ326faKwOgd8bvFvm55EOI/udo=;
        b=ftMci7ZJhkRe1Wwsv7v73fFcdU+Be3JQt9rDO07MXjb6YXQdsNz2wi9huFpM+1o8pl
         eHlUiCkPynXNA9URL4uWoDoEI5vh458DCAKdSJfjUVHi1CJmEyA7V8gAumMGk8pR6V7q
         H4eAZ0kCZpu03c/E2BKTRcOKuAat/OR07CSzG/5HP9QWcwTZF7lTTL0E5cFhecZEL1RB
         hmdrrOiNswRDhiYhak+H3L+baP4jEXuHkThtAWyODYevrREv5aRUgvS4mdKtY2Za+1YR
         kLXQv7KZ+XCPMtwvsENUeA9r/0gO48Aai3241kYefReNfBCSeNs9Y/DqhYiY+IFD8w71
         zYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgLLMema6cbOOELLEJ326faKwOgd8bvFvm55EOI/udo=;
        b=wlZ55uKZsj567/xNMst4oMA1RXmUiWTpxroWQLhMdPj4zGBEEujalvZ7T2YXDbZW8k
         KTFlb/FPj769t1K8MSbVkUhvK0EyeNQzI7Jtdd7OAtwOyKpNwiAoXDA+5lTxnfE4mdba
         8GUqAm4tpt510pnYQZA4R+l1UnkfZlbQF2apuXo/QyBhj6a51w/ihhVRFTwIB78y9NIN
         hnSd0N8eWJrQTbmy8AIagDPXHTL30qI9ek7E5Ql/0cuB+AC8KKAcQiR19kUXL4VFRi5V
         swm/3rDUaNRqiJHrlX6GvqWexmmBKHAzn0/G519lmG6rwI6grGXkuk74aXE+cZ0Cj8f6
         Rc0g==
X-Gm-Message-State: AFqh2kpZh33eP+y++yV+cqNsd3VHR0B4UeFa+O6LrvlOLZUe3r5CJ9LV
        BeJBJOuxfBS+TVWr5YrBtJGd2CLhT/8=
X-Google-Smtp-Source: AMrXdXssEcQUiVDYiA4KY7REsHRUN5FRBAdpZ4iFY8lIpmEmsfzVvXODtFe7DRjsGTvB5pA27Vx5Ow==
X-Received: by 2002:a17:907:9712:b0:7aa:491c:6cdf with SMTP id jg18-20020a170907971200b007aa491c6cdfmr69222698ejc.18.1673275648219;
        Mon, 09 Jan 2023 06:47:28 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 04/11] io_uring: mark io_run_local_work static
Date:   Mon,  9 Jan 2023 14:46:06 +0000
Message-Id: <b477fb81f5e77044f724a06fe245d5c078659364.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

io_run_local_work is enclosed in io_uring.c, we don't need to export it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 961ebc031992..5b62386413d9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1337,7 +1337,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 }
 
-int io_run_local_work(struct io_ring_ctx *ctx)
+static int io_run_local_work(struct io_ring_ctx *ctx)
 {
 	bool locked = mutex_trylock(&ctx->uring_lock);
 	int ret;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 011932935c36..78896d1f7916 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -29,7 +29,6 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
-int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-- 
2.38.1


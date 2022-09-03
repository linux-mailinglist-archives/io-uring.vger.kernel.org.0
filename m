Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BDF5ABFE2
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiICQwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiICQwl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 12:52:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF944AD75
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 09:52:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fa2so4722917pjb.2
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 09:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=G3oQEHPP4aCknOkBVbhd/F2rNscoAVe643nWi1SXJKk=;
        b=pXc++ytMunbS4ouRAL+lDn62c44vBGJKumoF+dLc934p+rhg3+IUeKpgvC9rtFx8wT
         cQ+RMUIyawpc134in7j4C2g9Cbda3hANjB7uYMJnRcmDCto0XMWicsMuAZ9Dp0UXX4o7
         z2iUH/WYBq9WDoqflpQBh10ArC5Quey+wNGH9NziCuTjCWJFYBO0gppvJ5l3BgV11/OG
         OT3Az+3woUGQMSgbF7NYK8rWydHk3zw6vy2GCEHdtJkxVkMp0MB9kyxKlAzTeKnDs1gf
         H0XZhJHObotw8IMnS6D9FVrri/UCs/ehayeeZ+ncerrIeq8+NRhMdFtxXq/ctYHurvZQ
         AhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=G3oQEHPP4aCknOkBVbhd/F2rNscoAVe643nWi1SXJKk=;
        b=uSG6vOUd92E/tMelje7e1vYwK1rdyZ8d9X4IXjnZkt8qCOcfzePlv91uRj/UQSniYq
         NYGkrJ6wNK3KMOIA2cRaJ55lRfjCSFT0utxcPHU8v948sQcFE3XH5g+UkTtuHk4OkGTW
         PPXj1mr63sZkloIZKpcipw1tdhr2hL3MoYw/vuj++N5SwTL8jZThmawRTjee/nTpvUPj
         6WlaZuN2QRl/NTyGxCPe1GIAEXyQ9Q96uqv8m1wTHBx7ugnGKk42aOWw1nCHA7S/w0Xi
         9CpM6L2AhmNIQ8vhtnM1obVADm2rUmDhbNkW6VMVi1CsRTa+YeEg2kwxmDMeZacVtbvh
         81Zg==
X-Gm-Message-State: ACgBeo3lelm12eSc8YI2aPM7CSoMZnF+ebFw0c/AsBi8eiCPLqENcv/a
        jndeauDsmWWNhrSHyDST9eVGRSaGeW0QSQ==
X-Google-Smtp-Source: AA6agR63QucbyZgiMn5shU0TlwhO/sMgJuulCyLh+LTn0oEv1fL6ZTH027c8n3A3yLvJ7jHuY+a8Ug==
X-Received: by 2002:a17:902:6b84:b0:172:f7cc:175 with SMTP id p4-20020a1709026b8400b00172f7cc0175mr39931719plk.158.1662223959914;
        Sat, 03 Sep 2022 09:52:39 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm4187296pfb.23.2022.09.03.09.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:52:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add local task_work run helper that is entered locked
Date:   Sat,  3 Sep 2022 10:52:32 -0600
Message-Id: <20220903165234.210547-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220903165234.210547-1-axboe@kernel.dk>
References: <20220903165234.210547-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have a few spots that drop the mutex just to run local task_work,
which immediately tries to grab it again. Add a helper that just passes
in whether we're locked already.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 23 ++++++++++++++++-------
 io_uring/io_uring.h |  1 +
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4edc31d0a3e0..f841f0e126bc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1161,9 +1161,8 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 	}
 }
 
-int io_run_local_work(struct io_ring_ctx *ctx)
+int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
 {
-	bool locked;
 	struct llist_node *node;
 	struct llist_node fake;
 	struct llist_node *current_final = NULL;
@@ -1178,8 +1177,6 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 		return -EEXIST;
 	}
 
-	locked = mutex_trylock(&ctx->uring_lock);
-
 	node = io_llist_xchg(&ctx->work_llist, &fake);
 	ret = 0;
 again:
@@ -1204,12 +1201,24 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 		goto again;
 	}
 
-	if (locked) {
+	if (locked)
 		io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
-	}
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
+
+}
+
+int io_run_local_work(struct io_ring_ctx *ctx)
+{
+	bool locked;
+	int ret;
+
+	locked = mutex_trylock(&ctx->uring_lock);
+	ret = __io_run_local_work(ctx, locked);
+	if (locked)
+		mutex_unlock(&ctx->uring_lock);
+
+	return ret;
 }
 
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f417d75d7bc1..0f90d1dfa42b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -27,6 +27,7 @@ enum {
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
+int __io_run_local_work(struct io_ring_ctx *ctx, bool locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-- 
2.35.1


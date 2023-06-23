Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADCE73BD15
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjFWQsb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjFWQsT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC2C2738
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-66a2a04de58so179974b3a.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538893; x=1690130893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g83UyOYA3HEZssvEWqLCOxWbPN+8YNXFzia9GMHc0No=;
        b=0Hz0e5I0O7YFkss7bQEcXXSKSxi3+2i6XaupVTqoMMcKP0b+gpz+xAZE9nF4G86klD
         ICAJVyITodyB+MwYsBf6ytSGYhTaHhd7C/ioyK1KmAOJQD49CGqx8zJhCOeueo7ymj89
         N7n4DT13slHfSAlcb/NaLnuvQwzhOWTc1K9AtxUPfdrP13mBmCjrDfhBrUKd3z1PSHcQ
         S5wyFuKQcjVWrbQ+oe+zirzYk6YL5SptaCq2ptkR6S9RqjDXv044nrkvVMMes4NkS2Eb
         MJc1CCpUKvVEBfbbvZYvzI/GDyrvSl14/NQiTYBwj0Z1/PPI4YunLHevASsgcWYwPcEm
         YSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538893; x=1690130893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g83UyOYA3HEZssvEWqLCOxWbPN+8YNXFzia9GMHc0No=;
        b=BKoOKYDjL6obAVR6ddE1N87gslFHMFto2JXuPXpvJ9fKUe7PfO9zTJmuuD5LwTUzHG
         mkNy4ZdJdbwECl62+g5UK7Pme1lwK5KVYH35DOItVMd2r3LiOsepIfPLzJR69cy+noRI
         rHAEb6ySgPoMzu5tT54Ku3UvPG/bMWSQdDqokk1zRAlCAu0eyqe1fOE6uZZMwdKRRa9q
         bmJMhjj4DKptspEhzKOQNdImmkuE5EN705DpSvYoksyldWC8c8rP0b+JoUxvvTC8FTiA
         NdQ6xFm7sY1NgXs5rLu4H182dMZmcxATPsPTt6dIiP9AxdV5WCoduQzVUrRL5kTyq52B
         YQig==
X-Gm-Message-State: AC+VfDwZSj8z25/SMCZDlGZEzRuIFLy+pUtrjYugUWJeZ8lm+0Y2z0kV
        b/kug+6gnVfFmF87eSgJV9VDyVWJQFl2kWn90dA=
X-Google-Smtp-Source: ACHHUZ5c5cKZc9bwxAJ7RWjc/xh6maOe3AHLjEsLq1y27RRgtROLFCSmRutyoXnT19EQlIZbDrkzwA==
X-Received: by 2002:a05:6a20:430c:b0:10b:e7d2:9066 with SMTP id h12-20020a056a20430c00b0010be7d29066mr27066062pzk.2.1687538893258;
        Fri, 23 Jun 2023 09:48:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring/cancel: abstract out request match helper
Date:   Fri, 23 Jun 2023 10:47:59 -0600
Message-Id: <20230623164804.610910-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
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

We have different match code in a variety of spots. Start the cleanup of
this by abstracting out a helper that can be used to check if a given
request matches the cancelation criteria outlined in io_cancel_data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c | 17 +++++++++++++----
 io_uring/cancel.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 58c46c852bdd..8527ec3cc11f 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -27,11 +27,11 @@ struct io_cancel {
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
 			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED)
 
-static bool io_cancel_cb(struct io_wq_work *work, void *data)
+/*
+ * Returns true if the request matches the criteria outlined by 'cd'.
+ */
+bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_cancel_data *cd = data;
-
 	if (req->ctx != cd->ctx)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
@@ -48,9 +48,18 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 			return false;
 		req->work.cancel_seq = cd->seq;
 	}
+
 	return true;
 }
 
+static bool io_cancel_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_cancel_data *cd = data;
+
+	return io_cancel_req_match(req, cd);
+}
+
 static int io_async_cancel_one(struct io_uring_task *tctx,
 			       struct io_cancel_data *cd)
 {
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6a59ee484d0c..496ce4dac78e 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -21,3 +21,4 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 void init_hash_table(struct io_hash_table *table, unsigned size);
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
+bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
-- 
2.40.1


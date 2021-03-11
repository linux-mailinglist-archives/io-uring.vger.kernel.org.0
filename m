Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070B338188
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 00:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCKXeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 18:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhCKXdo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 18:33:44 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6628DC061760
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:44 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 61so753133wrm.12
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=v6NwQpmCO19J08MqTvdeZ8rtVnPQ8T/bzKFMBR5j14k=;
        b=Vh0MxoeUz/LRutGOQ+x7A8qr4siKVqo0mTgOAset4He8EYDgSIKLyMFjAuU/ldEAm6
         G735nN5v5U8FMJfb+XMmCx1/brvhyHDwH8Mr2OSQ373izhwGyEWNkNnqwxba+gyOmts/
         14if2E3UcREsWKe+181+6wcPt3nLgMTC71uHfqu6qf1iYuYZJjgiRD3u341fTPsa2gY7
         6Ro6BrR/zRYH4jhG09BRXKprvguEl51jO1SoiL3C2I4MM6y4PwO8wv63pQ6D/iLcnNqR
         RSPr6gtowE0DfCq4HiHpAMCceACjgTfL1VVdALgbmePGKJIRrVMwfVW+TiwcX5bBhiQk
         5iPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v6NwQpmCO19J08MqTvdeZ8rtVnPQ8T/bzKFMBR5j14k=;
        b=JRVD9ethPYw6/FdMJIbnjiwDPicUBFtPGZ6jchAR7Mb31TBF2wavsb9S8V2kuHSmel
         qQ8MhF3vKumsF63TOYnz/0ETuBi6uKa0zkjsSUdWNzZT2/pQVRfLQjvWNL+zW4dJNt7A
         WcFfUb7H7Qpq3zaBYA1iru9pD9wdXJp80WbVQTPVQDFCiBoajDr7p3gJ1wyUPp8vp9u5
         OSB07ljoNu0FkD171MVrHXrGONsug8Q5WRWyI7SYjX3NEeccCinkmF6P8UOCJS9Ykj6k
         n33s/3m4OAh6DI/XTONIBem78kRATNCDcrwvgx37CQ5A0Oy+Xs1iXJLjx5hWwNQY/NGr
         gA5g==
X-Gm-Message-State: AOAM532LIHgwIpPqv6zCxW8Fq5GBFdUjzBqdjlALqlJwCdsV/ePoY4Xr
        DjfeCCvdxgbhPrcEXsBeSLugfhIXR0TWpg==
X-Google-Smtp-Source: ABdhPJy4qQkUwcw1MrZrSsmtyZMLHXkqWKmN2iZBGTV1zBiP5rtSj0cmRNofIfQGEwGPWwbPVdERbw==
X-Received: by 2002:a05:6000:124f:: with SMTP id j15mr11109568wrx.263.1615505623181;
        Thu, 11 Mar 2021 15:33:43 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id m11sm5828062wrz.40.2021.03.11.15.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: prevent racy sqd->thread checks
Date:   Thu, 11 Mar 2021 23:29:37 +0000
Message-Id: <e9c957315ea1edfec57da73c807c87874c70baf3.1615504663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615504663.git.asml.silence@gmail.com>
References: <cover.1615504663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQPOLL thread to which we're trying to attach may be going away, it's
not nice but a more serious problem is if io_sq_offload_create() sees
sqd->thread==NULL, and tries to init it with a new thread. There are
tons of ways it can be exploited or fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6349374d715d..cdec59510433 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7119,14 +7119,18 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 	return sqd;
 }
 
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
+static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
+					 bool *attached)
 {
 	struct io_sq_data *sqd;
 
+	*attached = false;
 	if (p->flags & IORING_SETUP_ATTACH_WQ) {
 		sqd = io_attach_sq_data(p);
-		if (!IS_ERR(sqd))
+		if (!IS_ERR(sqd)) {
+			*attached = true;
 			return sqd;
+		}
 		/* fall through for EPERM case, setup new sqd/task */
 		if (PTR_ERR(sqd) != -EPERM)
 			return sqd;
@@ -7799,12 +7803,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
+		bool attached;
 
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
-		sqd = io_get_sq_data(p);
+		sqd = io_get_sq_data(p, &attached);
 		if (IS_ERR(sqd)) {
 			ret = PTR_ERR(sqd);
 			goto err;
@@ -7816,13 +7821,24 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
+		ret = 0;
 		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_list);
-		io_sqd_update_thread_idle(sqd);
+		/* don't attach to a dying SQPOLL thread, would be racy */
+		if (attached && !sqd->thread) {
+			ret = -ENXIO;
+		} else {
+			list_add(&ctx->sqd_list, &sqd->ctx_list);
+			io_sqd_update_thread_idle(sqd);
+		}
 		io_sq_thread_unpark(sqd);
 
-		if (sqd->thread)
+		if (ret < 0) {
+			io_put_sq_data(sqd);
+			ctx->sq_data = NULL;
+			return ret;
+		} else if (attached) {
 			return 0;
+		}
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
-- 
2.24.0


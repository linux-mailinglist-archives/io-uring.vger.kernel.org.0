Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FC9351BE3
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbhDASLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbhDASH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:07:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7130C00458A
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j9so2085700wrx.12
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=l8PZSKnBx1N7lVjCBcLe5ITd3VK5WkZK+xa5DomWnEY=;
        b=t+NNKk48wM8VK7+Usjlv0RTzPklNFlBpVc0U7YywehrA8418+E/EoKaMpuCnl3Rn0j
         bAkPs3yINuoVbwQ5ee7AsyUZr+0Uzt+/ZPVYtono6b7iLtQHpQ+Q4YtuJKFvezvXACTU
         tOriF9A6meKef8RjyoJUZASDF5GAsPPLtZZhNAYKeDsDJpqdetTHyfUgHTBOGtLaERsY
         n9yaS6yEvjWTOAN7+i6zcFI7Le5aXgKIEMukUMcM0mv9LmDKHtOLEJXWFsKNbNHnuvaR
         KqoylgE9E+7EShAJ2C1kNGBaItPGoHgQasbvF672+XX0qPkNWUCnbFVjEfvqKVN+qXF5
         c+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8PZSKnBx1N7lVjCBcLe5ITd3VK5WkZK+xa5DomWnEY=;
        b=uE6Re5Dys+QSQfWc0L1aE5ohZoVGmpzaPVxpgYel9PEln3K99DVJX7ErOOwx4/M3ci
         O59Ziehe8N0X2ztP2HapdS3phWV77gZ6xpt+PbUYIaDJ+CbLRD2oE7bDcY0aV/wbarCR
         0gfHal5zuatduIYDjVRFol1KGuve0MWYkT0fABtpQNILTnCXmB692XH0GV118ZFAwdEL
         pQsU4bzYAhwMxL8S57l7c6ZKgq1e8n55dnXawJPscKBoqrcOtTPSjKyQ9lUAjudlW654
         HFn345ciLrt3kPjdkC0RArs4//MdqyHgLSndsrGIHSjVpxHVXmrlkqmelHR/ACHgv0Zf
         +/Rw==
X-Gm-Message-State: AOAM532kDj3DwWkXlIVvRsXYs9OVxP9udbTaWFP9qDyYseTCo5HntcWf
        /6pGdmA+8qW+q09vg59zv5A=
X-Google-Smtp-Source: ABdhPJxzvfKUfHmeyQWEgGkeJCMeswYxErGosrkBpLQzAB6y9ChIf8sEKiKJ6Yi4GuqnFETE/kgZbA==
X-Received: by 2002:adf:f005:: with SMTP id j5mr9921895wro.423.1617288514500;
        Thu, 01 Apr 2021 07:48:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 17/26] io_uring: kill unused forward decls
Date:   Thu,  1 Apr 2021 15:43:56 +0100
Message-Id: <64aa27c3f9662e14615cc119189f5eaf12989671.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kill unused forward declarations for io_ring_file_put() and
io_queue_next(). Also btw rename the first one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bafe84ad5b32..352c231571dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1024,14 +1024,12 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct files_struct *files);
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
-static void io_queue_next(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -7436,7 +7434,7 @@ static int io_sqe_alloc_file_tables(struct io_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
@@ -7598,7 +7596,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx, io_ring_file_put);
+	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
-- 
2.24.0


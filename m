Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207482EA0FD
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbhADXiR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbhADXiR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:38:17 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3F1C061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:37:36 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o13so68530553lfr.3
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Syu+xxRAPCF7ZDfxf+eNrKawbMbaHC21ZzbVNHvmoNU=;
        b=vS6piS7GZ7FM8pSxgUMVT0AesLf79CFBlO57LTgwBgs8ZY4/9C9RwBL8z1cbvUJ1Y5
         ZfX3W46abfFMvSgr/+C3qqoqrdHPJUPmLkFe+u2cREVGmnDRL8e9Ld6lcwQYQBuuPec4
         9CWnSIIQ56Tqnt386PKMbLVBwlwAvuu5tALDQuYRcfbAojS1QG/5ySEFW+eNxpr5VLf1
         jFtUyvoOg1ZV2KGr4fKaQ6SCqnx9Sa9oy8NfKVy47ImF0axZBpmTTU3sVurybMakWLIo
         jrygYOD+N0yKO0hjR2w4aLsM3Zga32PMD0vJbwO4tSbUkDZxKriIYc1eIF7b7Ahim3QC
         FMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Syu+xxRAPCF7ZDfxf+eNrKawbMbaHC21ZzbVNHvmoNU=;
        b=Hqz7iugag4EBRXbJrtKGvti6WtQOPGyfGCenfQQkDrU9v3FsnHRfKGPECymTY9D5Sz
         ef6edn5yw5i0nlw9MwrW6fajQQyPzJFuKz7CB5V+M9ndsSkuG6oQIK/LV2cW0OV1ZLmN
         Btm7CUTV6dcgQFcn5hwWJjYO0hhQic0f+i0FdGnvAGNlM1Dy6JskPFOZacDIe6Z7KWuT
         YsWAd/OwHSlPpelnSX7HcDfT8FtwDBFYh7LPDfuz2qeiwye1ZNnXlfdDRVbodkFy8w+U
         WBkHf6C3xvcB9IOinKA2hsQs/X7YKVGFLEvrzEf5IXRCpaJvd6dv67hINTjLYE/zhLBf
         Bzww==
X-Gm-Message-State: AOAM5311gP9e27MSQwzlr2wuEwS1Rpcybx3Lw3JXOgjNjqE1SO07CROk
        U0wpUS7hgsIkPniopcRCHGz2SkiqiTJ7mQ==
X-Google-Smtp-Source: ABdhPJysZZK8X4fQAnsVO1k6luBlR+0WTc4jfn+LYo/Mh8Chbm4wCTVsqpwJIRJDDhmWzw1rfTpCmg==
X-Received: by 2002:a5d:4e86:: with SMTP id e6mr83186185wru.33.1609793226722;
        Mon, 04 Jan 2021 12:47:06 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id n16sm54715017wrj.26.2021.01.04.12.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:47:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: drop file refs after task cancel
Date:   Mon,  4 Jan 2021 20:43:29 +0000
Message-Id: <a4bfd86170f8a4b69fc477276e583465c6bcaa6e.1609792653.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609792653.git.asml.silence@gmail.com>
References: <cover.1609792653.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring fds marked O_CLOEXEC and we explicitly cancel all requests
before going through exec, so we don't want to leave task's file
references to not our anymore io_uring instances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 445035b24a50..85de42c42433 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8958,6 +8958,15 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(file);
 }
 
+static void io_uring_remove_task_files(struct io_uring_task *tctx)
+{
+	struct file *file;
+	unsigned long index;
+
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_del_task_file(file);
+}
+
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8966,16 +8975,12 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		io_uring_cancel_task_requests(ctx, files);
-		if (files)
-			io_uring_del_task_file(file);
-	}
-
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
+
+	if (files)
+		io_uring_remove_task_files(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -9038,6 +9043,8 @@ void __io_uring_task_cancel(void)
 	} while (1);
 
 	atomic_dec(&tctx->in_idle);
+
+	io_uring_remove_task_files(tctx);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.24.0


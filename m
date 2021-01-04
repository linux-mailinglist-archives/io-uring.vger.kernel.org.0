Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E772EA11A
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbhADXtv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbhADXtv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:49:51 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C620EC061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:49:09 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id y19so68347571lfa.13
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Syu+xxRAPCF7ZDfxf+eNrKawbMbaHC21ZzbVNHvmoNU=;
        b=VZWU+ypQBnwUwzS9fgjVQ2+C6+9e52vs6hGohsnOaNXWkNffQey4B8MgBLXBH4rThN
         ZCp9WN6A8tMJ60bBv7xSeBM42HrwvTbWSduheR9lvToHcheY8Cr2EFm9gq40MK0tHBKo
         9eKdncGRARlTH+fTk2iDyFd4R7/IM5k2kQG5JwXQ7tIXds6GdJB5O+TXQ8xHlQph7H9r
         R7/KEFkXVXJgEMx2dFDKqSTsSFF3NwHVoK1XdDE6iRCzjePHlXQT0Zxqf5O15TiYQjq2
         2exmx6qcM9wJXVxETBmCF47RpWXEWcIR2MZowcbjDwDR8hg3RXbKc0UJupcayNakyxOa
         GzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Syu+xxRAPCF7ZDfxf+eNrKawbMbaHC21ZzbVNHvmoNU=;
        b=YefUTOaDuN15W3NlamEb2f07MVfSU8Pm6+iMpocLK4WBWBLKCbMvH8iXvmTehCIhrj
         lOiOXHey2tXuRWmUfU2qn/H+8NatLPk50kZ9IaddClAa6YCjucfXAKBC5CZq6+rrKn34
         quw2cN4kCWwBF017ZGUoeFQyJM2IqyZbuNse1f/OYD8wLV0nJOicHXEV/c8vq2CEhDNt
         2wUaJzFoeJ6Rntc5/Qchsoi9BS5XhM6pYzfy3T9M6MYsq6r9KH0ere629gM4Yq9/mOpx
         Fpr8Ewg2Pdawazsq8akvlHs10rTTTeb2Qp8Y3P9a8Kus2jkTulmHdJxyRDtW1+Tnf/Mu
         v3hA==
X-Gm-Message-State: AOAM530oVDOdC5lIxN9TrDp8/QvjWZv49y1neRxiXh2HDrzjVwdGQv2d
        DpkwWrB+xfJY12BB08UY+0k8AS8RSi5kVg==
X-Google-Smtp-Source: ABdhPJxglpsJSOsi0kuWofTnvEnaIHB3jhOnZfUIRX+M5eYNczr97NoeFm1zLgutbYOx2MX198dS8Q==
X-Received: by 2002:a5d:604a:: with SMTP id j10mr82516747wrt.290.1609792965202;
        Mon, 04 Jan 2021 12:42:45 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id o13sm73525006wrh.88.2021.01.04.12.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:42:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: drop file refs after task cancel
Date:   Mon,  4 Jan 2021 20:39:07 +0000
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


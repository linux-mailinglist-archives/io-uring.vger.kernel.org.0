Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A945C32E09C
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCEEW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEW0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:26 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E060C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:26 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j2so601796wrx.9
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=72Con7c/l/YWuWFaky1WYBcstZNDGg/iYgHhg2KKpzk=;
        b=oemlgVmnxtqX8MfqhlfNPA5CixG1B4lRzQmMqoigox2fEUZB+Nfxks3mhvHa8RyAzr
         LLInUlAs6E+frRNgJMsrKyrR8pIeVHTszYqcHuRcSLow83xzuldeHKWvWgwxtFTOPnOt
         FfUVmp/NtfqW87VxWMBaHStIiIg72u/LH80BQrQI5Pt2unC1NrEFyJq9lAQ9D7sTeDET
         2WrVcGQSIeKiM0RXIauuf6I/xZVAr51VTIvrNhWRAtAvKvjtyLMdbRInoKWyoKDfjsIg
         N1tz2BaNGkV5Tom+YqRtTR+m3cVUxUUllSmShALZsz38JoNqvm7/e5PzXkEF0RaBSTTs
         AMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72Con7c/l/YWuWFaky1WYBcstZNDGg/iYgHhg2KKpzk=;
        b=qeKWjt/lMzJxMQNqd/XD7YFYaHOvmKnBjsTHhFrBhGqjxwkhCJX2mdIj2q8dmdmtL7
         Fug0QtfKJ2bWKD0xWHLuQmSXeVFt1RKlr7fH6OR/Ud8jqGDeKljk7oMLxVnr3vZ4Wl1o
         tMt4JxZIC1UD5lqaXCbggP7AZb1X0zTAzMaCBe18mHsi9vpwzX4SZraQivY3Yvvrfupo
         g9FBu1K9bKHclHARPdDedCi0wSfX/+VRYdbn7oc12JFaPUmpNH+bLfrvTwJWZz/JHNk9
         O5lzYGQLy+wzIC6tD1AmUTdtVr3Gv6LSVkf2HRsMPirBJUXDWYz7jgEC4MUjytv3CsSv
         NBrA==
X-Gm-Message-State: AOAM533wjVCPip0i+9VI1ocNOc3SYUrjMDSlAbIYfBwX/8r1bAqFfQXY
        3a1XUgk9I2cuQWVGo61+X4EC/AAQK0+WrA==
X-Google-Smtp-Source: ABdhPJz0H9rU8DIj6xdl9kDA4Dirk7wXAQxmeCJULqUYvrHahrvAWSh46tTx+AV1w6WDzhww2SxPZQ==
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr7444582wrh.396.1614918145265;
        Thu, 04 Mar 2021 20:22:25 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/6] io_uring: make del_task_file more forgiving
Date:   Fri,  5 Mar 2021 04:18:19 +0000
Message-Id: <1612f92861f7e5595f8a5fbdedc376e91b8f5faf.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rework io_uring_del_task_file(), so it accepts an index to delete, and
it's not necessarily have to be in the ->xa. Infer file from xa_erase()
to maintain a single origin of truth.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99e37f9688bf..bcf2c08fc12e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8779,15 +8779,18 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(struct file *file)
+static void io_uring_del_task_file(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct file *file;
+
+	file = xa_erase(&tctx->xa, index);
+	if (!file)
+		return;
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-	file = xa_erase(&tctx->xa, (unsigned long)file);
-	if (file)
-		fput(file);
+	fput(file);
 }
 
 static void io_uring_clean_tctx(struct io_uring_task *tctx)
@@ -8796,7 +8799,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
 		tctx->io_wq = NULL;
-- 
2.24.0


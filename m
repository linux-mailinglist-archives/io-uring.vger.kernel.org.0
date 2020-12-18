Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71C72DE32B
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgLRNQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLRNQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:16:44 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA44C061282
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i9so2116528wrc.4
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1jUphlCEnTFt9oF/6fJMz/1eHol/vFf3aUlztC1aqbo=;
        b=Ma3k4KGXEMSLfitwMtWIPGbl747VYyBPr3Pu5HGqhRkAUoFAu7rhTbXFacv5bnNILn
         cRrJ2rXk6es0TFuBToWJS2nEx0wVDmkQcKTTfgcXJ9CByw0Qqkko/CmVsCRVMPnCBvfi
         T5Mm01fdVGU8/aXl/pSTg2czvwSWSo1s3QEWIS2hNokBzWpMVKtTkNCmg/Ktdj4UqqJi
         1k+eybMy8OqL5jxW0aPwbS1xQP1PqJuYXi4FRFur3QcnSnHf2aq5fY+8yizM7zDZ3j3U
         vcY9XNj57PntToL4+TlEMgE5ULOQJMSrGZ3M9nF/6Ok1Urm3UiaPJsgrdr14hYuF496K
         Y+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1jUphlCEnTFt9oF/6fJMz/1eHol/vFf3aUlztC1aqbo=;
        b=nODITKtEl6zgWRc5PNAHi15dPrjeGRcnSFsMYLQpfwA34F/eTq6P7Uh9XJFjBUEoqq
         ItCyKV+4B9Httrhexv9EAUBjih2FwVOqgXz8tsDoetvZTq1WA/cfv7m6qBz6lYcTLlw3
         XXcVhH1JKmJBZJHETldw/IahzKwBH2+BMvZHFhqflN7rjhdnWqGSyAPtNQii2W89ke41
         TsQC0SudTdlw0b+PedpC5bIUQT8/T9I/Ks7OFSbQW9qY98UsSTM8vWUfcbPSQGSIHxIP
         1OmIfX/Rz0IhBO0SJLkmDNiupb56tpGOld48s9Bdms8N0Xiho8iJcA3WUyzDqB+AgAkP
         Jdjg==
X-Gm-Message-State: AOAM530eM6IifhOYpnzXcil8H1EWEkeHcwCyswkIQ5pF2boUecIVl2yW
        KwL9tVgvBICjPMfh1/jhulQ=
X-Google-Smtp-Source: ABdhPJx3EhAurOh4pC5EWjuG6hqvmusljowXrJx6KxkQFeOcXEGy9hS+mEWkn6KA11IYVaD5vyOXPA==
X-Received: by 2002:adf:fd41:: with SMTP id h1mr4543608wrs.284.1608297363255;
        Fri, 18 Dec 2020 05:16:03 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: explicitly pass tctx into del_task_file
Date:   Fri, 18 Dec 2020 13:12:24 +0000
Message-Id: <b800dfdf749a45b5ceffe016b11bd9d7d4ee7490.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass tctx to io_uring_del_task_file() from above. No functional changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3a3177739b13..1794ad4bfa39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8882,10 +8882,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(struct file *file)
+static void io_uring_del_task_file(struct io_uring_task *tctx,
+				   struct file *file)
 {
-	struct io_uring_task *tctx = current->io_uring;
-
 	if (tctx->last == file)
 		tctx->last = NULL;
 	file = xa_erase(&tctx->xa, (unsigned long)file);
@@ -8907,7 +8906,7 @@ static void io_uring_attempt_task_drop(struct file *file)
 	 */
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
 	    atomic_long_read(&file->f_count) == 2)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(current->io_uring, file);
 }
 
 void __io_uring_files_cancel(struct files_struct *files)
@@ -8924,7 +8923,7 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 		io_uring_cancel_task_requests(ctx, files);
 		if (files)
-			io_uring_del_task_file(file);
+			io_uring_del_task_file(tctx, file);
 	}
 
 	atomic_dec(&tctx->in_idle);
-- 
2.24.0


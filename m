Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0032F999
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhCFLGe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCFLGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:21 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBAC061760
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:21 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j2so5223939wrx.9
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=In8AR6ijw0/oFfROYq2JXqIR5CBDLwClt4kCCJ/sfdU=;
        b=fPUjyLB8CIdRLJwZVQL62vMTkw7YvYV1e4GfBcvUQ2kn6qv1AaPIOp7bVTnYCWwStz
         5fO8hxV9JF08LH0B5RvPcPBn5VC7mptXKsNcNTTQ49LMFnCagkV/MHce1tQlArnLPw6v
         tXWV6VeQgjAda+CgJGR1D9UMX/ZYsMHhbAmEXCzmO5e+D/XL6zdgi2rnIkq1FzASO1cK
         RUGMF/G1OmskjLyv/2BZZm4ncCBcCUWG7Dt+wSNZY+DYVHQ0CGk1ydiQppZ6LnjtaMDQ
         trDyNzWciHsiAqXjlfF94wKsiCLtePhJZfnACplD0xCcW4D4fP6QqBYnfdsTfRzvrMf5
         6B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=In8AR6ijw0/oFfROYq2JXqIR5CBDLwClt4kCCJ/sfdU=;
        b=HrWpvQ0JG9b1t0WGasZXtRblKgoYqEW2i3mtXEgaCNV2lWxXQAJqNv1hLqX7IZbUtq
         YmSfH6qm2j44ThRMU8C3Y84HwYTcGVEF5Th8DtWwGPWHvMdKWKzU4t5AEHD6OuSikEKH
         mtz8YqRt/7TS+65QJnX3W3YaEtSj48nBZbcz9bJdPsW+3rriSPFJZ2ji63M0JPoAiQ3l
         se81l0xBkeJwrzBp1jdRbQzltx3QWIQeAGmer5ZH0rKunzWgUNtjm3t2wNTr6H4N8mGE
         rtJUamTHcukQZYzPn/OS7TkIj3RPRKn2pxYNYc4ub3E4+Xki8dwNsv/hoxTJPz8FBgHR
         0YOg==
X-Gm-Message-State: AOAM531mc/Nky+hzFnrZSv4uPplNQUA+xSjKYYYnW3u1BUjXVQMJwwFl
        NK40j0oRgDW+d7qV5mFZcRgnnG+za48c2Q==
X-Google-Smtp-Source: ABdhPJzRhLbNXL/G+qBMrendG08gujFU03dwpHci+jDZ2RkN0JwVB+QYYkvbffABkDSFdULfnADlng==
X-Received: by 2002:adf:f584:: with SMTP id f4mr13968615wro.311.1615028779981;
        Sat, 06 Mar 2021 03:06:19 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 1/8] io_uring: make del_task_file more forgiving
Date:   Sat,  6 Mar 2021 11:02:11 +0000
Message-Id: <2f937d84470746ddae40a16619cdd59ff7419168.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
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
index 92c25b5f1349..4c6a92e5d5a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8780,15 +8780,18 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8797,7 +8800,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
 		tctx->io_wq = NULL;
-- 
2.24.0


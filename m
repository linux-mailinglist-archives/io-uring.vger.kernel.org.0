Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD722EF9D6
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 22:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbhAHVBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 16:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHVBr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 16:01:47 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B19EC061786
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 13:01:07 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id 91so10239447wrj.7
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 13:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/ix59SLPbYlTivFsL8flOoaPA7xOkBv26IelpXPMoog=;
        b=imE/v3V9vNCOUfLM/joOvZkD56XZTFAbWr07mHlIDa2nJOnw1LK5+ZHT4lrW3wD0+i
         PBosGTLhf0o8QaLjICNxH0flfn1kjebbXTldVuQ26ix0H6SD40LpnpNmxju7LVC3eWvE
         xtBHXjvvX05SfoC2l1hEvIDN4OzFFOMXKTRLSYXBwHPOK7d7G5/PEkGJ0S/F45H0RjK/
         a7M3dMK0HrQeQNPRCjwx4rOo5SoWHJKX5dOfHdMPNpUPdUW222WwPfuP2pMH+0J8MA4z
         ofs96fHpxSnOUZBv+Aks+GcS8HlB4BBb6uBvCBX9SXBz4n1mGAOdxmbV4xLDlHZIcTWa
         9PaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ix59SLPbYlTivFsL8flOoaPA7xOkBv26IelpXPMoog=;
        b=hbiyMl5r9FOr6TbUSwKlgKtGhuYZT46X1zW97FxOp2JlVNikocWjKbjxri+Hq7k4FV
         WhOLUHChvefR40h7qlGjVtjdaqVRrSgkucve+ee4kT9YiN6p+9JBGtj/V+69NRXafcb+
         9VrLFRw2lSXY9vkmQrS2rGQPUnGxKQBqP2bZ0fAGQGnO4bQD/pTYH/Hu4Xn0dpQmtaBB
         YuRCXHxQ9e/bfPNFUppMVsM4tcnqm28rPrM3KsmQVbrNhm+/chdMiwqI7PDtzmKr2jje
         dXxVuAs6Ulr+KFU8/NTfYaTby0jNRmEIeieTC6cc1rEyIlqicE/18btA+vroTn4n1CZJ
         VSUQ==
X-Gm-Message-State: AOAM532UFSgVQdfMgDJouO9+6f8EsV+2mf0J2Evvu3Ae+hPovR2CmGnM
        2ipVEeE2AqzZWo68RZwimpg=
X-Google-Smtp-Source: ABdhPJzoD97CyNQbnS5wviEPe8xpyR4SX/zh+4IJGSIYrdv3yW7JHWwk17YALSDKKnLJz9EF58BO/w==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr5485623wrx.310.1610139665980;
        Fri, 08 Jan 2021 13:01:05 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id r2sm14919211wrn.83.2021.01.08.13.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:01:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: inline io_uring_attempt_task_drop()
Date:   Fri,  8 Jan 2021 20:57:23 +0000
Message-Id: <245e6f164ee95b43a2885bd6d8bc639a4ef72397.1610139268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610139268.git.asml.silence@gmail.com>
References: <cover.1610139268.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A simple preparation change inlining io_uring_attempt_task_drop() into
io_uring_flush().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 55ba1922a349..1c931e7a3948 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8964,23 +8964,6 @@ static void io_uring_del_task_file(struct file *file)
 		fput(file);
 }
 
-/*
- * Drop task note for this file if we're the only ones that hold it after
- * pending fput()
- */
-static void io_uring_attempt_task_drop(struct file *file)
-{
-	if (!current->io_uring)
-		return;
-	/*
-	 * fput() is pending, will be 2 if the only other ref is our potential
-	 * task file note. If the task is exiting, drop regardless of count.
-	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
-	    atomic_long_read(&file->f_count) == 2)
-		io_uring_del_task_file(file);
-}
-
 static void io_uring_remove_task_files(struct io_uring_task *tctx)
 {
 	struct file *file;
@@ -9072,7 +9055,17 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	io_uring_attempt_task_drop(file);
+	if (!current->io_uring)
+		return 0;
+
+	/*
+	 * fput() is pending, will be 2 if the only other ref is our potential
+	 * task file note. If the task is exiting, drop regardless of count.
+	 */
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
+	    atomic_long_read(&file->f_count) == 2)
+		io_uring_del_task_file(file);
+
 	return 0;
 }
 
-- 
2.24.0


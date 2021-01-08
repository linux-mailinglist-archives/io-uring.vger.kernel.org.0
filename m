Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450452EF9D7
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 22:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbhAHVBs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 16:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHVBs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 16:01:48 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0174FC061793
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 13:01:08 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q18so10273561wrn.1
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 13:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0Gx3IV5aABnaAU1JhYZKaYB60gzZL0Oo6+lGZ6NKMd8=;
        b=SbZT5bVR4efHGzzwVbOWiE4Djzy7PT9zN/wwTETk43Qn1nMDO7dnCTfBAsAVrH//0R
         JDfDXR7UtCHFprbQnwwQ05y8CaOpzR2Q2nNPiUVtHYLbCL6qKH1G/wDtLgualXPODinY
         YXbuxv2t06rxrfIA39mNKnVXr+8hqsGKp50mfuPe+fg2rD55QxMrYQ/X0aicl3uylBer
         rfRa4PS3cRrTtw8uUq/IqPjl5rxp6zF5Erj5KZ6i9ypp4m02o6Ko897UOCCDlnivChCl
         oUzGVm4hvYBhOts+8xlVDXmmXw70WqumNwIrpTBPAGCq/6tBkRprZi5Je48L1KQQBqY+
         V3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Gx3IV5aABnaAU1JhYZKaYB60gzZL0Oo6+lGZ6NKMd8=;
        b=QjobpjW+pg7BDM6g0g30ZU1+Pn/tRcwfYEseE9soGFGmKbQBnfWYCUnD8I+gVVVuM6
         UGzlftJF4Tt2fSxdg+X9JaMoew//Y7VGJ82JX3EB0LH1OqOsHz5wVOOWF5iPvBcvEWJj
         UiIRgeRBDw8wrKHQNboYeIfVl1UgaGD5ZUz+L4nK3jvsxkc6tUZtyQoj6GCElPHTSnam
         CS2Mz+1p/CPgqfGXoGPPeZZ4UU4fsWm4mfLnciCVU6vR2nfjD6LDDRGiLbXoOFRTTGZV
         UtWUT2hAMsyV9IyR+qwCzDINvE8KEd0zY1tJxNdX3ctFBFmxGmB4U1GHafuH+iidkrO8
         rV1w==
X-Gm-Message-State: AOAM533RdX/FUIv5or3tYWDTy/swicv/2rm+YdJ05LOGB+7f+DrHY1cE
        tbF4ckoma6Vmz2DyPuHWk+b5cfX3NZ33dA==
X-Google-Smtp-Source: ABdhPJypLg4+PWqWhiUwEw+pYYybICYXhNSwNSreKsPdl0I8OKIHoFihTswqOE/ijSXeZHkic1kSLg==
X-Received: by 2002:a5d:43d2:: with SMTP id v18mr5420883wrr.326.1610139666810;
        Fri, 08 Jan 2021 13:01:06 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id r2sm14919211wrn.83.2021.01.08.13.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:01:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: add warn_once for io_uring_flush()
Date:   Fri,  8 Jan 2021 20:57:24 +0000
Message-Id: <7e34a436d7e440fb378907c0798ff38e626e50f5.1610139268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610139268.git.asml.silence@gmail.com>
References: <cover.1610139268.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

files_cancel() should cancel all relevant requests and drop file notes,
so we should never have file notes after that, including on-exit fput
and flush. Add a WARN_ONCE to be sure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1c931e7a3948..f39671a0d84f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9055,17 +9055,23 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	if (!current->io_uring)
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
 		return 0;
 
+	/* we should have cancelled and erased it before PF_EXITING */
+	WARN_ON_ONCE((current->flags & PF_EXITING) &&
+		     xa_load(&tctx->xa, (unsigned long)file));
+
 	/*
 	 * fput() is pending, will be 2 if the only other ref is our potential
 	 * task file note. If the task is exiting, drop regardless of count.
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
-	    atomic_long_read(&file->f_count) == 2)
-		io_uring_del_task_file(file);
+	if (atomic_long_read(&file->f_count) != 2)
+		return 0;
 
+	io_uring_del_task_file(file);
 	return 0;
 }
 
-- 
2.24.0


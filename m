Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A032D4D6
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbhCDOFI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238879AbhCDOEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:54 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4206C061763
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:38 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id h7so498709wmf.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FFbOAs04pPJzQYPasGpH6/vA74jNPkz192AsYDFJuE4=;
        b=fJwn089MkI0VvLMy8LAXb5kXYtfDfsrXmx+Ddk2vtVSb7TAzSrag6mKZpBWPqugMh/
         ehNeCWko20F+uqRKAwh3m+sQ/GqX885opc/Rcq8pznEMxs+Rgirfb5XvjdjQLyCmnbMc
         kJdOd6EaVo770m93+4ijhSTQj/NS2pcgUZ8VB2GYhJ+MLKBfLB08BoLQN8/pQnMlOQj8
         IjFpQ3IZzpyDMejsKigc9ft5pOPKfUM21PVbKI3Kw+TdtV0Wgws7tBC2zAP7OWbJanmY
         iAhy8D4wwuvP1OKjgmU4MFCC0FyMMfqDlHbICsFq116cmc8fF4zXEYM4vSJwwS6oz9mY
         vJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFbOAs04pPJzQYPasGpH6/vA74jNPkz192AsYDFJuE4=;
        b=WEeBGqQJrsfGyaa3SXtNBPVF6T1CsI/XzFy2q2wETknQqExnj4g4ivxHm9SOv0ouAZ
         b3IKK6Jpq2FPaZ1q5plQYojq5XDH4hKj2WQj4kBGpxajr8ZTYUhq/GWKcMeatrUErglN
         1sza9BUsSmIAPa33oTiS4N9Ibtl2yBBc/qWZ6gmZePmQC65sV3dcMTLPLKr7nyCIlGSE
         deNQDYS/4HIpG9T+0yKSobxKfQEPmKAyqdxPt7994+B+JNYp1fUZSpH2ZEn4LONFiSJi
         4g4ZgUuNASh4Z1L/5KD5/geeFD5gUXEVCnLfjrCxCglm2DCDSF3v/aqiR9qnnSrKLUlw
         RxLg==
X-Gm-Message-State: AOAM530o3a3BsV7l68EWdIwCCOJKhEB0BJ3S593oblzL951qqqLjZpsq
        a9bjlNb0X2P1RqNa4vujnSc=
X-Google-Smtp-Source: ABdhPJzC5bnsdcQvWThCwYIX78Mz52K1xQNULIaFqY8DidLsbuUQxhpJyy+TeRwXYI9mo+Q2vFPOPQ==
X-Received: by 2002:a1c:e208:: with SMTP id z8mr3962745wmg.111.1614866617416;
        Thu, 04 Mar 2021 06:03:37 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: make del_task_file more forgiving
Date:   Thu,  4 Mar 2021 13:59:26 +0000
Message-Id: <b040d5dcd90e551bb0926dac0b3ec092bef1fee2.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
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
index f82f46c604d7..55e1ec4c0099 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8772,15 +8772,18 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8789,7 +8792,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
 		tctx->io_wq = NULL;
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ECE2DFFFD
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgLUSiP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 13:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgLUSiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 13:38:15 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D375C061285
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id y17so12081705wrr.10
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ddEP+n4dNfyJyTQ7QZ3QVye5SWEtbJ+4haK+YSRSxnc=;
        b=qWm3cxP1WretFjLw0TxfQF9h5M8s54feWlLbmOxJVEhj1kbj6mgL4fJa+VhGKt2QGM
         TSuLlPJ9PAOSWDjrMHweUJ++H0567T5vntbUKb5cDe9UnEmSiWWklBL0gDcLTxOrtkiD
         8bmhYe1F7zA62OVEgokHJtRn8qcqXfVjjbcdHkzWaniyPwES5qdDc32Fz5ouv2E3Js5d
         33Qh1tGI8DWHI4/qBAO01Ep9kC3Vr6sDmqzjgarF7Dntt2IbkmGx3vKy0sclx7/JDMVd
         XHwqVBd8J+rma8/xuMaf0lMmxKUn3mLxUpwaPrqdXM2wLD0tx/RSrkLZoOJlFjMqPRkH
         WyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ddEP+n4dNfyJyTQ7QZ3QVye5SWEtbJ+4haK+YSRSxnc=;
        b=cwMznrsbF/YkUonCMUB6OAINoEA4Afwqe3/OQqzftwKrNiJoRUH1FZSDdh2nIHJiHt
         6It25VQOF/lDlKHaax6w1V+iYQ4I87sQPLdt4olIgZWZdGiikiQ0d1iyETj6t74zIjy0
         +K2LuNp36o11ZOiUd36AfY5RP7gNZ80BlMrrXodpraiNyHNjSrwYcGS4m0HVjxipRoZh
         LV89zUGjULSX3o7tm27dt+SegiuxBZyR530MvJ+ONiLeKxvD14XqUM3RUDZFqkbogYLi
         AqrkgZccct46sApk/z6l099Az/F47/CyuDR0XNzWwgxUH3cBubIR//zXGjg4uXljqPti
         kT9g==
X-Gm-Message-State: AOAM530xG4U6T1fvfPGe18dyTr55lDK/QTnkLC8SDY6QtuaUvwD1HBcK
        7pWWX4wrPWxsUSFabexN0dM=
X-Google-Smtp-Source: ABdhPJxfOSMmD+dkQ7kLWKvX0R6ttuEMwCuYU2mOpmNbgv2dGxXEXzdB2+WICPsRVMWBWqE8+0rWlw==
X-Received: by 2002:adf:ebc2:: with SMTP id v2mr6051431wrn.88.1608575854004;
        Mon, 21 Dec 2020 10:37:34 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.158])
        by smtp.gmail.com with ESMTPSA id w21sm23551409wmi.45.2020.12.21.10.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:37:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix ignoring xa_store errors
Date:   Mon, 21 Dec 2020 18:34:04 +0000
Message-Id: <7ba58ef02c309cc19bca4f5832686fe6a049d868.1608575562.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608575562.git.asml.silence@gmail.com>
References: <cover.1608575562.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

xa_store() may fail, check the result.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fbf747803dbc..846c635d0620 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8852,10 +8852,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	int ret;
 
 	if (unlikely(!tctx)) {
-		int ret;
-
 		ret = io_uring_alloc_task_context(current);
 		if (unlikely(ret))
 			return ret;
@@ -8866,7 +8865,12 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 
 		if (!old) {
 			get_file(file);
-			xa_store(&tctx->xa, (unsigned long)file, file, GFP_KERNEL);
+			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
+						file, GFP_KERNEL));
+			if (ret) {
+				fput(file);
+				return ret;
+			}
 		}
 		tctx->last = file;
 	}
-- 
2.24.0


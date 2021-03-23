Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC9134632B
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhCWPlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhCWPlN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745AEC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo11096138wmq.4
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pU24/bUO1FGRgkC6dwkVugc5j9FrEv9JmQsYYaHPouc=;
        b=C0WaRsiqW9xel4bO/TrU1HmMkVUzaXh5bxovgEnAfMmz71sPwKkX9JAWutntCr6vcR
         uXnyVCWew6cntGz9V0GT7oCrM4uG007VtolxU3xsqxQkuqW1x9bkW+So644LZFVZAC1R
         HMnjxscM/lw1u8OZ5VU3ouFerhM+Y/vbzCfZBzQRUx8LmDwUZceYQ5AWKOiha9V2h5Ls
         623Nh0vmUFqBjWNSpHurAp5FNzsnXmOpUIoq/nEXrzI/ChlZrtkqq0rA4UXGnc2O+UDw
         wADwYjoF5f09JjWgaVEtaQAf1Vq1VTCpbb8XQDHqu/+oqDNaFL6r2kIVZoJtUaTU2lF2
         YDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU24/bUO1FGRgkC6dwkVugc5j9FrEv9JmQsYYaHPouc=;
        b=G1/xna42z7S+tAbOGLkc/RQzowPmwpw4K1t/p9SDIGllKF8/EaajjkG+4KSOXVodkq
         QZqu8z8n4dIPe4wI0HdCP3IPv2upjyvA1Hak7PumqmnC6zpp0x2saKkAnS5JOhSCLAMr
         uI/TDQgmcFhXIU4kfHO/A24IlWbqSiHb5vOiw3e42Nrjgl9Nnc5H6ae2Uvl5n7goPR1A
         fKMv5BrV2bDArrdRQWgC7+WpnFy4CZhYM6noa+jlVV8a9SKZ2As6/gRImten4jAZaLf+
         lN+Tp+btXqsJJbHbGf/VKh8Y2VC9EcWQ6ObQ5tu2PIrYgYiK5ZctMGpVZSE3UdtNoVQN
         OcoA==
X-Gm-Message-State: AOAM532QE7xLF+frYMH5WVhOsVYpAAIIti71v3Tyr4sbw99p9A22RfiY
        7NIId2iejK+EsKP2+OTpPAI=
X-Google-Smtp-Source: ABdhPJy7vnA2GONyQugyDcMEykM3LcNTIqMgc/M5qXtW/ZCuUTnOdzcla0w6v9vF8nwRethHKoDy1g==
X-Received: by 2002:a05:600c:4844:: with SMTP id j4mr3937100wmo.179.1616514072301;
        Tue, 23 Mar 2021 08:41:12 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 6/7] io_uring: refactor io_queue_rsrc_removal()
Date:   Tue, 23 Mar 2021 15:36:57 +0000
Message-Id: <944b9e10c462bb18756bbb43e7e28758807a554b.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass rsrc_node into io_queue_rsrc_removal() explicitly. Just a
simple preparation patch, makes following changes nicer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f9ed4151e71..175dd2c00991 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7619,27 +7619,20 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data, void *rsrc)
+static int io_queue_rsrc_removal(struct io_rsrc_data *data,
+				 struct io_rsrc_node *node, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
-	struct io_rsrc_node *ref_node = data->node;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
 	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &ref_node->rsrc_list);
-
+	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
 }
 
-static inline int io_queue_file_removal(struct io_rsrc_data *data,
-					struct file *file)
-{
-	return io_queue_rsrc_removal(data, (void *)file);
-}
-
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
@@ -7674,7 +7667,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_file_removal(data, file);
+			err = io_queue_rsrc_removal(data, data->node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
-- 
2.24.0


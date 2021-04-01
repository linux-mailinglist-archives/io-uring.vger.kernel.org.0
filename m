Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E6351822
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhDARoF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbhDARiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:02 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E781C0045F7
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so3022848wmc.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7JVxNs4jmV2401yDe5x3o9vCuQ9nG239eaawJDoTaAg=;
        b=H7ddL2qkOoQcvuCyCk0lGiSNoo/ONmjCJ6cbHm/LfaGfK99iPCVnx56hFIPzsFQ/GQ
         UZePlF4ae8W56pQi+FlaN4J9bHoYCioFFukWw+PWn/EmxMNLZCsUCqD+nQFz1FC2We3J
         1G2pj44I5W5Dwq82LYsUD6PqhPN8MBRHokqYMbSMafSiaWkIqXcNXD3QcUBidpwSFqAt
         nRn/S1joPhu7r90oGy2Cu5hebQB+dUTk7QFO9w5ki1d6Hr5nCgffgvk4b3vQcldqo7al
         FLdACOCgIRPYtIGCCtGfx3N0X9KgxlH/Do9aNWPptCPQg/RAkK297gIw8s+Tc6oR9F2s
         UufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JVxNs4jmV2401yDe5x3o9vCuQ9nG239eaawJDoTaAg=;
        b=f+7/qVa9kOvk9LzaTjvnKU7f0e25YT9WYNgUaa7lN6AaWIX2A2i2drBrRqCbWOIVQE
         kZeVaTO0aziQhAUIF8dKUBRA+ct/SJVUkgxY3MEQv7SkhTAf3sMFMqsMBQ2UwxCgcFEb
         bFr3DNjn8QyLECpdzfWAcwqnRVYY3eRNn0Mid9Qwssh5PtiGjdWW39IV7s5+G5GYIr+8
         W0qjrS/UY236p5GbnacXzA6a7y2gh1q3m3qz/p1DUbkMSwic8uP6wrk0B0nIOpeTO0NH
         rMbBUysA0JNGMSRYMCW43Oe8lc6dDNXNCZGNYans5rsuC1phJ0I8iqp8A+e+I3sI5bZj
         +Saw==
X-Gm-Message-State: AOAM531Jmno/se2qm88ZBUzebVxrGkMDDiMDxuKMLcHu+KbQKpxg2MIm
        YoE8jrpPJsvYu6ABLABYxGhH6hJ0PZwrLQ==
X-Google-Smtp-Source: ABdhPJw9c55tx5CnvYblTK2Mgrj2ceGjjqOSpjGXyerO0LOTxvxInQ4ee+0DpeGVtzYawrcJEp++wA==
X-Received: by 2002:a05:600c:2282:: with SMTP id 2mr8385884wmf.93.1617288502401;
        Thu, 01 Apr 2021 07:48:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 06/26] io_uring: refactor io_queue_rsrc_removal()
Date:   Thu,  1 Apr 2021 15:43:45 +0100
Message-Id: <002889ce4de7baf287f2b010eef86ffe889174c6.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index 42c9ef85800e..5dc4f6bb643a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7736,27 +7736,20 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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
@@ -7791,7 +7784,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_file_removal(data, file);
+			err = io_queue_rsrc_removal(data, data->node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
-- 
2.24.0


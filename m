Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60136677E44
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjAWOmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjAWOmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:15 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87AF22014
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id z5so11024910wrt.6
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VtTZipjq85PArcJmx2dGRRWjObu2HyoKvfr/TFfiL0=;
        b=KEgZ0DVEvN6Ngrn0bDPGB8CkY3p/dDsOY1LgnK1IluZ9rynV7zHlqWLgp3cMHMp+wt
         JJN59SCieovluRG/4Hl4wHgIh8LIigpZ7/NTXVDB6F2Fp07Zoq4jZzGga9Cs1RerZ+Q5
         9h+hTdFb5Do3GsJqDG/VztaKzCJiWlqnMmi5QujPlBTPQBewBhOPXmOCCQG5HZcCc1On
         nwJDVc56p4tpG3a7BoMS2bI4YT44bFnyUOirDkPbxOhoHNPlU028hT1b51/u2s2vwYUw
         iGV/WZZ77Uxngs7Q01CbHJkfkV6IO88R20KZ7q72R801eO9Xox6uTA+dihLTyqyzgB7g
         KWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VtTZipjq85PArcJmx2dGRRWjObu2HyoKvfr/TFfiL0=;
        b=KlCnqLwHZBs1bK+ZLmSDG9r4E+MD2TeBd9QTiU2OS2g8T/ARc4HPLAtUTWQpXYwK88
         1spfCTfHQf6dxapyArM3l+kfNhRRYPR+DFk7KbBt4zamLdkR+DtkNwuZKh8KQajp3H73
         RXEarMaD0rzBvaVvuwvOnyV3bzLLJ1Ksnkkw9dygdbpoOr5psbZwyL1CM+q44zTmBTW7
         uGfRTb0Bl5Nkx3Au0VA7X10Vmr68X1WqngHOmaK5ggG82+ZTmLK9ygdcEVv4PyzW/29i
         fMRFyVGQMbSe5Zvf/nIszS5L6a3tLJcq94z6UbDmzJjpzG9kfzAhZ4Hf+rhowLAD6Y4L
         giVg==
X-Gm-Message-State: AFqh2kq4ij1ZS1O4y54xKuCKhVxwNl3rKDW4RnqEKJc9ZbDTIpiJF8Mp
        SU23E3B6DzOlq8fFYz0oZdcR5vwWyg8=
X-Google-Smtp-Source: AMrXdXubM2D/BB3AOZSWpGyRU3uju+5W4twFpuJxvJdiBnd8MkGACNn6SVcYuG5DWWdz43LJEjS7Pw==
X-Received: by 2002:a05:6000:689:b0:2bd:ffad:1bce with SMTP id bo9-20020a056000068900b002bdffad1bcemr24442189wrb.59.1674484933305;
        Mon, 23 Jan 2023 06:42:13 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/7] io_uring: refactor tctx_task_work
Date:   Mon, 23 Jan 2023 14:37:18 +0000
Message-Id: <d06592d91e3e7559e7a4dbb8907d110863008dc7.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge almost identical sections of tctx_task_work(), this will make code
modifications later easier and also inlines handle_tw_list().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index faada7e76f2d..586e70f686ce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1166,7 +1166,7 @@ static unsigned int handle_tw_list(struct llist_node *node,
 {
 	unsigned int count = 0;
 
-	while (node != last) {
+	while (node && node != last) {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1226,7 +1226,7 @@ void tctx_task_work(struct callback_head *cb)
 						  task_work);
 	struct llist_node fake = {};
 	struct llist_node *node;
-	unsigned int loops = 1;
+	unsigned int loops = 0;
 	unsigned int count;
 
 	if (unlikely(current->flags & PF_EXITING)) {
@@ -1234,15 +1234,12 @@ void tctx_task_work(struct callback_head *cb)
 		return;
 	}
 
-	node = io_llist_xchg(&tctx->task_list, &fake);
-	count = handle_tw_list(node, &ctx, &uring_locked, NULL);
-	node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
-	while (node != &fake) {
+	do {
 		loops++;
 		node = io_llist_xchg(&tctx->task_list, &fake);
 		count += handle_tw_list(node, &ctx, &uring_locked, &fake);
 		node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
-	}
+	} while (node != &fake);
 
 	ctx_flush_and_put(ctx, &uring_locked);
 
-- 
2.38.1


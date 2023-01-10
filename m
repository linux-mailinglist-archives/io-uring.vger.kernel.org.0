Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43766480A
	for <lists+io-uring@lfdr.de>; Tue, 10 Jan 2023 19:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbjAJSDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Jan 2023 13:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238680AbjAJSDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Jan 2023 13:03:21 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3BB201C
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:01 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f3so8790456pgc.2
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBLTJKNJmXg7kXEDzNfqLolzkfF/YX6ZhQGxLLurmW4=;
        b=Xw4DaHPGOdoMkjAzraFF0T63CdFBrtAwbSLcaxNFl0r0tIUBueMO6GuaF4S3OewdK1
         B2rEyhbBLJX8F6qY/kOQ1cbdVLdowfmUxV7XW0B9ZcLghMVQ+loSrUN1vIQYH+E8a0z6
         qCpDPui4cFKBs7AtQt4TBAf6W+BWaQesOJJHvLwHbEsK7ccFpycgWHPUemNxVVyMibsk
         /LZNqPJ/X734D3rQMZVeHlvr/wYC2Mtog0Qqm0N0jFpRXfmBSqVxtZ7Hzf2b+qaTBnRk
         JoLFhfVxhrz1Os+vUrZBqcF9rPi4Ei3ISSN8xdSpugzm/sLG3ljta9Cr5Php8m5CNzj0
         nhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBLTJKNJmXg7kXEDzNfqLolzkfF/YX6ZhQGxLLurmW4=;
        b=jXi5Nw5M8sm6A9LYxHuhOesok9GiOCXATzmugnG4RhWdMQlSxDOktaZ0bhiFnIwEsD
         7wqfZiWPmhtrG1J56/AvXlSKt2Tl2GTe78uhlhavl3nVza3PKvg8ezNivARjQyWloUec
         rBDQj5KjttvggMQ/tir/Km2KSo1pzN1l9kX5Xk/3zO0hIkc903FIGf8NL1zSOX7nGKjM
         N9pFj8DmTLAXJ4qGcSMswBT107GKxcMsPxE9wJ8cxs6oOkN81j9xFj3NntUIceuvw2JQ
         zGXr3sYZrXBy/nJqnXrVZ3V4ABUvWC3+TYUYKjM9CjSz3DuJhOifL+0YwTITLXt2Jdvl
         Ubhg==
X-Gm-Message-State: AFqh2kqGWIsFUdcXzcw+q3LwXAcmIy9tJv8fgVTphNPj6OP20b9Cv1R9
        1hil/wI/vPEaIbtVVOUCebjMQ9WbUix6wW+z
X-Google-Smtp-Source: AMrXdXubZ//VBneOk2DqToKpdNnG5H/zjDo7dfEUk8+bmP6Te8tZPRJCzqxXCNKBWgB0WxeTqtf6uw==
X-Received: by 2002:a62:3845:0:b0:58b:453e:d12d with SMTP id f66-20020a623845000000b0058b453ed12dmr268438pfa.1.1673373660304;
        Tue, 10 Jan 2023 10:01:00 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b00583698ba91dsm8405877pfu.40.2023.01.10.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 10:00:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/fdinfo: include locked hash table in fdinfo output
Date:   Tue, 10 Jan 2023 11:00:54 -0700
Message-Id: <20230110180055.204657-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180055.204657-1-axboe@kernel.dk>
References: <20230110180055.204657-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit split the hash table for polled requests into two
parts, but didn't get the fdinfo output updated. This means that it's
less useful for debugging, as we may think a given request is not pending
poll.

Fix this up by dumping the locked hash table contents too.

Fixes: 9ca9fb24d5fe ("io_uring: mutex locked poll hashing")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 2e04850a657b..882bd56b01ed 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -170,12 +170,11 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 		xa_for_each(&ctx->personalities, index, cred)
 			io_uring_show_cred(m, index, cred);
 	}
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
 
 	seq_puts(m, "PollList:\n");
 	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
+		struct io_hash_bucket *hbl = &ctx->cancel_table_locked.hbs[i];
 		struct io_kiocb *req;
 
 		spin_lock(&hb->lock);
@@ -183,8 +182,17 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					task_work_pending(req->task));
 		spin_unlock(&hb->lock);
+
+		if (!has_lock)
+			continue;
+		hlist_for_each_entry(req, &hbl->list, hash_node)
+			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
+					task_work_pending(req->task));
 	}
 
+	if (has_lock)
+		mutex_unlock(&ctx->uring_lock);
+
 	seq_puts(m, "CqOverflowList:\n");
 	spin_lock(&ctx->completion_lock);
 	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
-- 
2.39.0


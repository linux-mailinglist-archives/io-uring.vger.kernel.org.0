Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83555167F0
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354929AbiEAVAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354840AbiEAVAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4269E2B257
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n14so4255370plf.3
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3XnxNLqe363fESAejxFPDDwjudUjJcczjJVwkfhRLyM=;
        b=rD0DoHnw+u5B6m+O3+FHXTPjXxDjSwo3EfG3BvjjZsAwXo9uFZQwwSdra1yoDzzdMP
         VNlLxKg8PLwbQpuuHIYg/bTAVe5+4QqMFgGZK6yh/ZLa66LCl1UZWCVTCoLnWE4sP/tk
         +bs/5eUkzsz9hmbdv+xGyR2UTmvcEDvLg+uvDdW7nyp0nC31mBLUx0hNDwpXoLgViCsy
         gaEHqAHAqEfgktgyWezkLYxqYTkpu3f+250tdysJErFli/kZXAE/L6Za5sirzPTVa/G6
         8uVogYcMnzid51ByFIGiCc8dVly4otKkc3PNeLcyogOz7leSx1XJjjqpuEPDjHFxzaFI
         txZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XnxNLqe363fESAejxFPDDwjudUjJcczjJVwkfhRLyM=;
        b=wTZSwaquo2zUzjNShPcQZQAIw3NqfoDZv4bPfe3r2DWjzCXc2uoGr2uEfUlQWzEnjL
         J0lZ2G4rOltgBPxgqBSNwaceAlsUKMZRWHblzC68xIWd14Ict5pOG+ThpBRavTYsvBDh
         0h5mXCxivQtqhzgeU1qiqZcqEG0ahSzHp8RbIOeRkeQC5hCGtFFIDDDKlTCwWusVtMmu
         N5NDzZxjXWlg6H0+c8KAEg4OIpkRDq65A/NqD6V13WInrID6Eci0fUEny2MTNGdlolpx
         hgtv9a3Wk5ZeB/Lju6wiNAioInbURIx8MCo3EpbHf2SjuMvb0Xj/vgLw0syRzDfQ8vib
         I1eQ==
X-Gm-Message-State: AOAM5327HDLpT+ZNA8R91JGhXGQP/d4UFROmKY1ZjSLnZOirEcWU0NVo
        i2CiYDWVa7FsSZ9dnSinJPoNwi4etWbQPQ==
X-Google-Smtp-Source: ABdhPJze1TuDXvAwHB8jjHXLBpI1nwHWD35fmz9F06bweoMxRke8iiM4zh3R5BlZrH/VcRWpU0L5kw==
X-Received: by 2002:a17:90a:4308:b0:1cb:b996:1dc with SMTP id q8-20020a17090a430800b001cbb99601dcmr9832145pjg.224.1651438630482;
        Sun, 01 May 2022 13:57:10 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/16] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Sun,  1 May 2022 14:56:51 -0600
Message-Id: <20220501205653.15775-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Obviously not really useful since it's not transferring data, but it
is helpful in benchmarking overhead of provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc6b5173d886..850125c02c9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1061,7 +1061,9 @@ struct io_op_def {
 };
 
 static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {},
+	[IORING_OP_NOP] = {
+		.buffer_select		= 1,
+	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -4911,11 +4913,20 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	void __user *buf;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	__io_req_complete(req, issue_flags, 0, 0);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		size_t len = 1;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+	}
+
+	__io_req_complete(req, issue_flags, 0, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
-- 
2.35.1


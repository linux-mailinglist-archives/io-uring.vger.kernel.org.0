Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F113FE64E
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhIAXkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 19:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242593AbhIAXkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 19:40:02 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F15C061575
        for <io-uring@vger.kernel.org>; Wed,  1 Sep 2021 16:39:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g138so21951wmg.4
        for <io-uring@vger.kernel.org>; Wed, 01 Sep 2021 16:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ef4R9QtsswGu4Bs6uHDxdef7RBITNT95AuoaJyJEW4M=;
        b=WG4pikwYBps2wAvZxb8VJwnoANamkTmgCtUHTjyZmvsXTIoXAcpoftUjGVB6XfEqWn
         4r0YOusq33Kft/7HSo15UROD8oTY6bfSHrp/c4XEbuqJIyMd/eNmz36vp8sDiSCPUVve
         qBdgI+6UX4UC8VmFQKaSyweADSfmC20Ig9jJROCga2mQ4KDv9s6diXfPogSQF1L7MboT
         I2JxfjfG+4qtPgJV8FAWX9KNdPMu6WDwZG+8viRnA2EVCFnDYV3xy9LW/hTxaWQh03Eg
         S2g95PUeabkxr2oZk6KpNPFXu+n7UpfWc7Ji6kdeDUNSgA3XXCiE1Vln31scGiuB3OOm
         farQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ef4R9QtsswGu4Bs6uHDxdef7RBITNT95AuoaJyJEW4M=;
        b=MtdxOEIGAMI57xLQ5t26wx0NJr5jLk7jlgSHYgoZ0hrqUwKHR7HYEas4cJzMTs/zLs
         giyxtpj4FqzFmtZJtWXx1pxC4JiHLeP1bRY3+wRbsMbGx4W0OAYHEAtjwzNWHZNxTTqe
         r3aqJhN4S8eOc15BvKHb+acHuBWcfdw8afRdpt5B6EfZ5uZ5ZxKquDZZ5i6Zl0naEPCQ
         BxRQDYd7xBi8xwQ7DFkaeEJP8PdB+a16ivO5ALuDtVoakVIPFKhyCV+kg5eIlTfp1MM/
         GPIuq0WPMC2KqXSkRuhJTUqJp2UfLfKndKkz6dDnFsiaJaDe0QRg0l1hfzcQW9joXDVd
         EDHA==
X-Gm-Message-State: AOAM5322V8BKSEZQLaAe40Ji+xyJBhESL3tMmvRXPf/Ku896NhU3rdqU
        VCfJriQLz6cWKAgvSc62zrSMd4tK8i0=
X-Google-Smtp-Source: ABdhPJy+3vFJ18FLvC2kFqfS+uktcYlM+wJFwY3bBiGrvRv+5MbVWRX1LxGO8IpoGQvvlTPagz09wA==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr284098wmf.100.1630539543576;
        Wed, 01 Sep 2021 16:39:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id y15sm134912wrw.64.2021.09.01.16.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:39:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: prolong tctx_task_work() with flushing
Date:   Thu,  2 Sep 2021 00:38:23 +0100
Message-Id: <0755d4c2c36301447c63bdd4146c10477cea4249.1630539342.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630539342.git.asml.silence@gmail.com>
References: <cover.1630539342.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() may enqueue linked requests for task_work
execution, so don't leave tctx_task_work() right after the tw list is
exhausted, but try to flush and then retry.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14b074575eb6..2bde732a1183 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2102,6 +2102,9 @@ static void tctx_task_work(struct callback_head *cb)
 	while (1) {
 		struct io_wq_work_node *node;
 
+		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
+
 		spin_lock_irq(&tctx->task_lock);
 		node = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
-- 
2.33.0


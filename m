Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6E3492DB
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCYNND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCYNMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:33 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1C2C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v4so2198220wrp.13
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u1x4v1eSeYB712uO5ksTGe54BRFc/lGPPNtA9Sawhpo=;
        b=SPo/ErQ5o6aBwHybUmt8xc9jRGncviOuz1emwq3+gqu2/vm7lgyP/++KW2allAt/Gf
         msjduYuh0g56Yg8geiRgIXVQBsfEu8QYskhIakbB543aSAO12ILTIn2Q7SbdZgamnlGS
         H0uP//CH9ciaRYPIWLwc2JbSff1bb+ltL7a158cmTe1XN26ctnLwoxnqAhnqwMuld4GV
         oQ2XWb1OeKpOrGx0/e40ZLIij8yz8MbJw3AGkZW0CYfsFZfh5Er79lTRz806GRU6HD5D
         L7kO0Sax4d4EuH+BdKe8CTS4LUwxDJtI8qEGOj/aVU4jO16j67QqQrgaZdcyoGnos5wa
         yb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u1x4v1eSeYB712uO5ksTGe54BRFc/lGPPNtA9Sawhpo=;
        b=hr4BqKQTx5AlkN9nOuaQKqrImF7g9vzsp04doylosx1Seh+brdeEPVwE7i1//0Sd16
         LpC3a6veznkK7xiy0/gNdT7qT7MKtdrL0ehk8UN0XcYb9D3cBewSleSysRjxBmAUXG2f
         iMPwnWtwpEUa0rvX1fHJW2lHfjCx4oyVMlfn7XAcGVc5msDloVpyGYqdV4hSkDWrK7Cx
         +APWY7Gk+lzZlpgSGrWz57RlGYmkkcpjMsS0DrdN1mGYHHGeyUOQdYr1Rk2tTXMr7HvH
         iZLXbxsK11Li9nJoS/9uM1qnfciMLopXo2w5FFJGSTZ2NuYc34l/0njMl+6D1CeOCTpR
         SVRA==
X-Gm-Message-State: AOAM530YSNwJ6YNUgPF9kflI4Jb41XU2U2ckoIA5CIuSXgmM3bzNrmA/
        6anX+g3j04Ej1wjRDQ93wg8=
X-Google-Smtp-Source: ABdhPJxcMUxECexkVP4mCHzrGO+peZyyrN0lJEElZJxW8nEt8vRM7zhwnSq/HV2P7MyMF5iXLKXnWg==
X-Received: by 2002:adf:e791:: with SMTP id n17mr8832817wrm.322.1616677951271;
        Thu, 25 Mar 2021 06:12:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 17/17] io_uring: kill unused forward decls
Date:   Thu, 25 Mar 2021 13:08:06 +0000
Message-Id: <1d978452a1271f717d3ae6bf77c909a295c92031.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kill unused forward declarations for io_ring_file_put() and
io_queue_next(). Also btw rename the first one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f062bddae31..661082f2094e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1012,14 +1012,12 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct files_struct *files);
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
-static void io_queue_next(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -7324,7 +7322,7 @@ static int io_sqe_alloc_file_tables(struct io_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
@@ -7486,7 +7484,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx, io_ring_file_put);
+	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
-- 
2.24.0


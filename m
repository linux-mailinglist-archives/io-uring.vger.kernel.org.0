Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E49066CB0D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjAPRKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjAPRJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFED2B616
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:03 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h16so28049618wrz.12
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfTXyyDOzpnifxCVJ2//GAjGuuwxv4CrpOLwdQ7dbaA=;
        b=betWjj1Mm9ThBWoYMUdyrhKJi/aTg4f/O653IuPazocza6Q3SjNLyZcFPC7KpK1aBs
         jaxo2HGbxAqlO0beXGS2AHvKT/5xJoz9WoQzRrwvnRSdjAemgivrpygqyaBA1oFrbMjc
         kzDyEOGzQXTIubVrQdALelQ5/EOOUvkf9INbJK6YR12Leao1BcfN+Hau+DDubvvfsWY4
         sfAT2sl9DRaRKc8FsYN7bJUVjs2J80xluRnJJeB8JVlqE95VMQlQwiS+GPmWYuQ2imcF
         6bvO6kswJM+sOU0uQQbeNX9+JB3F9/8hTY1HmVCxAr2V0bQ7sGzeDf0whp11JUr7wWUA
         p0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JfTXyyDOzpnifxCVJ2//GAjGuuwxv4CrpOLwdQ7dbaA=;
        b=RGaRFBJALC3+HSAR2D/LOGOcwyfjLnvqOE8Mcn0RCrOVsz6nC8AwkOCZ34zosIuVv5
         QHo1aROYaTd/ux5cnIbkAMoaDAqdFOk8H+4MCIYwewl23hBTq4Vnf9b6G/bELl86L2Vr
         gwcZeDEj61fz1FP5M506YmO9wD8blK7fUNEcBnqmyu7JCkLvoYZ5IFKwY3AZAuK/7z6c
         V9IRqmoc4/D2L74TLLV35Nb76Bzj4vmkem2cRP+CprAeuvOnNGXSLmr6llajRQxBJFTd
         w7ZVT3THQwFancH/J+wvUoxWNZMX4YowqQmiDSFbs4Tt3mUNqpzsDGCVbaJkW+VEE/7u
         aJyw==
X-Gm-Message-State: AFqh2krBbiPEjRv49y/6lBj8gS+oC4eUBc7ZZM/20JXD8Zzr/+q2jfo7
        +kyXP75ZFE6lO3it02yI0Au01bEXLOw=
X-Google-Smtp-Source: AMrXdXtbzgs3ylxCOCO5XgU55VdRDlDPbL3t9hFw6ZfGPmwl80Gs8alWy4Hnmjpnemj4gH20V0aBGQ==
X-Received: by 2002:a5d:5259:0:b0:2bb:6c90:26a0 with SMTP id k25-20020a5d5259000000b002bb6c9026a0mr150224wrc.43.1673887802050;
        Mon, 16 Jan 2023 08:50:02 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:50:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/5] io_uring: simplify fallback execution
Date:   Mon, 16 Jan 2023 16:48:59 +0000
Message-Id: <56170e6a0cbfc8edee2794c6613e8f6f1d76d276.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
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

Lock the ring with uring_lock in io_fallback_req_func(), which should
make it a bit safer and easier. With that we also don't need refs
pinning as io_ring_exit_work() will wait until uring_lock is freed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1b72ff558c17..e690c884dc95 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -245,17 +245,15 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
-	bool locked = false;
+	bool locked = true;
 
-	percpu_ref_get(&ctx->refs);
+	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &locked);
-
-	if (locked) {
-		io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
-	}
-	percpu_ref_put(&ctx->refs);
+	if (WARN_ON_ONCE(!locked))
+		return;
+	io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
-- 
2.38.1


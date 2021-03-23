Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38263346327
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhCWPlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhCWPlL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69976C061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c8so8340933wrq.11
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U85TZZTUM9w8Ru7FIjGY3BovYh1CW+ZdNIf4ACVlEFo=;
        b=bkFedmuJoqkOv5q+2qaJzMmb55XMWqWmR+b9/dMTACILTp7aJbQtfyZ7+10WhA8+8h
         mqafhLbld/5todl84Wqhq288DFJui8PiVOy48UkBKTB9c31WMMFARzyrzmjAsn6m5t0Y
         7i3pojheZFk9hJmtPb1JQn+nibmha27JxtIM3PTlaVdL2ESIo9ziiDR4m+0/qOvQ016c
         6c0yR1MdTPCLT1AUmNegoTXZWLdnFa5EAlpy7iYzCARNic8nJnU5h2qQyP7VGHFnP0Cf
         sy6CLQdim0eww592CM8T2Yteu80tuxYd+UFDNJudyjfLtLkIz+qDiDeLxRlrAk1bb1W9
         4ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U85TZZTUM9w8Ru7FIjGY3BovYh1CW+ZdNIf4ACVlEFo=;
        b=Nif7/2CHxWPh0qI0cKDmphqZ/NvJOiUB9cHXbd6GqUSgKqg4yZqwmszzc2Oim0BdFu
         DC1DGnCdgoLdkUaNfLjJljDm/QkZ8lBqFx5Ck7OfFWl6BaNQ8SmMwuYhoF4UjMiJRQfo
         9ing2uTWFEo6hW8OwzxSm1fgVURWJp8nP0Hlf4HEMHY9LHD0JdGLVDFen5PeIEqU0iUb
         HMzrvQlS9tn/84RTVa/8PzB+eVw0yz3Trxr5HtpD3+ndc8asTqoPiQx/ifiaJJQpxQ6S
         W+rGnl8wZq9GXv7i8IO5S/uVh2s1kacM0IWayJLf8UJxDWooW4bHwbnCCHEHMVlnX0W0
         78vw==
X-Gm-Message-State: AOAM532GWYZ0wUMKURApLG6c25v//Klnq4NmMY7CVH/lzI1qe4iLdZh1
        QbPLDVdp4JrunuVUqQMC4Lg=
X-Google-Smtp-Source: ABdhPJxgN68jj2O3SXv5QpjsUdnquSEJh188bkNcER9dQn8S9t4eViIxi+RGq3DyhVIjAOzsysSyJQ==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr4763458wrr.118.1616514069262;
        Tue, 23 Mar 2021 08:41:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/7] io_uring: use rsrc prealloc infra for files reg
Date:   Tue, 23 Mar 2021 15:36:54 +0000
Message-Id: <0dd2bcd20e0d52d7eb503f97f3cf480d731d989b.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep it consistent with update and use io_rsrc_node_prealloc() +
io_rsrc_node_get() in io_sqe_files_register() as well, that will be used
in future patches, not as error prone and allows to deduplicate
rsrc_node init.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c5fd7a8f31d..bcbb946db326 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7488,13 +7488,6 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	return ref_node;
 }
 
-static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct io_rsrc_node *ref_node)
-{
-	ref_node->rsrc_data = ctx->file_data;
-	ref_node->rsrc_put = io_ring_file_put;
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7507,7 +7500,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	__s32 __user *fds = (__s32 __user *) arg;
 	unsigned nr_tables, i;
 	struct file *file;
-	int fd, ret = -ENOMEM;
+	int fd, ret;
 	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
@@ -7517,12 +7510,16 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	ret = io_rsrc_node_prealloc(ctx);
+	if (ret)
+		return ret;
 
 	file_data = io_rsrc_data_alloc(ctx);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
 
+	ret = -ENOMEM;
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
 				   GFP_KERNEL);
@@ -7575,13 +7572,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_alloc(ctx);
-	if (!ref_node) {
-		io_sqe_files_unregister(ctx);
-		return -ENOMEM;
-	}
-	init_fixed_file_ref_node(ctx, ref_node);
-
+	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
 	io_rsrc_node_set(ctx, file_data, ref_node);
 	return ret;
 out_fput:
-- 
2.24.0


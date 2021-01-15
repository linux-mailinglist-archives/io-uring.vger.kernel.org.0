Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB362F82B2
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbhAORmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbhAORmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:18 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E3DC061793
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:37 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c124so8117635wma.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RXmBz5ODd7DL0wFR6SAUmZbIGDnf5Y70w7ecWnf4Fc0=;
        b=NFLipTdx9S6asg3zztu65J9rcI9G5SfKw8c2F/JFccFqC44N1aetiRiEScjQ0h6FUu
         RV/mNSObX+f5bfpWxfRNxPpy3giQftZ3JUz9ImZRhpXZDpb/sLq8IklB3xNspJ3YTBYt
         BNLPvIqVHodILoFO1tqFpTpUHfX752ctYDEOxc5/SjemmlMUyaBoSD42uNpcRoyiSYOq
         a95IPU+saAFVAPU6748Egh5zg7J+uisQ6CdzY55R+/GMOLMiJJ80/fOtCuV14PuFpwpi
         7ijA8HLlDwkAVPN5MiHQAeITHUmWlS2p46TtAd113bmKvQLyzDGhiBCULiTvFlCIf3/T
         ZbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXmBz5ODd7DL0wFR6SAUmZbIGDnf5Y70w7ecWnf4Fc0=;
        b=bDkp7r7zc1uGw7d9w68h5yN3eGNca5IbGrWLtv640cLc67J7UxhX1bJXF4cNQPzDSj
         9pUV6GAnkWA3lXeSdFdvfvyHEBP753gSmHfu8uBi2tUHMLR8e2m2gH0vQuKnnQbxjeTW
         yjR0VMcshhfhOLXGGLt0P4iWtYtUH5QNN/UyeRAoHIyJn64yK58nIiKSsCk+aQqWjKCc
         m/9yajyMRc7c1J5rDBh6z1/OBMkWkmdyRCUQdm2183kyMqjtdYAaktzhRdJ2qI2Us5ej
         UtgG2MWcl1EdtNoz0qjgz318czFyt084qxQyIg78tfyyGVFFG2FQs2d1PPr9sXVEFSAA
         AbdQ==
X-Gm-Message-State: AOAM531ywc2tHVJu7uNOM9e9jao2fZM7Ghx6XYXb5hEJ69IH8ct7sSZp
        HEd3DRxpfaNuygDe3MsxHjY=
X-Google-Smtp-Source: ABdhPJxzV221Be9IgraORANFFcrkjhgyyl1BDj47K0dzcRr+KYIPVWqB7JFXgCPgxrKaUL5j1ijtFw==
X-Received: by 2002:a1c:3c0b:: with SMTP id j11mr9797636wma.90.1610732496409;
        Fri, 15 Jan 2021 09:41:36 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 2/9] io_uring: generalize io_queue_rsrc_removal
Date:   Fri, 15 Jan 2021 17:37:45 +0000
Message-Id: <9ae39f72238058ae3e7bcce1ae2d7bba7523484b.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Generalize io_queue_rsrc_removal to handle both files and buffers.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[remove io_mapped_ubuf from rsrc tables/etc. for now]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 183a761fd9ae..35b4440ca7f0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,9 +195,14 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 };
 
+struct io_ring_ctx;
+
 struct io_rsrc_put {
 	struct list_head list;
-	struct file *file;
+	union {
+		void *rsrc;
+		struct file *file;
+	};
 };
 
 struct fixed_rsrc_table {
@@ -209,6 +214,8 @@ struct fixed_rsrc_ref_node {
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct fixed_rsrc_data		*rsrc_data;
+	void				(*rsrc_put)(struct io_ring_ctx *ctx,
+						    struct io_rsrc_put *prsrc);
 	struct llist_node		llist;
 	bool				done;
 };
@@ -7570,8 +7577,9 @@ static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
+	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -7640,7 +7648,7 @@ static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		io_ring_file_put(ctx, prsrc->file);
+		ref_node->rsrc_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7719,6 +7727,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->rsrc_data = ctx->file_data;
+	ref_node->rsrc_put = io_ring_file_put;
 	ref_node->done = false;
 	return ref_node;
 }
@@ -7876,8 +7885,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
-				 struct file *rsrc)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
 	struct fixed_rsrc_ref_node *ref_node = data->node;
@@ -7886,7 +7894,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->file = rsrc;
+	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
@@ -7895,7 +7903,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 					struct file *file)
 {
-	return io_queue_rsrc_removal(data, file);
+	return io_queue_rsrc_removal(data, (void *)file);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-- 
2.24.0


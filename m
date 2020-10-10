Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4082028A237
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 00:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgJJWzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbgJJTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:04:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B6EC08EC23
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i1so7586576wro.1
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=064JNWj8H4A1f95PRineYL5UK1TBiDlCrA/cCJwb8BQ=;
        b=qSwv4KdoGc9NmPWKRCRSs68OVbf7TF0jcAJwIFVZ5/NL+CtIfnD8gXUXOxlWFeQdXN
         djhQbyywl59bkrtTPawuXgvbp6xdsvKDd2NGSqEablwxi1ZPjpFWCRAe2XwqkFnC2EMt
         l+X5ooU4X6FDV3Fjk0dMG1z+BBVoN59ts07kuBR66qTEc1frpO6U6UX+jiYo/EcLuUQA
         Tg9qJJJH4FiIcHoX5l1XyDZxEcfFE0rh4cMriId0KyfWfq+qxSnO8xr7d4tPp5JFk6tU
         95WS4L4RgQrUkYLWCNeJ2uVTCb4uk0wsN4ZID5wqTw+4PqdoZQgMYAORZm839WQ0gRKz
         WlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=064JNWj8H4A1f95PRineYL5UK1TBiDlCrA/cCJwb8BQ=;
        b=X27KuRYiLzeP9zuiPl4gBTew6O7UcnHRcfVTuWdK+z68sgVHKxYionpKQpV+M/xbQr
         jdQvoFwdGChFtTr9+3he4AO/5LGmPH1Cf1L7osw5mZcO3v5JzqKq1eRaRsKUrkecbE8V
         cCVlN+e6Dayz2I7HzdKEPt0Sp0HoAioIGuZm3NzbXo9KcpEy1lTZmqCZrXvU49ypZXUu
         N6KMZWWzT9mEjxDsz5GGLI0onHCbueP8XES25lHP0uFEnsUbW3GBmexG6FJP9uZQzByi
         /T0/yqg3jLk+Rm+OH1eNi9Emn2h4Hn3L7bELVINQ1jWe0psZ9LPanFg/J77jZXfzNBef
         lYsQ==
X-Gm-Message-State: AOAM533MIaIzjUFaadjrVRvOLpsGOI55pIgj+P1qJsKVejvMDWKGlF/H
        cndYxAlT/sdAVSt3l9W520nRQxnKqr2KAA==
X-Google-Smtp-Source: ABdhPJyDBf0MVMSMXo0CRRzc6RPFvmmFWss5Hfid5J/jOX1sA0ikKOwa0L4kRC/U6M08CmRk5YtqYg==
X-Received: by 2002:adf:ba4f:: with SMTP id t15mr20311123wrg.335.1602351443241;
        Sat, 10 Oct 2020 10:37:23 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/12] io_uring: keep a pointer ref_node in file_data
Date:   Sat, 10 Oct 2020 18:34:16 +0100
Message-Id: <0819c89fbad91febab0b0ae069ffbe0884f710ca.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->cur_refs of struct fixed_file_data always points to percpu_ref
embedded into struct fixed_file_ref_node. Don't overuse container_of()
and offsetting, and point directly to fixed_file_ref_node.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc4ef725ae09..c729ee8033f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -210,7 +210,7 @@ struct fixed_file_data {
 	struct fixed_file_table		*table;
 	struct io_ring_ctx		*ctx;
 
-	struct percpu_ref		*cur_refs;
+	struct fixed_file_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	struct list_head		ref_list;
@@ -5980,7 +5980,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
 		if (file) {
-			req->fixed_file_refs = ctx->file_data->cur_refs;
+			req->fixed_file_refs = &ctx->file_data->node->refs;
 			percpu_ref_get(req->fixed_file_refs);
 		}
 	} else {
@@ -7362,7 +7362,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	file_data->cur_refs = &ref_node->refs;
+	file_data->node = ref_node;
 	spin_lock(&file_data->lock);
 	list_add(&ref_node->node, &file_data->ref_list);
 	spin_unlock(&file_data->lock);
@@ -7432,14 +7432,12 @@ static int io_queue_file_removal(struct fixed_file_data *data,
 				 struct file *file)
 {
 	struct io_file_put *pfile;
-	struct percpu_ref *refs = data->cur_refs;
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_file_ref_node *ref_node = data->node;
 
 	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
 	if (!pfile)
 		return -ENOMEM;
 
-	ref_node = container_of(refs, struct fixed_file_ref_node, refs);
 	pfile->file = file;
 	list_add(&pfile->list, &ref_node->file_list);
 
@@ -7522,10 +7520,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	}
 
 	if (needs_switch) {
-		percpu_ref_kill(data->cur_refs);
+		percpu_ref_kill(&data->node->refs);
 		spin_lock(&data->lock);
 		list_add(&ref_node->node, &data->ref_list);
-		data->cur_refs = &ref_node->refs;
+		data->node = ref_node;
 		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC94C346144
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhCWOSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhCWORa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918AC0613DA
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:28 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c8so8038644wrq.11
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U85TZZTUM9w8Ru7FIjGY3BovYh1CW+ZdNIf4ACVlEFo=;
        b=Yhpgo5kOVB7W2Jge436/2DhEnUc6nEVCYNaOT3RXS4BGoXxELqQJsJvOIbufxqlLo2
         L7fbsDiQiz0PB6+M+cJaA/ay563yR2SwGnHYada7EdUEbqy/PLa8XD+9IJhq/05PlR/c
         HZyg7DhcswYwBKO3w9W6/Ek8e5MXNQC8A7XV622QL3n0DnpgAHV7pYVPBiy9t3EAAuCa
         dfbnXkRchNFV9SFfXfgE17lJdioTkB3rRkT5avAw8rNpZBbrZnBy0v5lQbFrol4xpfdL
         yJnVbtg2imyDC6dg51oBIFgGdzTIOt9AupruGXc+7qAAgUWCZyxCyP5Sc6zPv47Xtnse
         H5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U85TZZTUM9w8Ru7FIjGY3BovYh1CW+ZdNIf4ACVlEFo=;
        b=P7NdwKarquMg1rZKvwYdTUi5JrmO22Dqyl5tQ5Gy70u8qkG7wG3iMIVJtGfMTbx1gL
         KVANOl74dVzg+pQSvushjzQuXlLeXzNYgMg5OhRQixSOk/NPjoS4ZsukKXrcZXUZBftg
         pcdOKcXayy+yPl8vF76p8LY08jBmgyy6VX/rTGajKSt7Q8xvjBpuifyG5Q5JqBi3q0Yx
         3ced06XRh8fJDIk30+E5eNiQi5LOBIWDX1Ldx2VEKne1DpiqA8HVeyzBGrfCfspk80+d
         bf/d2uXe2NiZgSsAr1TjRd9PMkRDNUv2nmrXo9o62egK1b27eis8kZGqMvAgvR10qaOq
         d8qQ==
X-Gm-Message-State: AOAM531l4fXNJ5Cgblc44uNaI0IfAfUXZCtwGyUvrD6rHPT2jQHbHG1E
        DIVeRuv48LqBFoHxonkjgeb7BAXBcCE2pQ==
X-Google-Smtp-Source: ABdhPJwTSPxFD8zl0k0ZhFq7cFG5v2IsXxQCnIEtzis2QMw/BAo4DJmzm6f/1BuKIPZeDmqLtodv/Q==
X-Received: by 2002:a5d:6307:: with SMTP id i7mr4259067wru.305.1616509046985;
        Tue, 23 Mar 2021 07:17:26 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/7] io_uring: use rsrc prealloc infra for files reg
Date:   Tue, 23 Mar 2021 14:13:13 +0000
Message-Id: <0dd2bcd20e0d52d7eb503f97f3cf480d731d989b.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
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


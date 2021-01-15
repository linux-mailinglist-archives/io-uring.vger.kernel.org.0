Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BA32F82B7
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbhAORm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbhAORm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:56 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64F1C061798
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:41 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id e15so1915238wme.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yNL1jyFlrLRhPSpfDfPyvavN2AjjZhFGmqsN6+5UMrU=;
        b=UceOBjJ/aW/k+Vf71o8rwuJfNIM0xy19328h6wOh26/69n5wOBpdEiq1EJ6DbIcXJY
         17h2bkzgJkSb4/dylANoC77z7Y1IxdA1gG4mY14yY282e3niUYNz4vsN/RK9raaktxgX
         nc6rTq1/AeHx6Bq3JR/OfC0PbO0LmZn7FgVSjKu/yaNiOr3oczikHq9DpLJEv6DXk6G2
         fCj1G4pooGDDS11NdNZkEJ1ITnD9rz/YGxPBGoJEXJomQV8uC7n7R7GAlxhD5/J1zqhe
         zWf2loS2pCc4gQCqJzwIKt2os0s1BkdqoYz7CJxvezAaefy4edsRY+qC99nX3je4A5ko
         urCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNL1jyFlrLRhPSpfDfPyvavN2AjjZhFGmqsN6+5UMrU=;
        b=lBOrr3swKKMsEN1omiwKsLT5pK2hXlui/3CEjbFJjx2bzPOMEbNG9IUDdfMqyeV6Cd
         cbISbGWtQmEMPmxjnRqXZtUtRFfqvpSEfl9401ftt3ul+85D0LceEAOzjoDbrG12m694
         h4JtxkK501lQ1lcm4gZ+vF+sqvQmFcaHJHi+i+wX0oRJXIWX68loVwTJDeJ9wpWQzMAD
         wGYgJHK44RhZ8P3n/0qxUjQqawk8LloidbMMUaERDQPmkcauFTJSSTmJirkHKus3YcSg
         khNZyyyVYDr/frT2C+yp0l71UdJARrurJT55CiB0SkSf3G/FwplZueuAExW/bp6Up1uv
         rZAw==
X-Gm-Message-State: AOAM530tQciP3pmtJ1/5Sdz+imnODURshlons2soabnDBdJzh/W5ETW7
        fjIpB2MgJnbjHoet2mJO8qQ=
X-Google-Smtp-Source: ABdhPJxw/0EuwaP+NSUtlXp/B5l/ufeht1+56S8a47lU6y/fYGhZ3y7a6y11R44Kb9xOL3ar9z6pig==
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr9803036wma.3.1610732500568;
        Fri, 15 Jan 2021 09:41:40 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 6/9] io_uring: split ref_node alloc and init
Date:   Fri, 15 Jan 2021 17:37:49 +0000
Message-Id: <5a7f0de3413c89008b4b872bf609cb4ba88d35ac.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A simple prep patch allowing to set refnode callbacks after it was
allocated. This needed to 1) keep ourself off of hi-level functions
where it's not pretty and they are not necessary 2) amortise ref_node
allocation in the future, e.g. for updates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a26fba701ff..f149b32bcf5d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1004,8 +1004,10 @@ enum io_mem_account {
 };
 
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
-static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
+static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
+				     struct fixed_rsrc_ref_node *ref_node);
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
@@ -7304,9 +7306,10 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 	if (!data)
 		return -ENXIO;
-	backup_node = alloc_fixed_file_ref_node(ctx);
+	backup_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!backup_node)
 		return -ENOMEM;
+	init_fixed_file_ref_node(ctx, backup_node);
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
@@ -7743,18 +7746,11 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 	return ref_node;
 }
 
-static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
-			struct io_ring_ctx *ctx)
+static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
+				     struct fixed_rsrc_ref_node *ref_node)
 {
-	struct fixed_rsrc_ref_node *ref_node;
-
-	ref_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!ref_node)
-		return NULL;
-
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
-	return ref_node;
 }
 
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
@@ -7839,11 +7835,12 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = alloc_fixed_file_ref_node(ctx);
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!ref_node) {
 		io_sqe_files_unregister(ctx);
 		return -ENOMEM;
 	}
+	init_fixed_file_ref_node(ctx, ref_node);
 
 	io_sqe_rsrc_set_node(ctx, file_data, ref_node);
 	return ret;
@@ -7946,9 +7943,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
 
-	ref_node = alloc_fixed_file_ref_node(ctx);
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!ref_node)
 		return -ENOMEM;
+	init_fixed_file_ref_node(ctx, ref_node);
 
 	done = 0;
 	fds = u64_to_user_ptr(up->data);
-- 
2.24.0


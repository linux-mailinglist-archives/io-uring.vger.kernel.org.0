Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2E3DA71E
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhG2PGm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbhG2PGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A5C0613D3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u15so3947354wmj.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NuW00eRPwV+Goiy+XA/sfyOyIHPFmHT8zw8B0ku+Uzg=;
        b=esWPfedJBVqVzug16nHwaqg8AX0TowqH/C44mM1t0y4muoAHDKKQTQhZk5885D7a5B
         IWy8tsalfd2ji2K6jbVqr0BGMi2tyKLceCznQU+pU6ht+Lj9Dn2J5QPWiRcsE+YjQBtK
         24CjhWqsnXk9uJ1/q+va0bRmuUMEAcly03vsfd1bf6X95M8pwxnPzKEtSzWEmRUgH2cW
         dY+4t4lPwtkP2NfIR9ndkYhoBO4+raHVcVod9P+EdlIorEHiWMgyEgJGVZ/AVsHfuXSG
         LwH4REe+9nBbTqpfmjvHoJCMPXS1JIjwRodEKuOnqhb7VmP5+VWqUkFOZOAVetHfmSf9
         DkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuW00eRPwV+Goiy+XA/sfyOyIHPFmHT8zw8B0ku+Uzg=;
        b=H8d/3cTl2jz1/jiKAVLGljL1AX9PFl4G36zAkXZfOL13b7B2XBA8kHBcO30CaRT3kj
         o1WYJss5qqZetzokuc1sFSCn67ndAnKhtbCyqfRNuIaeuJp7lW/7Z7bF33G8ycxTZuML
         MOYDWjb4UAGlCKUGMtqzQvVBrsWTnZsYZyUCTRemfnGkgh0R1ApgvFqy1HQup+k7mkBy
         hNI2qlBclAUKTzYrInPNm0ShKXATGJ4v+3WaSlJwC6ekPEz7rdjNK4Ayxn6vIWyk+pkQ
         1DM3/21s0frbatXinTY99Zrwfo5J2y3O+eKuW/CZXFq4Zvjj42sy62MATbsuq3FtjFYg
         9BTw==
X-Gm-Message-State: AOAM531H2yrudk9god9XczoKKn8Rt+fyq9/+lMHIpCVoyaPCcrwh1JaP
        VsZOEnqZuax6O4Q37mevB8A=
X-Google-Smtp-Source: ABdhPJyUlqooQo8YfslhAVahpS/OYJh0x/rcpQYipBzgq2kJXKQ3OeNEUzLlHIrRoSKkSb9V7SFbZg==
X-Received: by 2002:a05:600c:28b:: with SMTP id 11mr14518376wmk.6.1627571197986;
        Thu, 29 Jul 2021 08:06:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 17/23] io_uring: move io_fallback_req_func()
Date:   Thu, 29 Jul 2021 16:05:44 +0100
Message-Id: <19899acfc1f85ff745cf098d889a1232cd58e8e1.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_fallback_req_func() to kill yet another forward declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index df970e0ad43b..44d7df32848d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1079,8 +1079,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
-static void io_fallback_req_func(struct work_struct *unused);
-
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -1162,6 +1160,17 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 	return !req->timeout.off;
 }
 
+static void io_fallback_req_func(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+						fallback_work.work);
+	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_kiocb *req, *tmp;
+
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+		req->io_task_work.func(req);
+}
+
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -2465,17 +2474,6 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
-static void io_fallback_req_func(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
-
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
-		req->io_task_work.func(req);
-}
-
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     unsigned int issue_flags)
 {
-- 
2.32.0


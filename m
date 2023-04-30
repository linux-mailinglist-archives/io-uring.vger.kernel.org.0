Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56186F2856
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjD3Jhk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjD3Jhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916D410EC
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so14174645e9.0
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847456; x=1685439456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PODfE/eB9roMtLo3DHpW/qaU1lJNg5kkSWiXbfO6TOU=;
        b=flAMcMU4+jmIVU6lXBEo4WBi4VY3NJRr/DoqFw/QwRnm49q+fUECOPVuZWUek/yn9f
         tlhDNtRBL5p3Eap2ZsasjeAUdkjc3WJkjs7Ih03DY+hmoTiHQ77qwJWblHwSjwUtuEbl
         gTEkdfBELXXk+a/IkW0HDCMxcUv1on/npyE+P/6z9Y8twitonMamk/X+ZCtUjwGk288e
         SS+VUN/UAwPfc391XpxZf287nUuFqg7YR25tEF+mD3oVXV/uMlQqih3IEqU4Ct7sRRde
         TKiaCQSg0HuYGQYWchXgRS6oBXXIgNhyNjYHjcHcazdbmRXMZJLsRzDN2etY7IRI4pfS
         2xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847456; x=1685439456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PODfE/eB9roMtLo3DHpW/qaU1lJNg5kkSWiXbfO6TOU=;
        b=Gfmx54DVeKxvyjN/3Sv+i+j3J+lN+87Bckw/AddP4C5i/4kNiyjP4suC48PwnCeXTp
         ogEkL6tIkmxX/LQvTOCHdDqTGHX7lI26wnTI7tgxJf40kgpYw6E+9EXwiOpGwDev3bI6
         C1MlPSjebMLi1JCGKM5BDjc3f/SzMwWr+l7lcmEMpXe9cBHTIVRxinYnatOMBVoTJEmP
         vuvQu81tj8+0qy2Mq8NIuSLKgK3Oo6Pr7Ow0qclLWk3bsGyOLfZ3c8POeKf1WInKvmOZ
         C35VS/EgsJjJwsMlAA2CQ48zephIU38j1QEZ/e1UVp/QKkQgOE+4yFUUuybD5ZrTTR0W
         nETQ==
X-Gm-Message-State: AC+VfDydO3HvZ7CIcpIgagpklze97+00LlKDHWld5X26QbROq/r6bDE+
        uwlhZrjfw1duS+npfKCBVeDC7597PPQ=
X-Google-Smtp-Source: ACHHUZ5n6eIketr0VlgaJ5dQMa3OgFu6PrnZUh9LYZGFdeD5T3s3yOTZrq39Jt8RZwTjGaFzgoRhQg==
X-Received: by 2002:a1c:4b12:0:b0:3f0:9f9b:1665 with SMTP id y18-20020a1c4b12000000b003f09f9b1665mr8248958wma.3.1682847455808;
        Sun, 30 Apr 2023 02:37:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 1/7] io_uring: add io_mapped_ubuf caches
Date:   Sun, 30 Apr 2023 10:35:23 +0100
Message-Id: <72f0d52521c35c1aee2d1327a3c1cd4ccb0bc6c3.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll be allocating lots of io_mapped_ubuf shortly, add caches

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            |  9 ++++++++
 io_uring/rsrc.c                | 39 ++++++++++++++++++++++++++++++++--
 io_uring/rsrc.h                |  6 +++++-
 4 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1b2a20a42413..3d103a00264c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -336,6 +336,8 @@ struct io_ring_ctx {
 	struct wait_queue_head		rsrc_quiesce_wq;
 	unsigned			rsrc_quiesce;
 
+	struct io_alloc_cache		reg_buf_cache;
+
 	struct list_head		io_buffers_pages;
 
 	#if defined(CONFIG_UNIX)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3d43df8f1e4e..fdd62dbfd0ba 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -312,6 +312,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
+	io_alloc_cache_init(&ctx->reg_buf_cache, IO_NODE_ALLOC_CACHE_MAX,
+			    sizeof(struct io_async_msghdr));
 	io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
@@ -2827,6 +2829,11 @@ static void io_rsrc_node_cache_free(struct io_cache_entry *entry)
 	kfree(container_of(entry, struct io_rsrc_node, cache));
 }
 
+static void io_reg_buf_cache_free(struct io_cache_entry *entry)
+{
+	kvfree(container_of(entry, struct io_mapped_ubuf, cache));
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2865,6 +2872,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
 	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
+	io_alloc_cache_free(&ctx->reg_buf_cache, io_reg_buf_cache_free);
+
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index ddee7adb4006..fef94f8d788d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -33,6 +33,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
+#define IO_BUF_CACHE_MAX_BVECS	64
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -78,6 +80,39 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
+static void io_put_reg_buf(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if ((imu->max_bvecs != IO_BUF_CACHE_MAX_BVECS) ||
+	    !io_alloc_cache_put(&ctx->reg_buf_cache, &imu->cache))
+		kvfree(imu);
+}
+
+static struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx,
+					       int nr_bvecs)
+{
+	struct io_cache_entry *entry;
+	struct io_mapped_ubuf *imu;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (nr_bvecs > IO_BUF_CACHE_MAX_BVECS) {
+do_alloc:
+		imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+		if (!imu)
+			return NULL;
+	} else {
+		nr_bvecs = IO_BUF_CACHE_MAX_BVECS;
+		entry = io_alloc_cache_get(&ctx->reg_buf_cache);
+		if (!entry)
+			goto do_alloc;
+		imu = container_of(entry, struct io_mapped_ubuf, cache);
+	}
+	imu->max_bvecs = nr_bvecs;
+	return imu;
+}
+
 static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
 		       void __user *arg, unsigned index)
 {
@@ -137,7 +172,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
-		kvfree(imu);
+		io_put_reg_buf(ctx, imu);
 	}
 	*slot = NULL;
 }
@@ -1134,7 +1169,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		}
 	}
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu = io_alloc_reg_buf(ctx, nr_pages);
 	if (!imu)
 		goto done;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0a8a95e9b99e..f34de451a79a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,9 +50,13 @@ struct io_rsrc_node {
 };
 
 struct io_mapped_ubuf {
-	u64		ubuf;
+	union {
+		struct io_cache_entry		cache;
+		u64				ubuf;
+	};
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
+	unsigned int	max_bvecs;
 	unsigned long	acct_pages;
 	struct bio_vec	bvec[];
 };
-- 
2.40.0


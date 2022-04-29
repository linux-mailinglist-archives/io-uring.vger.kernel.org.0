Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE751494B
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359148AbiD2Mbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359151AbiD2Mbh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDE4C90CA
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id i62so6409545pgd.6
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GKrcOv9pG1lneRAWczG4a2bMEv/yL32HG8D7qHOkWaA=;
        b=aysWaOkaeZbDgE2zklAFp712PKn3NPsePud87O3z5zTkyzwg74dM8hpzfqf7cBtTHq
         C3aUOmmcaWztHOhaCZldV7Jg0Z89lI0CGiGjP+Psbn/gnSO1NSCntUu8VcJCRXnc8tlP
         4oqv9k9wEWWkSFUh/8zdo6DwY21lAlmnWdlTcEeKsqxO6csjen3oC6VrJfUKuwqzafc2
         WPKBYN9ByK2mKjyoa/SkqCx8z0YLUfERqmzLHHSEcSt00JnCSjD3kjAWGsz4P1bbyKj1
         gvPmE4zPyTPvNJDaDSHr6tNgUgHiyWK2WTMfZa/pzQK9i0Bxvj6VjXiwx4kSopquuCsC
         Z1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GKrcOv9pG1lneRAWczG4a2bMEv/yL32HG8D7qHOkWaA=;
        b=hgCH0/YYMzr+dipLaoaxuOR9SSdksgU5b4swrX1ke+tKHI1DajB+q2HdHu1T3+igPH
         QLRz8810rrNsbqs8zxrE/xC8kGONK7DbKtRkxk8C+qQ48l1OCfkq4td92TtZlvpDtFrk
         Jby5+o8aA/saT1M+vCvjLJpVnOEkQa8GHEIYPpbqaLw6/8h73gPfrLoyF0B5zxhVv/68
         ifa2i35uzJNkaCIXVTyhjN9ZNj54X2Uu3Y/Bj364ol7eXBIjgDXKBDXJiWJsVifIYu9W
         B0ij4Vzc0zEw/eZZSqaQfG+5jT+TT4/fXWRouIbEfdDsT9vyXoXuAZxREI16EuajuKZO
         +fJA==
X-Gm-Message-State: AOAM533TN2YAXi8tpsArxFbyQBU6hIAFEhevgFvUfhJ2PHvQa63Erwvs
        T2Uumxzaxt/ihZ+vVS+zbUpfaLN2VKqMYGlj
X-Google-Smtp-Source: ABdhPJyVeyYm/JacXBjr3oK0zYItBzbKCk1W8XyZgfNtrA432txI9NSkO0eBfTaoLPqGTeI32PXCSw==
X-Received: by 2002:a62:cec4:0:b0:50d:9030:722c with SMTP id y187-20020a62cec4000000b0050d9030722cmr9756934pfg.41.1651235298396;
        Fri, 29 Apr 2022 05:28:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/10] io_uring: relocate io_buffer_get_list()
Date:   Fri, 29 Apr 2022 06:28:02 -0600
Message-Id: <20220429122803.41101-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for calling it from __io_put_kbuf(), move it up a bit to
avoid a forward declaration.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f9b9aa57ddb..5b0deba430ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1558,6 +1558,27 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
+static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
+						 unsigned int bgid)
+{
+	struct list_head *hash_list;
+	struct io_buffer_list *bl;
+
+	if (bgid == ctx->io_bl_bgid)
+		return ctx->io_bl_last;
+
+	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
+	list_for_each_entry(bl, hash_list, list) {
+		if (bl->bgid == bgid || bgid == -1U) {
+			ctx->io_bl_bgid = bgid;
+			ctx->io_bl_last = bl;
+			return bl;
+		}
+	}
+
+	return NULL;
+}
+
 static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
 	struct io_buffer *kbuf = req->kbuf;
@@ -1614,27 +1635,6 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 	return cflags;
 }
 
-static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
-						 unsigned int bgid)
-{
-	struct list_head *hash_list;
-	struct io_buffer_list *bl;
-
-	if (bgid == ctx->io_bl_bgid)
-		return ctx->io_bl_last;
-
-	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
-	list_for_each_entry(bl, hash_list, list) {
-		if (bl->bgid == bgid || bgid == -1U) {
-			ctx->io_bl_bgid = bgid;
-			ctx->io_bl_last = bl;
-			return bl;
-		}
-	}
-
-	return NULL;
-}
-
 static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.35.1


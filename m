Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2433451F228
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiEIB3Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 21:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiEHXxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 19:53:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B12FBF4C
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 16:49:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so11233393pji.3
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 16:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y09dGxniDgP24WwGmY1xOioqN5AC7Ww9dCLNDr8NAUQ=;
        b=7LuT1TsJZgstQ2s5ee71ep9h0zSdCcxR2W2EFrTmPBRMDLWpS+HyVzXisHSddiuGDy
         nCHXJNuNW+U4hwpA+m72D829SmTij94r5aULIT7Ccb1fM5Dl7+0rSly6hZ+1QWdOMCiE
         /6nIqi3wnRt80hkfohMBAi9aHqKY2xa/V154e+IBhYKrL4IwLg2E2EpyCf/ZkzP81F84
         zTgh7o5oPe1v6C2O9raw7YZKdtQdB5hTmv3MMwu2jTuRK1tqWpBYZtJSXpfJT/K7MfuE
         CFK45ggAD2FOaNjylKn+riU3pNOyHDqRo4S7T+WHgd88hYaQR6JYtEIg5x2qy9mg2Uy6
         LpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y09dGxniDgP24WwGmY1xOioqN5AC7Ww9dCLNDr8NAUQ=;
        b=FqgHM9SC7tRvKe+eEJdGQrxSkTLX2eIbLfm97p9ibqF4fk4LrbApcBqeuzDxGLyC4B
         Vv5fn8P3IIGcz2wUH8SQCOu6g0ArvNiHNJ5X8vkFy7eky/At+tNy9pFL0cgL+gIXOS0L
         e2JnzU4zBkNephNr4ZSD7M5zYgnelBStXtHhCurWErmAmNRLwUd6akpbh8XGoE6N32YJ
         Qmf+G189HXjrNMGzf9IuRaxr3BFm2OvJ+z9821RvYBpRCJ/GdO6RLrGqmuoWxLvbPUbD
         K66mi3lNaAYXTaM7QMskArerO4blZU1Hxr8ELGboxFSrmBVFAJh3AAXQirYpW56WVlr8
         3R3g==
X-Gm-Message-State: AOAM532YwrMMwp6pCtqm/SMaLKb11JKNvBJX5NxcZizFQwJl70hpkEe8
        oyGxgs/Do0TkorHzauYhtjA9mfqc63+lzdkc
X-Google-Smtp-Source: ABdhPJxUvlG3eabm/vC1EwXNbWRBAT8yOu0rJZfukXNps0fhHs65zjh0KGmy0NrEAld2nhDehQ6foA==
X-Received: by 2002:a17:90b:1c87:b0:1ca:f4e:4fbe with SMTP id oo7-20020a17090b1c8700b001ca0f4e4fbemr23519590pjb.159.1652053755880;
        Sun, 08 May 2022 16:49:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902ccd100b0015e8d4eb2a2sm5675249ple.236.2022.05.08.16.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:49:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: allow allocated fixed files for openat/openat2
Date:   Sun,  8 May 2022 17:49:08 -0600
Message-Id: <20220508234909.224108-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508234909.224108-1-axboe@kernel.dk>
References: <20220508234909.224108-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the applications passes in UINT_MAX as the file_slot, then that's a
hint to allocate a fixed file descriptor rather than have one be passed
in directly.

This can be useful for having io_uring manage the direct descriptor space.

Normal open direct requests will complete with 0 for success, and < 0
in case of error. If io_uring is asked to allocated the direct descriptor,
then the direct descriptor is returned in case of success.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6148bd562add..986a6e82bc09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_openat_prep(req, sqe);
 }
 
-static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
+static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 {
 	struct io_file_table *table = &ctx->file_table;
 	unsigned long nr = ctx->nr_user_files;
@@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
 	return -ENFILE;
 }
 
+static int io_fixed_file_install(struct io_kiocb *req, unsigned int issue_flags,
+				 struct file *file, unsigned int file_slot)
+{
+	int alloc_slot = file_slot == UINT_MAX;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	if (alloc_slot) {
+		io_ring_submit_lock(ctx, issue_flags);
+		file_slot = io_file_bitmap_get(ctx);
+		if (unlikely(file_slot < 0)) {
+			io_ring_submit_unlock(ctx, issue_flags);
+			return file_slot;
+		}
+	}
+
+	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
+	if (alloc_slot) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		if (!ret)
+			return file_slot;
+	}
+
+	return ret;
+}
+
 static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
@@ -4777,8 +4803,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	if (!fixed)
 		fd_install(ret, file);
 	else
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    req->open.file_slot - 1);
+		ret = io_fixed_file_install(req, issue_flags, file,
+						req->open.file_slot);
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.35.1


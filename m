Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E13252019A
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbiEIPy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbiEIPy4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:56 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B8C20F70
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:01 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y11so9584279ilp.4
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fU5PI/Xb9BjpSJMYfn0s6B200MtWs1UXYAflxcZuUBw=;
        b=7Ii5N06IQSJ73LZUsumC01VDgQI/WABNW1JAPsycrnQ6Xv+LH6edqZWu5nSgyG1+tT
         WvZfH/n9p4/EXE5z6S0MAe0Tu9umir42ZCSLm5/ATOBpnmbr5+og1RCKgk1yb/EGP7Ts
         SfE/vL2E7CEDW7g1sTflOb/K5EOoZNV+xciKmBs5KwTP1iDbDl0ksGlq9kwTiFW5rH5G
         S/hay+3FYWkTHfFnqpZWL3xFULGtMaiYaHYfv1mRuGjurGMGsZUbVr0u8cwAgshKfgRx
         cC41ST1xUnXH2zIDG9LBemirwnMFxP8HLmZkMGX4Tj8gmLcew6rAIAQN/4Djes6ZuD7D
         lasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fU5PI/Xb9BjpSJMYfn0s6B200MtWs1UXYAflxcZuUBw=;
        b=HtARsXzy+qTLT8WCd6K/4SfEH8wAIUkAKXs+gv/xrBTsrfHN9Mrp+A5AqNkz4KLhZR
         j+kvZXH1y8I99PwlqRJzvleYsNxnRoJdwke3BVzMOzTMkaJDBH+Cebi3eqc3Or9/uRSf
         M2r5Z7W5RVYDI8U/xoi6fYcxUD3CNqT/K17zrOcQds99RB8eo0SqFj85RoVPKY8sX1ug
         Imt0ExvonVtBWppU4B6J9OeZj3FjIegypJDwTpW59KrPEZ2C/q+f67XnUdeUwtz5DlmZ
         Z7bz73HMAeRF+GMkWqdCi3Ot6hwOz+dPHcur+Uw129biAf0Ur6+o0htKYvhGq+Z23KlT
         mYvw==
X-Gm-Message-State: AOAM531YEG2jNHnXoLw87Q1Ge3gvDkqY3Swc+5Cdg3EgQ7J3u736QGlu
        3qEYDG1EboIs0z3UbM3tDr7ohJwZeAnwyw==
X-Google-Smtp-Source: ABdhPJygPNRsys0hcfdn3CqfuaIG9sX3D1m2Pzo7ehHQ0D5v0iH/s9KuBCoQJ9rvFQ6LUJIm4Eje6A==
X-Received: by 2002:a05:6e02:1bac:b0:2cf:832a:e41 with SMTP id n12-20020a056e021bac00b002cf832a0e41mr6376498ili.102.1652111460683;
        Mon, 09 May 2022 08:51:00 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:51:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: allow allocated fixed files for openat/openat2
Date:   Mon,  9 May 2022 09:50:52 -0600
Message-Id: <20220509155055.72735-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
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

If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
then that's a hint to allocate a fixed file descriptor rather than have
one be passed in directly.

This can be useful for having io_uring manage the direct descriptor space.

Normal open direct requests will complete with 0 for success, and < 0
in case of error. If io_uring is asked to allocated the direct descriptor,
then the direct descriptor is returned in case of success.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  9 +++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c40411a7e78..ef999d0e09de 100644
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
 
+static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
+			       struct file *file, unsigned int file_slot)
+{
+	int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
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
+		ret = io_fixed_fd_install(req, issue_flags, file,
+						req->open.file_slot);
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 06621a278cb6..b7f02a55032a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -63,6 +63,15 @@ struct io_uring_sqe {
 	__u64	__pad2[2];
 };
 
+/*
+ * If sqe->file_index is set to this for opcodes that instantiate a new
+ * direct descriptor (like openat/openat2/accept), then io_uring will allocate
+ * an available direct descriptor instead of having the application pass one
+ * in. The picked direct descriptor will be returned in cqe->res, or -ENFILE
+ * if the space is full.
+ */
+#define IORING_FILE_INDEX_ALLOC		(~0U)
+
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
-- 
2.35.1


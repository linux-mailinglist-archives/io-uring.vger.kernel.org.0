Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B6D4F7F47
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245336AbiDGMmy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbiDGMmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9086454BC5
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:44 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso5621312wma.0
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Molm2KW7uFh68s6XqowD4nx7KTeoB73d3UMUuGy++vc=;
        b=kXJa+KSB9FZDw3UAL89ubp4zd7544XB+wnbHLkeiydBW/GpzO9Kf3yKp1tXYBvh4Zr
         efwhR1nyzve75AFpfXaYLBzaKpTqagMskY0oZVGEbsaooXU4CLlzWLBLMY2sxZJIQxG7
         ZKZiQYBBwd5Vimc/6JW3s/76Px325quP1JZmqNoE44lkF2M5Q+qeM4aJpOm9brOtSGFi
         pnsa6n9LNuavLQfTvLrHj765WlmsvKcuBeu94ugc2JJnVDbZXvUNcXR122zLP1CDEDUN
         WNjuOhMlnjVXBhn9iigI9KTjrrPSN0I028DGKmcO0oF+z1POWMfaOmj9IxxINB90Amjf
         UZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Molm2KW7uFh68s6XqowD4nx7KTeoB73d3UMUuGy++vc=;
        b=UJ6pQw1r5bxpzm4iQM7y5GKVvllXu7YSr7YeBq6BBuTx8mLlAVGdMmSdMDQkyYSzW3
         7zaq9m7x5cuFspTceiOizBG8arZ4vztk36x4AB1Y/phy2naddvj1Bm0zi3u7PAxCbzrO
         QUBJTgohPzurv6mfRvWAyODDUSb6m51eZA/i8j4zWwS1zi/4eJjxz3EiEKyiaYcBJ7e1
         lYa68LMGbZg/CwrdXs18fDXX8JjU4RloHm4hcdrGV6ZF9rWMyyGsZefpFdosBX7J43Cw
         +ePeOik+CchoZNYkHD0dXsrRO8USTAtr1mpKK9AElk3plpnmVXSyKVOB4VLn8mzq+pby
         etRg==
X-Gm-Message-State: AOAM532yK+D6X0YFmxEh9Nd+g16+2T0QW+/r5m4oXksc3wQt7dLcJXdF
        5ZDbzpatOZovxNfviBSgRxDbxlTi/y0=
X-Google-Smtp-Source: ABdhPJzedAE50Un3abCiWVX9Z4n+nuV1KzQMiM+WVNKB2tL6kofeuvh7sKl2s1Ti9YtNlFoaIo93GA==
X-Received: by 2002:a05:600c:3512:b0:38c:be56:fc9c with SMTP id h18-20020a05600c351200b0038cbe56fc9cmr12110968wmq.197.1649335242644;
        Thu, 07 Apr 2022 05:40:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring: uniform SCM accounting
Date:   Thu,  7 Apr 2022 13:40:01 +0100
Message-Id: <6c9afbeb22812777d0c43e52353b63db5b87ed1e.1649334991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649334991.git.asml.silence@gmail.com>
References: <cover.1649334991.git.asml.silence@gmail.com>
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

Channel all SCM accounting through io_sqe_file_register(), so we do it
uniformely for updates and initial registration and can kill duplicated
code. Registration might be slightly slower in some case, but first we
skip most of SCM accounting now so it's not a problem. Moreover, it's
nicer for an empty set registration as we don't even try to allocate
skb for them anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 93 ++++++++++++++-------------------------------------
 1 file changed, 25 insertions(+), 68 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 877753e5f569..6212a37eadc7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8651,48 +8651,6 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 
 	return 0;
 }
-
-/*
- * If UNIX sockets are enabled, fd passing can cause a reference cycle which
- * causes regular reference counting to break down. We rely on the UNIX
- * garbage collection to take care of this problem for us.
- */
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	unsigned left, total;
-	int ret = 0;
-
-	total = 0;
-	left = ctx->nr_user_files;
-	while (left) {
-		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
-
-		ret = __io_sqe_files_scm(ctx, this_files, total);
-		if (ret)
-			break;
-		left -= this_files;
-		total += this_files;
-	}
-
-	if (!ret)
-		return 0;
-
-	while (total < ctx->nr_user_files) {
-		struct file *file = io_file_from_index(ctx, total);
-
-		if (file)
-			fput(file);
-		io_fixed_file_slot(&ctx->file_table, total)->file_ptr = 0;
-		total++;
-	}
-
-	return ret;
-}
-#else
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	return 0;
-}
 #endif
 
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
@@ -8813,6 +8771,9 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
+static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
+				int index);
+
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
@@ -8837,27 +8798,31 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	ret = -ENOMEM;
-	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
-		goto out_free;
+	if (!io_alloc_file_tables(&ctx->file_table, nr_args)) {
+		io_rsrc_data_free(ctx->file_data);
+		ctx->file_data = NULL;
+		return -ENOMEM;
+	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
+		struct io_fixed_file *file_slot;
+
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
-			goto out_fput;
+			goto fail;
 		}
 		/* allow sparse sets */
 		if (fd == -1) {
 			ret = -EINVAL;
 			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
-				goto out_fput;
+				goto fail;
 			continue;
 		}
 
 		file = fget(fd);
 		ret = -EBADF;
 		if (unlikely(!file))
-			goto out_fput;
+			goto fail;
 
 		/*
 		 * Don't allow io_uring instances to be registered. If UNIX
@@ -8868,30 +8833,22 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		 */
 		if (file->f_op == &io_uring_fops) {
 			fput(file);
-			goto out_fput;
+			goto fail;
+		}
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		io_fixed_file_set(file_slot, file);
+		ret = io_sqe_file_register(ctx, file, i);
+		if (ret) {
+			file_slot->file_ptr = 0;
+			fput(file);
+			goto fail;
 		}
-		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
-	}
-
-	ret = io_sqe_files_scm(ctx);
-	if (ret) {
-		__io_sqe_files_unregister(ctx);
-		return ret;
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
-	return ret;
-out_fput:
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		file = io_file_from_index(ctx, i);
-		if (file)
-			fput(file);
-	}
-	io_free_file_tables(&ctx->file_table);
-	ctx->nr_user_files = 0;
-out_free:
-	io_rsrc_data_free(ctx->file_data);
-	ctx->file_data = NULL;
+	return 0;
+fail:
+	__io_sqe_files_unregister(ctx);
 	return ret;
 }
 
-- 
2.35.1


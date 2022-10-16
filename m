Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A860B600343
	for <lists+io-uring@lfdr.de>; Sun, 16 Oct 2022 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJPUdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 16:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJPUdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 16:33:06 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D76030F43
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:05 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bj12so20785120ejb.13
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYx2685bsWJJw39MW3yJCcH+2KP08OPq5xO0rYWVOLA=;
        b=THETVeKMXqOaA9K3j0TV7fM9xjDnZBu4C/ATYX6HMKAWd4D8k11Qb5aPIh+UjMwyXe
         RqHzi9Sim8DwrtEtUMe1nDq3hDTrFlPkrYkewT1JutHQxNN/YoBqk/xvN1HuizsBCeDO
         eKlVyJuwYhySLyBvbQjInF9HaqsHXq10vWI/J2KQE8q07KREj5uMSiw5nbKmF3TYHLfQ
         oedESvYfKsJRn1FSgyOe/weoLQYozb3uRVmJLmq5qYs8k9xPryBcZ+JMl4KcatqmQ0ob
         ta0o4px9pESBktI8GY/EePsECEJjCMchHI0IAKF3vv4KiNGpelZiswvKCok0gnreD6+C
         2ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYx2685bsWJJw39MW3yJCcH+2KP08OPq5xO0rYWVOLA=;
        b=YjH+cCeEtvbIlYEiFU1NLaVm0DKeMWf8Emvfx16/bWg5R8pUTwBx0UzVQYKw/3vCQq
         FYYlmQw5OVWA8hGIpU596d0mq6Khwl5wGV/Oh+qXvDXwWiXuTomzY5Op455d4lqBYsFm
         +DA6bPs5gCUS17M+t4hJij2egU4mUzxUcaK5ADLwH6loN62COUEX5/jn/ObBksBNpyLM
         2yIqJcH2bzkl+/cmpthZS1MR/vYAylY15Vj+3szHCtsDdnSJ9Mp+vA7eiLs0lw03yb6k
         xHC+6bbvCvC/SpO8dJdU21+FD4c9365NeFU2vrkPVb0Kt4lVcE7BgZZ2edWfPMu3P995
         fYGQ==
X-Gm-Message-State: ACrzQf1hS7AqnotMfF/LPIJzxc0ql6/I0MbKniQ8yhCBaAHFLl24xzKQ
        +qjNlgqPoXwy6D3u+Lxkrl+CC7vkaG8=
X-Google-Smtp-Source: AMsMyM62cRKVGerlVRLxgNeBCsANZyULs2Z09Cq11yIJfzGQxwjGFfE5PS9N22XRQSE8E3vruuRV8Q==
X-Received: by 2002:a17:907:d22:b0:78e:2788:51ae with SMTP id gn34-20020a1709070d2200b0078e278851aemr6038480ejc.689.1665952383271;
        Sun, 16 Oct 2022 13:33:03 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00788c622fa2csm5069345ejf.135.2022.10.16.13.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:33:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: remove FFS_SCM
Date:   Sun, 16 Oct 2022 21:30:48 +0100
Message-Id: <984226a1045adf42dc35d8bd7fb5a8bbfa472ce1.1665891182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665891182.git.asml.silence@gmail.com>
References: <cover.1665891182.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

scm'ed files lifetime is bound to ring_sock, which is destroyed strictly
after we're done with registered file tables, so no need for the FFS_SCM
hack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.h | 15 +--------------
 io_uring/io_uring.c  |  2 --
 io_uring/rsrc.c      |  7 ++-----
 io_uring/rsrc.h      |  4 ----
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index ff3a712e11bf..19d2aed66c72 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -5,22 +5,9 @@
 #include <linux/file.h>
 #include <linux/io_uring_types.h>
 
-/*
- * FFS_SCM is only available on 64-bit archs, for 32-bit we just define it as 0
- * and define IO_URING_SCM_ALL. For this case, we use SCM for all files as we
- * can't safely always dereference the file when the task has exited and ring
- * cleanup is done. If a file is tracked and part of SCM, then unix gc on
- * process exit may reap it before __io_sqe_files_unregister() is run.
- */
 #define FFS_NOWAIT		0x1UL
 #define FFS_ISREG		0x2UL
-#if defined(CONFIG_64BIT)
-#define FFS_SCM			0x4UL
-#else
-#define IO_URING_SCM_ALL
-#define FFS_SCM			0x0UL
-#endif
-#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG|FFS_SCM)
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
 
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
 void io_free_file_tables(struct io_file_table *table);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index de08d9902b30..18aa39709fae 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1587,8 +1587,6 @@ unsigned int io_file_get_flags(struct file *file)
 		res |= FFS_ISREG;
 	if (__io_file_supports_nowait(file, mode))
 		res |= FFS_NOWAIT;
-	if (io_file_need_scm(file))
-		res |= FFS_SCM;
 	return res;
 }
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 012fdb04ec23..55d4ab96fb92 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -757,20 +757,17 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 
 void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-#if !defined(IO_URING_SCM_ALL)
 	int i;
 
 	for (i = 0; i < ctx->nr_user_files; i++) {
 		struct file *file = io_file_from_index(&ctx->file_table, i);
 
-		if (!file)
-			continue;
-		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
+		/* skip scm accounted files, they'll be freed by ->ring_sock */
+		if (!file || io_file_need_scm(file))
 			continue;
 		io_file_bitmap_clear(&ctx->file_table, i);
 		fput(file);
 	}
-#endif
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9bce15665444..81445a477622 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -82,11 +82,7 @@ int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file);
 #if defined(CONFIG_UNIX)
 static inline bool io_file_need_scm(struct file *filp)
 {
-#if defined(IO_URING_SCM_ALL)
-	return true;
-#else
 	return !!unix_get_socket(filp);
-#endif
 }
 #else
 static inline bool io_file_need_scm(struct file *filp)
-- 
2.38.0


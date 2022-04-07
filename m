Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4DA4F7F49
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbiDGMmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245388AbiDGMmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0722B54BC5
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c7so7749892wrd.0
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xS0iZ6Ra27lVGcqAHuscO5xZGlNfz9cYa0P32K+cI5M=;
        b=jmAGTPUp6NFwNtYkfE0XaHQM3wP1pgfEBz1ueDjQsHAc1xjNmk9XZiBLvrXZkZh5a0
         FDJYHpyrlH87OrijKE747p/A4loovDkb6kVI3jOCoy8GGEMLkI6s5L6NbvdDo/T6yYyt
         +8f4vHPcUJGd48F0FJEOq25gwL8bl81QUFyB9E2yr3ZtGqljVxm6SXoFguoBnAu4cUw3
         Yq/4WOd68flCcJVuJOSzJAdJqY58Qaq3iPHDd21S1/Ay0vcZxQciACe45bzevqLfk7xb
         A3WsamtUuxyjAxtmTPVENpiRk0KMdstrcak+QeeOPcMhE5N6p0iHQXYo2/cvcrH68wWX
         4vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xS0iZ6Ra27lVGcqAHuscO5xZGlNfz9cYa0P32K+cI5M=;
        b=1uiqdx+euUakoIOMlDdmabnNnbuuP6vfVYONdW0bbrt5f8dEtcC6uXnfl/k3gltyql
         TfQixp5MG+S01guRGLn/n86ZPN0tN/BzRuV9oY8G/6OysF4+qRY4V261Ih8aIhG6Z+58
         ApH02nRh7DR9cozz2nJ2tp1D+c1EjB0BpYPxKS0/gT6zasw8AP5DSjMlCohxhAwDMAM3
         ICd6A6OnJLilx8YO7+SzWYy30OMEnLbx0zgG5Z5AC+U9b4pFJ03hc3NTlSyU/IjYLF5m
         K0hF8jVoloMAku8hVC0tOxZVJKB1rN6jEs/a1jV+4Iqnz6x2r3Fd+LmvCrrRYLb2Sd8v
         h/1w==
X-Gm-Message-State: AOAM532O09S+4/EpDvo8BTj1FJPTzx8WHgHTgf1VHYstO+Fao2O9GgjX
        MUzMu1OkUjh7JJ0QtXCWGPB0q1aZmDU=
X-Google-Smtp-Source: ABdhPJzTdebTCckea71KhoRyGV6qWhMBTeLIM0YHRRjq19XWlyostOgnq9xisPxM5aQvrL7kDXVCXA==
X-Received: by 2002:a5d:60c5:0:b0:203:f85a:2ea3 with SMTP id x5-20020a5d60c5000000b00203f85a2ea3mr11045355wrt.316.1649335246394;
        Thu, 07 Apr 2022 05:40:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring: deduplicate SCM accounting
Date:   Thu,  7 Apr 2022 13:40:04 +0100
Message-Id: <dddda3039c71fcbec24b3465cbe8c7e7ae7bb0e8.1649334991.git.asml.silence@gmail.com>
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

Merge io_sqe_file_register() and io_sqe_file_register(). The only
real difference left between them is from where we get an skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 107 +++++++++++++++++++-------------------------------
 1 file changed, 40 insertions(+), 67 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f90e1399b295..2545d0e9e239 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8589,7 +8589,6 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 	return sqd;
 }
 
-#if defined(CONFIG_UNIX)
 /*
  * Ensure the UNIX gc is aware of our file set, so we are certain that
  * the io_uring can be safely unregistered on process exit, even if we have
@@ -8597,38 +8596,59 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
  * files because otherwise they can't form a loop and so are not interesting
  * for GC.
  */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, struct file *file)
+static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file)
 {
+#if defined(CONFIG_UNIX)
 	struct sock *sk = ctx->ring_sock->sk;
+	struct sk_buff_head *head = &sk->sk_receive_queue;
 	struct scm_fp_list *fpl;
 	struct sk_buff *skb;
 
-	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
-	if (!fpl)
-		return -ENOMEM;
+	if (likely(!io_file_need_scm(file)))
+		return 0;
+
+	/*
+	 * See if we can merge this file into an existing skb SCM_RIGHTS
+	 * file set. If there's no room, fall back to allocating a new skb
+	 * and filling it in.
+	 */
+	spin_lock_irq(&head->lock);
+	skb = skb_peek(head);
+	if (skb && UNIXCB(skb).fp->count < SCM_MAX_FD)
+		__skb_unlink(skb, head);
+	else
+		skb = NULL;
+	spin_unlock_irq(&head->lock);
 
-	skb = alloc_skb(0, GFP_KERNEL);
 	if (!skb) {
-		kfree(fpl);
-		return -ENOMEM;
-	}
+		fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
+		if (!fpl)
+			return -ENOMEM;
 
-	skb->sk = sk;
+		skb = alloc_skb(0, GFP_KERNEL);
+		if (!skb) {
+			kfree(fpl);
+			return -ENOMEM;
+		}
 
-	fpl->user = get_uid(current_user());
-	fpl->fp[0] = get_file(file);
-	unix_inflight(fpl->user, file);
+		fpl->user = get_uid(current_user());
+		fpl->max = SCM_MAX_FD;
+		fpl->count = 0;
 
-	fpl->max = SCM_MAX_FD;
-	fpl->count = 1;
-	UNIXCB(skb).fp = fpl;
-	skb->destructor = unix_destruct_scm;
-	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-	skb_queue_head(&sk->sk_receive_queue, skb);
+		UNIXCB(skb).fp = fpl;
+		skb->sk = sk;
+		skb->destructor = unix_destruct_scm;
+		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
+	}
+
+	fpl = UNIXCB(skb).fp;
+	fpl->fp[fpl->count++] = get_file(file);
+	unix_inflight(fpl->user, file);
+	skb_queue_head(head, skb);
 	fput(file);
+#endif
 	return 0;
 }
-#endif
 
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
@@ -8748,8 +8768,6 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file);
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
@@ -8827,51 +8845,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file)
-{
-#if defined(CONFIG_UNIX)
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-
-	if (!io_file_need_scm(file))
-		return 0;
-
-	/*
-	 * See if we can merge this file into an existing skb SCM_RIGHTS
-	 * file set. If there's no room, fall back to allocating a new skb
-	 * and filling it in.
-	 */
-	spin_lock_irq(&head->lock);
-	skb = skb_peek(head);
-	if (skb) {
-		struct scm_fp_list *fpl = UNIXCB(skb).fp;
-
-		if (fpl->count < SCM_MAX_FD) {
-			__skb_unlink(skb, head);
-			spin_unlock_irq(&head->lock);
-			fpl->fp[fpl->count] = get_file(file);
-			unix_inflight(fpl->user, fpl->fp[fpl->count]);
-			fpl->count++;
-			spin_lock_irq(&head->lock);
-			__skb_queue_head(head, skb);
-		} else {
-			skb = NULL;
-		}
-	}
-	spin_unlock_irq(&head->lock);
-
-	if (skb) {
-		fput(file);
-		return 0;
-	}
-
-	return __io_sqe_files_scm(ctx, file);
-#else
-	return 0;
-#endif
-}
-
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
-- 
2.35.1


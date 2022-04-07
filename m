Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF64F7F46
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245331AbiDGMmx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245381AbiDGMmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:45 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE128E0C
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:45 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z1so7682317wrg.4
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOZO7W70b0lNVASaaHoHwDGmNiTzq7pmBWA6lAwShus=;
        b=dQk9WD14bc615LDFg/XmiuDY8rv3cOgN0TyGkyGFt+WVHnYcln/fx0eg9V0SkiFJf8
         PDZpb7Cl+XPMd+8kic2yQM1s/4/jxByd7rUG0aXMpuvEqE9eu6K2NpUgA7OthxP6+jDS
         f34I4wPf7P6kwvRGqzC5k/gRYKb6ObI7pLIq9VWpxKFkujFZspa3kx+TKxjjHkfWWCMv
         D0k9lE5MMPZH2XJ0UDPImSzKUngtiHNVBqgN8KqwaF5WFEo4R6LwRck/A9IFCSP+pzYo
         MhSbxGbIeO5a7ZuU+pzhX/Y1op2eweDzxrEe8M/Ep0TTA4JI6cacuCRrwJCT+v3SWzGr
         Wa9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOZO7W70b0lNVASaaHoHwDGmNiTzq7pmBWA6lAwShus=;
        b=RPC3fpqgOh25hNlhqxkuJctKME5oKW9U7No49DBSiF4nxlyiovJsBPb/Bt9K9yXDCM
         B852D2VlmGHorzp2Iyp2AiX7APx5vEiaXBgvKGLMKZQifLMhl0tcl/0LV933bQbDKYoz
         hyRRzuCBVyGv8+r+3XizQBd2BVngKXlRQGKyhD6qKWEN2ho08U4FOrDjBlrNAD7gB63V
         DuxBzwCqUrj5nkDP8kiGWfJHscw/33ijbj0TA3wH9AfELs/nRN9y9BW7Jwa0Vnh77sZL
         Iqh+5k1j8M44Rc4pYnbcIgCYYhMekNA13mDcHRVhdyAQkEY6NMKkyIXShRGz1Zz1p7XT
         9lfw==
X-Gm-Message-State: AOAM532jxJG8gqzDjBLeUAHHvvCfe6tGNgv6bXhN53Yis3mP9n8OV5cZ
        vVNJk+WKTeRgz7tx03Ffxlpz8Kr+CbQ=
X-Google-Smtp-Source: ABdhPJwI78qJ9P0vCN/K2m9v5+vU5iXof7L8KM3OJa8M/N4r6a5Np/yQLSc18kWY9dh5DeXJ4T2AIA==
X-Received: by 2002:a5d:528b:0:b0:203:d928:834c with SMTP id c11-20020a5d528b000000b00203d928834cmr11040637wrv.500.1649335243835;
        Thu, 07 Apr 2022 05:40:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring: refactor __io_sqe_files_scm
Date:   Thu,  7 Apr 2022 13:40:02 +0100
Message-Id: <66b492bc66dc8356d45d64076bb31d677d11a7c9.1649334991.git.asml.silence@gmail.com>
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

__io_sqe_files_scm() is now called only from one place passing a single
file, so nr argument can be killed and __io_sqe_files_scm() simplified.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 +++++++++++++-----------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6212a37eadc7..582f402441ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8597,12 +8597,12 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
  * files because otherwise they can't form a loop and so are not interesting
  * for GC.
  */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
+static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int offset)
 {
+	struct file *file = io_file_from_index(ctx, offset);
 	struct sock *sk = ctx->ring_sock->sk;
 	struct scm_fp_list *fpl;
 	struct sk_buff *skb;
-	int i, nr_files;
 
 	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
 	if (!fpl)
@@ -8616,39 +8616,17 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 
 	skb->sk = sk;
 
-	nr_files = 0;
 	fpl->user = get_uid(current_user());
-	for (i = 0; i < nr; i++) {
-		struct file *file = io_file_from_index(ctx, i + offset);
-
-		if (!file || !io_file_need_scm(file))
-			continue;
-
-		fpl->fp[nr_files] = get_file(file);
-		unix_inflight(fpl->user, fpl->fp[nr_files]);
-		nr_files++;
-	}
-
-	if (nr_files) {
-		fpl->max = SCM_MAX_FD;
-		fpl->count = nr_files;
-		UNIXCB(skb).fp = fpl;
-		skb->destructor = unix_destruct_scm;
-		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-		skb_queue_head(&sk->sk_receive_queue, skb);
-
-		for (i = 0; i < nr; i++) {
-			struct file *file = io_file_from_index(ctx, i + offset);
-
-			if (file && io_file_need_scm(file))
-				fput(file);
-		}
-	} else {
-		kfree_skb(skb);
-		free_uid(fpl->user);
-		kfree(fpl);
-	}
-
+	fpl->fp[0] = get_file(file);
+	unix_inflight(fpl->user, file);
+
+	fpl->max = SCM_MAX_FD;
+	fpl->count = 1;
+	UNIXCB(skb).fp = fpl;
+	skb->destructor = unix_destruct_scm;
+	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
+	skb_queue_head(&sk->sk_receive_queue, skb);
+	fput(file);
 	return 0;
 }
 #endif
@@ -8892,7 +8870,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 		return 0;
 	}
 
-	return __io_sqe_files_scm(ctx, 1, index);
+	return __io_sqe_files_scm(ctx, index);
 #else
 	return 0;
 #endif
-- 
2.35.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E745E4F7F4C
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiDGMmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245383AbiDGMmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:46 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F262BD8
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:46 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r13so7649148wrr.9
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53nAUnhZmQT4gr01s5DInDaVWfl1bEvle65MwhCWZeQ=;
        b=DIlU1xCSBY4C7f1p9t4kWBDCi5WQueu6DrVASiHcBGx+Ws5kNujWd4trMw+rNvLln6
         eF0YftbjcJToLjq1sYLzoQJX29lPfnih4xKFRcOe/prYSocoZ4jMnnRTWNKx14dhQ757
         dinuHw55kvghIkEBmw/auZjEec/L80mzTH8vPqDSwtp1Uxas2QTYZx2KCX68sxaDqaxV
         BmTa9v43+E708WUv4qjd7LQPmvxqCKYgF/CCLV4F8sK5iGTaOSWaT7kUsskJwz/vqyHg
         CnE5Sg8imAJpzZqH/I/1VmtDVq7hoZea6bU2qUFy6uLlbO9yYxU//EycPhYL+DihSaMn
         HU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=53nAUnhZmQT4gr01s5DInDaVWfl1bEvle65MwhCWZeQ=;
        b=1oHlTPCfvgRajX24KyRj7I1wQxxlHzJI/DnVRR1gvjw3/UF4oV44P7jX0qLocL7Aec
         fdvE31aUDIVbCwYexq4EWgGxm2aff97gehFvp2w14bRW3PwlsVGtCbfaTO4i0+QrjdRP
         EF0+suM97PW7/hl9lcPFnOYUStgkmLIAuyICYqgq6rAvZVQUG6okB0OHukWd7V+O3O7d
         8ybbSKcSrka8LotgMdTLAWLktwLJH6PhJ5GMJ1ZGD7qgQPzx+R3vJGuVmk9kPxRw82aY
         z+/k5wfA919rnaiRbhoyPj3b3gaDUuO9ERcBjAjHxN7X2hd5QZ0E6blyYys+mDo5JR48
         XR0g==
X-Gm-Message-State: AOAM5332enEZh5kn+AMpsnzNkcZWRnuyq2TxPWdYIsygttMXsGJjA7M6
        Z3PPxd3106nGApX37mjq6/SE1ldLN4o=
X-Google-Smtp-Source: ABdhPJydZ1Szl56sNdmOK6Q88/7ALqbtMWbbZdjSwWlyvrWHdfQAyER9FpvN7kMC0RJj39GCS6lggA==
X-Received: by 2002:a5d:5949:0:b0:206:1482:1b8c with SMTP id e9-20020a5d5949000000b0020614821b8cmr10572401wri.365.1649335244989;
        Thu, 07 Apr 2022 05:40:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: don't pass around fixed index for scm
Date:   Thu,  7 Apr 2022 13:40:03 +0100
Message-Id: <fb32031d892e61a7748c70da7999725d5e798671.1649334991.git.asml.silence@gmail.com>
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

There is an old API nuisance where io_uring's SCM accounting functions
traverse fixed file tables and so requires them to be set in advance,
which leads to some implicit rules of how io_sqe_file_register() should
be used.

__io_sqe_files_scm() now works with only one file at a time, pass a file
directly and get rid of all fixed table dereferencing inside. Clean
io_sqe_file_register() callers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 582f402441ae..f90e1399b295 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8597,9 +8597,8 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
  * files because otherwise they can't form a loop and so are not interesting
  * for GC.
  */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int offset)
+static int __io_sqe_files_scm(struct io_ring_ctx *ctx, struct file *file)
 {
-	struct file *file = io_file_from_index(ctx, offset);
 	struct sock *sk = ctx->ring_sock->sk;
 	struct scm_fp_list *fpl;
 	struct sk_buff *skb;
@@ -8749,8 +8748,7 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
-				int index);
+static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file);
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
@@ -8813,14 +8811,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto fail;
 		}
-		file_slot = io_fixed_file_slot(&ctx->file_table, i);
-		io_fixed_file_set(file_slot, file);
-		ret = io_sqe_file_register(ctx, file, i);
+		ret = io_sqe_file_register(ctx, file);
 		if (ret) {
-			file_slot->file_ptr = 0;
 			fput(file);
 			goto fail;
 		}
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+		io_fixed_file_set(file_slot, file);
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
@@ -8830,8 +8827,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
-				int index)
+static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file)
 {
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
@@ -8870,7 +8866,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 		return 0;
 	}
 
-	return __io_sqe_files_scm(ctx, index);
+	return __io_sqe_files_scm(ctx, file);
 #else
 	return 0;
 #endif
@@ -8928,15 +8924,11 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 		needs_switch = true;
 	}
 
-	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
-	io_fixed_file_set(file_slot, file);
-	ret = io_sqe_file_register(ctx, file, slot_index);
-	if (ret) {
-		file_slot->file_ptr = 0;
-		goto err;
+	ret = io_sqe_file_register(ctx, file);
+	if (!ret) {
+		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
+		io_fixed_file_set(file_slot, file);
 	}
-
-	ret = 0;
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
@@ -9048,14 +9040,13 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*io_get_tag_slot(data, i) = tag;
-			io_fixed_file_set(file_slot, file);
-			err = io_sqe_file_register(ctx, file, i);
+			err = io_sqe_file_register(ctx, file);
 			if (err) {
-				file_slot->file_ptr = 0;
 				fput(file);
 				break;
 			}
+			*io_get_tag_slot(data, i) = tag;
+			io_fixed_file_set(file_slot, file);
 		}
 	}
 
-- 
2.35.1


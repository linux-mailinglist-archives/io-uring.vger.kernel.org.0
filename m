Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D04F6CB2
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 23:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiDFVbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 17:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiDFVbE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 17:31:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE7216FB3
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 13:34:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r13so4908671wrr.9
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 13:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q77BaAR9yUBtg43FTuAPRwXtFcLqvHQk5ZYB37v9gNE=;
        b=ACI5lvoq0SUPPnu8hTANCgvOXO+wuEmm/bPIAvhKxpIGBSShrRjPcrFIxKaK/d7NUy
         ZixiZ76Y0FeFhM7h0PiylMWvqTG/HeOneYgZuaaRP5z9P3xQP8PYUsAd0XC0cwLfGnWg
         9tH+jk28hWts0yzc5hfQvIgFODFKtm0m9KIUbEXpXJ8x1cpK5YBwezc0p5/NsohnPf1s
         is3AYBnhLbjdMTtuXBa4nBoCnhSWtT5APOLtFjHHvDS79Xw0NlbEblYxGDL8c9RAcfRO
         PM4fbk3t7Qk/peeudm7cL4HdHcmh+5cNeiBdr3Spa742gdPFixa8cV0ewT7YTkkHNzln
         M+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q77BaAR9yUBtg43FTuAPRwXtFcLqvHQk5ZYB37v9gNE=;
        b=8BK9UCUjW2hwGQdK+2tD0H09b4UOcRm8X8L3mNQN7Djq0QN0rgZ/4+uqF7G4axclOQ
         WjzJN0IHt6GParUvmsvzQx1Bj4r/dL1PQk+H789FzwnlJwpTHI6A/4TwzceB/r0ZDnPQ
         1ipCI0Ozo8ZggntISzfdRP0lG8DTaIXMaaiHH6Z6tfhf2iYmosUxb0H5oJWccemSAVsF
         z/0g1giZW3PHyntWWHoHmF5FmbVoSJXXsXHVEljvDK/YTCBDTJvTzTVfXkRVN1fEhcCZ
         iDDFDjLB9ZvppDfIbMrzcykJqLzITB188PgUr5d664EPYHbWdoA2rDRS7F68Jc04VxZC
         rqYg==
X-Gm-Message-State: AOAM531owAy2ll8RVY9Re77wng/stgpaedf/Fe5Di/MzXq1eguQbjDQV
        LLbSqryEJiIqLiaaEu9wnxAUtf3kzsY=
X-Google-Smtp-Source: ABdhPJw5+IyuXUyJ512kV6z57YchZ2jDz1oeaLoKxBKpd/Hw6xQgH8gcoISe4DVZTfRe3atuVNt71A==
X-Received: by 2002:adf:e583:0:b0:206:859:f816 with SMTP id l3-20020adfe583000000b002060859f816mr8103175wrm.429.1649277275607;
        Wed, 06 Apr 2022 13:34:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.65])
        by smtp.gmail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm8266446wml.5.2022.04.06.13.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:34:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: don't scm-account for non af_unix sockets
Date:   Wed,  6 Apr 2022 21:33:56 +0100
Message-Id: <9c44ecf6e89d69130a8c4360cce2183ffc5ddd6f.1649277098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

io_uring deals with file reference loops by registering all fixed files
in the SCM/GC infrastrucure. However, only a small subset of all file
types can keep long-term references to other files and those that don't
are not interesting for the garbage collector as they can't be in a
reference loop. They neither can be directly recycled by GC nor affect
loop searching.

Let's skip io_uring SCM accounting for loop-less files, i.e. all but
af_unix sockets, quite imroving fixed file updates performance and
greatly helpnig with memory footprint.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4c85d85f88d..be178694e8db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1211,6 +1211,18 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+#if defined(CONFIG_UNIX)
+static inline bool io_file_need_scm(struct file *filp)
+{
+	return !!unix_get_socket(filp);
+}
+#else
+static inline bool io_file_need_scm(struct file *filp)
+{
+	return 0;
+}
+#endif
+
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
@@ -8424,6 +8436,17 @@ static void io_free_file_tables(struct io_file_table *table)
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	int i;
+
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct file *file = io_file_from_index(ctx, i);
+
+		if (!file || io_file_need_scm(file))
+			continue;
+		io_fixed_file_slot(&ctx->file_table, i)->file_ptr = 0;
+		fput(file);
+	}
+
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
 		struct sock *sock = ctx->ring_sock->sk;
@@ -8432,16 +8455,6 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
 			kfree_skb(skb);
 	}
-#else
-	int i;
-
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct file *file;
-
-		file = io_file_from_index(ctx, i);
-		if (file)
-			fput(file);
-	}
 #endif
 	io_free_file_tables(&ctx->file_table);
 	io_rsrc_data_free(ctx->file_data);
@@ -8590,7 +8603,9 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 /*
  * Ensure the UNIX gc is aware of our file set, so we are certain that
  * the io_uring can be safely unregistered on process exit, even if we have
- * loops in the file referencing.
+ * loops in the file referencing. We account only files that can hold other
+ * files because otherwise they can't form a loop and so are not interesting
+ * for GC.
  */
 static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 {
@@ -8616,8 +8631,9 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	for (i = 0; i < nr; i++) {
 		struct file *file = io_file_from_index(ctx, i + offset);
 
-		if (!file)
+		if (!file || !io_file_need_scm(file))
 			continue;
+
 		fpl->fp[nr_files] = get_file(file);
 		unix_inflight(fpl->user, fpl->fp[nr_files]);
 		nr_files++;
@@ -8634,7 +8650,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 		for (i = 0; i < nr; i++) {
 			struct file *file = io_file_from_index(ctx, i + offset);
 
-			if (file)
+			if (file && io_file_need_scm(file))
 				fput(file);
 		}
 	} else {
@@ -8676,6 +8692,7 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 
 		if (file)
 			fput(file);
+		io_fixed_file_slot(&ctx->file_table, total)->file_ptr = 0;
 		total++;
 	}
 
@@ -8697,6 +8714,11 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 	struct sk_buff *skb;
 	int i;
 
+	if (!io_file_need_scm(file)) {
+		fput(file);
+		return;
+	}
+
 	__skb_queue_head_init(&list);
 
 	/*
@@ -8889,6 +8911,9 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 	struct sk_buff_head *head = &sock->sk_receive_queue;
 	struct sk_buff *skb;
 
+	if (!io_file_need_scm(file))
+		return 0;
+
 	/*
 	 * See if we can merge this file into an existing skb SCM_RIGHTS
 	 * file set. If there's no room, fall back to allocating a new skb
-- 
2.35.1


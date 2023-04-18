Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBED46E655F
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDRNHY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjDRNHW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E61610F3
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dx24so28989662ejb.11
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823229; x=1684415229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0MsgxYB2Iq02trpPOl6BLs1BfzN5XDlIYa0nDp5ATM=;
        b=kph1pFazWK+8vqScP2gDYKDJPWdAdUWsK+5iHZ+Trk3HMVDMPbLYYQdbifizChPzVC
         1EdTBkEvXnUS/mNI+vqH9zup0/y/164WGVcQAyIlCswhs44SSMqV0R6EQlqlHNiUzsJF
         rKHU79jtliBCa5CkvY8vmKxDH8rjJij97+jxsQJP1+0HNbuTw+YhYVP3toLipjqSFXJE
         IAkL7AijqODjfu3BxV7C1oduGRk8c5rnP2wM1N9EEcLkyTxve9iaw/wVnr6CuZS+ayje
         m5rxZkbOQkA+NnJq+8+/gc7QhpOu7gmrj207CdEx1iFLtPsLKlwzs7to+Vp7Z6JTagdg
         WafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823229; x=1684415229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P0MsgxYB2Iq02trpPOl6BLs1BfzN5XDlIYa0nDp5ATM=;
        b=EFE393JCb1EBRqqU8YBjMjrx0NrH940MP2CX5vl2wGBrv22vf1TU+7HXazNByBl/QX
         AOChJs6/8nA1kPZLTQeNk/LsfwZfXxjmuLkwDt/4IFQFgRf95NyiWKrRBJnau/rY0S1A
         +e/isBKPRcOPbApoee6qlfwI2RmFVlOZjO5FcL/ES6BqkyQko0A4BPOV+CNeEUiLaRGm
         BmB+qlz5FHUoKgJn0hRo8x/M4xMGnPPfGaOuVRhJYma7XJjfwcjnvMJI8GZCsKlNYnSP
         x7C/Rcbzot/C59/qtshFEn3wU5UR5nyr4UpH7dd7HFJUg+0d1v/eCl+hFQ+v4i15Gt97
         VArA==
X-Gm-Message-State: AAQBX9fEsWRx/twXxr13sHHwdRUDV/LWNlmQBhjXo2TFO9dwaNa0oDzf
        4n8qzPu/4dwKMGFfG36WQ1+xaHDis/o=
X-Google-Smtp-Source: AKy350b9004eSvx1/6n78uTSPUUQdlIjLrOuTCc+ePnJxG5NpBihmVLwRxSEdu37uRfPrc78HVKlNg==
X-Received: by 2002:a17:906:4f02:b0:94e:f9b:66e7 with SMTP id t2-20020a1709064f0200b0094e0f9b66e7mr10514308eju.13.1681823229197;
        Tue, 18 Apr 2023 06:07:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/8] io_uring/rsrc: infer node from ctx on io_queue_rsrc_removal
Date:   Tue, 18 Apr 2023 14:06:35 +0100
Message-Id: <d15939b4afea730978b4925685c2577538b823bb.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
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

For io_queue_rsrc_removal() we should always use the current active rsrc
node, don't pass it directly but let the function grab it from the
context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.c | 5 ++---
 io_uring/rsrc.c      | 9 +++++----
 io_uring/rsrc.h      | 3 +--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 6255fa255ae2..367a44a6c8c5 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -85,8 +85,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 			return ret;
 
 		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
-					    ctx->rsrc_node, old_file);
+		ret = io_queue_rsrc_removal(ctx->file_data, slot_index, old_file);
 		if (ret)
 			return ret;
 
@@ -163,7 +162,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 		return -EBADF;
 
 	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	ret = io_queue_rsrc_removal(ctx->file_data, offset, file);
 	if (ret)
 		return ret;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index db58a51d19da..3be483de613e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -409,7 +409,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, i, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -492,7 +492,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
 			err = io_queue_rsrc_removal(ctx->buf_data, i,
-						    ctx->rsrc_node, ctx->user_bufs[i]);
+						    ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
 				break;
@@ -680,9 +680,10 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
-			  struct io_rsrc_node *node, void *rsrc)
+int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc)
 {
+	struct io_ring_ctx *ctx = data->ctx;
+	struct io_rsrc_node *node = ctx->rsrc_node;
 	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 525905a30a55..8ed3e6a65cf6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -70,8 +70,7 @@ void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 int __io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
-			  struct io_rsrc_node *node, void *rsrc);
+int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc);
 void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill);
 
-- 
2.40.0


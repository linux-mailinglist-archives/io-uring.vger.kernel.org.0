Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129726E6565
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDRNH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424EB86BA
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ud9so72809831ejc.7
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823231; x=1684415231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KE9dqChOXKEnacrEqCkS5RH4b0y+phq2HjIj9BZdycA=;
        b=GdEQUdjhdWzRDdfsIqJGsdC0kNd8uz1doofnL4SNF/zNB9jtlaW8+7POmZAG9zsFr+
         w5F964GvMSvPTECHAnwN4QEttp33ryuJ7k1JPJzOBlmMHoPWEJqmtDh0/JLyTGLuc3vb
         F1XxHB8nkvddIzKm9iSOFJPqnlDiQiEfVJKs4rf00zRByCXNPbyAlt50/QdT1hjKiiXp
         KU2xqINi6fEGt1owGsRfpazGxvcAt0g24WanGYpHHyCdF+dzE+/5TTxGjbmsrSQpmHV4
         lvmjYtOJ/wMrnn8JtbgXkd8aoN2or5P3xQzfmT5P9u/dAU2Bg4lnLLJR+6QH/pNpA+wd
         UJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823231; x=1684415231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KE9dqChOXKEnacrEqCkS5RH4b0y+phq2HjIj9BZdycA=;
        b=CAGBvUkxIkQ8SiyxKxaScjEV5jB9dMx7xTo3jz9Pgrr/4KH5U0pNOKLSZrJdMx09u5
         FkbY5rqzv7VBxexpYyw4syXvdwQOUiuOTv7A7HW2dFk9FFmS1Ym4JyXxBXdFFPfzuCEw
         BCyGdK9FKQTEsiFrDNSjErTOyh3iFA/IBaRt5RgLEtBaxo6iqZsvonlK0Or/XWgpFGM9
         45UaSYu5zcqBgfhIzgQEoUC7R3TH3BpRciPyfHUvHtUWE0iL8amCvF47k1QHFcpr8+sG
         4oEyEvaTJVx8KiUzD78Z7UxDbbPq7xLJC15C+JHjvFGR5f9vYWix+1QL6E8XbpLE7wID
         dUfA==
X-Gm-Message-State: AAQBX9eatd2dtwYVYEbQiOj69SRelXXbaBrSFCeQ1cyRBi6howeygNiS
        FZ0yXoXMDUPqOkvZDF+6TwAFCohMI8w=
X-Google-Smtp-Source: AKy350abMe9TdjUVSYtx5BDjQJxi/RvgO7clXbhO9P4PDxx8CfUQZbzy4qNZgLnCFIUFiHJ6zERYNQ==
X-Received: by 2002:a17:906:a0d0:b0:94f:1a11:df56 with SMTP id bh16-20020a170906a0d000b0094f1a11df56mr9457830ejb.35.1681823231629;
        Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/8] io_uring/rsrc: devirtualise rsrc put callbacks
Date:   Tue, 18 Apr 2023 14:06:40 +0100
Message-Id: <02ca727bf8e5f7f820c2f404e95ae88c8f472930.1681822823.git.asml.silence@gmail.com>
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

We only have two rsrc types, buffers and files, replace virtual
callbacks for putting resources down with a switch..case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 25 +++++++++++++++++++------
 io_uring/rsrc.h |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9378691d49f5..62988b3aa927 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -23,6 +23,8 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
+static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
+static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage);
@@ -147,7 +149,18 @@ static void io_rsrc_put_work(struct io_rsrc_node *node)
 
 	if (prsrc->tag)
 		io_post_aux_cqe(data->ctx, prsrc->tag, 0, 0);
-	data->do_put(data->ctx, prsrc);
+
+	switch (data->rsrc_type) {
+	case IORING_RSRC_FILE:
+		io_rsrc_file_put(data->ctx, prsrc);
+		break;
+	case IORING_RSRC_BUFFER:
+		io_rsrc_buf_put(data->ctx, prsrc);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 }
 
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
@@ -297,8 +310,8 @@ static __cold void **io_alloc_page_table(size_t size)
 	return table;
 }
 
-__cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
-				     rsrc_put_fn *do_put, u64 __user *utags,
+__cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, int type,
+				     u64 __user *utags,
 				     unsigned nr, struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
@@ -316,7 +329,7 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 
 	data->nr = nr;
 	data->ctx = ctx;
-	data->do_put = do_put;
+	data->rsrc_type = type;
 	if (utags) {
 		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
@@ -849,7 +862,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
-	ret = io_rsrc_data_alloc(ctx, io_rsrc_file_put, tags, nr_args,
+	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_FILE, tags, nr_args,
 				 &ctx->file_data);
 	if (ret)
 		return ret;
@@ -1184,7 +1197,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
-	ret = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, tags, nr_args, &data);
+	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, tags, nr_args, &data);
 	if (ret)
 		return ret;
 	ret = io_buffers_map_alloc(ctx, nr_args);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 232079363f6a..5d0733c4c08d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -33,7 +33,7 @@ struct io_rsrc_data {
 
 	u64				**tags;
 	unsigned int			nr;
-	rsrc_put_fn			*do_put;
+	u16				rsrc_type;
 	bool				quiesce;
 };
 
-- 
2.40.0


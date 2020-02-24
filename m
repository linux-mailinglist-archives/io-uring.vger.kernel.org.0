Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9FD169C72
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 03:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgBXC4P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 21:56:15 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39626 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgBXC4P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 21:56:15 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so3436638plp.6
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 18:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bZWs3g4ivEodh6WFzH0c3kjRxR1SL/AnXUni3U5yJrc=;
        b=bdFFKaI6f+wvppivcMV6PvmU1zDFDe4lZOHPzgAnquRq/MFUNw/jk2+CTGKnTzxzPR
         ltVo8qY49FpCygD5KRAWJrTAFJSFJ7MvGXY+3mifa5ZM79pZNo8krv6CeFPmKhiep9rb
         VFyEhvivz3RIf/b8HIVTAFX/BNbc/Id+8jBO984BW8ktTJStOWEJLE5o8yfsv5vwGZiW
         ujE84gROhK7EZHlwitbZJSnDu46kb6m2R8copupeRNgzs0aTjbegM28izdrEvog3QhpV
         L1pi/aaDEAxo5MQcSvFXEIwmdaTiEb8jakVnHVe0lQHyMIWoP9NXfI+Rb+j+Srm09kIh
         7ahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZWs3g4ivEodh6WFzH0c3kjRxR1SL/AnXUni3U5yJrc=;
        b=SJ1qcVgnD1IgcG2sRwACUJfgNz3kl/ap8ohF3tSQbfkEwVX9qPKEm0iISQ9DE29QuN
         FHEfArfJDND+NWHVOHv9qjbiebkBFCSZylV2XRhUUArevZaRLh5R5+HPHrhxkM6WdSwM
         b8MKD7Q2ahxboPHq32MglyE0RHuZfTa6H3dho6Qv/OGYk/Dwq3s/kSgG3hiWYIrWWmB7
         UuqMY+Rk60seXddv/1G6Ws2p2yqkD1xycteH5V8VjYq2113XzO7hJQVJg5Og4FLKaKC8
         KDnGsPqqyUg3JAjRmjuvsexFjGih4CJBXwL7lRjwGGeVpko8+f6xPoHLi+Qz6UtNxnF1
         uOiA==
X-Gm-Message-State: APjAAAWfhG+TcIpXcWU4ILChcGWK7q03buuJV64slK/rYJTy5gO7UNao
        tE4SBzTAAQ32GmJd2A868TwwBCLSugI=
X-Google-Smtp-Source: APXvYqw6FnXMX3SdP228YT3RpNa8XfH8uTQJC5BRZkexIPxgMlruLJe/hHz67AWOqJDgSPeuKCsc1w==
X-Received: by 2002:a17:902:864a:: with SMTP id y10mr48399222plt.2.1582512973056;
        Sun, 23 Feb 2020 18:56:13 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z5sm10859169pfq.3.2020.02.23.18.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 18:56:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: buffer registration infrastructure
Date:   Sun, 23 Feb 2020 19:56:05 -0700
Message-Id: <20200224025607.22244-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224025607.22244-1-axboe@kernel.dk>
References: <20200224025607.22244-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This just prepares the ring for having lists of buffers associated with
it, that the application can provide for SQEs to consume instead of
providing their own.

The buffers are organized by group ID.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 945547a5e792..98b0e9552ef2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -199,6 +199,13 @@ struct fixed_file_data {
 	struct completion		done;
 };
 
+struct io_buffer {
+	struct list_head list;
+	__u64 addr;
+	__s32 len;
+	__u16 bid;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -276,6 +283,8 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
+	struct idr		io_buffer_idr;
+
 	struct idr		personality_idr;
 
 	struct {
@@ -863,6 +872,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->completions[0]);
 	init_completion(&ctx->completions[1]);
+	idr_init(&ctx->io_buffer_idr);
 	idr_init(&ctx->personality_idr);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -6447,6 +6457,28 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
+static int __io_destroy_buffers(int id, void *p, void *data)
+{
+	struct io_ring_ctx *ctx = data;
+	struct list_head *buf_list = p;
+	struct io_buffer *buf;
+
+	while (!list_empty(buf_list)) {
+		buf = list_first_entry(buf_list, struct io_buffer, list);
+		list_del(&buf->list);
+		kfree(buf);
+	}
+	idr_remove(&ctx->io_buffer_idr, id);
+	kfree(buf_list);
+	return 0;
+}
+
+static void io_destroy_buffers(struct io_ring_ctx *ctx)
+{
+	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
+	idr_destroy(&ctx->io_buffer_idr);
+}
+
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
@@ -6457,6 +6489,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
+	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
-- 
2.25.1


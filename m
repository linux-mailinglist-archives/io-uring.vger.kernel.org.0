Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC916EB37
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgBYQVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:21:03 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:42987 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgBYQVC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:21:02 -0500
Received: by mail-il1-f195.google.com with SMTP id x2so1823578ila.9
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=NcMuyouzR6x6lZsnGgM+94xVVqfXP4ZXsa+cefmT7nat9qnDaBE9GaiWn5wey0nQvy
         qIuslcFccCtVDef1oqegFP/o1b98bb+W+vGtwc1mgVIl29OBKNbAMy6bn9SBunr9K2qn
         eXi/yERNybbbF7YWqtzNqphf2LbA+TScTTAB1ouaj0fz6VVZGCOSr4TOQdA8zjvokHe8
         gArDgzmxrhtWDRf4j2h4d3+qEdsUvWGNcWGYjTl60NrrYdP64R2aqXB1Yed6rf03Nt1v
         ykpCNu8f6cL15iyEcosSrliA4otYz5MM1lR+D5xDaR7a+Y6MQ1udcHAccUQcNFnMR2TM
         63lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=OqlRy4X0opIIu3jcAOaOkFSgvGIy0azka52RePV6AS/ybYIX2V0xYNgrLNFzvkRXOl
         IjH+s1EGGBXyr9mBQY3mkyHV/OFakcEo64xhn1IoglffGox1Nnro88NMm5cqP7uRoaV4
         Jfjb/57YzljFHd6eJAIRJCUOOeXj9k6S6nRV/y2ka0bpLQTGLPhQTpih+fAadFbDIXjJ
         RTXmwP/2d2e/TmZjSJgTN3LEtlm10+9CUyQSM5NLFk5woroQG5cMz76xSfdJwXsT0z95
         695yq0oD/3WOz7m3AaJMw5+Rk+v+hwbjyTTGbXvBm5O+r384nnkVDYK+U9Lz201nqziL
         Xchw==
X-Gm-Message-State: APjAAAUjZYC+PSC9yaF66wCVdg0usbVMUsjItaJR2yUXG1F86JdCQNRs
        e0Cj5aH0p807y0bN3ym/staFO5EbrVs=
X-Google-Smtp-Source: APXvYqwgWg+w8KMsu1kOHOlsR5OPpNsgT2PX633xZoEoPhwJ8bL1moaCXzmKPmdUDbkGY2h45PIRiQ==
X-Received: by 2002:a92:afcf:: with SMTP id v76mr67179898ill.20.1582647660404;
        Tue, 25 Feb 2020 08:21:00 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y19sm3842417ioc.78.2020.02.25.08.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:20:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: buffer registration infrastructure
Date:   Tue, 25 Feb 2020 09:20:55 -0700
Message-Id: <20200225162057.11800-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225162057.11800-1-axboe@kernel.dk>
References: <20200225162057.11800-1-axboe@kernel.dk>
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
index 040bdfc04874..d985da9252a2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -200,6 +200,13 @@ struct fixed_file_data {
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
@@ -277,6 +284,8 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
+	struct idr		io_buffer_idr;
+
 	struct idr		personality_idr;
 
 	struct {
@@ -880,6 +889,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->completions[0]);
 	init_completion(&ctx->completions[1]);
+	idr_init(&ctx->io_buffer_idr);
 	idr_init(&ctx->personality_idr);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -6570,6 +6580,28 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
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
@@ -6580,6 +6612,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
+	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
-- 
2.25.1


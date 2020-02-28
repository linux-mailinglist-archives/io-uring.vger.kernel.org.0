Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAD1740F0
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgB1Ua6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:30:58 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40999 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Ua6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:30:58 -0500
Received: by mail-io1-f65.google.com with SMTP id m25so4887985ioo.8
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eCNOJMqU9clXyAZPCdTVMgWbqmuBoGS11aNUmVEvlzQ=;
        b=y6aAKr+siHnEF58Lfh5GYBf040xIbRpwlquOKAaSI6f4gYGCqzUeBHEVoORnjUpuo+
         fdJ1EmyKH5h5bgkHp102AnFLx09Fyk0KHnwBY90ub5wRA/cFWdbiEf1r/xE26LRKnk2f
         ZpGvZNXrRa88yiN8k04hHty0yU+9FH97EZRxRt8SnRR8f7T/TnwWqrj1fsxCz3xXPjA3
         dj7qW8LEmTVJgK5O/QVYc3yFdFOvq96ocF+qY/ZyTDAApiKxscC+qJHxbYDanrK4I0Lb
         xKcTPpT7WYUAjJku/GXzyiYj+g1c7nLInJM4EYFH7JGqqTh5CWBhIq73MxuY2Hi0ebIu
         2HGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCNOJMqU9clXyAZPCdTVMgWbqmuBoGS11aNUmVEvlzQ=;
        b=Dd5FAb8HhD1Z2E/0gZzKIefPWfym1puG0rgbyfEabqVIgjEhcH68tgAB4I929Jm40m
         QGocQMDic86q/JWWwI+JzsLIbsgt++Mls4laLQqmQVWXKSY+kA7jtismCWUsqx6bff8c
         DbcBzgTeZRQZIHqUUurKEUgV3mIL0TkR3z8leuMUjYAo7B7OC4/NwRtJm4g2A6sgOjWY
         EQvQAu5MRWluw8d+h3brbrh5R5iQryxXdQjGR8z0eALhSFtaXnlyZvFJpG0Ap4qQM0iw
         awv9eNLRiH8RPXFm7Io+fKpXJr2TE4uigEiGSGsW7TTGeHss3ioJTGOMqtE/O/+yasUD
         iE9Q==
X-Gm-Message-State: APjAAAWpVNXB+q+FAeKAe4Y3x5Xtw0qQbVAWT6s/E587sInOUYS52Hk0
        E8+Ihubp961S+JF8ZSGjKqPTWBH/alY=
X-Google-Smtp-Source: APXvYqzFnAjploEHvyfdPuoB2OJbepfu/ulIfT23hX3+RTFWD1XEPrDohb4AfcJ10ig9dpvp6MVTRQ==
X-Received: by 2002:a02:9f06:: with SMTP id z6mr4663205jal.2.1582921857348;
        Fri, 28 Feb 2020 12:30:57 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:30:56 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: buffer registration infrastructure
Date:   Fri, 28 Feb 2020 13:30:48 -0700
Message-Id: <20200228203053.25023-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228203053.25023-1-axboe@kernel.dk>
References: <20200228203053.25023-1-axboe@kernel.dk>
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
index 8d8d93adb9c2..f6a0f07e35b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,6 +195,13 @@ struct fixed_file_data {
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
@@ -272,6 +279,8 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
+	struct idr		io_buffer_idr;
+
 	struct idr		personality_idr;
 
 	struct {
@@ -875,6 +884,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->completions[0]);
 	init_completion(&ctx->completions[1]);
+	idr_init(&ctx->io_buffer_idr);
 	idr_init(&ctx->personality_idr);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -6565,6 +6575,28 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
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
@@ -6575,6 +6607,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
+	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
-- 
2.25.1


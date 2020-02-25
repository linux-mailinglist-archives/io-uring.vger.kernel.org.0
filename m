Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86B816EB2A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgBYQTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:19:43 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34420 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQTn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:19:43 -0500
Received: by mail-il1-f194.google.com with SMTP id l4so2063233ilj.1
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=jGVGgjzOdPQiiRESxD68cCc4aO/4MJxkw/n5ad7Up0Yp5ouQouswqgNbs6gWjdOY9j
         daWatON/+clQYqLfX6XyICSxpaFIKgm8soAmojzz1UoAIm1zyV8dBU6rwoDe5TODmwlo
         WPNyD3Jnt5+AgcJABcJQAWjMCBQbfztEv2upLIB10N9GcJVlmELaJYnVS2ITQ/7EFoO0
         cICqYtGbm1EZHyX4gitGDwMfsqyPapsmxwu141ZR0c5tGKfpGHRUF3qHL7XPOsHUl5gi
         l1LPTupu6WpdvfZ1oB8YMXQWP/cBnUhp9SVow1EpkbdpCjwlcvSBOeH2jg5qsj3mQPby
         lpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=oH3mAY+Hp7bxXAUh9WeMxLAS+fbsAkHoWuFQ3wIvLhZVSDMZNApN9y+wzvkwJEUIuK
         qS2JAmd5RPGVRMlYuvupP/z1Rrv0ibU5DrWxOe4raLOD1SjALh7F0RHZhrJ4mWmqydpl
         lq7JJya8ID3K9POsrAShW9IGkFga7NPg5NXKFNV+bykS+Jx8BRajjfOhZnYW5R3MEGdf
         F0BAePSmuFgx2SfcdGCFGxW4zrOsBTudzxoWoF6gJz0Rlln7Rv4aVcYgl8bpTf8E9I+e
         ihC2nhGEYYTE1It4W/Oti22TRlCKde9bZLi6DhXJBUr7uSM+C3vToWPOpvOSX/J/6Bwa
         cglg==
X-Gm-Message-State: APjAAAUIgxRSh5kKZuKWwa0JTSQnxe8EZfe6+0P6BKd7plzNolsJRDWl
        84T6EZ92qtG+0Ww+BJlwYqO5/DevgPY=
X-Google-Smtp-Source: APXvYqx1m4HUjODpycFXYLGywE8DP7x/STH5qdXJ3dysGBs6N8FR/v8fSUp8GBKRyo01Flgt11S4Gg==
X-Received: by 2002:a92:8f91:: with SMTP id r17mr60506848ilk.97.1582647582581;
        Tue, 25 Feb 2020 08:19:42 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm5652204ilp.46.2020.02.25.08.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:19:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: buffer registration infrastructure
Date:   Tue, 25 Feb 2020 09:19:35 -0700
Message-Id: <20200225161938.11649-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225161938.11649-1-axboe@kernel.dk>
References: <20200225161938.11649-1-axboe@kernel.dk>
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


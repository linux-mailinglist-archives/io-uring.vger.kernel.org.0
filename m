Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9822516EACA
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgBYQE5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:04:57 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43894 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:04:57 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so14697497ioo.10
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=WV3vFu1PXJxOY33Wa7JkzAs7Ez6D7ac/kynu60cR72IMzNXsq/6yfA9ICD+LOJaqR7
         pueQXzAtrJHTX4gasqDec/jeTAwnulTXb3x7pzb/ZGNhnuTWpAqIC/jHB/tElgqb11f3
         co2xIABF0oQwzpqEJjv6VHk6U6fZHoIuTUQRQ2bK1CQSse+MBwYX38R7kZE8JfaRqK9V
         yzL+siITYHGQvO72fZSnu+h3G49QWnale8xSBjFErS1KWWdE/8JxsgYU26luZTINVgtI
         WW1CANu0op5mQqg95kCrut4BWPcN7RvgqeH2QPFZLal7++vSnjkArmWxb+4VT+gtHoyv
         bGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWrKuiYqCVkoc7PiSAV+HSYkWNAo7PkqAcL1rg8hSQo=;
        b=HypvPxHK+3ov4antbpwUdsXVBgEVa2u6b81s/E8axQ3n8eRANcf7tRhWh03MFc3rHM
         UhY/TFzyaW2OF4+lXQ3cXNxtJEShEjmr+c7hLs0DPRZZZa47GXAXdAXSRSGmrzO/Db6k
         aYbyQ3z+YwQwjZT1l0kX8hLyBhQ6IGmwVsHeoFpxsXQrRs2HN8jK7IY7e6G4P9CRWuwK
         9uHvXvfUfuBgKMcylHBrSJA3GHCX1x3TaAuuS89ISQ01bnSEkUbdyMZypkek2oRlzwXx
         ItTSc+LXUhQ+LEfktBYUIKTmiMsRTnfwmFSxxz8RN4bq4cUH3qHzu9kBmtlKVwxkii3Z
         Ipkg==
X-Gm-Message-State: APjAAAU/VAJw0SWnQPsLG+qFctqdWskyiOdp3BEhJmyGO94+Y1V7GPGm
        KgvFRqutRMgBM/Q2ulwydveAJ6PEVxY=
X-Google-Smtp-Source: APXvYqwTzYQri5gB/R/qAZk7VzpL/vbos4B+UeBi8KbsRHP6lLVFRd8Y2UNsvhYo22URR0JqmruMEg==
X-Received: by 2002:a02:cdcb:: with SMTP id m11mr60678071jap.125.1582646694724;
        Tue, 25 Feb 2020 08:04:54 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k23sm5628100ilg.83.2020.02.25.08.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:04:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: buffer registration infrastructure
Date:   Tue, 25 Feb 2020 09:04:49 -0700
Message-Id: <20200225160451.7198-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225160451.7198-1-axboe@kernel.dk>
References: <20200225160451.7198-1-axboe@kernel.dk>
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


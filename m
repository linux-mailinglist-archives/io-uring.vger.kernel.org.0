Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A17180112
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgCJPEj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:39 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:32875 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgCJPEi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:38 -0400
Received: by mail-il1-f194.google.com with SMTP id k29so7090533ilg.0
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l514IrcApzP58j83EjjHprocgNUYX0xcvH3LdD3Ambw=;
        b=I+nmKcUpnAIMRvdkAa9YyD0rzCcIQsdWT4/PESStcZJMica21yoWulR1eNq7VyU0Q2
         cE8ny9dkGzIVJFjNTdSwOB2srMoVqsqO4aSOCkajcxfuslS3kdpVwYeIkmmRKidiDzSt
         U5HRFVyyG4cvd2iVuGNamXg07V2OJhDyMT5WQKS74KvcAooBq16LaeOWl3QtfzlvT0Yv
         uxmB00LbfeA/75Ot6Yqw9io+JXbwsPOUW0nKByXrevUkBWIem9IOf/WqlYID1Bmn3zGV
         ZFSnAzbjY4uSvqXPxIbf5keu1s5QayL8RU3wFg0/Tv+PDLRL2/iShdqe+bRC/LUSXisF
         a/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l514IrcApzP58j83EjjHprocgNUYX0xcvH3LdD3Ambw=;
        b=Ft9Mrfk4BWjBstoeZ/z+jv5QPjeWzqGJ8svjIMvYvKduRWS0AYJ2wntTVEnfqBwxtp
         RtHh1q9l4zgiotGr+qcl8sGIyxYoLdlLWxqkK1uHXd87sjBrrZQUuQOAAwMvAOZJyv3y
         JC8sQo2odIcbGqot8bevEBhUWsqyEZ0GMDf0ifOrJW2yMPvN7OrVqhXA3s7mdH1RKdBi
         lejGaLbK9182+r2kvBgMgGxlfABGe1FVZyx/zCe8zY/yJ58IblSULKrOW+SKqqs9TB+6
         tza0RH+R0Roknhaxu4JDxBeNGoQH90kmEagMl1TTxVcClQM2G0UbDddq6lLfg50NJ0tD
         O32g==
X-Gm-Message-State: ANhLgQ2AtYO2HL9tlGa37sQbN9+677p27MnbF9Ud4scxmAOxIgBswib0
        8VVJ5IP8HgY18XycSTSGHiZwKRHmcbg25A==
X-Google-Smtp-Source: ADFU+vuZHNqk7H22Zq6S6BzK0JyYsvs7FqQ29vbL1lWzK10uG8MuhD/n47c0DZ/cxiTzoWtjC/ebdw==
X-Received: by 2002:a92:7911:: with SMTP id u17mr14632433ilc.44.1583852672949;
        Tue, 10 Mar 2020 08:04:32 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring: buffer registration infrastructure
Date:   Tue, 10 Mar 2020 09:04:18 -0600
Message-Id: <20200310150427.28489-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
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
 fs/io_uring.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d6f4b3b8f13..1f3ae208f6a6 100644
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
@@ -6524,6 +6534,30 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
+static int __io_destroy_buffers(int id, void *p, void *data)
+{
+	struct io_ring_ctx *ctx = data;
+	struct io_buffer *buf = p;
+
+	/* the head kbuf is the list itself */
+	while (!list_empty(&buf->list)) {
+		struct io_buffer *nxt;
+
+		nxt = list_first_entry(&buf->list, struct io_buffer, list);
+		list_del(&nxt->list);
+		kfree(nxt);
+	}
+	kfree(buf);
+	idr_remove(&ctx->io_buffer_idr, id);
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
@@ -6534,6 +6568,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
+	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
-- 
2.25.1


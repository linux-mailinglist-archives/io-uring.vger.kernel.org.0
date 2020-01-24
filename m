Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0699814902D
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAXVbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:31:46 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46860 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgAXVbq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:31:46 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so2716783ilm.13
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SaDB+bO5TmFBEMMZ/Gm1B42QyFMtf8QcGfU/nC8R2JI=;
        b=PeuFyaE987FdEjvfvlDqPOHOg2N2skIEJrcu2CXWf2bD+i6Dl5DRqiovd6S5O6JuZH
         8P1LjUGgF2K/dHt/PTxgScAuh9nZ49WktTRjoIZbG9H0mJtDQfbt7gqCy6R3iszvT1BL
         vszUnWyVBmIBbuYj5yl97p/SA8PV8IpHDylGo6Z3zlI8nsOJgJzvZZYqCD7/9nqyUdnQ
         T4zM3bF2MpqClDuokjWLBGmdHm4uxcDhyRqRqc9QuN4DD1V/Kju2WnawVYjlcbvDYbrX
         LgfyY51NvkC29URzo+7sZ4GUkyyj3aASiliGDS5CZffbuanuETQdETU22LKL/bUNhwTk
         vY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaDB+bO5TmFBEMMZ/Gm1B42QyFMtf8QcGfU/nC8R2JI=;
        b=UAh8CSXLsGSYlb6Gd/vfSSKhAeTUmcuZZ5wVsYXr2ixfYT7VExN9bj8aFCA+gobqms
         eYF41sQNYZ2pR/ApfMAxLzZLgVwcK6A9S3Z0/t1MP3ABi4w232QMjfZ21w8Puar7dwjk
         Ck3XPEDKMdAc8avtiGtOQc5dTGclYEBcu0POcWMk0EYbqkvAWcsfCdQnpBH3wi5KEvvA
         H5TESVwOuCc2+KB+oipFZ81vV8tUZwh4F0UpdCb2teQs4gLLdIbW2naPcmnIInMZMnOa
         8lZH2+GAIv5yQOMrq8+M3aSTjETnxUXycvs33fhyStWcpDA1hgA+u2f6kYhC5fduFTU8
         A/EQ==
X-Gm-Message-State: APjAAAUdIb0OCk4qyVE8GkPjaHHdzmx30uSaUTSCCLhbWGQq1Ej0gF4v
        AzzYEC30vsmnSLHSNr4XGCr5vZldyF4=
X-Google-Smtp-Source: APXvYqwJRb9fifct+QDTgKtSbh6NQYHM66RarveBbhm88fkDZo8Tjx4QgfIfQftFBNx/aTt0QVdlNA==
X-Received: by 2002:a92:906:: with SMTP id y6mr4912903ilg.157.1579901505801;
        Fri, 24 Jan 2020 13:31:45 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 190sm1322705iou.60.2020.01.24.13.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:31:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add support for sharing kernel io-wq workqueue
Date:   Fri, 24 Jan 2020 14:31:41 -0700
Message-Id: <20200124213141.22108-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124213141.22108-1-axboe@kernel.dk>
References: <20200124213141.22108-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An id field is added to io_uring_params, which always returns the ID of
the io-wq backend that is associated with an io_uring context. If an 'id'
is provided and IORING_SETUP_SHARED is set in the creation flags, then
we attempt to attach to an existing io-wq instead of setting up a new one.

This allows creation of "sibling" io_urings, where we prefer to keep the
SQ/CQ private, but want to share the async backend to minimize the amount
of overhead associated with having multiple rings that belong to the same
backend.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 20 +++++++++++++++++---
 include/uapi/linux/io_uring.h |  4 +++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f73586dcfb8..3dad12906db3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5673,7 +5673,7 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	struct io_wq_data data;
 	unsigned concurrency;
-	int ret;
+	int ret, id;
 
 	init_waitqueue_head(&ctx->sqo_wait);
 	mmgrab(current->mm);
@@ -5724,13 +5724,23 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-	ctx->io_wq = io_wq_create(concurrency, &data);
+
+	id = 0;
+	if (ctx->flags & IORING_SETUP_ATTACH_WQ) {
+		id = p->id;
+		if (!id) {
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+	ctx->io_wq = io_wq_create_id(concurrency, &data, id);
 	if (IS_ERR(ctx->io_wq)) {
 		ret = PTR_ERR(ctx->io_wq);
 		ctx->io_wq = NULL;
 		goto err;
 	}
 
+	p->id = io_wq_id(ctx->io_wq);
 	return 0;
 err:
 	io_finish_async(ctx);
@@ -6554,7 +6564,11 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+		return -EINVAL;
+
+	/* id isn't valid without ATTACH_WQ being set */
+	if (!(p.flags & IORING_SETUP_ATTACH_WQ) && p.id)
 		return -EINVAL;
 
 	ret = io_uring_create(entries, &p);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 57d05cc5e271..f66e53c74a3d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -75,6 +75,7 @@ enum {
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
+#define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 
 enum {
 	IORING_OP_NOP,
@@ -183,7 +184,8 @@ struct io_uring_params {
 	__u32 sq_thread_cpu;
 	__u32 sq_thread_idle;
 	__u32 features;
-	__u32 resv[4];
+	__u32 id;
+	__u32 resv[3];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
-- 
2.25.0


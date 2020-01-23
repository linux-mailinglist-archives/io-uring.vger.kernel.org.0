Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC1A14748D
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 00:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgAWXQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jan 2020 18:16:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32776 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXQX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jan 2020 18:16:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so119562pfn.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2020 15:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MfwyBKCtGS5PGGfuA3mGGNmgroVGmLBm53f0RhB4ck=;
        b=1icOZgDqc5t6L8XXrqsPFjTkoG0fLCKurp2nMB1S6NaBf6dkuP25nJwvP18aBzO+8P
         u19ncdZE4U5mu9ulqeEfHij1SwIQr6p1TJVgbtgIsW1MQsfHQvUErGYIGrkQY8WIr1k5
         Vh8H8KC8PzWaJv2zCAOEmrkThzURcDmrKC4SUW/+ZBZ8TdTH8V+KJXPGt/AQIu5SdeQC
         Iy4DcWjDX1NP5dkmMooVoDMGSPr80G8+pApuogkXwEjUI9Xjvveuhnl5BpHEqHxt0OjS
         ZW714IQaAxtiMOPisi8DjEr/eNHZihQmed1q86/TV/vNXwe8shPHztFLfYtl9LVsIBCK
         yzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MfwyBKCtGS5PGGfuA3mGGNmgroVGmLBm53f0RhB4ck=;
        b=mk6ZtBfqorI2axZEfhQoVeCjcq3GV+7q9dW5Cd6Q45pi4aSl37wJL26uN1F8sRtzWT
         u4Q9+ZuzUza4YnrFXb3uwb3hbDY7fHIioa9Diy3afIAiQpEIrK0vtYNkQanjM7UGpTzr
         9bnf5/maUhOdo5WviS0yGyAOeUsrz/XeQJNMs7gdh1053R5qLrpUgee8KgSaMOY8Enmc
         XdLrFHaLTBrRVhPhG9Bftd5PjHq63LmBrDgm6BM+VxjryY5hytqYKDx4jxUEn5um1eDX
         h+S52nJwPXxKXCFSx/exfx4SR1hUIeMAKYwfC3mQXFAtNGLiUFbICO70YDQpj7sB+RIV
         u9qA==
X-Gm-Message-State: APjAAAXw+YnZ3dB6QSEEZMe5GjsxF48WmXCX4GEfwB16jIoX7NdeCVph
        7NscGCz+aaqKT2Ip6ifWhVNPn6x4Swz1IQ==
X-Google-Smtp-Source: APXvYqw6yFvhIaoXQK+zAxgFOyztnjRYBqXtsfe46SZQ4ro/0AVf7D2tQ0fxTNpA7eMbBHV0cPLQkA==
X-Received: by 2002:a62:87c5:: with SMTP id i188mr611854pfe.52.1579821382424;
        Thu, 23 Jan 2020 15:16:22 -0800 (PST)
Received: from x1.thefacebook.com ([2600:380:4513:6598:c1f4:7b05:f444:ef97])
        by smtp.gmail.com with ESMTPSA id u127sm3766627pfc.95.2020.01.23.15.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:16:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add support for sharing kernel io-wq workqueue
Date:   Thu, 23 Jan 2020 16:16:14 -0700
Message-Id: <20200123231614.10850-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
References: <20200123231614.10850-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 9 +++++++--
 include/uapi/linux/io_uring.h | 4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25f29ef81698..857cdf3f5ff6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5796,13 +5796,18 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-	ctx->io_wq = io_wq_create(concurrency, &data);
+
+	if (ctx->flags & IORING_SETUP_SHARED)
+		ctx->io_wq = io_wq_create_id(concurrency, &data, p->id);
+	else
+		ctx->io_wq = io_wq_create(concurrency, &data);
 	if (IS_ERR(ctx->io_wq)) {
 		ret = PTR_ERR(ctx->io_wq);
 		ctx->io_wq = NULL;
 		goto err;
 	}
 
+	p->id = io_wq_id(ctx->io_wq);
 	return 0;
 err:
 	io_finish_async(ctx);
@@ -6626,7 +6631,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP))
+			IORING_SETUP_CLAMP | IORING_SETUP_SHARED))
 		return -EINVAL;
 
 	ret = io_uring_create(entries, &p);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cffa6fd33827..c74681d30e92 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -75,6 +75,7 @@ enum {
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
+#define IORING_SETUP_SHARED	(1U << 5)	/* share workqueue */
 
 enum {
 	IORING_OP_NOP,
@@ -184,7 +185,8 @@ struct io_uring_params {
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


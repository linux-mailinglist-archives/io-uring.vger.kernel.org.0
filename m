Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6519D3B1D80
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhFWPUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhFWPUP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 11:20:15 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0ECC061756
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id b5so2908579ilc.12
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dh0c4CNS4QTUOp6NK4eb+9Hjedew2mIOcwvS7F1Bn54=;
        b=X9DDh2es5LFu3bWA8RTnZTVT1bMNtbiwFQ0pR2gXT2Fkw7+SWWkcyJCSJXoRc7XbI9
         iqIuim7HhIxr7IRe2jZq2FPqggVS8iM0RcDPlubYPsAqtUgTfSQ2MLLdP6E3crl0LFAg
         nUpY+8yWuaWkSf9F7KP+/k1c/7GaTrgjHXFmnjJ3EAfib3mjkU0P7tkHH22Po4bWMf39
         14zsFiqEW8C0FtMDE9mAeMdPMcjdIC/JQkZu67ZgVwTrxIkWi/yMZrqRIoUObw+n2OZj
         6RJ7WxiHB+QcpzbUXEBbNzf0islkbdMMUVAQRh9QDFU4Tib9A0WoFkCgk36tsc/U0Xzq
         r5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dh0c4CNS4QTUOp6NK4eb+9Hjedew2mIOcwvS7F1Bn54=;
        b=ISO2qzFX6p7/xSqEMSVSuQ8MWMJsO+8RlOp948E8ICrRinbOP4U083WTvnnM7LWywH
         rSlhTMxO7mWZSj8A/kj7zSdzO/LJ1imoBzIhTU25oKd+sc+H+x4EDSgKfVeK2GS9ZtIy
         l9CWhiZi0EcWTBrE2c2XYY19ccecq55VpyYnHVe+nsEUS9Xmk47nhGYWfA9xwca3DPiB
         n7S57vZp958b60VxgRKx7fUYG7Q8VtfmkbhIIl2Tp/7xA+IIvgrDyEFKZ2KSyLqRDoFd
         hNC0TIZ7czyRNfiq6A/0jjiF++Xxma9PNOZAlsIJiwOnKr5FSCbzbz49jRxcnA+oAtOi
         bZ6A==
X-Gm-Message-State: AOAM532izhmZanqpod9UcwhaJaDzS6XSVUkHTlE7PHVY515u0J/q3HA4
        USUfoYHVAz+54T3Kcy865jIvMyBf7E7b0w==
X-Google-Smtp-Source: ABdhPJyX5jFCkLMyaMYwMIU2FErvGlPr2cxXbPTTPwm+IhZzuAMG5x9NZ4uq7tM/hTNvioKyTgl8LQ==
X-Received: by 2002:a05:6e02:8b:: with SMTP id l11mr3388531ilm.228.1624461476517;
        Wed, 23 Jun 2021 08:17:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t6sm97967ils.72.2021.06.23.08.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:17:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dkadashev@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: add IOPOLL and reserved field checks to IORING_OP_RENAMEAT
Date:   Wed, 23 Jun 2021 09:17:52 -0600
Message-Id: <20210623151753.191481-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623151753.191481-1-axboe@kernel.dk>
References: <20210623151753.191481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can't support IOPOLL with non-pollable request types, and we should
check for unused/reserved fields like we do for other request types.

Fixes: 80a261fd0032 ("io_uring: add support for IORING_OP_RENAMEAT")
Cc: stable@vger.kernel.org
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa8794c61af7..9b6c7dad0b73 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3453,6 +3453,10 @@ static int io_renameat_prep(struct io_kiocb *req,
 	struct io_rename *ren = &req->rename;
 	const char __user *oldf, *newf;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-- 
2.32.0


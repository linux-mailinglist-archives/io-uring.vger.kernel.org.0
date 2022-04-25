Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EAD50E2EF
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242434AbiDYOYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242425AbiDYOYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:30 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA8022BDA
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:26 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id p62so16031123iod.0
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8qG6FNzA7RZaSQM2HyZmiBnUDdixJD6bCfMWO4og0Oo=;
        b=fPuC9TrNPO+WL9h2N8m69d3ur54a2THfYEHUuVjtmURuv26gOviW8FE1TQBYFto5tQ
         fYXl2mGl3jk3T36QeShNUEx4pCyDyboikpiQgs7QHweTbN3cJ5N8g7DH1k9Jrzcxt1ow
         WlVqLIfMpTkB8MgZlPVtcTuXmrvWrUzJz6UWaYt85oIeyfxGBqSZM+x1EBFmlMhMN78x
         bMFDLvrDk5krjfnMNjM/66vvZuMbZ6quUwr/xJfD/blRFUg+braKOjOxPcHJeZrE37Q3
         XZ2BYncUsKSCMHsHPbYXkJaH1nITlSpeoI2itBPnZNRnNJVIjj611QRsvor+oLceuQmZ
         XkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qG6FNzA7RZaSQM2HyZmiBnUDdixJD6bCfMWO4og0Oo=;
        b=IURzkGpPvp1BtL7pSpp409RQ+NR8OL232h79/OwFb8Wmr+1U+msk+j6kpdONfK5n9W
         SsUKiJlMuMLBXQfF5XbOIrwhkYi7dOieLDu69p8cI4yXvF7wime4dEgfPbguqevgmlgn
         tcwxUZc2pkuNjrPEX5XhWgK2JE8SpDkdZH00vRPVElmW3ytQTrrmXt0ewc5kYy51IGzp
         zM7RBIpgvj8PrKn7jTbDT3Xbre4v+pXVGNbxLFxLehDYTW3djXfl3XU+NeFCKaozNXKd
         5aKDa7/aU9hcdtVenw7JxpHaVOZQzId7yqotZMpgsT1E/E8qoiYXezL0+Dw3fIGr7JA5
         1X8g==
X-Gm-Message-State: AOAM5315GhqwfI1QKZp5mcExotttlTVz9A3gnfWtqVduqOA9szjnGIqU
        3Az0Bv/+DRoUBDw7D4TpM/wE1OUmOccPtQ==
X-Google-Smtp-Source: ABdhPJwNdh9Pr5SMEpmSkdjStD/Paicph9RW95ZSLrhmn1YUTPoZvGLfibDGxnKzy53oBG7pbEUxQg==
X-Received: by 2002:a02:6a6b:0:b0:323:fcf9:2227 with SMTP id m43-20020a026a6b000000b00323fcf92227mr7436014jaf.137.1650896485760;
        Mon, 25 Apr 2022 07:21:25 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_COOP_TASKRUN is used
Date:   Mon, 25 Apr 2022 08:21:17 -0600
Message-Id: <20220425142118.1448840-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425142118.1448840-1-axboe@kernel.dk>
References: <20220425142118.1448840-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this is set, io_uring will never use an IPI to deliver a task_work
notification. This can be used in the common case where a single task or
thread communicates with the ring, and doesn't rely on
io_uring_cqe_peek().

This provides a noticeable win in performance, both from eliminating
the IPI itself, but also from avoiding interrupting the submitting
task unnecessarily.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 8 +++++---
 include/uapi/linux/io_uring.h | 8 ++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e9ac5fd3a8c..81f5b491c1a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11696,9 +11696,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->user = get_uid(current_user());
 
 	/*
-	 * For SQPOLL, we just need a wakeup, always.
+	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
+	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
 	else
 		ctx->notify_method = TWA_SIGNAL;
@@ -11800,7 +11801,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
+			IORING_SETUP_COOP_TASKRUN))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5fb52bf32435..4654842ace88 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -104,6 +104,14 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+/*
+ * Cooperative task running. When requests complete, they often require
+ * forcing the submitter to transition to the kernel to complete. If this
+ * flag is set, work will be done when the task transitions anyway, rather
+ * than force an inter-processor interrupt reschedule. This avoids interrupting
+ * a task running in userspace, and saves an IPI.
+ */
+#define IORING_SETUP_COOP_TASKRUN	(1U << 8)
 
 enum {
 	IORING_OP_NOP,
-- 
2.35.1


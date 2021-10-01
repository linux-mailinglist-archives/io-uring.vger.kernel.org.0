Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4990441E9B9
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353108AbhJAJmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 05:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353106AbhJAJmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 05:42:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A248BC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 02:40:21 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u18so14509513wrg.5
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 02:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M5kL/qJL9+TUyCEiVnVGup2bjzARVjWd1Vnzzd5t8/Q=;
        b=Cb7y61/QPCtFwqhP+3jWJLSMVw+rIcEPue3LPvoF73W4Gge6TWxerDrLBWjqW1nwVt
         QPY6c5ttft7z4PE78+zQ/X3HYWd+FQ7jpUWyLfCd8ffeI+NdWS+yX+11nsMEyKTRFIab
         EA98LBbAvQVkXDS+5BWdCprp7feRQtGWZcek+CysihNnmCoSQINrVhjhBy+/F2T4w+g7
         R4NfKbt2SVmoUpeHNPfIaOMJMzPSCHYccq5x2Ykw5jS5+uA3eGobgXsbOjbiFcGiDFVd
         FxNvtekhxoRGfFtXtixBg5/ij3wSZYJV4eRuklUL4L3aLEODwoNIBsqap2ICB8TnMY8s
         LQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M5kL/qJL9+TUyCEiVnVGup2bjzARVjWd1Vnzzd5t8/Q=;
        b=f7zBoje+mkfQeAr/5t6bpmZaBaeAm2YciPreGb4/S4BoRw8uwAl0VbYDgO0l9SIDkF
         bXTJ6jI6u6BB4YZIODMawsE6y2vIveIpwx7kc0OOAkp8fwxN0cGVkrt1wG77ntkwIihF
         ng0cdvwLAGSQAVbuqei261JK7rWHJd0H7Rz+JHDBXwl28wdCCSD02rOwUGVowhhmtND+
         E0e0Jt+7358/nTMwhkDmoM2Op/9vmZ7IHFQMbqkibf8E0CEgMdHUJhcjfBUgaEb4hvYG
         S/F2+yKk55u8UWo8Jqmow8ZR6fOooi4jvBdlvzjaDsBjPRAxpNfAsTp7LVhM9vzRRFr7
         6b9A==
X-Gm-Message-State: AOAM531dfGrK5LIVzyfNUzQuxCutbVNRcxPH5xZ2w3VIsQ9Em0H4aWeE
        zzDWh8WBvF83Ec01s+RxqrI=
X-Google-Smtp-Source: ABdhPJzfjZEubR29U8syAQ7UvEOQqMXzk5gI95fwdA/GtRiCRmbPQB6H67f8nP+l8wiNz3AxiHrfrQ==
X-Received: by 2002:adf:cf04:: with SMTP id o4mr10732613wrj.352.1633081220058;
        Fri, 01 Oct 2021 02:40:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id c15sm5365846wrs.19.2021.10.01.02.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 02:40:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: kill fasync
Date:   Fri,  1 Oct 2021 10:39:33 +0100
Message-Id: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have never supported fasync properly, it would only fire when there
is something polling io_uring making it useless. Get rid of fasync bits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c6a82c67a93d..f76a9b6bed2c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -398,7 +398,6 @@ struct io_ring_ctx {
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
-		struct fasync_struct	*cq_fasync;
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
@@ -1614,10 +1613,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait)) {
+	if (waitqueue_active(&ctx->poll_wait))
 		wake_up_interruptible(&ctx->poll_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1631,10 +1628,8 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait)) {
+	if (waitqueue_active(&ctx->poll_wait))
 		wake_up_interruptible(&ctx->poll_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9304,13 +9299,6 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int io_uring_fasync(int fd, struct file *file, int on)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-
-	return fasync_helper(fd, file, on, &ctx->cq_fasync);
-}
-
 static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
@@ -10155,7 +10143,6 @@ static const struct file_operations io_uring_fops = {
 	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
 #endif
 	.poll		= io_uring_poll,
-	.fasync		= io_uring_fasync,
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= io_uring_show_fdinfo,
 #endif
-- 
2.33.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4EF551F98
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 17:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbiFTPCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 11:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiFTPBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 11:01:40 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CDD1FCFF
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 07:29:33 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ej4so11423335edb.7
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 07:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceJ7TUEVJHUX9e4W14m2+0zdyOFckSwmhaEPPTxhWwI=;
        b=ogDa3tCHL/EKUyZUWMrBuOuWtSIXv32s2qQ4mFgI/Kv9Xvvyg8iuncHlVFfD2wPaz9
         YDgnQYmq9qHtKam341J8ZZfT34P0+QnlrmeZy3Tdmos1WZnbnSo+01pQ05d3vOXMvcbm
         n0T2yw73CYbeOnsqmHScu/u4Qh/wYz5QU6xrA2XDnpMFEJ+NJz4ojPYufQm/E0gUI555
         TvuXP3nQ+jsGZZktDWTOX75FlvTSpXlIF924WSL33ypvi3FdrnFR+Vdsm2QvV+3n0pQ/
         0T+MJNTE9gfx3XnHGs+U5ugTW+nr9k4X6jhHyq4EicUMCnzOhlZGWtzVoErOp1QOrkVU
         2JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceJ7TUEVJHUX9e4W14m2+0zdyOFckSwmhaEPPTxhWwI=;
        b=CFoKAKZYqIbIpHdnRhWsFDKtQoKcPCi5p1tR5I8FyGPJR5lvTWwDrvHHON/lQYY1V3
         nezuH01y0pJxsNdYIfFCoulFNf62Yu9Iapg44GHcRWxb90AELI25xlvmHz5A9d6nmpmc
         jfGzuQzWcFY39ycO7OEVYMU+FCeXLtBXi2t5nv1McVcyPVsslM1SwNPpWLdyp2gJKFr+
         cIn9X8E+U1n/ui9eW8ezHa09tvGTZaiQiW550XenXdBS355PSyNXNAMPMBBNo7Eu8WfQ
         KiZg6TmxRF3Z+ffRa7VhxvTA4LPJ1aiN/8Jpd8MW0fVWqdbY/907HNc4JoM0CeMYK5n2
         MXKw==
X-Gm-Message-State: AJIora8ZyQDtoPvuCXsNur6yl4ma8KcMKVFgpFBRbjTptfyRORbx/7D7
        fn7INQMIgAMOtzI9P+8Q/vDA0ftl9xuNWw==
X-Google-Smtp-Source: AGRyM1u+2xPX4CoErCb1GnIcvyoQW7HV84AGKXVhe1GhRB0x9uIe1PhYjr3g2Jex6bMj/sFk3I5tBg==
X-Received: by 2002:a05:6402:3227:b0:435:8e00:62b4 with SMTP id g39-20020a056402322700b004358e0062b4mr2385941eda.325.1655735371487;
        Mon, 20 Jun 2022 07:29:31 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:bcc9])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b00705fa7087bbsm6201376ejo.142.2022.06.20.07.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 07:29:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring: optinise io_uring_task layout
Date:   Mon, 20 Jun 2022 15:27:35 +0100
Message-Id: <282e7d40f93dc928e67c3447a92719b38de8a361.1655735235.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_work bits of io_uring_task are split into two cache lines causing
extra cache bouncing, place them into a separate cache line. Also move
the most used submission path fields closer together, so there are hot.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/tctx.h | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index dde82ce4d8e2..dead0ed00429 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -7,22 +7,24 @@
 
 struct io_uring_task {
 	/* submission side */
-	int			cached_refs;
-	struct xarray		xa;
-	struct wait_queue_head	wait;
-	const struct io_ring_ctx *last;
-	struct io_wq		*io_wq;
-	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
-	atomic_t		in_idle;
-
-	spinlock_t		task_lock;
-	struct io_wq_work_list	task_list;
-	struct io_wq_work_list	prio_task_list;
-	struct callback_head	task_work;
-	bool			task_running;
-
-	struct file		*registered_rings[IO_RINGFD_REG_MAX];
+	int				cached_refs;
+	const struct io_ring_ctx 	*last;
+	struct io_wq			*io_wq;
+	struct file			*registered_rings[IO_RINGFD_REG_MAX];
+
+	struct xarray			xa;
+	struct wait_queue_head		wait;
+	atomic_t			in_idle;
+	atomic_t			inflight_tracked;
+	struct percpu_counter		inflight;
+
+	struct { /* task_work */
+		spinlock_t		task_lock;
+		bool			task_running;
+		struct io_wq_work_list	task_list;
+		struct io_wq_work_list	prio_task_list;
+		struct callback_head	task_work;
+	} ____cacheline_aligned_in_smp;
 };
 
 struct io_tctx_node {
-- 
2.36.1


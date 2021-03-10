Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA042334BD0
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhCJWom (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbhCJWoP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:15 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AED3C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:15 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bt4so2448114pjb.5
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EGTjW5hEVNNXIdwm1Ylkp9MYUFGzZlAUTbBtL7EtUXw=;
        b=xLJxOfb5II2jWrw91+sS3DWTylzMTmFLnrWQ3tsakZ0Y3PTK0fChvrBswEFAYfZLvi
         9flHjqt1RBAUCRmNsXjqc3IghnOG1cYncJToXrBfS5eO9rQT1FCa3D93gn+ODbfw9xSZ
         i1bupSM5bwBnadEA00qJtbcA9X20L7PSajB/zznMVEh7ZRwHVv7Y0bsI3TD0bC+5l1B5
         I4ubsAL5jwyKPDefbx6xK69fsxzu6gB7O9rIdYaKvkiyF+rI1GyPBKO6RVpN4im7vzLP
         GNFkOhIzvEDrUENB42e42fyRX8hh93OraFpVDVmG0THRpkQdZwYGJmJ5l+g0MlfP2WYD
         Ck5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EGTjW5hEVNNXIdwm1Ylkp9MYUFGzZlAUTbBtL7EtUXw=;
        b=PMNTcTd6I6sovjsU9QAAeZioeSlJyDk5n5O8SwWIKHU6a//fjgx/VGkN22T1z+V4IP
         8DzPLCuI+I/wHRGAeKF2AW1hKTrIQrbRd6hfK1Rkzcqly+6ZFi5qNI5F+eDzTPav4Lui
         mbKWsR8iJyDYG2SFxJpcO1ImBdE7RZuHlHBLccrmwdpuRxvsBK7d7oFuO3+JtVuYd32p
         o11Iq+2kq4a/QZL4yGmV34AKTx/3ITCE3N7WIe1uIycb6KFP5m6+jma+khUchYzkPCEd
         Ralw9LFM/lZe4Sq/rUZm9n+8RMd+vD/V7waH/dxkN+BWilb+BEil6lvwC+wbI46NGbCZ
         CXHQ==
X-Gm-Message-State: AOAM531KHR86lUvlV5vpZOhOAYgZVDP2I/Hmd3ykuZ3TOocvUWF24npO
        IST2dT++8qpdGsk4A3GzU6ZYd81sxf2smA==
X-Google-Smtp-Source: ABdhPJwjSJVjUMZA05QruzDBKP6CbIdq+/yZPUEkxuATr22kNc4PHpHWsu/ZpI+aEzrztybKBeJLWA==
X-Received: by 2002:a17:902:7249:b029:e4:358a:1d47 with SMTP id c9-20020a1709027249b02900e4358a1d47mr5433931pll.8.1615416252871;
        Wed, 10 Mar 2021 14:44:12 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/27] io_uring: warn when ring exit takes too long
Date:   Wed, 10 Mar 2021 15:43:39 -0700
Message-Id: <20210310224358.1494503-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
monitor whether removal hang or not. Add WARN_ONCE to catch hangs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 01a7fa4a4889..945e54690b81 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8560,6 +8560,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	unsigned long timeout = jiffies + HZ * 60 * 5;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -8572,10 +8573,14 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+
+		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
+		WARN_ON_ONCE(time_after(jiffies, timeout));
+
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
 		exit.ctx = ctx;
-- 
2.30.2


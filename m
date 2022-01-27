Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7303349E422
	for <lists+io-uring@lfdr.de>; Thu, 27 Jan 2022 15:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiA0OFP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jan 2022 09:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiA0OFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jan 2022 09:05:15 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB8DC06173B
        for <io-uring@vger.kernel.org>; Thu, 27 Jan 2022 06:05:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso6014701wma.1
        for <io-uring@vger.kernel.org>; Thu, 27 Jan 2022 06:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UISkPhT4BIca5WtrYEoFfdvyYgnDGNawnKFtZI4dWXI=;
        b=MQ4hjmTLKV3S+exHiNuEnPrwYDeQ3PRnIHGNbWhvRaBbD4/ewTiy2Vsoh14g1hwXIL
         G88aSutxFfatY/ruzii1OmT4QEpF6Gjm58fLP/EcCeLaiqSeIzFmy4mpCOmKY50o5rHm
         DLsgEeec8EE37gvjvSHu5KlYaW9zrEkkTPklJjJF0Zeyn0JU1J0DXQoFsTKYz2NOsGVK
         2Z861mbR1WX5eLd46hc++N7R1NPtPOLPpURLruWYBtyMEERzVXOuIRxFCUwrirWucW4q
         j53leMkSnF1l+pyq/28dLTlJ+/YvFeyReMVKhC8WATLfaUMtdFCkFblL1goEjR/Pd1fV
         Wm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UISkPhT4BIca5WtrYEoFfdvyYgnDGNawnKFtZI4dWXI=;
        b=FC/LDVGgLTG6SzsyDeSqYwLPltGbM1r/l1n7pjrxs9FlxmUdCVpyG0CiMoMfUqPPy5
         iWz/7EQWH5YrVdhplwuTb5W/uOsBIBpO5Oyaz0NJvO0m+WDl4NvAQuym1NyWES21zrA0
         otGZnr5ckbOifOz58n3+zUWWTiArSityFKCZratiTwu6mEq/HEaEO9/7ajl5jpzpAVTA
         nTozEi+N1AT6VDWgsnZ9tJzr8Ee5cNEz+AYLTBO9d32gQKC/iPejwXVKhpfq3u9y/f2Q
         B4E0wxuvL/54du42YITn03nneXiu4ao1x41ztoXkmzdgMIZWYxbA+rFx+EmiPxbumAjD
         IbCQ==
X-Gm-Message-State: AOAM531M/WDli6i47pMT+jUNhTmvDKsY1GEPKDolBPOlQY4m++slGz3M
        Goa6agK2+qAgyZ+QDhodLiNh6HRhi8OJfg==
X-Google-Smtp-Source: ABdhPJzooFiVCR3Ny5P0GNnKhxVwEEWl+CPWpFH0tsQEsjmwsHUGx5lcyR4WRQdykwYiTlcDw1EOWw==
X-Received: by 2002:a05:600c:1c8d:: with SMTP id k13mr3377064wms.171.1643292313171;
        Thu, 27 Jan 2022 06:05:13 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:b164:2cad:2ae3:b81a])
        by smtp.gmail.com with ESMTPSA id bg26sm6101321wmb.48.2022.01.27.06.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:05:12 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH] io_uring: remove unused argument from io_rsrc_node_alloc
Date:   Thu, 27 Jan 2022 14:04:44 +0000
Message-Id: <20220127140444.4016585-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_ring_ctx is not used in the function.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e54c41274..a256600fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7841,7 +7841,7 @@ static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
 }
 
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
+static struct io_rsrc_node *io_rsrc_node_alloc(void)
 {
 	struct io_rsrc_node *ref_node;
 
@@ -7892,7 +7892,7 @@ static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
 	if (ctx->rsrc_backup_node)
 		return 0;
-	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
+	ctx->rsrc_backup_node = io_rsrc_node_alloc();
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-- 
2.25.1


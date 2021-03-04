Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423AB32C9A3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbhCDBKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352090AbhCDAd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:33:58 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4EAC0611BF
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:27 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 18so2690577pfo.6
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MnNMSiHjWf/W8J/T96zNFO/Nk8e1oyKL7bj80WI2W9k=;
        b=Iy05Saf1RqYFqytPf4UetBB0HeqzPK57xZcItx4ZTzLOQPgtbN6cDoYVxRxllY20Yg
         2C/Ho0b7aNHM4N4+UOn4R741sfgtONp7ljv1PDQp70u7ApD6CAVAzCCLTgYRa4KICqpf
         OuR0wcByWAeJSrDU2JmHGNKEhCgmYwqT9rH/T5rIpPNpJP1YIJl2aUYvxxhMCwgWrnyL
         hFYeux6zjucH+aUvh+5XJJjIlcUBqvx5mQZsd4o9PFJJ/45oRwCuEzkC1lOJoKXXh646
         XwMAFAjouuGWIf7J+4fNRCdByKb5DzzOrDkLPb1ePKyiHDTu9R4ooUyRuz/cWWMaAE2Q
         a8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MnNMSiHjWf/W8J/T96zNFO/Nk8e1oyKL7bj80WI2W9k=;
        b=NNhE9mmGf0++LLUIgJaSBk8VHcDFg46HmbROIVOF2rdNxBPgMEgIjqR+oIYzRZb3P1
         jBOTlJocEu/Fc9PPP38iXGmkfpBDyNUpLAa05AGJiGoz3xUeCJ1KGUc7wZfH3iNqaer6
         /2DwE4pZnx9pXDwLkw/CathU0vJ8f972fdVZlnDN5EJF/FOR3s212/iJjSTn+xL1dMM6
         sm7sS/6oly8K5EazomH0WRroLfWw85KjhBrPC6gVOeTPzshqZ46It9PslU3EHOoj4OWA
         0weTP1PJzEnK0RlYOAA4QYGG2e2+k5I2XYovawHD8qbMVF56aoLXzi426xwDhjnHJ+aV
         7lOw==
X-Gm-Message-State: AOAM5339xsewxDSwfw11t6qLGtJdMZoFDlReSTk3nay+0FFXsrz47Bqn
        PYZdmnlVYvnBQ1w5H08E/+U6T1n4qibXPFS/
X-Google-Smtp-Source: ABdhPJyOTbkHlm10iiqW2AxQYax6UUbz7YkVs/kF0PJnfTARXJr0/xh5Kl7SlPMNLV+Fz58nQyXvXA==
X-Received: by 2002:a63:1503:: with SMTP id v3mr1319171pgl.240.1614817646936;
        Wed, 03 Mar 2021 16:27:26 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 18/33] io_uring: kill unnecessary io_run_ctx_fallback() in io_ring_exit_work()
Date:   Wed,  3 Mar 2021 17:26:45 -0700
Message-Id: <20210304002700.374417-19-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already run the fallback task_work in io_uring_try_cancel_requests(),
no need to duplicate at ring exit explicitly.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d309795d910..def9da1ddc3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8519,7 +8519,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
-		io_run_ctx_fallback(ctx);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
-- 
2.30.1


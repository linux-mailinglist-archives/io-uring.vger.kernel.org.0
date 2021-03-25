Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B09D3492D4
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhCYNMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhCYNMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:18 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970DBC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:17 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso1172052wmi.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=APXOgohIUk73i9FEoOPQ/7PLeaAk+kt+OWzQWuT5Cxw=;
        b=Z6LUXV9uC4vxZWdmuMVGDiaE9yvNRAeW7vSWcrilI+CIh1oz0KzVfesXXxSNQtynHo
         zOSr81ghejq0KGbzelO2dT5m6WSQM3gTFqQfGtKyaA4hUhMg501ZJDKoHszmYWMaACUv
         pDexGZRMQb/QrIFG8nEalbJLeF26egbMHCRehOarc3mJ8rqDRtDIgBITNJ15kPByP7Ex
         5QJbQJ/WV1Hy4jNZZrm1WLhLcRGbtEzmQhbyQz3NRl5GMepZL063Jwo4x+olNTjqSphO
         AJrIJL9aJZbWu9/+ia4R/Dblw1OPBS3KXL+iU1AkIrNTlftGnrjodyn2Nn3iQhMQKB2T
         POng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=APXOgohIUk73i9FEoOPQ/7PLeaAk+kt+OWzQWuT5Cxw=;
        b=IfD8ChnFQuPxbTfDADt1sVN+uLnCNlgYd+bkbEja8iegTa8rhGfUBvCoP3GV5gCDjg
         iZSHlixTZUohh+Mc63Fk5uoEXQ2iZq7em+TgMy2wxwYtgw4wzv/8xJs0EA637BPkBLxE
         D5W8qrXmL9rkeTHc4qMZYC7Z5pQZbDdK4oOJmm/CaaGb3InXN+dLdh6b+ULVNYqlCRVc
         A5sMICbRH+2tt96DGOEhE536ZRUQOSv1R1nmnJpnqHe7YfXhnCbwkQM4mE29ZC94Qcc+
         z6VUZ7edutznivh2WOvOKZAgfXTwRciEG+nWxDEHew5jbnxJ6T5Uawbpyz0jWaYXeNyj
         eWFg==
X-Gm-Message-State: AOAM532/W65rDOvuONK51s8ZezbnY0YhhLfPRfDEgFYhSCGNguI0VV1n
        s6Ab5pDUHqFynb4YMCzE9hU=
X-Google-Smtp-Source: ABdhPJwXfIQRtx4nbhg76N5gROGlPmuO2SjmAN26SfqDW/4hBYGXr18qZ9rtILgijFVsGgBWKGHEQA==
X-Received: by 2002:a1c:6a05:: with SMTP id f5mr7816926wmc.75.1616677936143;
        Thu, 25 Mar 2021 06:12:16 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 02/17] io_uring: simplify io_rsrc_node_ref_zero
Date:   Thu, 25 Mar 2021 13:07:51 +0000
Message-Id: <dd22c634662343a2dee06a879c0979f9adc9c391.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace queue_delayed_work() with mod_delayed_work() in
io_rsrc_node_ref_zero() as the later one can schedule a new work, and
cleanup it further for better readability.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b2c6d91749df..502b0f6c755b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7453,7 +7453,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_rsrc_data *data = node->rsrc_data;
 	struct io_ring_ctx *ctx = data->ctx;
 	bool first_add = false;
-	int delay = HZ;
+	int delay;
 
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
@@ -7469,13 +7469,9 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	io_rsrc_ref_unlock(ctx);
 
-	if (percpu_ref_is_dying(&data->refs))
-		delay = 0;
-
-	if (!delay)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, 0);
-	else if (first_add)
-		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	delay = percpu_ref_is_dying(&data->refs) ? 0 : HZ;
+	if (first_add || !delay)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-- 
2.24.0


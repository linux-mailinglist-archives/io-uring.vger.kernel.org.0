Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6000A319259
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 19:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhBKSfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 13:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbhBKSc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 13:32:57 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E779C061786
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:17 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r21so5141698wrr.9
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BveZzhGcr5BXOZHmHIbS7OiQjQ4/3APtxtTDxrAHvDk=;
        b=DDX5R1EJIB8MBBn4XCLtnMU48ayZ4VpnRZlenbeXCSBuNN8XxZftX5wIrK4KjeYOuZ
         00TaGLdIvRUfbrAeeO5MSqR1ljZ+FpxrgTaFSIdOddkhw79fibGv1ZSiOgx7eeJFi6iK
         n8fmrjQF3XPfsa0nAEVqNL3eIPKUxna35chuHK1BSSmgNyPZY34RIPZaAY0rwoWSNguv
         XWgheMnMTC/O8mQbTMsKCk4x8UEcpvfQRmCMYOOfVLKZUyWaLXPAU2Iom5GTgSKbTeSg
         WFS6NUYroV/uVJ3kqlhwdeX12gCWdSJJ9edyJMS+lSPOf/bCauO8XFXUuc8Ld6wq2Y1I
         lepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BveZzhGcr5BXOZHmHIbS7OiQjQ4/3APtxtTDxrAHvDk=;
        b=i4Ntyj+AntGHy1/xvGMeTBDEwsbLE2h8Ryq0zOK+V+1ty6aIaaGR53Knuno+Oic7P7
         8N6GVOgcxp7YevPWNn+5fyLZay3sgrLBLW8qlXKRJVqJln8Kq6wcQDUkoYt+0iqDOtr2
         qKldTpzOwFeN4wVIidssMXFDYG1MyYx2B+p7GTJw5TfaZ9GgHzaMs2RfxNO+JtWjTgaK
         f+E00zOiEmikJvhRkjHXdmnnJNpPEu/qXAU8gD3t5+Bx4cgLvT0Ptu2U3f+z8+jVd3Fo
         qgETFZEBZl/FNn2pYnlZgllp9qw8Gr+KBYHyErJIFB3+7ntmFWoAPCtFBs3OBMQlnxC2
         5BWg==
X-Gm-Message-State: AOAM530kGPCx9337WklWcrROeAtsY4mhXg69jtRaUEJH3uRvd5VSCS3t
        9GG26Ueu1xFgk32aw6W/ELQ=
X-Google-Smtp-Source: ABdhPJxj6f1RSprn6unKzwdlHUMXr92lrTSpoYRuHnL/TJPBD1M3bcaPK5XcGhlyzdxgjitMz3D4VQ==
X-Received: by 2002:adf:ee84:: with SMTP id b4mr6857925wro.339.1613068336193;
        Thu, 11 Feb 2021 10:32:16 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id a17sm6501595wrx.63.2021.02.11.10.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 10:32:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: clean up io_req_free_batch_finish()
Date:   Thu, 11 Feb 2021 18:28:20 +0000
Message-Id: <fc684490abfb34d4d7f5acc076fceeba6c9716ff.1613067782.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613067782.git.asml.silence@gmail.com>
References: <cover.1613067782.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_free_batch_finish() is final and does not permit struct req_batch
to be reused without re-init. To be more consistent don't clear ->task
there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a1e4ecf5f94..0d612e9f7dda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2394,10 +2394,8 @@ static inline void io_init_req_batch(struct req_batch *rb)
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 				     struct req_batch *rb)
 {
-	if (rb->task) {
+	if (rb->task)
 		io_put_task(rb->task, rb->task_refs);
-		rb->task = NULL;
-	}
 	if (rb->ctx_refs)
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
 }
-- 
2.24.0


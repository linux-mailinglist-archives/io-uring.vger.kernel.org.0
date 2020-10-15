Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A028028FA80
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbgJOVO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbgJOVO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:14:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F9DC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z22so279949wmi.0
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+F5yxIgG8VOU6SAL2XQXFPG9ZeyxOwUbL8PC7VrsD5o=;
        b=BJlln0JYLi9pNIdXVEpPlE/0vtlO9VNr8Gf2dpkgzRKqw57oqNraUX0/nXrRZ+biqd
         m+k3GrZRSnTkiWvlIoptimx2RFfp/0k/hYsY0OLoxTUIKHD9y1zsIAfHBvpDfoYlH3ON
         jeq4sOyFF/z99886gkFV96IS4fue7VGS8K63HYdVxx65pHoHKBfoClgaD1CtAd5YZMY9
         tpNu/09f3IAO/PTAw4PAcV7daf8Cp7SojS/RpdoRgkCVaJkDpYU18Lhze/cZvY3tu5J0
         X6/QX9nMVLKZylW8lG968c38Zd4yugkKOFNPZ2GdZqygF3hvQ3agswJMeyenw8dPcjSQ
         eL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+F5yxIgG8VOU6SAL2XQXFPG9ZeyxOwUbL8PC7VrsD5o=;
        b=OgzY/NhOdvnLUi31BEimEDfuBRvpWnXj2AUXpxCuICgIu3db/YqrMpca/21rBZo+4w
         MpiVMdH/06yrAh++Alq2+F8u6elMR9p5kTOgDI27Occ2/G95HrXHiwSVh1HRKA3VBV3Z
         HWKiC3z8Wa6wV2Ejx28DbWpDAeoD11vtVxzZmmdR4zJ63ZHABxDD9lc5oZlU+3Isc/Nf
         lVIiChO5qKccArckcAssAwjgBcaSfBT1Vw5Zrg1e08SWZwmfhDYPLYcrVFZ0iUo6iPZQ
         b400yQ1lq9MkvHRBLyYzUxDMAici576TE3Zp/3JwTqO9S6Dj90L+Xmg8gJJu00wrfwBN
         8BWA==
X-Gm-Message-State: AOAM532fhNf+dt2Q7tIuG1AlM1OSRCgmfngwu799n5JtSRIwGsiPtRkw
        XbcQ26Sl5WNLOZKi4GyhYHFsd0Uq6LR46A==
X-Google-Smtp-Source: ABdhPJxWRnmA32xBbu0gtDZnz3aKZUZrAjby42PYslp7X3/MeOGrKvLYJsnSMltb1cLBaBTqkYnN4Q==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr557492wmm.2.1602796465009;
        Thu, 15 Oct 2020 14:14:25 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x3sm320865wmi.45.2020.10.15.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:14:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: inline io_fail_links()
Date:   Thu, 15 Oct 2020 22:11:21 +0100
Message-Id: <e66583b0b479f051a82212e87b17eea903ae96ca.1602795685.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602795685.git.asml.silence@gmail.com>
References: <cover.1602795685.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_fail_links() and kill extra io_cqring_ev_posted().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c83c2688ec5..373b67a252df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1795,10 +1795,12 @@ static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
 /*
  * Called if REQ_F_LINK_HEAD is set, and we fail the head request
  */
-static void __io_fail_links(struct io_kiocb *req)
+static void io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ctx->completion_lock, flags);
 	while (!list_empty(&req->link_list)) {
 		struct io_kiocb *link = list_first_entry(&req->link_list,
 						struct io_kiocb, link_list);
@@ -1820,15 +1822,6 @@ static void __io_fail_links(struct io_kiocb *req)
 	}
 
 	io_commit_cqring(ctx);
-}
-
-static void io_fail_links(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	__io_fail_links(req);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
-- 
2.24.0


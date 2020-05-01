Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84301C1770
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgEAOK4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729219AbgEAOKy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:10:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F96EC061A0C;
        Fri,  1 May 2020 07:10:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so11642843wrb.8;
        Fri, 01 May 2020 07:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=M/HjbUxD/OrDoik15Fa+gZu3/yY1bEZ62TD4ptiqSXA=;
        b=kckmiiqbEzAbel6pdnVbEDSy+pW8D0WJK1OZvYnksJUAhkt5Tz6/SF0CMeb6iFzpI8
         4RhY/aus+atQ+Iy3xsb9aGeWhZ8IqnQ/kPROgLq7Mn8gdK/0O8mvLE3H5Ihfp+chIFdQ
         13ak6/4FxVcQR3ptdXHI1K+ggyG2qwhjyv9z4UZz6K3blSJLE1nlUUt1qaM/4vN0Ejc3
         emX4KOmQ66g5AMpwZWx1Rk+Ewy7/xz5+OCrURluri3z1kUcwNBcA4+/HO4hNZ99SKoPC
         fhoSaVXfxUSF+S1mkNJGWBPcE2BCWZULtlE1PPBBi62TzXSvelgEzjTPEwNF5UceDzbv
         Al5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/HjbUxD/OrDoik15Fa+gZu3/yY1bEZ62TD4ptiqSXA=;
        b=C6FThzCOKJSX8vRE9+H73kFTiu36wTs6Y7yrZI2sW+M+Nlok/GbbAH2ZL7O0L8ESQC
         s2f45y6Nh/wsJYwGNxagNWajgsOR2wVTKlf9EytCaiHUIrQZ+dmy/KxUGLiI2EyGwkpb
         6WzWnwW4W5QkcjgQGITzNMJ1qJyP/FxZRk0Vk1EIaYwTr3X/12lciwSDptmQbkRrgf+J
         Rc0MOxaofOEjJryQo+/28+wp/GW5LeMvPIhWFwT5HXcjdI4Tg1gxjjjnkDnpG64xm1In
         FswhBO4fkuO2eRPqbXyXg0EkLfyaXlVCBnRAMED1+y4IVW08TRD2rviMDhq41dNLpAkw
         GB8A==
X-Gm-Message-State: AGi0Pua5YJspWn/f61/Jksz7e3JZ+TvNOlDO3ANT6IkzLBaKyLS2UgmV
        p4K+0j1ABVJJ1EJO3TlHhLI=
X-Google-Smtp-Source: APiQypKgQimO1lanqNunLSUtlIWdFu7TplTBbFmDKgsr1dP0AyBfAYweAQJK7hJ4kIz9E90CjrVUcw==
X-Received: by 2002:a5d:66ce:: with SMTP id k14mr4707770wrw.73.1588342252993;
        Fri, 01 May 2020 07:10:52 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j17sm4837390wrb.46.2020.05.01.07.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:10:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: check non-sync defer_list carefully
Date:   Fri,  1 May 2020 17:09:37 +0300
Message-Id: <c3224e56c1d1f97cf40e8dc1e03723b0dc4137cf.1588341674.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588341674.git.asml.silence@gmail.com>
References: <cover.1588341674.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_defer() do double-checked locking. Use proper helpers for that,
i.e. list_empty_careful().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7d7e83e3d56..e5d560f2ce12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5028,7 +5028,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
-	if (!req_need_defer(req) && list_empty(&ctx->defer_list))
+	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
 	if (!req->io && io_alloc_async_ctx(req))
-- 
2.24.0


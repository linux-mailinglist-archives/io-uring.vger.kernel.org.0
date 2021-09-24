Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998BB4178EF
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245135AbhIXQiX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343872AbhIXQiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:38:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286C8C0612AD
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:07 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y12so2085017edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fiCW8JJzUjhdsuRCcKndOv71dRr1FwsRV5Vs+F93TaI=;
        b=YXAJ3KfdsJRsgFVz2HpL3RHmkSMnv4ZRnC8mvJK9dX/4OlZLoYxy8bYELOsmwByCHp
         7JpohOis2oiKiQ3QnKa47s78MWZqHCspYMPUy7EM496z1ts4+jSeMwlv3QR3xIZmdfvc
         3NiDh/pLPfRHFOTz6vrwP7/SwedJq2XwLDLkq2/eJkGSKkwgRWC37Pkk1+BhE4gziubW
         y6pfgGimeQmg7ZtupDe8XebgJoU2qnH1bz2mJjQvA13J7Q0BJMkjAwvlxkPlSn5GiFF1
         /L4xTT1SxRLX/fjE3mOmLkg/JzG9uCDPODB+ZhFZYbzUM/6h36JJMRZnzi90J4r3pN66
         Cghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fiCW8JJzUjhdsuRCcKndOv71dRr1FwsRV5Vs+F93TaI=;
        b=K8FsfGzBT1Q9SAVB+pAP0zuE0sZmqt4O+ju55x+ZzrHobMCKcR4g1yBITBdITBqWC0
         wLcOAHndJLlAsmRH3mYm58nvPbX9dX8ZfIut9en4SYBjx8J7IusWENxL+ehk8jdkz9Vv
         t/tA2Hv7ylqRVKAM2CgiDjIAu25OTSFhIhPWcMP2LD+VUBIlwfiWkeXFOei0ojCbA0fN
         qHtQa2ySu2NZgYilWDb8aXWI14Lih5LXpB6yEI5Iie0pQTV1UTYez4uYH08/Sm9BUiNT
         bd3rEJbexlEDNKTpB/Ifo/C66BprzjYBJkYBglAFmJ5/ZgDjwro00x76MPJEzDFNOLOy
         yCQg==
X-Gm-Message-State: AOAM530dnRT7plspf77zejGzLlhYNvr0ByGynAgMMQ1mYnl3GXMiPyNy
        NFpo5/soMRlvt4yummjRO37LqIfdhcg=
X-Google-Smtp-Source: ABdhPJxVrs6z310hEzpe6IhEss1CqW6d+4S+fsiDeIxeTVB9SR4f9+5JZFxKDiRyDuZ/yc0TBvHPIQ==
X-Received: by 2002:a17:906:d04b:: with SMTP id bo11mr12149782ejb.513.1632501185827;
        Fri, 24 Sep 2021 09:33:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 21/23] io_uring: restructure submit sqes to_submit checks
Date:   Fri, 24 Sep 2021 17:31:59 +0100
Message-Id: <7c4eeaa0efd0d65cde143c28da1f4fa4785972b9.1632500265.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put an explicit check for number of requests to submit. First,
we can turn while into do-while and it generates better code, and second
that if can be cheaper, e.g. by using CPU flags after sub in
io_sqring_entries().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7c91e194a43b..3ddca031d7d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7217,16 +7217,19 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
+	unsigned int entries = io_sqring_entries(ctx);
 	int submitted = 0;
 
+	if (!entries)
+		return 0;
 	/* make sure SQ entry isn't read before tail */
-	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
+	nr = min3(nr, ctx->sq_entries, entries);
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 	io_get_task_refs(nr);
 
 	io_submit_state_start(&ctx->submit_state, nr);
-	while (submitted < nr) {
+	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
@@ -7245,7 +7248,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		submitted++;
 		if (io_submit_sqe(ctx, req, sqe))
 			break;
-	}
+	} while (submitted < nr);
 
 	if (unlikely(submitted != nr)) {
 		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-- 
2.33.0


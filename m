Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367A632D9CA
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhCDS54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhCDS5u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A7AC0613D9
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:37 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m1so10712739wml.2
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JKztUQ/kk0aJLdZ0VGWJVJMj19Dy7TdOk5t/uItLUlA=;
        b=vb3cFOUmPXJAFJIJFLQo2s9mslLKktyP2CmWjLB1r/YLOaIC+yWmPqqWFMW2gcRhDN
         2zPtSFfEfX78cnMezBmQyxrStVGd+acAuDNO414P0Bbgg7lz/dup159vYltaPL8rWjP6
         bRUpKIDhu4QJCaq8t14JKt6hfcLgO1AOloygM38Htb8Stg7g2tk8/t84Leh0f6RBIeSo
         IgV+Dgv3Pbjj6kRGzqmI5CANZ1HCSuzvkAlSObpVw5PW/b3FMoS9QbUeMuzeNe4liFQ5
         82uYH0CFzc3FUtAsem1KpexKAfFCP8ghUd9vOubYTPeLHqK4qbH8bF24YIfy/X2VsR7Y
         U/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JKztUQ/kk0aJLdZ0VGWJVJMj19Dy7TdOk5t/uItLUlA=;
        b=oMz19q++DUvVkPRuasDQKhk0zA3przwL+sWkE2mlUspk/EVI6GnWhrFeqGTE1z1+4L
         YQyD0GdlLqXEV1I1q8S5e8qjmYte9s25i+uNlnOFlIg7zLzvfkbZafZHgukQVwNUR+Ro
         wKuEagDOggEQeWuoh8ohbRGqB7UAWyaHK2N72tuS69C2wECQZkESvmyhRRcCtfVTr7pw
         n7yvrMECtSHYX+i1yCJAMNC+CCyVNFQjGv91KyTa1+W1bC8KGbEAFFHVZ2PUQRrl6RyG
         M4NF9lWTqGmiOO8J/rk4s8uSdYmHkpRU0OmlpHRgNRTQYwighovFkyz8iq3FiGyDBd5o
         D4YA==
X-Gm-Message-State: AOAM533JJTwgwalqr4IVGY2De/BYLcilAh2KhbmDf/6Sm7BxL7ipCfCN
        EA/8Iw4wvh/+bEupWEz9XIk=
X-Google-Smtp-Source: ABdhPJxp1C8IkFF80h2P5qvn0poyu8oWcu/kQ8uZEK1F5dZXsRPxNGb9B0YhiiUwrW2+bpw60MgcrQ==
X-Received: by 2002:a05:600c:2cb9:: with SMTP id h25mr5337569wmc.110.1614884196578;
        Thu, 04 Mar 2021 10:56:36 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/11] io_uring: refactor io_flush_cached_reqs()
Date:   Thu,  4 Mar 2021 18:52:25 +0000
Message-Id: <7cf1d8c2d9578c1c7fec80ce4f45f6045a30b200.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Emphasize that return value of io_flush_cached_reqs() depends on number
of requests in the cache. It looks nicer and might help tools from
false-negative analyses.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75395cc84c39..202a3b862722 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1597,11 +1597,12 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
 	io_req_complete_post(req, res, 0);
 }
 
+/* Returns true IFF there are requests in the cache */
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_comp_state *cs = &state->comp;
-	struct io_kiocb *req = NULL;
+	int nr;
 
 	/*
 	 * If we have more than a batch's worth of requests in our IRQ side
@@ -1615,16 +1616,19 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 		spin_unlock_irq(&ctx->completion_lock);
 	}
 
+	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
-		req = list_first_entry(&cs->free_list, struct io_kiocb,
-					compl.list);
+		struct io_kiocb *req = list_first_entry(&cs->free_list,
+						struct io_kiocb, compl.list);
+
 		list_del(&req->compl.list);
-		state->reqs[state->free_reqs++] = req;
-		if (state->free_reqs == ARRAY_SIZE(state->reqs))
+		state->reqs[nr++] = req;
+		if (nr == ARRAY_SIZE(state->reqs))
 			break;
 	}
 
-	return req != NULL;
+	state->free_reqs = nr;
+	return nr != 0;
 }
 
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
-- 
2.24.0


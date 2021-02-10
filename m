Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A118315B09
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhBJAUr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhBJALv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:11:51 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416E4C06121E
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:33 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u14so438934wri.3
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KJs+sp6nt1cBMrq8g1IVJMyb7upog/EKLATytEJ9ATk=;
        b=HNi4AFdlMennkdNgqlIKIOiDoUbnwHveA6KtmIYODNKtGTr9LY8/V/LoQa/uc84XdK
         yM6B+kTC7R+wvEEDG6jukPhsL3D7M4Tgi8fxGBj+yTAqr0TtxLXPNEG1wK34qK9vYi/S
         vptAnjchxRcmLUllkcsCBUIyDL4roTyDUnQ6KOAXIPNeNlE6U0aRGQXkUvYdt14bxP45
         kupoKsMP7OLLD5O5l+P49WcLCEtbBEz0A5ENJKL4+PjcrpxhYD6xftHdxSSJ8e5eAE6h
         xPS6uXLNAkccLtM2OBQoQpuwRB85Nny4SzJI9+5W1tpBoX8XFOPFOmvlvJMyd5OKSHlk
         34XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KJs+sp6nt1cBMrq8g1IVJMyb7upog/EKLATytEJ9ATk=;
        b=PjMFnHavsKHkBf4ox1anKgzqPS0MQ4urw4xrGYMWWBR7J9IM0Eu0n9UOxZaUrPTTyq
         c0hLyVkGtFPCraG0vP4JteWh1MId2elg80awUanFyU40sa49dE92e2/HgbumrPKcYtSf
         HbD3m+mJkEpsFTLmHismnqSXKMJxQ9ZsQIlO5sEtWYMNyf0Dgjtk9E7Ox6LnKB8HRlk/
         K192HCQjrNgLHlaoZSzjFROktYC+Md/mXRc9sWFcrqgUGwZ1+rwbX0wc6GD8bZu9KooS
         X7/0VZ1j9WGneD6Oo0R3StD5eAztuj8sd+EnMPaHNpqn3Jo4HfRN4Af2DBDPkZ8CXRLO
         exYg==
X-Gm-Message-State: AOAM531KFcx8Td8BGGY4SQ4IWa/f0/I5T+VCXUdYx1GFICABhDMlHQAp
        bHr9QCZRBaVtjPLGdQnF/Ts=
X-Google-Smtp-Source: ABdhPJzgOl4P8VVsM+tCzXShaFmuqNR1kH6qlDLQx7NOd8NckLuIK22o8FPmZ6W0szl7rGHKSabJ4Q==
X-Received: by 2002:adf:bb54:: with SMTP id x20mr567171wrg.112.1612915652043;
        Tue, 09 Feb 2021 16:07:32 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 17/17] io_uring: defer flushing cached reqs
Date:   Wed, 10 Feb 2021 00:03:23 +0000
Message-Id: <e9ba205c3894e88cfbca879b386bbce19c34d150.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Awhile there are requests in the allocation cache -- use them, only if
those ended go for the stashed memory in comp.free_list. As list
manipulation are generally heavy and are not good for caches, flush them
all or as much as can in one go.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64d3f3e2e93d..17194e0d62ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1953,25 +1953,34 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 	__io_req_complete(req, 0, res, 0);
 }
 
+static void io_flush_cached_reqs(struct io_submit_state *state)
+{
+	do {
+		struct io_kiocb *req = list_first_entry(&state->comp.free_list,
+						struct io_kiocb, compl.list);
+
+		list_del(&req->compl.list);
+		state->reqs[state->free_reqs++] = req;
+		if (state->free_reqs == ARRAY_SIZE(state->reqs))
+			break;
+	} while (!list_empty(&state->comp.free_list));
+}
+
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
 	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
 
-	if (!list_empty(&state->comp.free_list)) {
-		struct io_kiocb *req;
-
-		req = list_first_entry(&state->comp.free_list, struct io_kiocb,
-					compl.list);
-		list_del(&req->compl.list);
-		return req;
-	}
-
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		int ret;
 
+		if (!list_empty(&state->comp.free_list)) {
+			io_flush_cached_reqs(state);
+			goto out;
+		}
+
 		ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
 					    state->reqs);
 
@@ -1987,7 +1996,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		}
 		state->free_reqs = ret;
 	}
-
+out:
 	state->free_reqs--;
 	return state->reqs[state->free_reqs];
 }
-- 
2.24.0


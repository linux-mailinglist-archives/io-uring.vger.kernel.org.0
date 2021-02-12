Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412EF3198C3
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhBLD23 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhBLD23 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:28:29 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF218C061756
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:48 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o24so7893015wmh.5
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U+GtQ//OBuqkv0pyOrByLUPECi8KpkGdGWFAbHbGm3s=;
        b=C1RR/tJHUicxQxfd8aJTMd1xhYvg5fEt7ChK9Tu+Fko5NvPfoYaw4BAvk4gb3r9X+6
         Ek/lhFlMSF1C3ngQqn2R09xj8XqaGricaRUhOnNWRWO6DBCssqkmmLtwlLVy0DnSNh4g
         njoFLF1mgfhXErPBlX23v+frwdWzgNXvGC6Yr1AC0shZxTNDfugxyQkzPfYhcGHC8/tQ
         M6mwApckU7Ig3EQD+6eSI7q4uY5LW8UYTiC5imeTL2TRGRFMWjamZacVrdYe+/ksFeGC
         Y/FueV8yBmyr5YEgsEegasthqFY+0pVJzTpHcYpeMLfybD6Z6CjkFYYc4qir+rsqUlP0
         hksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+GtQ//OBuqkv0pyOrByLUPECi8KpkGdGWFAbHbGm3s=;
        b=cvSf0pdTBFxNcNX+3MQGmIWrkmKYfKVHUAPKyjZ1xogQru0bY+ND3FyZmOqW3DXQAS
         CoqtI3RCqR42u6GNPA25MCLsn7gtjtp5AvI26P/t1DFvi6oRFo5/3eZuTIBoo31v7XmA
         sRDsbfTuzNKNuXzFqbbN02Il/65sMON/wq2d68/PGwxhbnKhcG8a/9DUfAMGInrdSw0T
         MOHo4G4hMB+/94aUbXMG5BnbscKDtAZ6rIPzQ5z2XrsIDgiT1NXgvOBrRk0CCG0FN3uK
         4/kH3w5Rqr6lPBVGl68hZB5L5LOU4wq7TsrxOO4+ocJoK9AuDCxNL0MgoL0ITCf28lMS
         qusQ==
X-Gm-Message-State: AOAM533QO/FnGyj84U/r+4ix2INtaK3QfnlLKjAg6ivZZN0vTakL3XfH
        7zGMmdfX7+gD763lCuf2khFp1Fj4BWH3UA==
X-Google-Smtp-Source: ABdhPJz3RGFMAg5cc1r/P7t8fyUdQGc6htRhAbZgZxiS0wifafoEA/MHCa/D0fw+Z8aEkFVlNRwjlQ==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr764699wmq.160.1613100467774;
        Thu, 11 Feb 2021 19:27:47 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: take compl state from submit state
Date:   Fri, 12 Feb 2021 03:23:50 +0000
Message-Id: <7801c44cf4d6f8a5093d65ce5b6fdb86b2f94d8d.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
References: <cover.1613099986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion and submission states are now coupled together, it's weird to
get one from argument and another from ctx, do it consistently for
io_req_free_batch(). It's also faster as we already have @state cached
in registers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7b1979624320..8c2613bf54d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2417,13 +2417,10 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->ctx_refs++;
 
 	io_dismantle_req(req);
-	if (state->free_reqs != ARRAY_SIZE(state->reqs)) {
+	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
-	} else {
-		struct io_comp_state *cs = &req->ctx->submit_state.comp;
-
-		list_add(&req->compl.list, &cs->free_list);
-	}
+	else
+		list_add(&req->compl.list, &state->comp.free_list);
 }
 
 static void io_submit_flush_completions(struct io_comp_state *cs,
-- 
2.24.0


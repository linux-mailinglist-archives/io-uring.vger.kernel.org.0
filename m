Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACCA34234B
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCSR1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhCSR0z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF0C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id p19so5880294wmq.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0/lZbrZpwazEnXHDhWuypvoXCMvcboLmJwq+xjSGfnM=;
        b=tCavWi3dNEaH2UMxwske63Nh68GHia5sCo/8dlNynKOgyf8sbj1FH2ol0AkM33Psse
         4UgLlgd9YglucrF2E1P8LmnqOS41EnGNKSF+ilmpikOzzEaTXyobWDmWHg8Dt+79g1QT
         jw0JKr97HUzis6Ib2jhRRxKn785PzYBo3A0Ux+JBStUe/TMjEle0p4HW7I5mq3y2WKOU
         isEgLTBxLPs56cAYtvy2oApAK7K53xxbiMOCnumBnibuuVdUPBCudmi63Fm+ouAMXIAH
         FfcVw7B5eYpq5pISUeQhXuzUNFuUBIi/fLDFacPiJRnoEI+O+n3u5Eh4CIiH38DWgf+3
         PSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/lZbrZpwazEnXHDhWuypvoXCMvcboLmJwq+xjSGfnM=;
        b=KcPdCP7ySilMoPhBwhax4C0KsiOQ5/eyRYq8JNrvimyFYGUzHUWmkgZwD+NRxDjDLF
         3dME6Z1bPeZWW1ec7gYz1p1yOOJ6nMnuTRCGBmCm7rBo8tP7tDs4EFVEVIQ1GXxDvXFb
         IS2RxQ3wdlx5O0ILYkkp9s0NkD6t2YZp1kEtKxXz6jKC1sIMbhr95YR7W3e6OMQ3t0gX
         xTXjKtaweLsDWyD3qtiVHBMbPxXEl59O0TFj6K2HrIowPiI9B9onpJ10EE062sDnTBGs
         XH1S4NdJg3JfNRePdZ9PVEzvAyg1HAiXK9IHoba3DrKqbbF02hSpT8Riq0DlEXKXeQ6p
         4L8A==
X-Gm-Message-State: AOAM532GRd7RFv48i5pu4wqJG7hzVD2nFY3AS0qfwlDBMqeTSvZONmur
        JmaydH/+ijo/aZKikp2mD9c=
X-Google-Smtp-Source: ABdhPJz9UtiwvCWkDFllINUgwOQKSOssBFh9sgUpA0JGtd9mTYscQeHTuFYAOIknUH4bb5Pme7/tCw==
X-Received: by 2002:a1c:f701:: with SMTP id v1mr2680443wmh.69.1616174813904;
        Fri, 19 Mar 2021 10:26:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/16] io_uring: keep io_req_free_batch() call locality
Date:   Fri, 19 Mar 2021 17:22:32 +0000
Message-Id: <d3cf238567d3b074286f82b9223e75c2b64ff1c1.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't do a function call (io_dismantle_req()) in the middle and place it
to near other function calls, otherwise may lead to excessive register
spilling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e00ac529df0e..e8be345c81ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2132,6 +2132,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 			      struct io_submit_state *state)
 {
 	io_queue_next(req);
+	io_dismantle_req(req);
 
 	if (req->task != rb->task) {
 		if (rb->task)
@@ -2142,7 +2143,6 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->task_refs++;
 	rb->ctx_refs++;
 
-	io_dismantle_req(req);
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-- 
2.24.0


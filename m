Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA520C0EC
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgF0LGo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 07:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgF0LGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 07:06:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9222FC03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g18so11920932wrm.2
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jomXdJsemw15WRBddyJR3q6+FA64NRb4bAuhM8gG+9Q=;
        b=JSaVhNp5JbvooqXddGAaSE/cR0s56bM0uTat71PdPIys/Ad25lxk/EqaspDDkqH/TZ
         sfkLfxxyVxLsdfybiXI7N2143uhQNemUmSgj2kE1bPCFXAn4QzKgWoHb9c5ZbG2TtHw0
         rH3d5nJMh2Gp4uPDPkFiPPECEXJDo7AOPw+6nniqfqHvhicIfO7pRt4wMRlcsPRwWkI+
         JzxfSW4DNJhbiXSyGO/u5se83b1ppXOgr0BO9tKzoM4nOqpvNfnBhwEKnkVb2EwepjaD
         l7nobXMAd7lXz+YFuiMvBe+bx0wZ6TP1Ix+JXx0TIfsaEUqxv3Ov+eWxNWhvurFy0GUo
         rTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jomXdJsemw15WRBddyJR3q6+FA64NRb4bAuhM8gG+9Q=;
        b=Odxh9PlVBQdDd1tdgf7IwdI60IOFcr1pTeVzZO1x2fwzysaoFphR3xqzHKu1pkILYg
         qVGXKDRM8mtqo+P/y/FIkRUV1Y3HjD9BAaIJV4dSbii1OfSg1ktyubnhPpp9eBbLnRpK
         LeGHyK9rxUDiHiWtqUmkhwki8hjLSyHovFAi0UrqSRIdR009foucpC/idbZc2F8L2gTh
         xJ8mQaLIhcreXeljFA2HWvtD2QHPz2ciG7a1qQfTSZaJHlo7Z09XzDc7R1E9E+Hq2zqs
         MbHwFUDck8Jq2cv82B1UGNx13GOir5mD2K2rAxqhyWDDZhbuY19skuJpnB4mmxL6j0N0
         iHXw==
X-Gm-Message-State: AOAM531TCVz1J5UBLcpnbASxD4y8uc+D/6LRIePvPnyUijiQlrn9JMVO
        F2yviQO7I4ESAK8MHwFMl0MgScFk
X-Google-Smtp-Source: ABdhPJxR9dIlWxiTpgLffaOjSFPAExVFDGV1BAo29fuvms/O4bKtHBNxizVkVzBnEXlVqKOXZ8AdCg==
X-Received: by 2002:a5d:6342:: with SMTP id b2mr8065698wrw.262.1593256002318;
        Sat, 27 Jun 2020 04:06:42 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x1sm14706721wrp.10.2020.06.27.04.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 04:06:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: fix punting req w/o grabbed env
Date:   Sat, 27 Jun 2020 14:04:55 +0300
Message-Id: <51a75fe36d01de3c8d5f24dce8ba1b8248c16594.1593253742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
References: <cover.1593253742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not enough to check for REQ_F_WORK_INITIALIZED and punt async
assuming that io_req_work_grab_env() was called, it may have been
not. E.g. io_close_prep() and personality path set the flag without
further async init.

As a quick fix, always pass next work through io_req_task_queue().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index af4d7a5c49f4..e10aeae8cc52 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1766,12 +1766,8 @@ static void io_free_req(struct io_kiocb *req)
 	io_req_find_next(req, &nxt);
 	__io_free_req(req);
 
-	if (nxt) {
-		if (nxt->flags & REQ_F_WORK_INITIALIZED)
-			io_queue_async_work(nxt);
-		else
-			io_req_task_queue(nxt);
-	}
+	if (nxt)
+		io_req_task_queue(nxt);
 }
 
 /*
-- 
2.24.0


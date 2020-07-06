Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A23C21593A
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgGFOQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgGFOQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:16:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6FFC061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:16:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z2so18866928wrp.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=a6BYrWqSBWIaYUp6dlfRFfZbrPPaLhqsSiaPBrMCUaA=;
        b=F71nCTLutNGu9sKWgZW95M0o01UW1e3xs8xu3FfQ9w7ECigezThhNUdYVrSc7YN/5J
         qKvqK0m27yWfcv6DgOktDoupEBgvKyn0dsNa0mFDgWxocVSoF/UxRXL1n6uQt/pUS1nN
         /NzIYUF1Lriw6QeErzHPRWUGPiZOkzYszMw59jySLXXx19++B0/K0Vuv/Wh2EddvOMqg
         /sZReNtNl9l/1CXnLJpJK4Ey+Kg6Kl7AuQoq64BhwMgXRYe2piMaiXkw26OTgZeWcThw
         Y4glGVT5gvQxxpKBrEHpbROASnMtKba8FNnifeX50UdJB6aOtVw1u4xswdakNp6SY+cR
         BMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6BYrWqSBWIaYUp6dlfRFfZbrPPaLhqsSiaPBrMCUaA=;
        b=LYxdJ9we3VpHvAtY4NyTYgPTu6yavKZevUS+scUWMu6jn60jRY8ZXvA65bPInD7EHB
         mv8ySxLq6nvgCtxoRgumGhVP2aneBOBwaLwnlZsiIBpphlJwwOuacjJrxBTYy2gq9n9t
         O0OMuKCTPysmS6BpEfiH97t+T4uxPA7xiDoerlOro3sZ4oS3zTtxS2XAvem+Hax8Q5h3
         StXOG9AS6xLFJmac+wxUpyzNvb/tCRRZfQbjwGb9z2CTiKo9A/Pu+kYnhmwoNJNBA9tM
         pNS3o1nY6BNHzAL9ZugC2hlyF9v4PyZQg+i41tDGoRQIgIZzI5Me54nEc4Fd9Z7J5jrB
         r7vQ==
X-Gm-Message-State: AOAM533waK1KY7xYgixhFOxtD6jZS4+weueU/G5vWR+grgn1Cuv/vHcl
        6cc4owyUFxVrqlGInCYrxoDlNqo1
X-Google-Smtp-Source: ABdhPJzL28DkSoEbP62dS7FjUN6wUtYxJoJcqkzhzCFThCptkop9Xraf5YZ+syCT77Nui8yVPXcb3Q==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr53264166wrx.219.1594044970956;
        Mon, 06 Jul 2020 07:16:10 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 1sm23719286wmf.0.2020.07.06.07.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:16:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: briefly loose locks while reaping events
Date:   Mon,  6 Jul 2020 17:14:13 +0300
Message-Id: <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594044830.git.asml.silence@gmail.com>
References: <cover.1594044830.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
For instance, the lock is needed to publish requests to @poll_list, and
that locks out tasks doing that for no good reason. Loose it
occasionally.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 020944a193d0..568e25bcadd6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2059,11 +2059,14 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 
 		io_iopoll_getevents(ctx, &nr_events, 1);
 
+		/* task_work takes the lock to publish a req to @poll_list */
+		mutex_unlock(&ctx->uring_lock);
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
 		 * in this case we need to ensure that we reap all events.
 		 */
 		cond_resched();
+		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
 }
-- 
2.24.0


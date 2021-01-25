Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427A2304A3C
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbhAZFKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729A0C0611BD
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:22 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d16so11362958wro.11
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s9/qaY/Nb9LsSoZDXsPlKfu77GSe2ww9TcdetCVUIVU=;
        b=MthzNxeOxJPbhkhgd2P/3tRUltfH7YktGqSFn1PocDCiSQKchO0/iwiAJiz45GRkEc
         D5FFFhKio5RtwuWzqu+F53N7pRrzXM8I6vKj6MvhzqP9hK7573WL42Q4qJEwh40kVbUB
         UGJ0yGmDMH+29guohWDQGIMHlFE3jtudfVY2cqqaKtk8mLOfVMTtEC1fI+2DhvZkmkI/
         ksIgrxjvrMi1C3Obu+/UpVeOzziLQg8kqn1J5JijAjLOq5I6f1Iqqx/IaP57oWfq8ruv
         xcERRSS9VNuI3m/uDeTJ4K8cJcdoXpRLMU3WDUXYs/AejRKJTeJpFj5d1RCTBxbVUzyO
         019g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s9/qaY/Nb9LsSoZDXsPlKfu77GSe2ww9TcdetCVUIVU=;
        b=qR6mgEQmjYVl8H6+2Cmnnysdl2ruIz9jHC+gZZ3nXTS1rvj7ZEB8xWkr+YpIeILMSL
         c2LRGhS16zuDReKQ96Tj2BFekorggCCUjNvUxbtv1SUfMRi59Nf/tA7a7zy9u8xtTp80
         OScTXHS5m5xTvdhKbOzRscM7w+nujohXUPOYyo7FOf4o/N2krQHTDMUj9Tu8FfzcONLM
         +oyhsfa8+yr34Aaw8rlRHpAQDbc9V0tdW37/uZwj6ZC1VMvYMfwSyeXs1lbajhVGoVI9
         K1I+8cK9OPXgfYP1UnNZ/I56dJyI14mHq/3q93OUHDmrw50h1rBWwzO8APHuXiru4Ygm
         4Yjw==
X-Gm-Message-State: AOAM531kwxPAs0H84NkQ/zYYO7Z2S5lYZ28pfp58TyVeuiNUQ/K7nazc
        GEVE6ZruB7UxaFOkUoc2Y/Y=
X-Google-Smtp-Source: ABdhPJwhS3PPBqb01t7eT5LnG5X1CL00hcPor6Vxysv1kLfPnSz8okl6WWRlQDKowQqWgix57WGVwg==
X-Received: by 2002:adf:ee0d:: with SMTP id y13mr512463wrn.228.1611575181249;
        Mon, 25 Jan 2021 03:46:21 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: keep interrupts on on submit completion
Date:   Mon, 25 Jan 2021 11:42:27 +0000
Message-Id: <1645f7f935aa833231ebaad974bc37890ad9a2e3.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't call io_submit_flush_completions() in interrupt context, no
need to use irq* versions of spinlock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a720995e24f..d5baf7a0d4e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2291,13 +2291,13 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	struct req_batch rb;
 
 	io_init_req_batch(&rb);
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
 		__io_cqring_fill_event(req, req->result, req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
 	for (i = 0; i < nr; i++) {
-- 
2.24.0


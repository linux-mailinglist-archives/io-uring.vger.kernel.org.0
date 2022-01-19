Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BF2493312
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351020AbiASCms (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351036AbiASCms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:48 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C057C06173E
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:48 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e79so1055377iof.13
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4zzoldbWfdTCp5m3EbpzX+b83HRt9eqlJtM+r+MRPo=;
        b=6DjKSY5cvx6waAge/aoRHBWJFWuUNgeEHB0lKjBHjhDjkZEv31fS135KEYfaVDjHSQ
         NpViQWGTK9uDipS5mXzSWfq9nXiRsUKMBgfU5AIh0UC73tmcwEq3k3KdlENGyGcCyzTc
         owumz5PlzrPPOAGDdXwqctKn7lH1vXzLrD32g8QdwHCv8ckkT1kklqKhmo/N7XYB2GBs
         NrETOXxGvYW4QtFmjMGonOKgpM0IEk3sKYsJ+mAqVniGMtNX97GolAy/H8SEYJs12VVt
         1j57C6LmxLIgjDCH9Fknes+np/ymsNAS1ITJVQFLXoBySzziDQkt9OE9nVhYcZTH7Ina
         M6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4zzoldbWfdTCp5m3EbpzX+b83HRt9eqlJtM+r+MRPo=;
        b=tkLEd2gXMgtUSGY+jwVO3UpNvhqXtlAd0H8AZvLg4oPKO8XjV9gc8yaLkIwhoFGb0v
         CUNZ5jcyDesyuRcQgMGxsJOcXUYVT7DrXCiNHGrR4zbQY615AnGDd5w+bJzOhmqJERWv
         9QbWrrRU0fdfxQF4cuxSZnCOs2BQQ/qeSlsbePAYJZWoVzq3+oVyWbZhJ/ipCKe37JnT
         dJjSTLazXvPyvMtQItztRreKu11uTxLVcdWr+Fec4Cg14JXw0tm7PKcP/Ftkz+hzW9fF
         JRm63hasM7jlMfkP2cHOMoNdAJl4BMOMj73awT/DP2fHaNJ5Q03symHc9N0/MG/E2cOA
         WLsg==
X-Gm-Message-State: AOAM530OjoTnnJI4qmfXAdlslakKfsN6CIWGkA+IOTFgC7RU19OsxXe+
        JQwEE2Q0ItnaEK+E7+rlgbiew+un978vVw==
X-Google-Smtp-Source: ABdhPJzlx7Dk45c0kgLFtHBzNFnqoC5fBvTWA5wj9qwJUKlEbJUByVzU4pwiRIr/Jqx35jY4T8gikg==
X-Received: by 2002:a02:9699:: with SMTP id w25mr13382546jai.27.1642560167498;
        Tue, 18 Jan 2022 18:42:47 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io-wq: perform both unstarted and started work cancelations in one go
Date:   Tue, 18 Jan 2022 19:42:39 -0700
Message-Id: <20220119024241.609233-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than split these into two separate lookups and matches, combine
them into one loop. This will become important when we can guarantee
that we don't have a window where a pending work item isn't discoverable
in either state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a92fbdc8bea3..db150186ce94 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1072,27 +1072,25 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	 * First check pending list, if we're lucky we can just remove it
 	 * from there. CANCEL_OK means that the work is returned as-new,
 	 * no completion will be posted for it.
-	 */
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		raw_spin_lock(&wqe->lock);
-		io_wqe_cancel_pending_work(wqe, &match);
-		raw_spin_unlock(&wqe->lock);
-		if (match.nr_pending && !match.cancel_all)
-			return IO_WQ_CANCEL_OK;
-	}
-
-	/*
-	 * Now check if a free (going busy) or busy worker has the work
+	 *
+	 * Then check if a free (going busy) or busy worker has the work
 	 * currently running. If we find it there, we'll return CANCEL_RUNNING
 	 * as an indication that we attempt to signal cancellation. The
 	 * completion will run normally in this case.
+	 *
+	 * Do both of these while holding the wqe->lock, to ensure that
+	 * we'll find a work item regardless of state.
 	 */
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
 		raw_spin_lock(&wqe->lock);
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all) {
+			raw_spin_unlock(&wqe->lock);
+			return IO_WQ_CANCEL_OK;
+		}
+
 		io_wqe_cancel_running_work(wqe, &match);
 		raw_spin_unlock(&wqe->lock);
 		if (match.nr_running && !match.cancel_all)
-- 
2.34.1


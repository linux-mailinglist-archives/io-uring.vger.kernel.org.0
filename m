Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576CF334BE0
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhCJWpL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhCJWos (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:48 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4FFC061763
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so731473pjb.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INXxMnGuJX13IYEybBa4uRAwFWGQA1vai7wLsvxtKDU=;
        b=UKqgHmGieJ1mzvyFSvOC9Hqvw7G9A/TU7DtITPX/2vM7FlMI5C9h3Sm3d41dmKZ82q
         b9zuzS1T2Etw2zSrDlfeI4IIwAPbe6qql2k1i18SXal0Dm3SYrMYQBKhxlWefEieyoZx
         cN/TGFM/zc7NwCHULWN8Em35wLP4t3lT+e5Ak2pmgGXIrKpHEM2R48365L0PH+B5FMLR
         CPmoKSKTcJfA9N9LC3vnkxlk6hNQppDo1wgFd0p3YI95edNUnknZUKRjp8fJ2GZReCzb
         O1L43dJsiumHtIEaPvV6LXQ4E58Yf/IIHiKD6T71+V0BGjBnu1/WkHMXQn/6uI3xAbS9
         3Abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INXxMnGuJX13IYEybBa4uRAwFWGQA1vai7wLsvxtKDU=;
        b=WuyWuFoUBXds5R8GoVkklkaZZzn1/WpmEjAvjZDVnh1nixk1/BxuOiA2uDEtckNPDI
         hIMKfcrvT3yCIP0dUS8fEVA1oWNyvDa/2+chPXm+MO24s2qEmPXORp1L4OUwddh/mziW
         9NsGECr11LCAbzfBZ7pdiIcB+MmPjJT5dymIiqcX6vg2JcRVjCore8OP8KgsnWR+Vv3n
         NxK2w6iyjiN4I4DxUUeiUxzxypPS7I5TDfbWU1JL5zdZ2Itea73Nrsi9wBtOX6xd0A/M
         WRB82lZpoPNTHJrTk3louBTdQ8FMIgURuB41K/a1LQb0elHV+qCkQEjaFKQ4/qazwHWV
         323A==
X-Gm-Message-State: AOAM530o4taO9sHSlvuqTD0h5fgf/0M7ikiAnJx7PeDBWknTNHmoGwaF
        cNNruRTEjLmIshKeUobCjaYxY48sxUPW1A==
X-Google-Smtp-Source: ABdhPJzz6PYEyyWOr0Gf1az6ZtkuP8vvgjt2KULNipG0JT2D2hRJAZZubNOe1M7puvgY2fQZ1YKtLg==
X-Received: by 2002:a17:90b:1213:: with SMTP id gl19mr5663282pjb.55.1615416265374;
        Wed, 10 Mar 2021 14:44:25 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     yangerkun <yangerkun@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 21/27] io-wq: fix ref leak for req in case of exit cancelations
Date:   Wed, 10 Mar 2021 15:43:52 -0700
Message-Id: <20210310224358.1494503-22-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

do_work such as io_wq_submit_work that cancel the work may leave a ref of
req as 1 if we have links. Fix it by call io_run_cancel.

Fixes: 4fb6ac326204 ("io-wq: improve manager/worker handling over exec")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/r/20210309030410.3294078-1-yangerkun@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c2e7031f6d09..3d7060ba547a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -799,8 +799,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	/* Can only happen if manager creation fails after exec */
 	if (io_wq_fork_manager(wqe->wq) ||
 	    test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		wqe->wq->do_work(work);
+		io_run_cancel(work, wqe);
 		return;
 	}
 
-- 
2.30.2


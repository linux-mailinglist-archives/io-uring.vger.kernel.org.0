Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F139031FD97
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSRKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBSRKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:35 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207EAC06178A
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:20 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e7so5070247ile.7
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWGNZl7qTnYzm7tEvyVGJlOoZYW8EYzsNMFZPU8idQ0=;
        b=dWIJ9RtM/PHY/6u5p6tNudgJjKCDZJev5W0u6FSuita/E+1wksYrZXAJx1w84g8d4L
         yhZnHRRSZGUAWQYwqbfA/OlcjeqNaC6Hb7mdQPGYPzwg+vENClNctPLZQMWZIuVhNFy3
         RDni2zWEfq9x0rSKLRDD4LrvCX69yRk5Aez878u/9HlNViav1VeVG56a8mSM6UipnbAb
         lr9SXSnhtX4o6gHxywU6uHszvyXmVZFkni+2asn3Fl3vRlv5+g2v8atE9UtXXBDheV28
         t6mr7aVDX0EAvJOnfjfYZXahersa6yfnqto+nf+G9NSp0sJbd/yP8TLZS3m4FOfCaWLo
         xYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWGNZl7qTnYzm7tEvyVGJlOoZYW8EYzsNMFZPU8idQ0=;
        b=aAKoNkqqfwmSuuX1ZLtAIYxYaodfbzfwueZizhPYQ8X5Fll66qOTlDRAYVtX00YpkE
         5/hJp723CbhYnqbY7XaBdtfNj/DX9h6hjFFsiOZ0OmecYbTJflrnqke8LvbeiEuTY+M8
         MKXPU4txXlXDGi6dH50vPF0NjepZ2FWrHaq0e4k0dbBXo8WmbfQaKxbGWL3SWaxFmSGg
         QQPwge73Our+naAx+C++dfOWinoQPSbRD0aFDFow0w29eEGDW1UFY63gtUHQWLCZs8ex
         Hj+hWeD3SU/8RQVm+0NcQ1qsU4GKOqDu1A3i69Ps94UUToGhAyRtrOODIGBDPj4vMot0
         uN1A==
X-Gm-Message-State: AOAM533yYJI3qx/JLV2TnLpCE9wG8l5q9QZ24wQ61/UBaZ2N3LCTUfoD
        hSB5H+KGzGEvdIrzb1QGWPHyqh459Gd1nyKV
X-Google-Smtp-Source: ABdhPJyTdWvhQjLop02sREome4gDUEQMJrW+5zx05bxaJIvvpQpTdcrn8G6VMEv3Vwu7tb06tASR8A==
X-Received: by 2002:a05:6e02:1c0b:: with SMTP id l11mr4539074ilh.187.1613754619282;
        Fri, 19 Feb 2021 09:10:19 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/18] io-wq: don't create any IO workers upfront
Date:   Fri, 19 Feb 2021 10:09:54 -0700
Message-Id: <20210219171010.281878-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the manager thread starts up, it creates a worker per node for
the given context. Just let these get created dynamically, like we do
for adding further workers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 800b299f9772..e9e218274c76 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -759,18 +759,7 @@ static int io_wq_manager(void *data)
 	struct io_wq *wq = data;
 	int node;
 
-	/* create fixed workers */
 	refcount_set(&wq->refs, 1);
-	for_each_node(node) {
-		if (!node_online(node))
-			continue;
-		if (create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
-			continue;
-		set_bit(IO_WQ_BIT_ERROR, &wq->state);
-		set_bit(IO_WQ_BIT_EXIT, &wq->state);
-		goto out;
-	}
-
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
@@ -796,7 +785,6 @@ static int io_wq_manager(void *data)
 		schedule_timeout(HZ);
 	}
 
-out:
 	if (refcount_dec_and_test(&wq->refs)) {
 		complete(&wq->done);
 		return 0;
-- 
2.30.0


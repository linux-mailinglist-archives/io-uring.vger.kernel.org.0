Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773EC6E8530
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 00:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjDSWsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 18:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDSWsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 18:48:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F10B1703
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:09 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b875d0027so98599b3a.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681944488; x=1684536488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/SELsnLsHCK0nWRVSzVqzlBrRNbSGa03JgUvF3IRuM=;
        b=2e7I9RasgqGELyVyPoI+RRRoBqZ03HqSrcxGlz6Pff+yq3nwnL+FExxBWm5Dd65cph
         lvY7rwaJRnLTccIj8FDM+dNfLRVZ/eP4vPtU88qbplR7RzrhpGIaQqv0lmdCN7byCimZ
         6r1qMqdgkjhsdx9XcF27+3kxp+kWYboH70xgdz921+UVpR1gmrwzjErIMhiVM6j3IEuN
         cqTcHH+AF2/4fz8fy8hZbUrc2J++4PCigt3pvs8JCzYij5RGedb7rhc/UUYqThs/RWCt
         UEuwNQJTNTY3LqsbBbrZw0mEM7RfOci93GY2fpjTk6wHSN7KFNcuiruuCCnYYy6nJhWW
         7lGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944488; x=1684536488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/SELsnLsHCK0nWRVSzVqzlBrRNbSGa03JgUvF3IRuM=;
        b=FWllX7BSIX2mf/10bxNGV0AzVRxlMUhCeOaZcTurMRYqSmDxwR0B4CGWC+P9JoKDh3
         8RcHZ9HV4EtUjueAJodmX6y0c3t7ZtwDWTgmGNvfdSzVMq61jaBoPtpTWkMtcuvKPRvI
         11/dCi01QF5nXKhuIkVdHLiN/OX4zzw+3bAuy33lDGRLZp6q9e+K8sPWZ/H9BypfpJHX
         Wl/sMN94fSC5DJMYMEyTh54HKqSKgBOyPa/RYgfuoopUVjQXB6ewlv/7XXxKT3klBU7V
         RU/uK/joTRGGOaEecsaxkLIUhr3FkcS+Kf/KipAK3pJG3GOXyvqtTGpIai/2aLhzcIph
         xfIQ==
X-Gm-Message-State: AAQBX9dR47282YzjxNHefOtqWqzzDKXiQ762oZbxPig5BYlQo8v1s9jA
        +i0nORo0nJKZ8v0Bdr0azT1UN3AG6kkMEknvwMo=
X-Google-Smtp-Source: AKy350aqoRThi75COXuKx0digly5jO8YYNFoDzpX7JiIHxow4UjF8wkgXXOUIkewjjT0mYNCuuCjTw==
X-Received: by 2002:a05:6a21:33aa:b0:e4:9a37:2707 with SMTP id yy42-20020a056a2133aa00b000e49a372707mr22961680pzb.5.1681944488536;
        Wed, 19 Apr 2023 15:48:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a49c900b002353082958csm1853364pjm.10.2023.04.19.15.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:48:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: remove sq/cq_off memset
Date:   Wed, 19 Apr 2023 16:48:02 -0600
Message-Id: <20230419224805.693734-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419224805.693734-1-axboe@kernel.dk>
References: <20230419224805.693734-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only have two reserved members we're not clearing, do so manually
instead. This is in preparation for using one of these members for
a new feature.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 68684aabfbb7..7b4f3eb16a73 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3900,7 +3900,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
 	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
@@ -3908,8 +3907,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
 	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
 	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+	p->sq_off.resv1 = 0;
+	p->sq_off.resv2 = 0;
 
-	memset(&p->cq_off, 0, sizeof(p->cq_off));
 	p->cq_off.head = offsetof(struct io_rings, cq.head);
 	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
 	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
@@ -3917,6 +3917,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	p->cq_off.resv2 = 0;
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-- 
2.39.2


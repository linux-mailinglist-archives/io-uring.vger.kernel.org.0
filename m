Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D77017A6
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbjEMOQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 10:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbjEMOQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 10:16:51 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C9210DB
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6439bf89cb7so2100184b3a.0
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683987409; x=1686579409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeikUptRo1Vz/99SDRwOhdtFlNgW5Ls2g9rBhwcNCxY=;
        b=tMPX8q+pyByMbA8QOrNTz6ngQcxolut01rB3UnmmFisYxMDxWMIuAIPklHt+Q0Kjxp
         nyj8PPOp1Hlrp1s+WTF7QDjHSmEnchne9X2lwAjtQNKZ19JASaZ/hb8xBRjIsRvDLzIs
         3z9xqrqRkgDaKeI2LrCHZXmpDQSNgDucw2moE2GtXIrxr7FYkirMPsltZ4i603FlOSw3
         GnkaYyBiLFAKqLBZCYWKPtXg8y1CY8K47gmBWLgZtSQyX7NCZv6VvTCCKtSTp4Q4FxJV
         HiadtbHRwRqAvMvRPkwP79Cr84sFC3/BcERkTzNtVYoUOrLL35zN7RGSRQUpWRDGlBxH
         AvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683987409; x=1686579409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeikUptRo1Vz/99SDRwOhdtFlNgW5Ls2g9rBhwcNCxY=;
        b=BlNT1WrSLU2BL9GL23iCn5RHDhrVEnpiDqcRvRW1LJQVvsfMqya/MCz4ZYK7q59rhb
         6bV/PR/zlNH6eQeRk2yDnyWK5n/bFNtrshwJlAB+bVAUyfaIeyYuqI/u8+2NRWeaehRh
         bmLGbDeJcxU+uJt5ucY902kD06ZmGu3TZMGIN4/VAc8ragMsbuL/jX8mcwSuTwiipyU7
         wRDWiXxhSRukmlmzKjt1i3ToKkHORAFmPhoa0zWGkNKVL5fN/OP5fGqGuCPhRIVsYlpX
         0UWCRILvlAeVLel4uEcwlZpwIN8lU+ZGF00EgmeAhVxG5qKDQJ5+SejgCILpFgmkjB9t
         Pa2Q==
X-Gm-Message-State: AC+VfDzJgvHDldimv0YyJsvA9ROllCpdqvVMofyPZzLfT4PiP2IzhiJL
        7sq+ByRFHwiRDKnb24E7+yQGGeQ01f88lYaVK9k=
X-Google-Smtp-Source: ACHHUZ7pway0wH28HUe8S9WYzWeZHs2jIfzcllOxD9e9FRoNfGxOSZCVhUAy8m7PCHqrA+1CIheM8Q==
X-Received: by 2002:a05:6a00:9a7:b0:643:62e4:75 with SMTP id u39-20020a056a0009a700b0064362e40075mr38629258pfg.1.1683987409394;
        Sat, 13 May 2023 07:16:49 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o4-20020a63f144000000b00513973a7014sm8360027pgk.12.2023.05.13.07.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 07:16:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: remove sq/cq_off memset
Date:   Sat, 13 May 2023 08:16:40 -0600
Message-Id: <20230513141643.1037620-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230513141643.1037620-1-axboe@kernel.dk>
References: <20230513141643.1037620-1-axboe@kernel.dk>
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
index 3bca7a79efda..3695c5e6fbf0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3887,7 +3887,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
 	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
@@ -3895,8 +3894,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
 	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
 	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+	p->sq_off.resv1 = 0;
+	p->sq_off.resv2 = 0;
 
-	memset(&p->cq_off, 0, sizeof(p->cq_off));
 	p->cq_off.head = offsetof(struct io_rings, cq.head);
 	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
 	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
@@ -3904,6 +3904,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	p->cq_off.resv2 = 0;
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-- 
2.39.2


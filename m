Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407145B5081
	for <lists+io-uring@lfdr.de>; Sun, 11 Sep 2022 20:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIKSSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Sep 2022 14:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIKSSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Sep 2022 14:18:07 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBEA24979
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:06 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id cc5so2170256wrb.6
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/7Dk60TU8OMo0FEUlY5XbrNEevKq+ZNj0KLJElMVzrI=;
        b=BbgJ2xflBQZZRjAcMWsxagpsTyYmG2nKLOGOPvRiWpnFfO0kyJwQaVlnNDuc+fUlKK
         PuiP/5NgHOL0GRL9NTZo63l2bDz+PuU4qGlNHYgpDjR6m8hSixpq0YGHSP5eE+0I/1Gi
         jEnKDPi89y+/QYwaSHjcKhfvvatpppPAvM5tKmlFFqkCkf+C1fnxizS8wMTRxKgFxqRr
         wDPAREA+k96tBDKviuhoYFzf1cYxogZ7UTqfdyc75wBhDuPjXZ1lupkhP5QVho2k6In+
         fcNGBvwIhfPt0BrQQdUR299UZgnsSItF4PprCvtlzc+D07O1mgeMY7/GO0uvxgWroNLl
         YQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/7Dk60TU8OMo0FEUlY5XbrNEevKq+ZNj0KLJElMVzrI=;
        b=6rM8sA4DpGt2Do019JkGp/WqAuBFdhAu5+hcyfrkFZcpL669VByml+sKA1UjoiHK6t
         kfD0W98FgweT+4FQrsPUHqdgsZ3yGgV/n9H4OiiZm4GNUwH5Ljt6hd8naQjANe7SeHC8
         zB2I/IMySZ2m8Nv8S2DQWTf6bH+mvCrFA0v1Oi1afP/yJ3c0i84+ZQHbDO5rBlYlRu0+
         UjLlgrMMsG89ph6jnb3xSC2VRPGV0fgqonScbubI8MZiWl3ESjrEf5yItZL9gguCMKE9
         mdE3JR5EnBZTeizYp23Gdj1bpClhdkO/WzbmDbeLhclIGoCLt+BM+7QUkgUelGJdz9d0
         jByA==
X-Gm-Message-State: ACgBeo325Nda1+94gFNM4YDZMv6s90Fgu4hZwHPzYiO+YjFYz6JgASc+
        OTbzrZ+Uif5tk3Zj/hOHVC7ctrFwN8O9Gu83NTE=
X-Google-Smtp-Source: AA6agR5hjZr2kJBd8f0UUJeaGgnLKiBe9kxA7flchu4MAlQM55MWYMkmDwAYkB9Bt3xfIuQL2wMgQw==
X-Received: by 2002:adf:e4ca:0:b0:228:d8b7:48a7 with SMTP id v10-20020adfe4ca000000b00228d8b748a7mr12687607wrm.300.1662920284767;
        Sun, 11 Sep 2022 11:18:04 -0700 (PDT)
Received: from m1max.access.network ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id v2-20020adfe282000000b00228dff8d975sm5160056wri.109.2022.09.11.11.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 11:18:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/fdinfo: get rid of unnecessary is_cqe32 variable
Date:   Sun, 11 Sep 2022 12:18:00 -0600
Message-Id: <20220911181801.22659-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220911181801.22659-1-axboe@kernel.dk>
References: <20220911181801.22659-1-axboe@kernel.dk>
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

We already have the cq_shift, just use that to tell if we have doubly
sized CQEs or not.

While in there, cleanup the CQE32 vs normal CQE size printing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b29e2d02216f..d341e73022b1 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -62,10 +62,9 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	unsigned int cq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	bool has_lock;
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
 	unsigned int i;
 
-	if (is_cqe32)
+	if (ctx->flags & IORING_SETUP_CQE32)
 		cq_shift = 1;
 
 	/*
@@ -102,16 +101,13 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 		unsigned int entry = i + cq_head;
 		struct io_uring_cqe *cqe = &r->cqes[(entry & cq_mask) << cq_shift];
 
-		if (!is_cqe32) {
-			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
+		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
 			   entry & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
-		} else {
-			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x, "
-				"extra1:%llu, extra2:%llu\n",
-				entry & cq_mask, cqe->user_data, cqe->res,
-				cqe->flags, cqe->big_cqe[0], cqe->big_cqe[1]);
-		}
+		if (cq_shift)
+			seq_printf(m, ", extra1:%llu, extra2:%llu\n",
+					cqe->big_cqe[0], cqe->big_cqe[1]);
+		seq_printf(m, "\n");
 	}
 
 	/*
-- 
2.35.1


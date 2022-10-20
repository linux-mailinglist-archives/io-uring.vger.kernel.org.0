Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F5B605527
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJTBrk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiJTBri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:47:38 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D487B1D1017;
        Wed, 19 Oct 2022 18:47:36 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w196so21297374oiw.8;
        Wed, 19 Oct 2022 18:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9vUhRSZJCY7KpJC4RI1IvvNhYQ/fmK2CLSJSd1FaYiA=;
        b=cavVnV1m3N5NzP2tWUyolKWTQYTngRg094gtT/25DeHzYd3cgOWjrVH8E2jFKHLk51
         7nM4JDL6aJY9FpUkYq0AOl9/Nj8I2KPsCNhMYGpJyiaHvJyWEH36gMyl2F0bsVYstF2G
         HZLRxTqfQbFBaLai7tB4X0a8m78LCMDJ0LwWWzL1Mn0kzmzeEwUld6mMVhv0mVGaGS+j
         +/ymesLIVt92rAXvCMBttH2YU8rukbqCynenjijaD83UcgBInFC3EqkvZneoFXeRA7Xr
         Zj9nrObRMe8//Yr+8fCT78UJrJdMFzB2cdywEWX9ohFisY9DcNfybz/PCqkzyETz7/Z7
         sx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vUhRSZJCY7KpJC4RI1IvvNhYQ/fmK2CLSJSd1FaYiA=;
        b=2+y8xlEiZUVInjotwsFwPau1VM3QDAPluEZ5s57GHt8IO6emxqQaFmj8FFPCLaP3bD
         4s6a161BW7lSN35htKvrMQwqr5Cr39RwzEqkI0ZOvytcbzpSpkoSf39TPb3Z8/1OVxZq
         ecK0gc68IAYwQ57MECzxAeJKwc7g8THdOuwTih9Uxa/DogNWZMe256bUD3Ola3r3Epq4
         uIWD4My7vmB8P351zc/44He3jJ4fKQOyeYu3P+LenYfYwvoVodlqFBh4rH9L+NaJnB3z
         bYF7Cnmok1ZYw9raub4rmUYxsEcfO+lDd45fGj8mgPSBjHM7PQ2ErmDlex7DElHSyRft
         rYkg==
X-Gm-Message-State: ACrzQf2zeOWBFLe9Rv0qj6xZC4Pwr11DV7aN0mwKcrXzJHZJY3WAv1WD
        ABmE7G+gHfRVEjLU245yBh9P/KWmZ5I=
X-Google-Smtp-Source: AMsMyM6KyAp1lPo3/Ky++XR1l54cXcru3NtP2qcPOA81rcBKjKix6JjImvrcIFGYItXw0VLJdoFzXA==
X-Received: by 2002:a05:6871:5d3:b0:131:feaf:b826 with SMTP id v19-20020a05687105d300b00131feafb826mr7528563oan.129.1666230445909;
        Wed, 19 Oct 2022 18:47:25 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:1855:8393:57eb:548f:5125])
        by smtp.gmail.com with ESMTPSA id f10-20020a056830204a00b00661b019accbsm7659796otp.3.2022.10.19.18.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:47:25 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: Fix memory leak in worker creation
Date:   Wed, 19 Oct 2022 22:47:09 -0300
Message-Id: <20221020014710.902201-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the CPU mask allocation for a node fails, then the memory allocated for
the 'io_wqe' struct of the current node doesn't get freed on the error
handling path, since it has not yet been added to the 'wqes' array.

This was spotted when fuzzing v6.1-rc1 with Syzkaller:
BUG: memory leak
unreferenced object 0xffff8880093d5000 (size 1024):
  comm "syz-executor.2", pid 7701, jiffies 4295048595 (age 13.900s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cb463369>] __kmem_cache_alloc_node+0x18e/0x720
    [<00000000147a3f9c>] kmalloc_node_trace+0x2a/0x130
    [<000000004e107011>] io_wq_create+0x7b9/0xdc0
    [<00000000c38b2018>] io_uring_alloc_task_context+0x31e/0x59d
    [<00000000867399da>] __io_uring_add_tctx_node.cold+0x19/0x1ba
    [<000000007e0e7a79>] io_uring_setup.cold+0x1b80/0x1dce
    [<00000000b545e9f6>] __x64_sys_io_uring_setup+0x5d/0x80
    [<000000008a8a7508>] do_syscall_64+0x5d/0x90
    [<000000004ac08bec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 0e03496d1967 ("io-wq: use private CPU mask")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c6536d4b2da0..6f1d0e5df23a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1164,10 +1164,10 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
+		wq->wqes[node] = wqe;
 		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 			goto err;
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
-		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
-- 
2.34.1


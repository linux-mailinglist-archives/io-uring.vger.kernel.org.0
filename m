Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F597CDFBF
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 16:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbjJRO2t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 10:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345438AbjJRO2s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 10:28:48 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F8E1BDA
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 07:18:09 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-79fab2caf70so54875139f.1
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 07:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697638687; x=1698243487; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+Z8/O9mn4j3QDAJqTUQTfmMcmy4Ie6GtmpgNil5ar0=;
        b=yfiaquiqwoMVJuOc4FwAGm+bb1lYT2pC5GGVD4KcrEOgV2Cld/GnWLMK+4bOjF/403
         hEHMXBAHgoUkOEYdCDXAK99KRqIAW3agIpaJ/prTQXY7V5ViBCu4hLRI0T96OmaK/sDk
         AK8NvTUui2vIdY/e+ehEU/QMF6BTbYDBgavVOOp/oJjM86i0B3uLOda2NzM/UxCNJwPu
         TLogDvGLJFzKmg60u6EwSCMWG0eGZzW9M1WWKQRQPYbLdK+I8Ljv+pOhyx/4YnV5/sh+
         E3iM6GlR4zyfcwUE/90jcfXf22Zcs5r5lTjEnHlj2Yi2PP5fBxcoOLQjROm/Yw4nLXbC
         IeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697638687; x=1698243487;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E+Z8/O9mn4j3QDAJqTUQTfmMcmy4Ie6GtmpgNil5ar0=;
        b=T+bwEunOaLEC1wL0ORGVTuFtmQ+ehJFVSaBGRsbW1yKlx0QJw+K32zyuvKdKRoqzSV
         sQq8KJyHN8CymfhCHUfTWZGhRy5F/C+1Gkth3/cv7L6ZZOAts4Lo5VuPl6GrJ4rzdNix
         2o74Tbwna1FECJipwSBFDkrYCSIdjVE7oYVSA9U6Hbc7aS+AymUZpJ4TfUzATRuOAAEO
         xu/LSVnj8tFmuOPp42c+2mq1sh1W7ZoloFynLewYA7l6xvxO9I8hyJ0Aen7olbLkRRUb
         7sCEVQyra1XbecWBKnCOyFLpYNUBQHUQJ0XPHYVG2zCSvOJmgZB7pF92MOlHvT0/4jmZ
         zkWw==
X-Gm-Message-State: AOJu0YxOQOCqtib2W0LqpErsC+5sqmFxAgj9oEfrMm9Vran7YXP9uape
        9KiAc6a5P0TBv9b+b2/55Z2VJurJHCgO6ntRYpGV/A==
X-Google-Smtp-Source: AGHT+IGQ7WNDETLvmp+NauGD9s1IJW5q2WUsFJkqN6DVfvrDT9e3ONeWn2SidhVp0StujhN8gf4h6w==
X-Received: by 2002:a05:6602:340a:b0:7a5:cd6b:7581 with SMTP id n10-20020a056602340a00b007a5cd6b7581mr6889503ioz.2.1697638687545;
        Wed, 18 Oct 2023 07:18:07 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f12-20020a02cacc000000b004551b5bfaafsm1235204jap.48.2023.10.18.07.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 07:18:07 -0700 (PDT)
Message-ID: <51bace4f-a976-48d5-8752-1fef2350c0e3@kernel.dk>
Date:   Wed, 18 Oct 2023 08:18:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     rtm@csail.mit.edu
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix crash with IORING_SETUP_NO_MMAP and invalid SQ
 ring address
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we specify a valid CQ ring address but an invalid SQ ring address,
we'll correctly spot this and free the allocated pages and clear them
to NULL. However, we don't clear the ring page count, and hence will
attempt to free the pages again. We've already cleared the address of
the page array when freeing them, but we don't check for that. This
causes the following crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Oops [#1]
Modules linked in:
CPU: 0 PID: 20 Comm: kworker/u2:1 Not tainted 6.6.0-rc5-dirty #56
Hardware name: ucbbar,riscvemu-bare (DT)
Workqueue: events_unbound io_ring_exit_work
epc : io_pages_free+0x2a/0x58
 ra : io_rings_free+0x3a/0x50
 epc : ffffffff808811a2 ra : ffffffff80881406 sp : ffff8f80000c3cd0
 status: 0000000200000121 badaddr: 0000000000000000 cause: 000000000000000d
 [<ffffffff808811a2>] io_pages_free+0x2a/0x58
 [<ffffffff80881406>] io_rings_free+0x3a/0x50
 [<ffffffff80882176>] io_ring_exit_work+0x37e/0x424
 [<ffffffff80027234>] process_one_work+0x10c/0x1f4
 [<ffffffff8002756e>] worker_thread+0x252/0x31c
 [<ffffffff8002f5e4>] kthread+0xc4/0xe0
 [<ffffffff8000332a>] ret_from_fork+0xa/0x1c

Check for a NULL array in io_pages_free(), but also clear the page counts
when we free them to be on the safer side.

Reported-by: rtm@csail.mit.edu
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d839a80a6751..8d1bc6cdfe71 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2674,7 +2674,11 @@ static void io_pages_free(struct page ***pages, int npages)
 
 	if (!pages)
 		return;
+
 	page_array = *pages;
+	if (!page_array)
+		return;
+
 	for (i = 0; i < npages; i++)
 		unpin_user_page(page_array[i]);
 	kvfree(page_array);
@@ -2758,7 +2762,9 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 		ctx->sq_sqes = NULL;
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
+		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
+		ctx->n_sqe_pages = 0;
 	}
 }
 
-- 
Jens Axboe


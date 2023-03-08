Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6695C6B0ECA
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCHQbB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 11:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCHQbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 11:31:00 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8BC4C17
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 08:30:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so3831799pjn.1
        for <io-uring@vger.kernel.org>; Wed, 08 Mar 2023 08:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678293058;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gn3atpUmiXm3KxY464V5YB2rz0e75eJUtWFJL2KJEbY=;
        b=SPk6D1sPYtu+A1n8I+ykLmy/KyccrYDJpGLxOK4wywvrje5eyq1W1Lqpp6X7MiJr2N
         aW+Urjq8W1DExfz4nE6LvjT2S35rU+LA0WVrIh2vvribf4ZplaNLxOtdYrFarKkSUQrx
         6ifsFqwZh/iiMEC5XjmVsULk66GMq2u5gdub2Htuueurep1eBM1qvv6vbJfWXuqDX0+W
         saQDNwGVVsByMcAuSezLpF56N28Zuiavl/6O1oQPgg7RK2W0iolMcf24w+LXLhAU4GT9
         8eO9Ivw6+xu9GV2t/NRlaV4XPl4VWXLhUUdh07Xrm3Tl+G2P6xHzTb8VorcXPVHRDRLs
         kXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678293058;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gn3atpUmiXm3KxY464V5YB2rz0e75eJUtWFJL2KJEbY=;
        b=NlQyBCs1GKvdMsOvQBcduMJ5ih/zJVIQIO0Yi7J/PoswbHkpE7BRlL4QZYfR3tPIUT
         Rx2/q9pM8nS8OCcF3Bdl3zjj08Os+56ksioCLjS2xCZVzfOysaCWqU4s3EW5n+64mY1E
         TG0puuRLNI6/C3dZpWnFH1YLjy8EA5ZYUPCjf4w1RKQXfKTkRp7xxfLXtzeVbNdMFP7q
         iKC1IRMl9hoR0QXGISVN5F5avbSeVWBc4lk4vbNtt7CoHnjJjvG2c66E3Jv9enb/6j/D
         UKJhCqiXTkQKoLTVDyDpEmi5yGbkpwZ3mXNxhfxL08gAB3JekhvRWHicrH4grhLNHlTE
         hiNg==
X-Gm-Message-State: AO0yUKXUpJcNfzgyuIHJBGPgTEFBuL39BaohbkElwn15dk6so6Fzm0pc
        XbK3Q5za7IIkZCrCt0GFuR/w6LHR45qHWLZaQj8=
X-Google-Smtp-Source: AK7set8g1NTDC1ztAzEO+WxIdG65SRN/NYpeuedN3kf1+crN2/X0iqtG6qtyIqzphDmr1qcAyU636Q==
X-Received: by 2002:a17:90a:9401:b0:237:47b0:30d3 with SMTP id r1-20020a17090a940100b0023747b030d3mr12872051pjo.4.1678293058199;
        Wed, 08 Mar 2023 08:30:58 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id h6-20020a17090aa88600b0022c326ad011sm9056029pjq.46.2023.03.08.08.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:30:57 -0800 (PST)
Message-ID: <2349df76-0acb-0a56-bda1-2cb05aa55151@kernel.dk>
Date:   Wed, 8 Mar 2023 09:30:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: ensure that device supports IOPOLL
Cc:     Kanchan Joshi <joshi.k@samsung.com>
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

It's possible for a file type to support uring commands, but not
pollable ones. Hence before issuing one of those, we should check
that it is supported and error out upfront if it isn't.

Cc: stable@vger.kernel.org
Fixes: 5756a3a7e713 ("io_uring: add iopoll infrastructure for io_uring_cmd")
Link: https://github.com/axboe/liburing/issues/816
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..e3413f131887 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -101,6 +101,18 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static bool io_uring_cmd_supported(struct io_ring_ctx *ctx, struct file *file)
+{
+	/* no issue method, fail */
+	if (!file->f_op->uring_cmd)
+		return false;
+	/* IOPOLL enabled and no poll method, fail */
+	if (ctx->flags & IORING_SETUP_IOPOLL && !file->f_op->uring_cmd_iopoll)
+		return false;
+
+	return true;
+}
+
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -108,7 +120,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
-	if (!req->file->f_op->uring_cmd)
+	if (!io_uring_cmd_supported(ctx, file))
 		return -EOPNOTSUPP;
 
 	ret = security_uring_cmd(ioucmd);

-- 
Jens Axboe


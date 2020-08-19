Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB5224A4AB
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 19:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHSRNY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 13:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSRNS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 13:13:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B254AC061757
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 10:13:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so1399385pjx.5
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 10:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rkakKPSNFLOtMYVSLBRtJdaJENvCvES1pVoFVzVKQVg=;
        b=AHGncAmU+xxKPky1kwLV3sHi3N4S7at6P8wcPISuVhb3RxjZXMJu6pgxLtrsejFTXq
         a8qB5f7cZ0N9r2WezQkF+O6ssNaphHZB8D6JiBt2pjiHP4aZ7ufPfLgXEz01+SbokRV2
         zegKJ8GNDnPTerZSnBUAVs5DzbU3bkvGRLrU8SIqVmrBwUrSmds/Fp5qOoAaQ42NWRjE
         D7RG//pc/fE88jcp9glk9JP4bWbszkHKP262xoWTYrws/H2oDPyphgcFr1jUzugekiNm
         tVut+v0h/F3QuBU1nK1akRyfWAzxUJR47S3FpuHplgh2jfgwYqH+PGkTPINei4aRB5eU
         I8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rkakKPSNFLOtMYVSLBRtJdaJENvCvES1pVoFVzVKQVg=;
        b=HUmkQMFGV2TJzEf9GV5t900Bti1SJelHhACV2BTalc8Xvkjphp2hpk34oB8dKUskg3
         li6EAMnyBc8UobazjRzYSXlbHrheAevGBYcjKGuXbJVgyZ9Oahk+1MubwWJo7d/aMn/s
         XteCiHi26zZAZdeir8oA8SoIWPEN7eMV6N5a099OeZFPj3TOvWvvkE/xcpkZK3TRz8Mx
         7azhbHo/kwq5u3hhKCqT9s6tnPb3sLvWW/ij/G+dpCzMsohHVRtR8U6vKcP7gmhHh37S
         OzlVdduJg+UA/ceQCFSNc++/3S5z/32FBGn3egjso9jHTp7vW9hyyrqnMGuvWGM7Dygt
         xTrQ==
X-Gm-Message-State: AOAM530hPgUto6PCljUwJ4+czxamsijZK6668gw7cVPIMOPKsp+I0aLz
        fgtsMkhSCfIqcB/LMIXcGIr3iczCnwXvmjiB
X-Google-Smtp-Source: ABdhPJzvFDrE99Z6o1PUxvNsOauHahtb1pzH7llhq5ZUL7vgrTPaOdRykH1ojx/huxl+x++kU92HtQ==
X-Received: by 2002:a17:902:c151:: with SMTP id 17mr18798354plj.228.1597857197903;
        Wed, 19 Aug 2020 10:13:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y65sm28481383pfb.155.2020.08.19.10.13.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 10:13:17 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use system_unbound_wq for ring exit work
Message-ID: <2fd8aeb6-0348-750c-f965-dee1cd0301f6@kernel.dk>
Date:   Wed, 19 Aug 2020 11:13:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently use system_wq, which is unbounded in terms of number of
workers. This means that if we're exiting tons of rings at the same
time, then we'll briefly spawn tons of event kworkers just for a very
short blocking time as the rings exit.

Use system_unbound_wq instead, which has a sane cap on the concurrency
level.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e325895d681b..1f2f31d93686 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7960,7 +7960,13 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 			 ACCT_LOCKED);
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
-	queue_work(system_wq, &ctx->exit_work);
+	/*
+	 * Use system_unbound_wq to avoid spawning tons of event kworkers
+	 * if we're exiting a ton of rings at the same time. It just adds
+	 * noise and overhead, there's no discernable change in runtime
+	 * over using system_wq.
+	 */
+	queue_work(system_unbound_wq, &ctx->exit_work);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)

-- 
Jens Axboe


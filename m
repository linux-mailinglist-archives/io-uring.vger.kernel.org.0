Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBECA638E56
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKYQkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 11:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKYQkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 11:40:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B52BB10
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 08:40:02 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x66so4604239pfx.3
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 08:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsIG3Dy2loMjgOnTo/pWmRMFyq49jQtnnk8ADHvtKSA=;
        b=fs9JDb4xtn8mYnG+dd26U7UDIJhtUTirNdnxQeIu4AXv0+QIcMPnFHouPuG5qyxNM9
         W855nWkXVO4oOR9RwsEtbM3uMxR7JEoW3Vb8X1p6a1NF4E/xow0yM4lDfkEQfV+5QLfI
         qJ7pG4QdQxDS2tcS7R57FNEkAwJR60ZMhZ2wcjTDOSI5kkN+T/2ZSJdn8C12MqkmHEex
         Zj11uV2GbIP91IstnJbdbuI7sQJE3f9Xn2rZqLVlVMMFdOnWoJlcM4rYMMhAzObM7gbJ
         hEatTny+s8xVLYDcZWu0tiTL65ywnkjhRHDwayOhJs64Anr6lOK74m6Cr/xBc2QQxYH/
         BNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UsIG3Dy2loMjgOnTo/pWmRMFyq49jQtnnk8ADHvtKSA=;
        b=7irS5dlouhVgAehUmS50tTbmhnxyY0E6R6vcIEgh3dcBQ1znUubTL8P08U76O5ByX2
         I/WcaH2PLVwTmp0Fh2zTCNRkLzH4vPhU7OA1a4iGi0EBF2WEUBmsQq1zx+aEb2Zqg0tI
         p/yWjGGCDBBgmYWugJ1dOOinUa27goPZFptP/lA/FgalVuaFFsXM/Mq1owq5EoZ6qQI5
         WAcK9H9hENIO1wta5AP3zSCQDPVn5phfFKbgTNs0z5ztagUF8Z7eOolQZoCY3vy7DJ9j
         vSvPMiTJeLjRvG5SAJff1NfD16E48yVNiRaDI2zlmteAFm/oFriqjWAMHi+3yRr3DEsh
         UJ3A==
X-Gm-Message-State: ANoB5pnDOB/XHu6AfRKU/Gx4wbrVS1ubuMbyXkDUT0IZBEo/Okc45cpz
        kaRH3BhsUHsurs2bwTexhj+rAoebhLCo16XJ
X-Google-Smtp-Source: AA0mqf5+tS018wCGCTDND5LZlyr/E946JppkqZz+8DKlEeiP4QAVsKUasfxgT0mKYOABh4TENtZbLA==
X-Received: by 2002:a63:ed0b:0:b0:477:9319:eb4f with SMTP id d11-20020a63ed0b000000b004779319eb4fmr17310029pgi.257.1669394401654;
        Fri, 25 Nov 2022 08:40:01 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j4-20020a170903028400b00189651e5c26sm2043305plr.236.2022.11.25.08.40.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 08:40:01 -0800 (PST)
Message-ID: <df2aa5d9-af07-f439-6cb5-87b7814f333f@kernel.dk>
Date:   Fri, 25 Nov 2022 09:40:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not
 available
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

If we have io-wq or SQPOLL setting the task_work notify signal but the
task itself doesn't have task_work to process, we don't clear the
flag and hence will enter a repeated check loop if we're waiting on
events or file/buf references to go away.

This was introduced in a recent patch which eliminated gating the
task_work run on just that flag, but that fix meant that we know don't
clear the flag if the task itsel doesn't have task_work to run.

Cc: stable@vger.kernel.org
Fixes: 46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cef5ff924e63..0ecfa36c049e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -238,9 +238,8 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
-	if (task_work_pending(current)) {
-		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-			clear_notify_signal();
+	if (task_work_pending(current) || test_thread_flag(TIF_NOTIFY_SIGNAL)) {
+		clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
 		return 1;

-- 
Jens Axboe

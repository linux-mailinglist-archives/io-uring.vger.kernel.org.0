Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB96AFD3C
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCHDKj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 22:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCHDKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 22:10:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D45A729A
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 19:10:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so911195pjg.4
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 19:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678245036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FloaxPRk0waiSGeIT5oBVNComsiu/a2Rdh0MTFr8W9Y=;
        b=CunZhBYWZAvSAwIn0oJbe/sq5qZbD/+edkgeV9g5pWJyDwS/S69A2uxEb0xJ8hdins
         yOqu97hazCuBqJygFMmH3Potp4q8CJdRh5Uug+p0IKmOmB3YyrOpJtSOzpfSERGODxns
         AJuFjm6bIwq1zVdEjTxBeroxZr+P9uDiSw+PVXYVaJZeZgHAt/9wDx/uQcuXaDXay6z4
         cFPUzs/Jco4NAAbKmpUdGKGPl61G0gbxVOs39oTylOvULBflNwyvfq/vug9QW606186P
         fitNEmVQr2Al209ATTrr02+ZK92nfBCIZud7kOyJPff77RuQzYMi/xXJ+P154f+daeez
         UiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678245036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FloaxPRk0waiSGeIT5oBVNComsiu/a2Rdh0MTFr8W9Y=;
        b=JBSkcvkHOvM7xJ8MMAlR9KsFLBoJGSN8E3WAqvq88D/aM05XnX5XfnBoA7Ft1wT1Gn
         uyJx5h1l62LrYLlw402fsKwUZBjMBdC+hU23O1P8lzJUI8DCTWVYxwu14WzO4eVdT05N
         1I/Zqt/x06AQPACE+Me2xLVa+POubaYCIa0wNybdjYrU7SROC1TG2jeBEi6fDrp8FMU7
         WC5szPtS18wo1BApYKYGmKDKYHQ3mx7rJvNIF9JDjEAfn+2ZEVj3wW541kBpkqmS/7V1
         V4ucYlZ2pitUecQrU8ysx9ZGT6jstqSe4rKtvpS9BJV5LtE2zoX9eMhfqaebBw9/u6cn
         Y7FQ==
X-Gm-Message-State: AO0yUKUdLI4NlWGzWajWKTKGS5dY6mZx5cBNQXt3iIF/rd8Y6P/0TJ3O
        /WSoKKtX8B82VRPUL4NjGaX/fL/rsqTBxqhjmTs=
X-Google-Smtp-Source: AK7set9DiqTrTuGw35dBAsM8FD5K5IeT7gfgwdJfa1BokyJDB8LtShJrj/0KyXK1h9p9+Dcy4ec3pA==
X-Received: by 2002:a17:90a:9805:b0:230:dc97:9da2 with SMTP id z5-20020a17090a980500b00230dc979da2mr12905967pjo.1.1678245036131;
        Tue, 07 Mar 2023 19:10:36 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id o44-20020a17090a0a2f00b0023440af7aafsm7995806pjo.9.2023.03.07.19.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 19:10:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHSET for-next 0/3] Add FMODE_NOWAIT support to pipes
Date:   Tue,  7 Mar 2023 20:10:30 -0700
Message-Id: <20230308031033.155717-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One thing that's always been a bit slower than I'd like with io_uring is
dealing with pipes. They don't support IOCB_NOWAIT, and hence we need to
punt them to io-wq for handling.

This series adds support for FMODE_NOWAIT to pipes.

Patch 1 extends pipe_buf_operations->confirm() to accept a nonblock
parameter, and wires up the caller, pipe_buf_confirm(), to have that
argument too.

Patch 2 makes pipes deal with IOCB_NOWAIT for locking the pipe, calling
pipe_buf_confirm(), and for allocating new pages on writes.

Patch 3 flicks the switch and enables FMODE_NOWAIT for pipes.

Curious on how big of a difference this makes, I wrote a small benchmark
that simply opens 128 pipes and then does 256 rounds of reading and
writing to them. This was run 10 times, discarding the first run as it's
always a bit slower. Before the patch:

Avg:	262.52 msec
Stdev:	  2.12 msec
Min:	261.07 msec
Max	267.91 msec

and after the patch:

Avg:	24.14 msec
Stdev:	 9.61 msec
Min:	17.84 msec
Max:	43.75 msec

or about a 10x improvement in performance (and efficiency).

I ran the patches through the ltp pipe and splice tests, no regressions
observed. Looking at io_uring traces, we can see that we no longer have
any io_uring_queue_async_work() traces after the patch, where previously
everything was done via io-wq.

-- 
Jens Axboe




Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4593950A10B
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359071AbiDUNr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354829AbiDUNr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:47:59 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3951AE6C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s25so1891270wrb.8
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tk8gzFH0qP8yRzUCRC8IBMwikQorOFnFt1tRxR/8jIM=;
        b=qXsv+n/MIRMfUZNglyVfCcwP7PjhPp+4/H8z5z2Ypifw54iiTc0xtxlajEgamY06M5
         irHDQRyo8BpdY8HNCt73jK7JY2okOswKT0T3VLR6BEMxbmIrv7EemKoh88cS1jHVAbrn
         9UssyDgift5gmKxxUCSoUenOdDz7BR/tmVQfp19Gp+OubwJyCFkKjlmHcOGlvkwzlEUI
         Byr2nYXVQwhI2WgM7z6HlG5DGsmo5E2GHkj/UlA+MeeWeUONmgNJY1nnBxURJK8hvK5q
         UH++YBSa4KJtvGPvvDf9LwQuf61hVEQHRwsYaTPnbjyxXHJRF3yrAqywonIGpsmUQDAc
         Llnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tk8gzFH0qP8yRzUCRC8IBMwikQorOFnFt1tRxR/8jIM=;
        b=hBAB9QXH/GMmIroqSznTpzPFzBqYtzZEHUd0abRFZWgHZOmQJRjkPyZbNa0/hRfnt0
         E4SnOIhkn1+qIEeHCUVdUwfjr6JuBWnGNQYuSZO/hbZCiFKjD2MWKLSmIdhSovrV0I5W
         wFQC/O4UOAJ5t0zBusNfBu4p7/M+0ErYw5/YJ34MNptGDtz9/8cXlNNcS/+A8Syh+XqH
         swLWc2p5rMAEsN3I8CaI1huw4TN+GfeL5CNtBPa9AE+lynvVw8YwCpHCUR/llQocZVo6
         he202e+KEFRVAI0Sl8PEVDyDrZFFhwh/ssqFtwUPvmt4ZF67Iarxr7xJIlKXM6zMw+WP
         NnWg==
X-Gm-Message-State: AOAM532Q7yUIrHbYfCUprKIP2Zad1NsGRxuDXAzBjeharYOBLIavibT9
        +sUqBYSq3yhzT0Wouu9yVJWAUyLB4VI=
X-Google-Smtp-Source: ABdhPJzpsdjSY5g/H1dV7ycRMLHMXaspRKhdUOMxMJYu6t/lL+UlO2o1saPeNI32AU7VdoLONRyKNw==
X-Received: by 2002:a05:6000:1847:b0:20a:8f02:1fe3 with SMTP id c7-20020a056000184700b0020a8f021fe3mr17559360wri.284.1650548707934;
        Thu, 21 Apr 2022 06:45:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 00/11] io_uring specific task_work infra
Date:   Thu, 21 Apr 2022 14:44:13 +0100
Message-Id: <cover.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

For experiments only. If proves to be useful would need to make it
nicer on the non-io_uring side.

0-10 save 1 spinlock/unlock_irq pair and 2 cmpxchg per batch. 11/11 in
general trades 1 per tw add spin_lock/unlock_irq and 2 per batch spinlocking
with 2 cmpxchg to 1 per tw add cmpxchg and 1 per batch cmpxchg.

Pavel Begunkov (11):
  io_uring: optimise io_req_task_work_add
  io_uringg: add io_should_fail_tw() helper
  io_uring: ban tw queue for exiting processes
  io_uring: don't take ctx refs in tctx_task_work()
  io_uring: add dummy io_uring_task_work_run()
  task_work: add helper for signalling a task
  io_uring: run io_uring task_works on TIF_NOTIFY_SIGNAL
  io_uring: wire io_uring specific task work
  io_uring: refactor io_run_task_work()
  io_uring: remove priority tw list
  io_uring: lock-free task_work stack

 fs/io-wq.c                |   1 +
 fs/io_uring.c             | 213 +++++++++++++++-----------------------
 include/linux/io_uring.h  |   4 +
 include/linux/task_work.h |   4 +
 kernel/entry/kvm.c        |   1 +
 kernel/signal.c           |   2 +
 kernel/task_work.c        |  33 +++---
 7 files changed, 115 insertions(+), 143 deletions(-)

-- 
2.36.0


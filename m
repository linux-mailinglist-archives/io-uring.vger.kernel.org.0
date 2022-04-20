Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2550861E
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352316AbiDTKmv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377793AbiDTKmn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:43 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641EBB848
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:39:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so1412661plg.5
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uErnz2OB9JlX36dfUkPdexUmyQJfsb8t6dmzRETf+KQ=;
        b=ADuUZwbDp4GtWOVTIvVTlxpANIViI7DvOikEqA1cJIcZpHjm5hmG+2RvRvma8OHnF9
         sw4+rJRwcK609qbLG4KE9lDPCWxFlWxh/rCDtUJNN96FGOtFMIbdiWZ/Mv+Z+tY8XyKk
         vhxVPgWhx2+2QCGQHYBlcr9McUClmQxurRz58vO0+HGe2dyX4gNN1KaOcHyX7fq/xDXT
         UW9nl5E6NCnyfHIkVR+KL+NdC87FFfa70JxqsnH4KMmQtThj/MHGOXJVhtzVkkZLtePR
         IWZn+D8DrCtY3vP2pkfD/LdyZwehnVwtyF3BypXrzdrOaSnQLI22gTbdVjjtqIHwaQ/T
         lzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uErnz2OB9JlX36dfUkPdexUmyQJfsb8t6dmzRETf+KQ=;
        b=GW5bISiiZ6zQGi/e8q+TIQfHi5X/dKQRMpkbnhmkGg7+1mNZbXXVh2Zk34eGEMMzCb
         zziRUj4ow/RqicOZXUwiVY1DeD4qIBaWXZa6+WIUC5Ubjvh8AWQwj7qwkdkh7ThjQrm5
         XcKp3jag8y7xC5kQTwXcIJgWm2gAXWJzYqhpODS1d2FUwR2uRBqK2rUnhg+gFBz7/F1h
         cb9s7gMhuP6Zn6Y7TFiceonfIGj3s/7SMfKKpq4O41RkF1yKEZ4VT0AhyB46ivvhz7TH
         TuTggS12yUGXyFp20HwLtHuK9t+GB2y0rzUzG63aSSKgvjOrbh2kDAjepxo4zMeCt9Ik
         U1Ow==
X-Gm-Message-State: AOAM531vx+hmNCs+uepmiySkc47Z9m5FoqbLkD2YYoEc+yrU8CCfNuYs
        y+MwyPp1QIXAb+TsVcAOTSQCrfP+0G6Dxg==
X-Google-Smtp-Source: ABdhPJwoEEn79OkLkTtPMe5TWlScBXHtVDtZqYEQhNWHLc1RaIew6rxRQZjTF6pbPByA8ZUjo+ND9Q==
X-Received: by 2002:a17:902:690b:b0:159:65c:9044 with SMTP id j11-20020a170902690b00b00159065c9044mr11883086plk.47.1650451196814;
        Wed, 20 Apr 2022 03:39:56 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.39.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:39:56 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 0/9] fixed worker
Date:   Wed, 20 Apr 2022 18:39:51 +0800
Message-Id: <20220420104000.23214-1-haoxu.linux@gmail.com>
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

This is the second version of fixed worker implementation.
Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
normal workers:
./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
        time spent: 10464397 usecs      IOPS: 1911242
        time spent: 9610976 usecs       IOPS: 2080954
        time spent: 9807361 usecs       IOPS: 2039284

fixed workers:
./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
        time spent: 17314274 usecs      IOPS: 1155116
        time spent: 17016942 usecs      IOPS: 1175299
        time spent: 17908684 usecs      IOPS: 1116776

About 2x improvement. From perf result, almost no acct->lock contension.
Test program: https://github.com/HowHsu/liburing/tree/fixed_worker
liburing/test/nop_wqe.c

Hao Xu (9):
  io-wq: add a worker flag for individual exit
  io-wq: change argument of create_io_worker() for convienence
  io-wq: add infra data structure for fixed workers
  io-wq: tweak io_get_acct()
  io-wq: fixed worker initialization
  io-wq: fixed worker exit
  io-wq: implement fixed worker logic
  io-wq: batch the handling of fixed worker private works
  io_uring: add register fixed worker interface

 fs/io-wq.c                    | 457 ++++++++++++++++++++++++++++++----
 fs/io-wq.h                    |   8 +
 fs/io_uring.c                 |  71 ++++++
 include/uapi/linux/io_uring.h |  11 +
 4 files changed, 498 insertions(+), 49 deletions(-)

-- 
2.36.0


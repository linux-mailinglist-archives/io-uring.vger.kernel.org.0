Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B25607511
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJUKgU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJUKgS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:36:18 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768091EA563;
        Fri, 21 Oct 2022 03:36:16 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f11so3755090wrm.6;
        Fri, 21 Oct 2022 03:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sBF0+eXXDy0WFwTI1/e0oRNDrvv6x7YYh8atYvH+z4U=;
        b=GqBimMsUY9QeEFhS8koHgIAWAQRORXeOnL/tcWTXAnmpx7SgHxmJ4l7gIo/4wF53m1
         OHPxRF/F+5axN5OLsjGtjURSxXb2LBFjt7kyFJCWfnzm05kHKYrcbt+Kg3+7vqJKKnMH
         nBz7skIGk53dYk81h4GMbDu99EX6Rqir8DymdeY7NeH7lxZBv0SS8rY0OBGvIt4pC/oj
         PIxo2JMro+HDCt/MWI8IFoMk0ZjG0J+RZIVsSMY/xUZO7h8vETQ7I8xZBgqGtawI4sNp
         eHW3GSVFWamvtR5eWfjfLjTe3XYy3eQ+1ER4jrUUnY5cJhG9Ri6Cx+1r6UL77f1uL/Wu
         l32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sBF0+eXXDy0WFwTI1/e0oRNDrvv6x7YYh8atYvH+z4U=;
        b=fP1lrGPFS8Cq9N4kJr9qxlDZXwSXadz9mDCFZ03fh5ic+uw5gIbcRomgf/c+70Rk5n
         zhbfCxbIa1vdFG2Z6vtIcTlKYx8vYqbaCPdbWTqFNDUsz5NfNhb1UvndiN7cACnSpQsU
         9hsEY4OLyoQ5rjbUEaij45Sr2oEZQfxT56RDdhibLXlKoUP9AoOM4YDaxQv9d+XVzZUu
         PxXAumZFCZuz45yMepnd1urVdO/1DzRuQXrwxqizm4Rhr6XurSw2Sau07IycSsaGZLkb
         nNAG7YcHVLd38lWmiZSmaaw85Naq0EndZxre/1Zw+mAIgMzh6kKCm32LcywQJGqTmG+7
         iwDA==
X-Gm-Message-State: ACrzQf1SIV2T8JDhnzxKjHHhvUtzlh6RBeDZH7ogL8xkehy05DL3rrl6
        /quAVbKVgHfEAcNVup3yYuU=
X-Google-Smtp-Source: AMsMyM5af7gR3IDB4lMQ/+9oE2EhmpNmsGOPqytLO8fLFQ6qAhEEjPUB7y0NlsZtduRnQOaag4VHBw==
X-Received: by 2002:a5d:5b1f:0:b0:22e:51b0:2837 with SMTP id bx31-20020a5d5b1f000000b0022e51b02837mr11881833wrb.132.1666348574359;
        Fri, 21 Oct 2022 03:36:14 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d65ce000000b0022abcc1e3cesm18544759wrw.116.2022.10.21.03.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:36:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next v3 0/3] implement pcpu bio caching for IRQ I/O
Date:   Fri, 21 Oct 2022 11:34:04 +0100
Message-Id: <cover.1666347703.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Add bio pcpu caching for normal / IRQ-driven I/O extending REQ_ALLOC_CACHE,
which was limited to iopoll. t/io_uring with an Optane SSD setup showed +7%
for batches of 32 requests and +4.3% for batches of 8.

IRQ, 128/32/32, cache off
IOPS=59.08M, BW=28.84GiB/s, IOS/call=31/31
IOPS=59.30M, BW=28.96GiB/s, IOS/call=32/32
IOPS=59.97M, BW=29.28GiB/s, IOS/call=31/31
IOPS=59.92M, BW=29.26GiB/s, IOS/call=32/32
IOPS=59.81M, BW=29.20GiB/s, IOS/call=32/31

IRQ, 128/32/32, cache on
IOPS=64.05M, BW=31.27GiB/s, IOS/call=32/31
IOPS=64.22M, BW=31.36GiB/s, IOS/call=32/32
IOPS=64.04M, BW=31.27GiB/s, IOS/call=31/31
IOPS=63.16M, BW=30.84GiB/s, IOS/call=32/32

IRQ, 32/8/8, cache off
IOPS=50.60M, BW=24.71GiB/s, IOS/call=7/8
IOPS=50.22M, BW=24.52GiB/s, IOS/call=8/7
IOPS=49.54M, BW=24.19GiB/s, IOS/call=8/8
IOPS=50.07M, BW=24.45GiB/s, IOS/call=7/7
IOPS=50.46M, BW=24.64GiB/s, IOS/call=8/8

IRQ, 32/8/8, cache on
IOPS=51.39M, BW=25.09GiB/s, IOS/call=8/7
IOPS=52.52M, BW=25.64GiB/s, IOS/call=7/8
IOPS=52.57M, BW=25.67GiB/s, IOS/call=8/8
IOPS=52.58M, BW=25.67GiB/s, IOS/call=8/7
IOPS=52.61M, BW=25.69GiB/s, IOS/call=8/8

The next step will be turning it on for other users, hopefully by default.
The only restriction we currently have is that the allocations can't be
done from non-irq context and so needs auditing.

note: needs "bio: safeguard REQ_ALLOC_CACHE bio put" missing in for-6.2/block

v2: fix botched splicing threshold checks
v3: remove merged patch
    limit scope of flags var in bio_put_percpu_cache (Christoph Hellwig)

Pavel Begunkov (3):
  bio: split pcpu cache part of bio_put into a helper
  block/bio: add pcpu caching for non-polling bio_put
  io_uring/rw: enable bio caches for IRQ rw

 block/bio.c   | 93 +++++++++++++++++++++++++++++++++++++++------------
 io_uring/rw.c |  3 +-
 2 files changed, 74 insertions(+), 22 deletions(-)

-- 
2.38.0


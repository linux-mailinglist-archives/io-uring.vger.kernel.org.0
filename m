Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C550752720B
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiENOfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiENOfT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1A1FCDF
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n8so10541365plh.1
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GtUTG0ydZAa1d3Ateo5oLXq45PNsHp23XC3iUyNOIso=;
        b=ESTdZ197CFuB0l2M/EQZtrRQKXZGSnBnZQxXFLK2mk+cBSL2kfw+/19OSrOBBYVgsz
         1V8+T4qUoaCrXr8UQbDhEHzxq0WfbRVqHkqZ4ZKGW0TXEaUDudR944AMVJlk0Juqkalh
         ZdUSPuJPHJ2PUwk76HdxiBiNKMqZXy/ExbLYVAEKtT2iqAi42l2V5xbHKPxb98dO7rE8
         d0yamyk1S27AMTZU27knnHWT8PnaBHBNbp7Zt1cIonkVNOwbRQve+8hpzlzCvS2FfwxZ
         0tSZp4YFnSFbd6lWKkpKho1mZnfC9SX7HQi9+2LDDJQ/uStyTHBFEpMipkQJAeuXwoCu
         Sb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GtUTG0ydZAa1d3Ateo5oLXq45PNsHp23XC3iUyNOIso=;
        b=X/z73j5WxJ5yMx7x0ZhS83xvZzunIkmAH2N9f33wsTGWcMBzHf0nd+4wz3VRK4jSVN
         FVhyrBLqF2Om+gmzHDJiL12vk7qIFrZ+4yiF3UTsM/A/rg0eMR0750IyxdGYL2Lke7Xx
         vklrhVI6/jW5HV4h+n7lhljSqpUj57FHqxMpA8jYDioKTU5xkZYdKA+gBnwtd1RZtHvc
         y3vpZLUEfUbPDid8qm5P9HihLWADrOnEDl3bsIp//6jCW4N7liy4/yQmS8id946GJg1E
         S3n/KtGivPi3Y56zoGagsP89KWgzEfX2tjQbFO3rPJ82HdrTxeHafrcu2wEBRKfsF3dK
         8AVg==
X-Gm-Message-State: AOAM5331WyAtidkn9GP5gDpFHuqNty56wuDmF0SS3lRoxiKENTY1YSJ5
        phdGai5nIVy9jjXOup/evbgoZAIg4Q2+a2x6
X-Google-Smtp-Source: ABdhPJxWYJeE1PCrDLcAV5B/DQYiHR9zhgsOVyQWmXuiGUcZpZomqArWU8+ccrmKhO67/GdSLoKlmQ==
X-Received: by 2002:a17:903:244d:b0:15e:a3a2:5a75 with SMTP id l13-20020a170903244d00b0015ea3a25a75mr9757797pls.89.1652538917638;
        Sat, 14 May 2022 07:35:17 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:17 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing 0/6] liburing changes for multishot accept
Date:   Sat, 14 May 2022 22:35:28 +0800
Message-Id: <20220514143534.59162-1-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds two APIs for multishot accept, and some tests for it.
Man page changes as well.

Hao Xu (6):
  test/accept.c: close the listen fd at the end of the test
  liburing.h: support multishot accept
  liburing.h: add api to support multishot accept direct
  test/accept.c: add test for multishot mode accept
  test/accept.c: test for multishot direct accept with wrong arg
  man/io_uring_prep_accept.3: add man info for multishot accept

 man/io_uring_prep_accept.3                  |  51 ++-
 man/io_uring_prep_multishot_accept.3        |   1 +
 man/io_uring_prep_multishot_accept_direct.3 |   1 +
 src/include/liburing.h                      |  21 ++
 src/include/liburing/io_uring.h             |  14 +
 test/accept.c                               | 326 ++++++++++++++++----
 6 files changed, 340 insertions(+), 74 deletions(-)
 create mode 120000 man/io_uring_prep_multishot_accept.3
 create mode 120000 man/io_uring_prep_multishot_accept_direct.3

-- 
2.36.0


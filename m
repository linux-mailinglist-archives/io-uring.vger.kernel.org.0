Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699D96452B2
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiLGDyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLGDyf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:35 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96C827168
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f7so23181125edc.6
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2C+JGMeyfLUIqmWoiO9YrUcM2p1+A9yImZF5FMFQF7A=;
        b=Y00FAQc1muQX6yQL+LcNQG0xY9Dnw4Q+rc9vGhPQB1TW0Vtt5k3fg9xBK2ust6GecQ
         C+dMn0TF4fEJvyYtAlyLyMNgPxbzDT2/12LIUPPU/gPy3S8XjLm7wY/47qzDqXTUyAwA
         h05wNeRMETuJx8IOxg5OK2UF/NhyLCM0rHxEBA3gxRKBiMYZtdMCpXk7NG471ZVLNaA7
         jdkDICaVFxsOBRzmXCjQooFWtINm+OdUWKJn54exeJV43r+l1RBlCKgiP47iHFrMTjam
         UUKp1013Llw/5CVP3s3Ky0Hg9x+jpdLLqqkr2xgM43fPbyOaEcfTsCG0D5WwRci50a7j
         IWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2C+JGMeyfLUIqmWoiO9YrUcM2p1+A9yImZF5FMFQF7A=;
        b=0p2B+X+MVgWnLPe8gB0x9t4J6+kMKFAP4OaIARCZtkIPWhihUMfiXGMmgM6CmvMjTl
         /y7I6zihUMKcVWVDLhwbh4nB8hVsZGYKPRqPjGaxtEU38gNzxUBfuNoEu6ixtkvaNwf9
         bKZ+7Ns7lW4/6JpOdpkeIvfY1l0E9I/bRQPGVZauMD2azH/DtVOYpzHS+f/5++LyJUyx
         3ir1OGDYKkmDaZ/FJhuKpwGbLguJ+HOaSjvzaFx86wx7E7L1NveuQlAtlTjTMVz7kIvw
         G0ARDXtZV/LpfTQ6eUmE236wMtkRHICFqzgETZnGdV6LTUJmYvclc44Oqqjrz5cBakOe
         HKxQ==
X-Gm-Message-State: ANoB5plOxmBNKf0ARoUEhvTjkoZmZM/9FWFbo6bKMaubU8vszLJsswLC
        sW8+9yIsw2dPijZNYtZ+PHCmhuuspEs=
X-Google-Smtp-Source: AA0mqf6cLtgpml+xf9KFIMdwJBPTKzthX2O9jTyUzUU2IPkjkc5xzkJ0+aUqXOy9ai5eBmdwdgbDJA==
X-Received: by 2002:aa7:c719:0:b0:46a:bfd0:f816 with SMTP id i25-20020aa7c719000000b0046abfd0f816mr17229391edq.277.1670385273047;
        Tue, 06 Dec 2022 19:54:33 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 00/12] CQ locking optimisation
Date:   Wed,  7 Dec 2022 03:53:25 +0000
Message-Id: <cover.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Optimise CQ locking for event posting depending on a number of ring setup flags.
QD1 nop benchmark showed 12.067 -> 12.565 MIOPS increase, which more than 8.5%
of the io_uring kernel overhead (taking into account that the syscall overhead
is over 50%) or 4.12% of the total performance. Naturally, it's not only about
QD1, applications can submit a bunch of requests but their completions will may
arrive randomly hurting batching and so performance (or latency).

The downside is that we have to punt all io-wq completions to the
original task. The performance win should diminish with better
completion batching, but it should be worth it for as it also helps tw,
which in reality often don't complete too many requests.

The feature depends on DEFER_TASKRUN but can be relaxed to SINGLE_ISSUER

v2: some general msg_ring fixes (patche 1,2)
    fix exiting ring potentially modifying CQ in parallel (8/12)
    use task_work instead of overflowing msg_ring CQEs, which could've
      messed with CQE ordering (9-11)

Pavel Begunkov (12):
  io_uring: dont remove file from msg_ring reqs
  io_uring: improve io_double_lock_ctx fail handling
  io_uring: skip overflow CQE posting for dying ring
  io_uring: don't check overflow flush failures
  io_uring: complete all requests in task context
  io_uring: force multishot CQEs into task context
  io_uring: use tw for putting rsrc
  io_uring: never run tw and fallback in parallel
  io_uring: get rid of double locking
  io_uring: extract a io_msg_install_complete helper
  io_uring: do msg_ring in target task via tw
  io_uring: skip spinlocking for ->task_complete

 include/linux/io_uring.h       |   2 +
 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            | 165 ++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  12 ++-
 io_uring/msg_ring.c            | 163 ++++++++++++++++++++++----------
 io_uring/msg_ring.h            |   1 +
 io_uring/net.c                 |  21 +++++
 io_uring/opdef.c               |   8 ++
 io_uring/opdef.h               |   2 +
 io_uring/rsrc.c                |  19 +++-
 io_uring/rsrc.h                |   1 +
 11 files changed, 291 insertions(+), 106 deletions(-)

-- 
2.38.1


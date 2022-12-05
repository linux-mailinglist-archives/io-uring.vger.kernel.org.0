Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20EA6421A6
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiLECpm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiLECpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:40 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B6FACA
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:38 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so5119402wmb.5
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OpCRW7I/akhdBppLHjwOXT/Aqty9W9na3TLnqnzqJSE=;
        b=g+BEttB7jBZFq2qHQwODBDn1zKGG8zcmK+swlw6APh2yFerx/voKUqedhfFG3LHgvI
         PUb3rZq83/QeYbRpdBcx0fT4yv9eD1APXZAbw7Z+qQnAyS648fheMRKb1GmWJVW3ChUM
         U+SbfZDB+pkQ/DyUoepOeASHgIBdJMSFpIXinPdwbZGkDuxmzfBuuTFcU2rQ63fUTsuH
         +CTa7/D6wXjije02YpIFdjxJViZzpZZJtFb7YVTUJQjLjabhVUNWDYOPDhWzwFYKlSol
         ZIdISxrCsECM7VHXeJitx/jIeopQ0hzsWVxg8nv28TnwHX4h4CaWHBk2xJquMiyiCP71
         sVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OpCRW7I/akhdBppLHjwOXT/Aqty9W9na3TLnqnzqJSE=;
        b=HVZOWDIN0TYj2JWzdk73QZqzUS11GPd/3KoeRd1qfyl1/qqH0QUE69WkSDyJ3ayhnm
         p+Kmvp6/RWaj0s8v2MgIas6iXGiGTMmBxR1wl6K+wvYZEjxOQnjJOtpRv5VZ+bOAc/+n
         Yrk1Pw26sq+vcNUBojShPqeVZhZt5DSi9khsNbwZXG1rg+rkPJK6RagnG0G8o5LTeym6
         5EBoUXNpbm1ZPDFAxaCisV8WGzhFtfclSJK/QfmF1f0pzPPXQGY2x0ixPH5rjJL+AtzI
         a9BgL1YREWxOEEumkb19rCxUEZxhZs+DgCVPKdD856DynF7M81AktijS++nsIdv4f7Wy
         m0oA==
X-Gm-Message-State: ANoB5pm1wd7Q/yd0/gK1bgtrIJakKgNj3WFpNS3qvtjhW+/XJg0IIa4O
        QDNOdVqGDTSR8rVIwCttiXSlsoSBRMc=
X-Google-Smtp-Source: AA0mqf64A5OrXiHy8AZDt4GVJe2e8GNTmuimYvuFS29Kp1d1JxFtOPJYOe82bE+L41Rq7+0QcOmpiQ==
X-Received: by 2002:a1c:6a13:0:b0:3cf:7801:c780 with SMTP id f19-20020a1c6a13000000b003cf7801c780mr59315470wmc.29.1670208337070;
        Sun, 04 Dec 2022 18:45:37 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] CQ locking optimisation
Date:   Mon,  5 Dec 2022 02:44:24 +0000
Message-Id: <cover.1670207706.git.asml.silence@gmail.com>
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

Pavel Begunkov (7):
  io_uring: skip overflow CQE posting for dying ring
  io_uring: don't check overflow flush failures
  io_uring: complete all requests in task context
  io_uring: force multishot CQEs into task context
  io_uring: post msg_ring CQE in task context
  io_uring: use tw for putting rsrc
  io_uring: skip spinlocking for ->task_complete

 include/linux/io_uring.h       |   2 +
 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            | 163 ++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  14 ++-
 io_uring/msg_ring.c            |  14 ++-
 io_uring/net.c                 |  21 +++++
 io_uring/rsrc.c                |  19 +++-
 io_uring/rsrc.h                |   1 +
 8 files changed, 179 insertions(+), 58 deletions(-)

-- 
2.38.1


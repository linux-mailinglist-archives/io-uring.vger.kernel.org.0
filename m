Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B102514674
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357296AbiD2KWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiD2KWO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114585006B;
        Fri, 29 Apr 2022 03:18:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g8so4138989pfh.5;
        Fri, 29 Apr 2022 03:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DnVHB7M4uVUttqO8ONn7UtaonGLw3+L/GjcfOo8uzHg=;
        b=lMFwhcc16g6s/yQPluRzDaFnMYWATsmVBDbRTateUwZZx9YaO7hvKEO1fK5Mo+CPGe
         l7VwiOg69uirbYGC1EZjXZf2p496zB0kbM/P9uB3d5NHlN6LLC3vcnohwDbEvJvhIzeZ
         bKar2RCY0uahqt9J0vCohNUIMEUiV9pqGNHKdXyFT54GvW/jQS1VbjI14llM1hm9ggI/
         OutPhjruZbWkkIJKyXWl14Mg+NFhR4ES3KarFDm/4FLKvxFHEs251wz6GHJtwhODzPXy
         Sl/kRbEExcneP6vpyLnrMemjRZ4iSceundGaGb1rD8Ql/9xcrUqymWV/Lv51aCJYEZaX
         m2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DnVHB7M4uVUttqO8ONn7UtaonGLw3+L/GjcfOo8uzHg=;
        b=NkPpuYuZcvhCJeLQZSdg1Mr4PqLprEwL4NLwstJEDPtW/lXL0/UIsEzN21ru3nRV6x
         BvUxEx2qeg4ef50kN4nuS1xMHC9TgODTSCS/aRSsDzqOWZgkJEreBxiFS1z+UCR/X6mI
         plz6qHX3lpiblnEZ3cfuGGQcF3B6JGfwWJLk3fmE3PCjQbdhEdx8NPE6+XWNoVb3v5eg
         yNu2qs4dVSxtbV5ipd7V/o5Fy0koOUSGJQ3PE5OdNClPcRoLbzYroHWBktrdRe2EagD8
         m5CnhujPeoBBaz4eguC6gwbzbh/brisi6NxuDFbR6Tu9uvibbSoHJlHsus6htXmCeb40
         njDg==
X-Gm-Message-State: AOAM533Lg9fcgPu80ZZ8KL3o4WlSBnvAZ5muVfKbMPhoeksQr0kmSqZs
        BbssZly96NnBPAcQRQLNKrc0MOdgMJY=
X-Google-Smtp-Source: ABdhPJxceM+dYaM8UPgZ7b1tywSAW6S5F8Pr8xUT/3cc4sTjr73WZdxYmO3hUQJKpqaFSQsrSIwPMA==
X-Received: by 2002:aa7:9522:0:b0:4e1:d277:ce8 with SMTP id c2-20020aa79522000000b004e1d2770ce8mr39082163pfp.16.1651227535431;
        Fri, 29 Apr 2022 03:18:55 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.18.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:18:55 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v3 0/9] fixed worker
Date:   Fri, 29 Apr 2022 18:18:49 +0800
Message-Id: <20220429101858.90282-1-haoxu.linux@gmail.com>
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

This is the third version of fixed worker implementation.
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

v2->v3:
 - change dispatch work strategy from random to round-robin

things to be done:
 - Still need some thinking about the work cancellation
 - not very sure IO_WORKER_F_EXIT is safe enough on synchronization
 - the iowq hash stuff is not compatible with fixed worker for now

Any comments are welcome. Thanks in advance.

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

 fs/io-wq.c                    | 460 ++++++++++++++++++++++++++++++----
 fs/io-wq.h                    |   8 +
 fs/io_uring.c                 |  71 ++++++
 include/uapi/linux/io_uring.h |  11 +
 4 files changed, 501 insertions(+), 49 deletions(-)

-- 
2.36.0


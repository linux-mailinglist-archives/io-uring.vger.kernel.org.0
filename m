Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814005FE2AC
	for <lists+io-uring@lfdr.de>; Thu, 13 Oct 2022 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJMT1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 15:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiJMT1r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 15:27:47 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C5716D8A4
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 12:27:45 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 137so2202569iou.9
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 12:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtK6UFVl/FpNKkB/eeo8ua3JzB5/ByZxm0cSBZ8zD/Y=;
        b=E4d+FOeCvYKi3fNkTHy/mehQ36xJu79k8z5RdunJ8+K+PQY2RKQNa7xBMWZ02Z6ePS
         of+ew0mX0gwx71KftY87lGr2GSn5CVI5EM5lWYhPj9H3O27FD5Dm9KcTLML6zJMOpIBw
         tT6oJE0nnLmhPAcmnKMTs6Bxud3uSzMp/ypu7s3YLoxfgsFgIKezTbphWLC5mwaNd0CU
         AGYDEIxCfwHcw85wISMyXUO7wfYjlb/keVWkbmnzDiGV1BkFF3Ia2nVGOnxhlxVWKh4J
         vfK4x9Hi9QX5j0gq97bETLWut18HrqnheIZjwC7wJ711QjvgN8vYZiG9f3Ni/dsm4Pmg
         XNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XtK6UFVl/FpNKkB/eeo8ua3JzB5/ByZxm0cSBZ8zD/Y=;
        b=VVEYU09n84tGRktGDFR8rO5j3ay7BUgerUKXc11AIbpMcG9hLylUoZjxz0JduS2p8+
         MkBIhhlBC1u/rpLodLXzYry7anR+y+cCLKK5Dl/NhgrGb6AdCJ4rUBAUCpcD9zj/Jhyp
         ySpbpGScJup5rr2dzzxEanY/KvjDyclb9MGwM/b2WKoA6n82Fw7qTwJlXgrDZmAzi8yN
         EgFWO8ap/TvSTJdmUDuVrcKRIogxs/oeCF2fP0P5JsOTgEviX1KTAHb4r08Dp6ZqldA7
         hm/X6R8sdDLEQK4BTNlrVULY4q7Ev2rZ71s+HAoE7LHGCT35HB969YoxPymVfRMNbkyQ
         Sq0w==
X-Gm-Message-State: ACrzQf0OX6VBdDtuq6M6hWfSxXQfLquVlaWbrWzgCc4LjzUyMCXFGVc0
        oyl8sddNsNe/TARkzIiqttjDalwMdv2LFqya
X-Google-Smtp-Source: AMsMyM7FU76DeFU/KE8MwAXAEg66KwP2ENWO/68Ycx2LCqnLcEN+bHKkHQ8BEUbWkAomGb1KRFDdBQ==
X-Received: by 2002:a05:6638:3398:b0:363:c8d9:fc7 with SMTP id h24-20020a056638339800b00363c8d90fc7mr857267jav.77.1665689265064;
        Thu, 13 Oct 2022 12:27:45 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u16-20020a02b1d0000000b00349cee4ef4asm285351jah.62.2022.10.13.12.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 12:27:44 -0700 (PDT)
Message-ID: <b0098418-170a-c7e1-1292-74cfce8aef27@kernel.dk>
Date:   Thu, 13 Oct 2022 13:27:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 6.1-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
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

Hi Linus,

A collection of fixes that ended up either being later than the initial
pull request, or dependent on multiple branches (6.0-late being one of
them) and hence deferred purposely. This pull request contains:

- Cleanup fixes for the single submitter late 6.0 change, which we
  pushed to 6.1 to keep the 6.0 changes small (Dylan, Pavel)

- Fix for IORING_OP_CONNECT not handling -EINPROGRESS correctly (me)

- Ensure that the zc sendmsg variant gets audited correctly (me)

- Regression fix from this merge window where kiocb_end_write() doesn't
  always gets called, which can cause issues with fs freezing (me)

- Registered files SCM handling fix (Pavel)

- Regression fix for big sqe dumping in fdinfo (Pavel)

- Registered buffers accounting fix (Pavel)

- Remove leftover notification structures, we killed them off late in
  6.0 (Pavel)

- Minor optimizations (Pavel)

- Cosmetic variable shadowing fix (Stefan)

Please pull!


The following changes since commit 9d84bb40bcb30a7fa16f33baa967aeb9953dda78:

  Merge tag 'drm-next-2022-10-07-1' of git://anongit.freedesktop.org/drm/drm (2022-10-07 09:47:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-13

for you to fetch changes up to 2ec33a6c3cca9fe2465e82050c81f5ffdc508b36:

  io_uring/rw: ensure kiocb_end_write() is always called (2022-10-12 16:30:56 -0600)

----------------------------------------------------------------
io_uring-6.1-2022-10-13

----------------------------------------------------------------
Dylan Yudaken (2):
      io_uring: simplify __io_uring_add_tctx_node
      io_uring: remove io_register_submitter

Jens Axboe (3):
      io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT
      io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
      io_uring/rw: ensure kiocb_end_write() is always called

Pavel Begunkov (7):
      io_uring: limit registration w/ SINGLE_ISSUER
      io_uring/af_unix: defer registered files gc to io_uring release
      io_uring: correct pinned_vm accounting
      io_uring: remove notif leftovers
      io_uring: remove redundant memory barrier in io_req_local_work_add
      io_uring: optimise locking for local tw with submit_wait
      io_uring: fix fdinfo sqe offsets calculation

Stefan Roesch (1):
      io_uring: local variable rw shadows outer variable in io_write

 include/linux/io_uring_types.h |  5 -----
 include/linux/skbuff.h         |  2 ++
 io_uring/fdinfo.c              |  2 +-
 io_uring/io_uring.c            | 33 +++++++++++++++++++-----------
 io_uring/io_uring.h            | 18 +++++++++++++++--
 io_uring/net.c                 | 28 +++++++++++++++++++------
 io_uring/opdef.c               |  1 -
 io_uring/rsrc.c                |  1 +
 io_uring/rw.c                  | 46 ++++++++++++++++++++++++++++++------------
 io_uring/tctx.c                | 42 +++++++++++++++++---------------------
 io_uring/tctx.h                |  6 ++++--
 net/unix/garbage.c             | 20 ++++++++++++++++++
 12 files changed, 138 insertions(+), 66 deletions(-)

-- 
Jens Axboe

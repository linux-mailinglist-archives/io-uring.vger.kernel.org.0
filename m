Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BBC6B329B
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 01:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCJAPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 19:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCJAPe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 19:15:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF23F366F
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 16:15:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so3582316pjg.4
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 16:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678407333;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrMvomxrbkThHEJ/lexzfgl3luXrPH0yQcH6yifg+9U=;
        b=DC36ZuLlBuG/XWfCyD1zoz01hMy8/qlCo3AF7X6CtE4NNIkz2wS2TlaRw5ezOtfmF9
         Quuimp7ISwz23TQABKaWdhvPtG1QaTMHltfom+5ar+3HT04i6r636srFr2DJtnL+RgGR
         HK88ZNH1PPYNUMOrUneBg5NBvJPY7VwcqsXJmeGofnGpj7/V7S+rg6uGrS3syQCf/msG
         FBFfwM5K9RI+a7M7DcqU9ma8FGLa+efwX7/YJl1ELmI/5wVCfMzGWaWDqlYCnyiGRTAC
         ZrEYrdriW0ahJ+WPiI/MBDroXev6s8Wboyu9kKAHMspGcVC2ERgAnVUt+vVWFv8onxSu
         E2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678407333;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KrMvomxrbkThHEJ/lexzfgl3luXrPH0yQcH6yifg+9U=;
        b=a9mLY9hRXm3N7EbEglL7TEn1FBMvmqHNn1yX6OAP/qX9VV9HVycBq1zmeXmgGcQ8Dz
         D+qRI9SSdMD1vOi1OckfUSpJWfwx/q6x0198S/L41p6Zg/T/E/DyXQ9q3BzoJgPZTEby
         b2f76zH1AbjqzOvotX0t6qAVUtx9VDP4etIWFSgxVfvntR3Op8uHoIn5KJqrBn8Z6H6p
         6FcljHnyBw5aueXbzrVGZr75gKljZ7KtY+Kphdx0RCTJL09Jc4XT6FLMrCmHS0r+qDFD
         a2/Ed4wKSZpBPJPNZoo3jrSYuuZkyVOgbGEqtD0rS/C7AI9bW26XCPSz97aPmLXmPPU+
         /32A==
X-Gm-Message-State: AO0yUKWDn19hjDTwWpFYZ/PwMuWVSCbubwNa74f1bkH5Cuhp/jTngCMT
        0RNqvPaXk7MsZn5qKj1SMLcj/nzHnrf+dTlsFOU=
X-Google-Smtp-Source: AK7set9DpHxUg+/UrWf3NBNUf5hdyZzOg1YM5wtqOacBgRSJ5dUr5JSUbH06FaA0PK709LkN+LN/SQ==
X-Received: by 2002:a17:90a:708c:b0:230:a082:b085 with SMTP id g12-20020a17090a708c00b00230a082b085mr791372pjk.0.1678407333023;
        Thu, 09 Mar 2023 16:15:33 -0800 (PST)
Received: from ?IPV6:2600:380:8747:c8d0:5213:cd32:8419:a625? ([2600:380:8747:c8d0:5213:cd32:8419:a625])
        by smtp.gmail.com with ESMTPSA id ga14-20020a17090b038e00b00233d6547000sm128445pjb.54.2023.03.09.16.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 16:15:32 -0800 (PST)
Message-ID: <7ec0e271-c49c-aea9-fc29-da52febfb913@kernel.dk>
Date:   Thu, 9 Mar 2023 17:15:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.3-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few small fixes that should go into the 6.3 release:

- Stop setting PF_NO_SETAFFINITY on io-wq workers. This has been
  reported in the past as it confuses some applications, as some of
  their threads will fail with -1/EINVAL if attempted affinitized. Most
  recent report was on cpusets, where enabling that with io-wq workers
  active will fail. Just deal with the mask changing by checking when a
  worker times out, and then exit if we have no work pending.

- Fix an issue with passthrough support where we don't properly check if
  the file type has pollable uring_cmd support.

- Fix a reported W=1 warning on a variable being set and unused. Add a
  special helper for iterating these lists that doesn't save the
  previous list element, if that iterator never ends up using it.

Please pull!


The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-09

for you to fetch changes up to fa780334a8c392d959ae05eb19f2410b3a1e6cb0:

  io_uring: silence variable ‘prev’ set but not used warning (2023-03-09 10:10:58 -0700)

----------------------------------------------------------------
io_uring-6.3-2023-03-09

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers
      io_uring/uring_cmd: ensure that device supports IOPOLL
      io_uring: silence variable ‘prev’ set but not used warning

 io_uring/io-wq.c     | 16 +++++++++++-----
 io_uring/io_uring.c  |  4 ++--
 io_uring/slist.h     |  5 ++++-
 io_uring/uring_cmd.c |  4 +++-
 4 files changed, 20 insertions(+), 9 deletions(-)

-- 
Jens Axboe


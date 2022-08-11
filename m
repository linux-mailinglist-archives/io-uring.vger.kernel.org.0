Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2358F579
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 03:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiHKBBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 21:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 21:01:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3F41EC69
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 18:01:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gp7so1955264pjb.4
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 18:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=iChp7iXu9YkONqC8dxeP34/ZLYXg3XKNwFJiao9TImM=;
        b=Bltir7zRG/0hxCdvdeI9AfKPWI2S7YsnQQX6F3FXH14H0Xu7vsKA77KW7I0Mh5JyMX
         PaHwGGtyIV9L2ifAiR6XcgjVdDbRtlhQDLbq+ZrnalMXRwxccCsfr/wRlaXiC0CFWGNh
         Jkb5Wfa3vAUNJWq+8uOsFHYmF8LYqZS2fey+sLeKPtw5rgNKT/ChBq6KNh/eufIqQRO5
         3CS6WxaDS6Q2KaP2+QQ5h6zMHIwhdo/plHet3VSw/SNV3f71Vbg6kbUz7vNtD0oLNez2
         b7XjmgpV0KTNuMvBB6T5AFeYZjTmi1G3lP3r0+HQyBgz9pZ+MhdbkI+3fAZEmbKYVua8
         apCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=iChp7iXu9YkONqC8dxeP34/ZLYXg3XKNwFJiao9TImM=;
        b=yU7f6uLJwZ5eNpp+W51/UjzKEhYBVcJ+yY+ThSL1hUAvH8c53Z+gHQXZnuYtJgu/Fi
         tiQUG64gVW9+Ma0iQxJkxEh+dhg/aIj2svwPYpRFuAAJt5bYyw/mSb9SYMLQqihjGOSk
         rG4wXffyIsYGqMGynpDcbicfghLEl+z4uwf7spYuF5m0I/sfdxTN/jFZ6GUF6yHICls6
         VFzPAxU7b6/2Izbb4F/O5OjgVDp0bcT4nJEfkukezSiUVfsriD3ThKt7R6QC3N0g9eeA
         aLYzKXJEADvEwXgVNDwIJ2hWJSt6zmC59L/LsIx6v0KdtOsOkF/CBC8zIhs8Y3P8Y8o3
         I0fQ==
X-Gm-Message-State: ACgBeo3rLv9SRGWIJcBObPABnRHidjLWBdT1sZ7UIQMfpm5LcxrLIaKk
        /z8U9vNtU2pLwx4Mx3faGKxrYmOD0SJ7jA==
X-Google-Smtp-Source: AA6agR6hI9wKKVv52azo1NtgaYQFpxy/iXWINGINj1cmr+NRHIf9iKM9ypRx9+yCzAcBylWVJLMJMQ==
X-Received: by 2002:a17:902:7247:b0:16e:ecb2:4870 with SMTP id c7-20020a170902724700b0016eecb24870mr30760216pll.110.1660179680273;
        Wed, 10 Aug 2022 18:01:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b0016bfbd99f64sm13755448plh.118.2022.08.10.18.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 18:01:19 -0700 (PDT)
Message-ID: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
Date:   Wed, 10 Aug 2022 19:01:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go upstream before 6.0-rc1. In detail:

- Regression fix for this merge window, fixing a wrong order of
  arguments for io_req_set_res() for passthru (Dylan)

- Fix for the audit code leaking context memory (Peilin)

- Ensure that provided buffers are memcg accounted (Pavel)

- Correctly handle short zero-copy sends (Pavel)

- Sparse warning fixes for the recvmsg multishot command (Dylan)

Please pull!


The following changes since commit e2b542100719a93f8cdf6d90185410d38a57a4c1:

  Merge tag 'flexible-array-transformations-UAPI-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2022-08-02 19:50:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-10

for you to fetch changes up to d1f6222c4978817712e0f2825ce9e830763f0695:

  io_uring: fix io_recvmsg_prep_multishot sparse warnings (2022-08-05 08:41:18 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-08-10

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: fix io_recvmsg_prep_multishot sparse warnings

Ming Lei (1):
      io_uring: pass correct parameters to io_req_set_res

Pavel Begunkov (2):
      io_uring: mem-account pbuf buckets
      io_uring/net: send retry for zerocopy

Peilin Ye (1):
      audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()

 include/linux/audit.h |  5 -----
 io_uring/io-wq.c      |  3 ---
 io_uring/kbuf.c       |  2 +-
 io_uring/net.c        | 24 +++++++++++++++++++-----
 io_uring/sqpoll.c     |  4 ----
 io_uring/uring_cmd.c  |  2 +-
 kernel/auditsc.c      | 25 -------------------------
 7 files changed, 21 insertions(+), 44 deletions(-)

-- 
Jens Axboe


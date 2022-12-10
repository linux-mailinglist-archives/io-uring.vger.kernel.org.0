Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73B1648F7B
	for <lists+io-uring@lfdr.de>; Sat, 10 Dec 2022 16:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLJPgE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Dec 2022 10:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLJPgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Dec 2022 10:36:03 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A1EC77B
        for <io-uring@vger.kernel.org>; Sat, 10 Dec 2022 07:36:02 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id f3so5443916pgc.2
        for <io-uring@vger.kernel.org>; Sat, 10 Dec 2022 07:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOw8KScuh/3E/UpSqDsJsWDJS6tJ64Rk7bcz3f298tc=;
        b=cy9smLyjCwqyJ4cUv5gUOPWzy8Jf4itVM6EG8gY+veeC95dx1PYnDBBQvl0TXH/jMG
         o7usNq3zP9QPOmg/DwO9wM42f8MZvCldnHnhYhOQH0RFlDcyyiWeD56ybHOlQ1XFBoJ7
         uYdTOvSNd0GC7JqexUxSP8u9kzTjCUlz1lr88b/fH60Kn3Ou9ILws6t3mV12UQ25dyUN
         5EHEWy1d3d7E9VGaCKNwYgV4lmsYbonJOznYZrCOJgY+6VGtNUxSl/Fg13LEClyWYGKJ
         7WTHfkYWYaRJl1tyPihmUuFg6bSTQxTx+AKxpqey/VhyyEVOB6Lf0Bdnwrij19+cYaVY
         4MXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gOw8KScuh/3E/UpSqDsJsWDJS6tJ64Rk7bcz3f298tc=;
        b=NvCZGq15GDvTL9bhYag+k5Ul+Xu2MtzJZe1X0s8twl78E1Dgxj7wOUeuZc58SsCQdz
         ra2NBXG00vNu+wpXb5iTMA1ol6fqECUbm9BKyNU4CnAIa91kpZpHoOcZoZxp0C37VAZT
         jMitqw6PxOPEFiXmMmrc60sF8rLtKOCXASkaNGkGvJxPCGK0qOoObfA4mqbxVz8Sjgc1
         SOYhz1aEuHlczeTPXGD76vTEC8jw3Z4GddM96v3ZWy992rZ/zt9DqqDrg+3oHwFvZURv
         68ozqPoIFFURc7Pw5lq68rk8twcBvXpSG7iBjj9xPGu1F12ytTB5JG095M/IGtBsxqEi
         BxXw==
X-Gm-Message-State: ANoB5pmyhWXXU4uNDT+S/r0ly9FwqG2zopjXZIHOHKsEdkD+UaRi4gHd
        tG234o89ZDBOwekq3JKAdxMyXUJMOm73sPjg7WY=
X-Google-Smtp-Source: AA0mqf6i7u4aCRqWJhtl1YAg5nJoUfsAjki2FA/QXVQxVKbw7MwnxyMg/Ui6CHawbjwWKymGGeckZA==
X-Received: by 2002:a62:190f:0:b0:578:450a:853c with SMTP id 15-20020a62190f000000b00578450a853cmr26014pfz.2.1670686562216;
        Sat, 10 Dec 2022 07:36:02 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i1-20020a62c101000000b0053e62b6fd22sm2880877pfg.126.2022.12.10.07.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 07:36:01 -0800 (PST)
Message-ID: <b5bd1613-6ae9-d6d0-84b5-22d0469d87b1@kernel.dk>
Date:   Sat, 10 Dec 2022 08:36:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring followup updates for 6.2-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

As mentioned, here are the followup changes for io_uring. This branch
only exists to avoid the poll related conflicts that would've otherwise
arised without the split.

This pull request contains:

- Misc fixes (me, Lin)

- Series from Pavel extending the single task exclusive ring mode,
  yielding nice improvements for the common case of having a single ring
  per thread (Pavel)

- Cleanup for MSG_RING, removing our IOPOLL hack (Pavel)

- Further poll cleanups and fixes (Pavel)

- Misc cleanups and fixes (Pavel)

Please pull!


The following changes since commit b7b275e60bcd5f89771e865a8239325f86d9927d:

  Linux 6.1-rc7 (2022-11-27 13:31:48 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.2/io_uring-next-2022-12-08

for you to fetch changes up to 761c61c15903db41343532882b0443addb8c2faf:

  io_uring/msg_ring: flag target ring as having task_work, if needed (2022-12-08 09:36:02 -0700)

----------------------------------------------------------------
for-6.2/io_uring-next-2022-12-08

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'for-6.2/io_uring' into for-6.2/io_uring-next
      io_uring/msg_ring: flag target ring as having task_work, if needed

Lin Ma (2):
      io_uring/poll: remove outdated comments of caching
      io_uring: update outdated comment of callbacks

Pavel Begunkov (21):
      io_uring: kill io_poll_issue's PF_EXITING check
      io_uring: carve io_poll_check_events fast path
      io_uring: remove ctx variable in io_poll_check_events
      io_uring: improve poll warning handling
      io_uring: combine poll tw handlers
      io_uring: don't raw spin unlock to match cq_lock
      io_uring: improve rsrc quiesce refs checks
      io_uring: don't reinstall quiesce node for each tw
      io_uring: reshuffle issue_flags
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

 include/linux/io_uring.h       |  13 +--
 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            | 167 ++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  15 ++-
 io_uring/msg_ring.c            | 164 ++++++++++++++++++++++----------
 io_uring/msg_ring.h            |   1 +
 io_uring/net.c                 |  21 +++++
 io_uring/opdef.c               |   8 ++
 io_uring/opdef.h               |   2 +
 io_uring/poll.c                |  98 +++++++++----------
 io_uring/rsrc.c                |  72 ++++++++------
 io_uring/rsrc.h                |   1 +
 12 files changed, 369 insertions(+), 196 deletions(-)

-- 
Jens Axboe


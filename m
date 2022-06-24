Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2160B55A066
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiFXRmZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiFXRmX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 13:42:23 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FCB794CE
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 10:42:21 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id i194so3385520ioa.12
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=pVUgB+GTEuyRqk8BvmrBV9NHxmeLVSzZLfxrsA7icOQ=;
        b=bLr0JXzeFI11CriSsiphCNJXmrlY4NX2VdH4e+jnV9iLZ17rbnzwefuxoZrxWsjkUu
         mB8DwD1tMwqhF+r48GSrkjvOMZ4Zl0kSaDq/cLDWasA1dMf2NT2gGlI2PmOJjGbnFVOW
         25CvT0VUhp/3y94ac+uEKljlN2GgzpOrmwP3kcGtcxnsM3uCm9VMIadEh0etWE4EoMMM
         fjhrOFnaGboA1LDx565BdPhIXu7zLufKJoSZBj0vnllWmJyzOxJBYJ5qEZ9ieJNe9jHf
         s4LITmnsPhK6zucPRU8G2jJtBnVSqA+/ySCFdzfYj8FhmGFpE3JmR3DdJ1EKZpOjwYDZ
         lc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=pVUgB+GTEuyRqk8BvmrBV9NHxmeLVSzZLfxrsA7icOQ=;
        b=UWzy48n6W6XtIFsT6JmFW2mlctWFy7utCkV3a7RlFmXJk9QX49H4xoopE68eXp7l5u
         Ect4KrCXnioKYj8xwpTfdiX+ayw4dxDfiABlKcLQKxBKRQrXJk19KA9SQxb5A5xkuH44
         aXj8D3y3hco3t8MkQ2iWW/i6hTysckSQD9JZz2VACQmdes3TPZ6wppE3qqnp4VKJn+uI
         tsiNKnovUQjtUmydnQBqFvjfEfz6/LXxmVbFUY/oOkmgltc56R+jrL+gThMMbtZgRFcl
         HqtOToWl73yy1qJJFS8h3nbpUI8nQu2BmK1Yajp47szn7nWbxupMvcD35TB7kxAOZRYE
         +yvA==
X-Gm-Message-State: AJIora9BiywW8b6Cqpp+xcaosyleQ9Mj3qJVI3ISKHWBWtzTlJRJJ82n
        pzVqT1sQ4+0RF6bVGLZc1dUr3ME5/bo8OA==
X-Google-Smtp-Source: AGRyM1utbSCjGqTgcFy+e0hqHU8E2kSMO7GWZS/uQ433iAlYvb4P4WtA7Yiwn2GY6repNe3ML50LVA==
X-Received: by 2002:a05:6638:3002:b0:32d:acc7:4a7a with SMTP id r2-20020a056638300200b0032dacc74a7amr203748jak.14.1656092540880;
        Fri, 24 Jun 2022 10:42:20 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w25-20020a02b0d9000000b00339e8a3e787sm1332937jah.99.2022.06.24.10.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 10:42:20 -0700 (PDT)
Message-ID: <7c74945d-1300-5e59-3afe-fad2cdabfe32@kernel.dk>
Date:   Fri, 24 Jun 2022 11:42:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.19-rc4
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

A few fixes that should go into the 5.19 release. All are fixing issues
that either happened in this release, or going to stable. In detail:

- A small series of fixlets for the poll handling, all destined for
  stable (Pavel)

- Fix a merge error from myself that caused a potential -EINVAL for the
  recv/recvmsg flag setting (me)

- Fix a kbuf recycling issue for partial IO (me)

- Use the original request for the inflight tracking (me)

- Fix an issue introduced this merge window with trace points using a
  custom decoder function, which won't work for perf (Dylan)

Please pull!


The following changes since commit 6436c770f120a9ffeb4e791650467f30f1d062d1:

  io_uring: recycle provided buffer if we punt to io-wq (2022-06-17 06:24:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-24

for you to fetch changes up to 386e4fb6962b9f248a80f8870aea0870ca603e89:

  io_uring: use original request task for inflight tracking (2022-06-23 11:06:43 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-06-24

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: move io_uring_get_opcode out of TP_printk

Jens Axboe (3):
      io_uring: mark reissue requests with REQ_F_PARTIAL_IO
      io_uring: fix merge error in checking send/recv addr2 flags
      io_uring: use original request task for inflight tracking

Pavel Begunkov (4):
      io_uring: fix req->apoll_events
      io_uring: fail links when poll fails
      io_uring: fix wrong arm_poll error handling
      io_uring: fix double poll leak on repolling

 fs/io_uring.c                   | 26 ++++++++++++++-----------
 include/trace/events/io_uring.h | 42 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 18 deletions(-)

-- 
Jens Axboe


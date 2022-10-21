Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287786076AA
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 14:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJUMCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJUMCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 08:02:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D7B253EE7
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 05:02:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u71so2387699pgd.2
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 05:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xebQeLAQvVoENjunu7zrmOLYbHaVpxw9tNTWe51AMjU=;
        b=y6amnYXZ/IOmxwU54iCvdOgKRPj82TMn3t6wW367iSIiReNGF49V8v48NIVcYm8Caz
         WJNWs+sBo9JTJpcL39IKT9Y9vM9xDqX1MI+pd1H1DSH7eLH8g2GM1hQsuqLw7/7VCsW9
         eqPGeXVWH2+Z1xNsBbZG90bUVJ5Yuj6wltSP6ZVL91HNse2Pxlt1J4/ARvmgiKPqpvXp
         2MAx2Obnm4Zzq7Q4YpNK1mivkc5kuQYRFyG1rxLZfaiMOxfnHHOy15LCu+wbfRebMM0t
         bQb/Pc8Q7y0ktlOGWRKpN9JpqKtR5ETCxyoLL6TQJoH+xuHHsHRDAwvm6glPBhox6GcG
         3eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xebQeLAQvVoENjunu7zrmOLYbHaVpxw9tNTWe51AMjU=;
        b=PYJgwGacbqH0fiQHtVBiPHvUvC82r0bpMGZ36Ou9vD1+PQg16Ax5ZHoiCyg9C28qE1
         ajB4Y4aV6qXQ3If8V69Qj0aXNSFCOK4BtPfHglwL/oZ1yGdrvWmnaC5oLtsbUwkmHagk
         oZPFWuXucTD6VYfoIVR9WxdyGYZ7afI3D+xIXUdriZZTLyvOvhvIRKVZ3BWZsDW01zaX
         7+P7pUvFRac7950DNiGlV/gf47n6LRETkX2CEBFIN+1VRT3Mt4VBuSKv+5Ww9P/ZU5uj
         KxIy6WG6ygtnrFz+kKt0RCIlXI+8aMK9c2YUz3yHtyQa279yUNh+iIYBoI3AEa8Fn2mL
         kRSA==
X-Gm-Message-State: ACrzQf2+VmWyp5G5Imxkb7MFvU9FBjVMQtfore3h6pEEWFH+JOWtHu5C
        IF+pXMNt57KxCUdHwHDalH0bDQrbMWkB6LEP
X-Google-Smtp-Source: AMsMyM6iIherZTwp+7nDfVak/t0uviTNWSQdTwXiVe5Sjhtkg6W/x1BVylLPGu0yvsG5uLaoY8I8AQ==
X-Received: by 2002:a05:6a02:20d:b0:430:3886:59e8 with SMTP id bh13-20020a056a02020d00b00430388659e8mr15927645pgb.516.1666353756772;
        Fri, 21 Oct 2022 05:02:36 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902780900b001865c298588sm4416526pll.258.2022.10.21.05.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 05:02:36 -0700 (PDT)
Message-ID: <57da23c7-63bc-6986-8c16-7bdd53c971ef@kernel.dk>
Date:   Fri, 21 Oct 2022 05:02:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.1-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes for this release:

- Fix a potential memory leak in the error handling path of io-wq setup
  (Rafael)

- Kill an errant debug statement that got added in this release (me)

- Fix an oops with an invalid direct descriptor with IORING_OP_MSG_RING
  (Harshit)

- Remove unneeded FFS_SCM flagging (Pavel)

- Remove polling off the exit path (Pavel)

- Move out direct descriptor debug check to the cleanup path (Pavel)

- Use the proper helper rather than open-coding cached request get
  (Pavel)

Please pull!


The following changes since commit 9abf2313adc1ca1b6180c508c25f22f9395cc780:

  Linux 6.1-rc1 (2022-10-16 15:36:24 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-20

for you to fetch changes up to 996d3efeb091c503afd3ee6b5e20eabf446fd955:

  io-wq: Fix memory leak in worker creation (2022-10-20 05:48:59 -0700)

----------------------------------------------------------------
io_uring-6.1-2022-10-20

----------------------------------------------------------------
Harshit Mogalapalli (1):
      io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()

Jens Axboe (1):
      io_uring/rw: remove leftover debug statement

Pavel Begunkov (4):
      io_uring: remove FFS_SCM
      io_uring: kill hot path fixed file bitmap debug checks
      io_uring: reuse io_alloc_req()
      io_uring: don't iopoll from io_ring_ctx_wait_and_kill()

Rafael Mendonca (1):
      io-wq: Fix memory leak in worker creation

 io_uring/filetable.h | 16 ++--------------
 io_uring/io-wq.c     |  2 +-
 io_uring/io_uring.c  | 24 +++++++-----------------
 io_uring/msg_ring.c  |  3 +++
 io_uring/rsrc.c      |  7 ++-----
 io_uring/rsrc.h      |  4 ----
 io_uring/rw.c        |  2 --
 7 files changed, 15 insertions(+), 43 deletions(-)

-- 
Jens Axboe

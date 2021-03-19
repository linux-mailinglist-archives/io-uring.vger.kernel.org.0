Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25983428B7
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 23:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhCSWbP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 18:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhCSWa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 18:30:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1671EC061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 15:30:58 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l1so3598825plg.12
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 15:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gI854csR2HsdbU3pYgaTZFQa3T6Y1McW3DZPrkKPPaU=;
        b=qZpjbZc+Un4Pos9oDpfUC3Q2mnsZYQVrUL4fqCjixWnm0IOn4VDemZMeRm4CAeHxIy
         Xzb8uTbODQGhTWOxTtFWuz8/zB+8KwatKi0H9PAkxcnL0wq2wf/h17tKLHObdZN5rRMC
         oy8TpZ1UonBv1FDEZVeiwoONvqlCvirubnHa75kOuv51BTZ9//YNFkuEwTNEFsLvBDTT
         XcvlklfqgsTTo/CjIdqEKyzeTPUwm6Tzqu8JpnYM67H1YSvB3da3y3Fkivkml5HQo7Jk
         J2dsS2RT7FY4kv7lLksYftVX1gJW8+r5hSP1Y9SiSzHvHHvO5nWTpkx/flbcQe0g5Xdm
         Sz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gI854csR2HsdbU3pYgaTZFQa3T6Y1McW3DZPrkKPPaU=;
        b=mIP74+T5+n/+J/AyJgooMMkVgAYhsi/HgCdieQztBKZaWvdn27wF79JBv3QwoU1oTT
         Q9qR3zCj2KpFnRjN+wQKuFx7gjZPAM+JMnlw0i0/4BRhYmfSqJbc0e41f5SCEzcpXkce
         Qj440h0qzMaIpqbIPnYiVv085WvCwIQXo1x6uiAV9gMJ3gueN64xHemlh62LuBK7x+9j
         I0/Y+huRhG3CJD2Vit44GZySuwdQI7yfgNYA4ho9fLjvsNBVHlU+OoxLc8DlAqLPT7or
         8Az6WJyFf1vOs/vsHr6e0PAdYyIXrdrMNrDYyaxoGZ3aFRGAXkiobygU3O1IhthqnDho
         7/Dg==
X-Gm-Message-State: AOAM532idlA5z8CSyjZZRHlff6fqFrZvMXBIxW17Eym57DgY6A8IBV9U
        AVIXa2GwSCY/EEFqqFN0ANGylZOB75CU6A==
X-Google-Smtp-Source: ABdhPJzjOk/3qTymBt3+rTWARFMjgRSZtXL19ztmKcniWgx6v3ZT/kBz0KAHi/oW9Q0BIIQHEOJE/g==
X-Received: by 2002:a17:902:b28b:b029:e6:375:69b0 with SMTP id u11-20020a170902b28bb02900e6037569b0mr16590501plr.25.1616193057276;
        Fri, 19 Mar 2021 15:30:57 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 8sm6380436pjj.53.2021.03.19.15.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:30:56 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc4
Message-ID: <24fa8b65-1771-f35e-fcc9-75974a92bea7@kernel.dk>
Date:   Fri, 19 Mar 2021 16:30:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Quieter week this time, which was both expected and desired. About half
of the below is fixes for this release, the other half are just fixes in
general. In detail:

- Fix the freezing of IO threads, by making the freezer not send them
  fake signals. Make them freezable by default.

- Like we did for personalities, move the buffer IDR to xarray. Kills
  some code and avoids a use-after-free on teardown.

- SQPOLL cleanups and fixes (Pavel)

- Fix linked timeout race (Pavel)

- Fix potential completion post use-after-free (Pavel)

- Cleanup and move internal structures outside of general kernel view
  (Stefan)

- Use MSG_SIGNAL for send/recv from io_uring (Stefan)

Please pull!


The following changes since commit 58f99373834151e1ca7edc49bc5578d9d40db099:

  io_uring: fix OP_ASYNC_CANCEL across tasks (2021-03-12 09:42:56 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-19

for you to fetch changes up to de75a3d3f5a14c9ab3c4883de3471d3c92a8ee78:

  io_uring: don't leak creds on SQO attach error (2021-03-18 09:44:35 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-03-19

----------------------------------------------------------------
Jens Axboe (3):
      kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing
      io_uring: allow IO worker threads to be frozen
      io_uring: convert io_buffer_idr to XArray

Pavel Begunkov (8):
      io_uring: fix ->flags races by linked timeouts
      io_uring: fix complete_post use ctx after free
      io_uring: replace sqd rw_semaphore with mutex
      io_uring: halt SQO submission on ctx exit
      io_uring: fix concurrent parking
      io_uring: add generic callback_head helpers
      io_uring: fix sqpoll cancellation via task_work
      io_uring: don't leak creds on SQO attach error

Stefan Metzmacher (3):
      io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
      io_uring: remove structures from include/linux/io_uring.h
      io_uring: use typesafe pointers in io_uring_task

 fs/io-wq.c               |   6 +-
 fs/io-wq.h               |  10 ++-
 fs/io_uring.c            | 228 ++++++++++++++++++++++++++---------------------
 include/linux/io_uring.h |  25 ------
 kernel/fork.c            |   1 -
 kernel/freezer.c         |   2 +-
 6 files changed, 142 insertions(+), 130 deletions(-)

-- 
Jens Axboe


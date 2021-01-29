Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D181D308D2C
	for <lists+io-uring@lfdr.de>; Fri, 29 Jan 2021 20:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhA2TLj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Jan 2021 14:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhA2TLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Jan 2021 14:11:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE86C061573
        for <io-uring@vger.kernel.org>; Fri, 29 Jan 2021 11:10:21 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 16so10449436ioz.5
        for <io-uring@vger.kernel.org>; Fri, 29 Jan 2021 11:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BuQposic9hvASHqkGLin2WsC9ekOb+BLeVLVz7LwmzA=;
        b=Yr9pM76QAPvM7wVewOrvJzeSWhge1y5aRZ9i90qx3CMIrQjSWt1SWFxLzeNj66abwf
         9EHWZbS8QFDHWX3U0LHTBfnyWPxECcVTrGec5yrKZcXS1r9UfLKB1fnxFIaCzfX4P9VX
         DPTc3z7P0J0YyRWqlprrFe4r//R+ENxSsZidaRb52Jvt3CcqDEC4P+4o5EeCJyyoJ+pk
         WNpApvJ/vP5uzrTRL0/x1UStBfvmh1rrXrxhzzSF2LO+WRIKWDjmjNKFGcBZmCBJlUOr
         1l89PFx8w6ColZlOlBJc24LbYY0ByKE5tFOs1gjHMVGMmPn0evz9rnD5DQk7EX+8OHg2
         mUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BuQposic9hvASHqkGLin2WsC9ekOb+BLeVLVz7LwmzA=;
        b=hDViBn6FdEPqwNsBepWSO/l3zU4AdnxL+OCe2m0Sf7LMMTUtnwNpigxY6wHBA5YUW8
         t2LipjQcveXE47G5Eg8K2j1SRaFDp5tYLpClUxli1cvh8J4sB7jh60xCo3AubrMXdmAe
         HakHN7Z4bNiLPH/UCio8+NFt/3Y/SSpOtJjUfOgPzwnDORlApmtrwP7Zxv5p1dSrnTxL
         9Uuze9Z/8WWzvsthpeSsFrl2lLtmSzaEXD3jTheE+9HzjuNDINJz9wB/f/U/sDrcDa1E
         NQ35Znke3GrwG9awwNjT0/OdxDNXCFyNfx84MluZcy5p8RvmYfCdeb1Za9VqRN9XHNJw
         ZEIQ==
X-Gm-Message-State: AOAM533Oj67bYlthdBaqULOE8uaB0KXZYLLA4YxkWtcmOB4qacn/DZMX
        TI2pxbN/gEQP8IC/6S+aS+mm+LIxp7aZwOi4
X-Google-Smtp-Source: ABdhPJzI2t5ji2y5XqcR0WSTwPMO+hw++ERYtFwVHakB+WNBPSXQHohL/xWxe+vz/wCaICgPHyXFRQ==
X-Received: by 2002:a02:5148:: with SMTP id s69mr4945631jaa.8.1611947420882;
        Fri, 29 Jan 2021 11:10:20 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m19sm4813685ila.81.2021.01.29.11.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 11:10:20 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc6
Message-ID: <f708dbad-9147-8a9e-2a9a-c0037a99eb60@kernel.dk>
Date:   Fri, 29 Jan 2021 12:10:19 -0700
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

We got the cancelation story sorted now, so for all intents and
purposes, this should be it for 5.11 outside of any potential little
fixes that may come in. This pull request contains:

- task_work task state fixes (Hao, Pavel)

- Cancelation fixes (me, Pavel)

- Fix for an inflight req patch in this release (Pavel)

- Fix for a lock deadlock issue (Pavel)

Please pull!


The following changes since commit 6ee1d745b7c9fd573fba142a2efdad76a9f1cb04:

  Linux 5.11-rc5 (2021-01-24 16:47:14 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-29

for you to fetch changes up to 3a7efd1ad269ccaf9c1423364d97c9661ba6dafa:

  io_uring: reinforce cancel on flush during exit (2021-01-28 17:04:24 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-01-29

----------------------------------------------------------------
Hao Xu (1):
      io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE

Jens Axboe (2):
      io_uring: if we see flush on exit, cancel related tasks
      io_uring: only call io_cqring_ev_posted() if events were posted

Pavel Begunkov (6):
      io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
      io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
      io_uring: fix wqe->lock/completion_lock deadlock
      io_uring: fix list corruption for splice file_get
      io_uring: fix sqo ownership false positive warning
      io_uring: reinforce cancel on flush during exit

 fs/io_uring.c | 95 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

-- 
Jens Axboe


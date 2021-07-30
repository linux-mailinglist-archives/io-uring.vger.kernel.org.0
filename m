Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3D3DBBE6
	for <lists+io-uring@lfdr.de>; Fri, 30 Jul 2021 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhG3PQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jul 2021 11:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbhG3PQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jul 2021 11:16:41 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9F8C06175F
        for <io-uring@vger.kernel.org>; Fri, 30 Jul 2021 08:16:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so11407249plr.13
        for <io-uring@vger.kernel.org>; Fri, 30 Jul 2021 08:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XR752PBeFjEe0CFMSvnIL9yf0c4EYiEOH4m66imDEUg=;
        b=ednQRNwtJhDynZ4VArof04PYD8i9OP9zl7RdKrKcFIbb/1k1QjkKCRm28QE4+4r6B5
         OBbzznn9yEmmTLhm+P47fNMThGykaPB20NiPSqYi50GmUNoknBhmKp2YBbmz8dWNdjMN
         KOkxLRjDzZxwCdx6EIB7f6Yj9/p3hY9vaN4FhraVwG2wfJxTuDZcAa9m33/mumHT08gJ
         18/+Pm77dOi8sR4nWuD6bT+meFH9d9blPqQY/8mn0eLwswKcFkRKINyspMKM7vc6aBpu
         J9vZM6X5e4mkjPDVqE0m790ghW7LWqRca++nIiyScq38pPc0PKdbGTvTrdas1KwfWmrX
         XpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XR752PBeFjEe0CFMSvnIL9yf0c4EYiEOH4m66imDEUg=;
        b=e00t0ZixPLqSoF9MSBlSrHzySG71EOTbiAwm851e0qgftpmAC2w0WgUh9rk8War1NM
         a8j8AK+yAxpsiQeZvzqpYMD6sVTpX2eYCWKQX6VmpyidbLXLfxai0g7HS4aYBgzyu/N/
         o+TMbi0hzhjKWKo15pgibcxXQnPA05X8V9AFy9LzDukrFzHYl91kMtzFo5/3eWeYS1u3
         g7moP2ZcaurZ1SBxIzIpZB7oZAuWwG9j5F91YFfRndwn1qT3OintW8bUcn+3TD6oNiJ+
         EdGx9+Wu6L5Q3E2LD5SpIAYobjn6Bb6wlK0+mEURHxWci1EP+j3rA3OK+JZAYX3D8zD2
         6F5w==
X-Gm-Message-State: AOAM530+kxCvqkf+2IVr2oCrYKrpbd6LPP68mMbfLI1cryIDheUWT+5a
        WEuE86oVCMbXXz902IBQ60jC9M1djDOHxAT+
X-Google-Smtp-Source: ABdhPJzPEaePBJCYcB68cI0N2d2kaOrxiZkj3/Zc2kDIOYHyhIaNQcZHUZ27aJ2YsYNKZ8XoJ7qgHQ==
X-Received: by 2002:a17:90a:cb83:: with SMTP id a3mr3658643pju.138.1627658195927;
        Fri, 30 Jul 2021 08:16:35 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id j3sm2734141pfc.10.2021.07.30.08.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 08:16:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <8f298e55-c978-a5b4-82fe-084ea2246fe3@kernel.dk>
Date:   Fri, 30 Jul 2021 09:16:33 -0600
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

- A fix for block backed reissue (me)

- Reissue context hardening (me)

- Async link locking fix (Pavel)

Please pull!


The following changes since commit 991468dcf198bb87f24da330676724a704912b47:

  io_uring: explicitly catch any illegal async queue attempt (2021-07-23 16:44:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-30

for you to fetch changes up to a890d01e4ee016978776e45340e521b3bbbdf41f:

  io_uring: fix poll requests leaking second poll entries (2021-07-28 07:24:57 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-07-30

----------------------------------------------------------------
Hao Xu (1):
      io_uring: fix poll requests leaking second poll entries

Jens Axboe (3):
      io_uring: fix race in unified task_work running
      io_uring: always reissue from task_work context
      io_uring: don't block level reissue off completion path

Pavel Begunkov (1):
      io_uring: fix io_prep_async_link locking

 fs/io_uring.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

-- 
Jens Axboe


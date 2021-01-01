Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285062E8406
	for <lists+io-uring@lfdr.de>; Fri,  1 Jan 2021 16:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbhAAPAH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jan 2021 10:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbhAAPAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jan 2021 10:00:07 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC87C061573
        for <io-uring@vger.kernel.org>; Fri,  1 Jan 2021 06:59:26 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m5so6667033pjv.5
        for <io-uring@vger.kernel.org>; Fri, 01 Jan 2021 06:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=giB4KnCdhW0/LL0hvJIs8+gDRyw3IBFm/dCw5aZmvBA=;
        b=RBtlqAgKUpa5tq+RuAuFtsYHPhmFeXUl6zeYdnsice+zs8oFQb8xAmFiWasQ8ccud5
         /NMOOJL1OIDzobh5/Pcs6ByVFijDDjXmGnA0FBkZWLIuUHWV5g5nU2vcSWtwoynLmsU5
         hEdqlOmsHXZ81NqeJKENHqtyyjZh/ucoEN0gJwJVXKuKUL6X6X0kkiSF+gYIgJBM9TD5
         fqW0De0cqZR79xVp06aSAHuiTWVpHW9WHvqjxm6WbwOBNJbGoIDYt1A4XWYGpLYuFm16
         /ZeQrUsX15KJTU8A05N8PXvL92yQjuI4fp0nZ6zyxMGY8maGssCci6WTJa9OKGWgMJvO
         theQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=giB4KnCdhW0/LL0hvJIs8+gDRyw3IBFm/dCw5aZmvBA=;
        b=dknry0i3DXsTYepSgfwrbJmFA8aH8fv5oyqR0UbvaXkzs9BdFfx55rE3nwo8lNvNJH
         9gDC0Qhvlj46qwEO0CbEbGum5MU7wTPeIfuR6L3lvwIco98Z3/v5XPP12c3ApwKnOKb7
         Bp+n4GufI7cbld2JpyHDKwU0bjfXA9DXcRwQ76O3rtFQmEzjqh1jo2DLvh7vSn98IBu9
         aRdyyoaNNqkwrbWD40m5aEzOxHNUhL78Drm2tynIgJ7gKVM5XMWJ0UToaQdxLwzjtX6e
         nsWvsp5TOLvMM4l+ws+PVnlKDKd97DJkMSfz2I53TP/mqOzU2JBNmAlg9CPCtPvo9fMG
         buLA==
X-Gm-Message-State: AOAM530dR7UCZvWfhvJzirUiH0NI7+fCr33Xk5xuZZqC8MhArlmEswm9
        hIsY8PzcHBnZQ+aCFmjXlwbWmwPm/UvwRg==
X-Google-Smtp-Source: ABdhPJy6VuwYmjobcTy4kGYaEcV67a8QfqnANXVsNaSOABlgptG0OQOgBu5/rpfk545Jg/pO6ykYww==
X-Received: by 2002:a17:90a:dc18:: with SMTP id i24mr18321022pjv.118.1609513165795;
        Fri, 01 Jan 2021 06:59:25 -0800 (PST)
Received: from ?IPv6:2603:8001:2900:d1ce:7a2f:4758:8d40:5fe5? (2603-8001-2900-d1ce-7a2f-4758-8d40-5fe5.res6.spectrum.com. [2603:8001:2900:d1ce:7a2f:4758:8d40:5fe5])
        by smtp.gmail.com with ESMTPSA id e21sm49779800pgv.74.2021.01.01.06.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 06:59:24 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc
Message-ID: <aa1cf4b6-a24a-94b8-3f5f-0bad553d01bf@kernel.dk>
Date:   Fri, 1 Jan 2021 07:59:24 -0700
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

A few fixes that should go into 5.11, all marked for stable as well:

- Fix issue around identity COW'ing and users that share a ring across
  processes

- Fix a hang associated with unregistering fixed files (Pavel)

- Move the 'process is exiting' cancelation a bit earlier, so task_works
  aren't affected by it (Pavel)

Please pull!


The following changes since commit 5c8fe583cce542aa0b84adc939ce85293de36e5e:

  Linux 5.11-rc1 (2020-12-27 15:30:22 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-01

for you to fetch changes up to b1b6b5a30dce872f500dc43f067cba8e7f86fc7d:

  kernel/io_uring: cancel io_uring before task works (2020-12-30 19:36:54 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-01-01

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: don't assume mm is constant across submits

Pavel Begunkov (3):
      io_uring: add a helper for setting a ref node
      io_uring: fix io_sqe_files_unregister() hangs
      kernel/io_uring: cancel io_uring before task works

 fs/file.c     |  2 --
 fs/io_uring.c | 60 ++++++++++++++++++++++++++++++++++++++++-------------------
 kernel/exit.c |  2 ++
 3 files changed, 43 insertions(+), 21 deletions(-)

-- 
Jens Axboe


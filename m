Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2B524E24F
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 22:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgHUUxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 16:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHUUxk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Aug 2020 16:53:40 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00ACC061573
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 13:53:39 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so3055184ioj.4
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 13:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wRTJWUU8fSzdhDfTq0BRzaQ/zjJqQDUaBrIo5OOWnZk=;
        b=Y1no10iGfPv/2PVXz7+f8kv9kimyipKF+8J21cdt6AVsvfhvcbTWi+Q/Il3iLSbRT8
         xdV1npsf/jUHz0DAUJgSUS1++08kiCBtAuYBJ/EHkVnUTpsDRcA6QGvcEvy0/m5VeMPD
         M3G+GIo7m5sVH2xrsn0rCX1VesZS1uSteBgINUWJA2Y7lcuB/LCJbDKj4MytVIpVZV34
         GOy8jn7P3xLjUOx2A9qNwkklqWS5hDyQQj3J+Ity8LhjWZHlut1MsepeQg0sgQXvzExh
         so7P6NqcWi+twAOuJppn53WXMRrDTvg4dIk8XEed3QN80Nsbi2Vt8paqB2PkhmG5BRZl
         U8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wRTJWUU8fSzdhDfTq0BRzaQ/zjJqQDUaBrIo5OOWnZk=;
        b=YZYoxdIOi9hWzUG7WyXQRox2vonUVdlXuKNqumZuvPDGjvGEu7G5mKm0EdZNJgmIWV
         /++I3zcWjYvFPEFk2SNLsF0CmvBnV8ku/r9d/wXl/qHco6EjQHbUo5EjWTcVptqYSd3S
         +y5TFNsjUUJZ/ODp3wdllUkrGVyrvIOZvyv2F+8KyPcT2WFwKvNtXLxOUIZEAaD8uyHR
         wROe9dU2CW3uJYgx3MSa+bmHSJzsnQeUNltq5IPhD7GFURoco7ahocyzzT460QInTJe3
         QZb4uQPAbjfQ8qU3s0hIpdsqdiYmNC2G+qnNkcktPjedQqk9+4WFup4qj6CbkUvKXmma
         z/0w==
X-Gm-Message-State: AOAM533FLyK7mYv89vTGPcFib84DZWoESS2aP7FN5tBUSwtE4mpqJFGG
        ixJO8wfcFA63CupLAynKAvVtNA==
X-Google-Smtp-Source: ABdhPJzkU9I7orNoDSyQBLDxcjJ5TqMUrGlGqWH1hdqCZEWFKCj3T0JherXQr1TQIy79H19xWM6xig==
X-Received: by 2002:a02:7786:: with SMTP id g128mr4046748jac.45.1598043219195;
        Fri, 21 Aug 2020 13:53:39 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n7sm1835848iop.45.2020.08.21.13.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 13:53:38 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc2
Message-ID: <82c089ee-4f2e-ad68-efb4-e90e3a0c543d@kernel.dk>
Date:   Fri, 21 Aug 2020 14:53:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few io_uring fixes:

- Make sure the head link cancelation includes async work

- Get rid of kiocb_wait_page_queue_init(), makes no sense to have it as
  a separate function since you moved it into io_uring itself

- io_import_iovec cleanups (Pavel, me)

- Use system_unbound_wq for ring exit work, to avoid spawning tons of
  these if we have tons of rings exiting at the same time

- Fix req->flags overflow flag manipulation (Pavel)

Please pull!


The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-21

for you to fetch changes up to 867a23eab52847d41a0a6eae41a64d76de7782a8:

  io_uring: kill extra iovec=NULL in import_iovec() (2020-08-20 05:36:19 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-08-21

----------------------------------------------------------------
Jens Axboe (4):
      io_uring: find and cancel head link async work on files exit
      io_uring: get rid of kiocb_wait_page_queue_init()
      io_uring: cleanup io_import_iovec() of pre-mapped request
      io_uring: use system_unbound_wq for ring exit work

Pavel Begunkov (3):
      io_uring: fix racy req->flags modification
      io_uring: comment on kfree(iovec) checks
      io_uring: kill extra iovec=NULL in import_iovec()

 fs/io_uring.c | 173 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 79 insertions(+), 94 deletions(-)

-- 
Jens Axboe


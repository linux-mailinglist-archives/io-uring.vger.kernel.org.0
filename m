Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04C2438195
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 05:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhJWD3M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 23:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhJWD2z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 23:28:55 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BC9C0432C2
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 20:25:57 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso6766670otl.4
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 20:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pwfOSx1wX6GYdzGSc8rzf/eN2jrIEU1w1XluUzGFcQ4=;
        b=Gw35gxKMJxdlrlJH9CGoupHCvwQQEQkqKcrFkvOrrdWzGsnmLdvTBLE+6tKX+JddkM
         5OZkXjSykL3IzRhY30CEy0B5OhcUdXNbLVMoAN/OhqNnjeSDnaHGKYxuqj4nGTgloCc9
         hANvwdhaJL/OddcxgH9BHGtwF9KAJk5I5ww6chPzwhZ4JrcxX7V53vT/Lxh6uXdBdCW2
         yo47LErOuVx2/gMqyfF+sy09LRRbJfNAGZM5Lvv0RcTbU0bIvrP9K4PJEYeoZHFJPnvd
         NOo0fAPWBD8o2Kj9w6zTJaos9O2MtVD0Yuh5+efuCcuk9KsQoxokVJbQ5BgqjAE4aV0r
         0l1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pwfOSx1wX6GYdzGSc8rzf/eN2jrIEU1w1XluUzGFcQ4=;
        b=7ySUAM4xQHXzUa1jIVE8GMRM1bqWEy1K0XWVQWUIP8APpQoUe5CAujJ+X6tNycEyjt
         txiCUajiD8TjyHoPcCnjBCkMEqjkj9uBN3wvHTbQwKdg9zTtMnzrLxM+TmvMAFy/3iN7
         ORer3x69iVhCLDqf32/nD1PBqJcDguQ51vBTWuX5K1uIlD8wqK1+pNWrsbPpqqGol5+K
         ObhZUoKhB4LPz3p/qoPtI3bcmPMbSow9zKjuC2PBpwlSfpil1dwz/9Lv1DKAgief+cjM
         ckazC2KPJbHpzbR/3fRWuzSXVRQIOCEuOcf3tnM/FYr0sosCfyAqLgURGjPJmxaOVhn0
         juhw==
X-Gm-Message-State: AOAM531YNkEeufdcN9ucr0Gg0t32ripfvpw1IanuJmFrcS/jooAh6nqh
        Cw08nQRkbyehD//8nfn+5dLQBoY26b71DRAE
X-Google-Smtp-Source: ABdhPJyAoaXVcFdeAlUo2jPPHPyNe4Hwt7c716kuXLRWBgqH0m4dIuD8eKtuhs1z+kk6Ezb0BgNN6A==
X-Received: by 2002:a9d:764c:: with SMTP id o12mr2985809otl.129.1634959556496;
        Fri, 22 Oct 2021 20:25:56 -0700 (PDT)
Received: from ?IPv6:2600:380:7c6d:de21:1bf0:5458:9b5c:7a3d? ([2600:380:7c6d:de21:1bf0:5458:9b5c:7a3d])
        by smtp.gmail.com with ESMTPSA id j4sm2226439oia.56.2021.10.22.20.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 20:25:56 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.15-rc7
Message-ID: <722f22d3-11b0-454c-ec89-e684d13d269d@kernel.dk>
Date:   Fri, 22 Oct 2021 21:25:55 -0600
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

Two fixes for the max workers limit API that was introduced this series,
one fix for an issue with that code, and one fixing a linked timeout
regression in this series.

Please pull!


The following changes since commit 14cfbb7a7856f190035f8e53045bdbfa648fae41:

  io_uring: fix wrong condition to grab uring lock (2021-10-14 09:06:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-22

for you to fetch changes up to b22fa62a35d7f2029d757a518d78041822b7c7c1:

  io_uring: apply worker limits to previous users (2021-10-21 11:19:38 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-10-22

----------------------------------------------------------------
Pavel Begunkov (4):
      io-wq: max_worker fixes
      io_uring: apply max_workers limit to all future users
      io_uring: fix ltimeout unprep
      io_uring: apply worker limits to previous users

 fs/io-wq.c    |  7 +++++--
 fs/io_uring.c | 54 ++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 14 deletions(-)

-- 
Jens Axboe


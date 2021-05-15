Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC938155C
	for <lists+io-uring@lfdr.de>; Sat, 15 May 2021 05:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhEODHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 23:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhEODHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 23:07:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B08C06174A
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 20:05:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so312536plc.6
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 20:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hpQ+QuuUD1IRim24cWYz0AJ2KPRL6JaYgBzzycBbX3c=;
        b=PsVrHMrOJVc27WAJlTT8N8cAdKHILpAw6xpvH5yK+B463hReZuExRLRxKneziqhmL0
         HQq2I7/Qs/QhDRJ1+he1rLDd2aUTu0EZfTzhu8XIBXeyQdRduulMwW5SQhP+YLL/eEtp
         yiwbYoxIamIYQJqY8ZqqBDETCriRA3CLrfYjxBi2yJ1NK8ce9qP0umfZNaEdI8L1uE8x
         qNc6aDsj6vEbAKOPs4D+8b/RDnJBF1fB4FS5vTd+2VnfZ7wMwpQwkLOPbDYiAlKIE+Dj
         ORF3Pi4HcUAO02I4cVw0rC5AKuTrSooUwZDRB9m16EDNPKb1YyVyKo+xKRqnhoTouS2r
         weBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hpQ+QuuUD1IRim24cWYz0AJ2KPRL6JaYgBzzycBbX3c=;
        b=n0HZ526gF51LztYDoKziqWOzNye7K39RalaAwBmHo1tSMU4z1xsrDTKLMHZqKnNYl9
         DPKNikwi4zNEcOS7JmPiKUh7CSI3BTRQVH6F78BT9+BC6BRwZ5WheXjXe8O0+oolzk7b
         uODBqB/S6FOl+6c0A8PokFTRvbGZkiJYMHCX1CVOGbZx1XSWlcE79vKUj06Dh2EusVAi
         Me+ygeWrfnwmaGtaGTI2lAYXe4p8eP/XdUQnROOYZdml9gkzbc/weALZrmoyEtKkd3d3
         S0bYhUDDRL12t3VusaAfzNnlBECp8S/eOilC2TzQeq4qQIlMOskL4eaz3nvPFIZ0sLPf
         uhRQ==
X-Gm-Message-State: AOAM530m/780rRS3BqyUX6kXJz299dLKX3Ldc+9lL9F/tguy3yIY83XW
        gH3xZSNO09xB5dxtemcUO9h3rK1Ue8J+Vg==
X-Google-Smtp-Source: ABdhPJx1rXJaLhucERJAmkDW4kuZVe8j15ZXGYLi+JPGaJjbPgKqA24TaOnlTFV5D/4nqQLeTfu0Og==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr29822406pjb.52.1621047957351;
        Fri, 14 May 2021 20:05:57 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v12sm5076749pgi.44.2021.05.14.20.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 20:05:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.13-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <b2514806-2c8d-eb6c-51d9-2214fa5c573f@kernel.dk>
Date:   Fri, 14 May 2021 21:05:55 -0600
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

Just a few minor fixes/changes:

- Fix issue with double free race for linked timeout completions

- Fix reference issue with timeouts

- Remove last few places that make SQPOLL special, since it's just an io
  thread now.

- Bump maximum allowed registered buffers, as we don't allocate as much
  anymore.

Please pull!


The following changes since commit 50b7b6f29de3e18e9d6c09641256a0296361cfee:

  x86/process: setup io_threads more like normal user space threads (2021-05-05 17:47:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-14

for you to fetch changes up to 489809e2e22b3dedc0737163d97eb2b574137b42:

  io_uring: increase max number of reg buffers (2021-05-14 06:06:34 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-05-14

----------------------------------------------------------------
Pavel Begunkov (4):
      io_uring: fix link timeout refs
      io_uring: fix ltout double free on completion race
      io_uring: further remove sqpoll limits on opcodes
      io_uring: increase max number of reg buffers

 fs/io_uring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69AD39487F
	for <lists+io-uring@lfdr.de>; Fri, 28 May 2021 23:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhE1V7I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 17:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE1V7I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 May 2021 17:59:08 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AB0C061574
        for <io-uring@vger.kernel.org>; Fri, 28 May 2021 14:57:31 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id i14-20020a9d624e0000b029033683c71999so4868055otk.5
        for <io-uring@vger.kernel.org>; Fri, 28 May 2021 14:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=36ene+k3zA2jxFrOHCN8onD7IAB++4gv+HiilYkDw3o=;
        b=flwgP4Gzsp08HXwrU4VTTyHO+oOTYp8K5NRjfU46tYe2Wgyda7bf8PBKN0sZTpSV51
         1fdp2RL3rGzkbcAwX4rtXrGIVHZw7HR8rukeO/U5zsP1IouQEt1bk0a71ggmtbPQdNWA
         3qHOFVC2s+moO5vtIzR4afwJtCehLUY1ctAPhBhfO6cDQqjS1ST3cYxAdKE+atHXFgs6
         rgU9mONNxt4OecRQLWsOKSQYcAHTursjRyhM7vfVwFEjnl3tTHNMMirSyAi574l7iR+0
         sq9egadZ8M2pexkzy9jLXdhzPHHHFS4ONk25YFW2B7MwX1ds60WPL2MMYGBzkb43zQr8
         KVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=36ene+k3zA2jxFrOHCN8onD7IAB++4gv+HiilYkDw3o=;
        b=A1cuoZpPZQPm0wXx5N1XK6oWRB2f/eF3OTwsY0QelC/E9DCFOml32dIuXjoSdkRu8e
         c03sfsiHLp/ZGTrihYc8eQsF1VLY5tfVA8Bujr9H6GAsOiDlJNoSeNbO6fPGNV4X4Vvf
         0Kmx1shm0rZZC9ND8B5F/SsJMaSvLk2zMrZJ4oRyx+A6sOZVaB1f1ZMlMxc7tBblirh8
         +OTA7+nDs5IMZrwm4jVq0VgEuRTdyEcLZTaGOCWHijNcFgix3R61QTELg+2Lw00uo3U7
         6OFF8VDHUM/dSVL1JtvjgbxiHlXvwyxPK5r1/V1RW6obycs+wh+IFwIreacqU2277Ae1
         Q1cA==
X-Gm-Message-State: AOAM533ONvQo26edX2KdlRuUeE0KbUP+AkXTPmOoyuDlqj8NppoOZA6T
        W0n4IGmT/1RX3vmo8N5227asVwqd53mIhQ==
X-Google-Smtp-Source: ABdhPJwEssQXr5NJUtjFS6n+QuWnj4jfYVQAD+HNucFbN6iW8jpAfOGcWXDYktv7bMdwAfsIuN5i7g==
X-Received: by 2002:a05:6830:12d6:: with SMTP id a22mr8998258otq.66.1622239050746;
        Fri, 28 May 2021 14:57:30 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id a18sm1434658otp.48.2021.05.28.14.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 14:57:30 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.13-rc4
Message-ID: <e57bc7de-54fa-3f76-c94f-e9321414a90e@kernel.dk>
Date:   Fri, 28 May 2021 15:57:28 -0600
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

A few minor fixes:

- Fix an issue with hashed wait removal on exit (Zqiang, Pavel)

- Fix a recent data race introduced in this series (Marco)

Please pull!


The following changes since commit ba5ef6dc8a827a904794210a227cdb94828e8ae7:

  io_uring: fortify tctx/io_wq cleanup (2021-05-20 07:29:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-28

for you to fetch changes up to b16ef427adf31fb4f6522458d37b3fe21d6d03b8:

  io_uring: fix data race to avoid potential NULL-deref (2021-05-27 07:44:49 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-05-28

----------------------------------------------------------------
Marco Elver (1):
      io_uring: fix data race to avoid potential NULL-deref

Pavel Begunkov (1):
      io_uring/io-wq: close io-wq full-stop gap

Zqiang (1):
      io-wq: Fix UAF when wakeup wqe in hash waitqueue

 fs/io-wq.c    | 29 +++++++++++++++--------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 15 +++++++++++++--
 3 files changed, 29 insertions(+), 17 deletions(-)

-- 
Jens Axboe


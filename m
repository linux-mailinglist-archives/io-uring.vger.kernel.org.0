Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDC279870
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 12:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIZKiK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 06:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZKiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 06:38:09 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5139C0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 03:38:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so4519151pgl.6
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 03:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nwfl/lq62BitkYKKljOu/Q51PCsKRJSgIX5wZoOi3oI=;
        b=NsTaMYUEPNBEl1Pzu5Gqkx/YyTb9he0wpQDZe2mN4Uc1ZhdvBroSjmeUxP532rkSOs
         1cdH1MPkdHeiD1WvgeLSQNC7cRrrgXwvswMW+vGDLmKBQarvAePu9bACFBfPzKXh/3wZ
         uCZHY65WiNty3oR7WZEL81A3nAqsMdkQ2T0xugwOB7nZ4UtZSLUhlNuvuTRcNqg07H7B
         XJPpU6UXr3xoHlLGyBTqyT9dFfktpWoJHQOQOWVn42KdU2aJMYLvaXixyZX3Mq4aHVyK
         7c/2L2Toq8Hyx9tO035ka3oXFtcNnRJoaFKbQVaouiAOgyHR1skHW7ltOHiSWGYN39qi
         q41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nwfl/lq62BitkYKKljOu/Q51PCsKRJSgIX5wZoOi3oI=;
        b=WCDCWt2p5lBhfJuiRcMEXHsCFPJwSu6WGe7WPq+/6YWAocv4aaI1ZJ2xEJDCyTlBls
         1Dmfqp48JEwVZ/0FDv4x154bm/2tiu5t2PpgSWPXjlAvkmvHafmB0cn5bpGA5WdBxdMH
         Szn53ho8NId+XVX1WXKvizunRL3KkNAjZq8vD5EVngzQRIes52IXAoPpJbGG+F7xnOxd
         xk8Y+MtnglSn61PfX29uYLjUvsfo/99A8eSLtnS9LZpi1MiFTJoFo0276jnPR6EPfktj
         mhERrEEiw9fXuKQhbnNrRJk+kkDtYE9S2ypgsjWVEIWAL77/avvy3ADid1ihJAZBIxg5
         Dyfg==
X-Gm-Message-State: AOAM532iEOwp5QPmffifM423deOxk8G1b94iYVhA6x3rwZ4UPAyDpJEk
        7YllLs1XDfjfaMx6E6JyuJIq+Q==
X-Google-Smtp-Source: ABdhPJzWS2S6+JPBXNWk5aDAyGJye2nQkN2CGcidP2w+hj4511pqgQAifUIlIW7YZv1A4y202j3yGg==
X-Received: by 2002:a63:204c:: with SMTP id r12mr2481344pgm.262.1601116688969;
        Sat, 26 Sep 2020 03:38:08 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f5sm4711685pfj.212.2020.09.26.03.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 03:38:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <e5c4b3b9-84c2-adf8-6449-459524695431@kernel.dk>
Date:   Sat, 26 Sep 2020 04:38:07 -0600
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

Two fixes for regressions in this cycle, and one that goes to 5.8
stable.

- Fix leak of getname() retrieved filename
- Removal of plug->nowait assignment, fixing a regression with btrfs
- Fix for async buffered retry

Please pull.


The following changes since commit 4eb8dded6b82e184c09bb963bea0335fa3f30b55:

  io_uring: fix openat/openat2 unified prep handling (2020-09-21 07:51:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-25

for you to fetch changes up to f38c7e3abfba9a9e180b34f642254c43782e7ffe:

  io_uring: ensure async buffered read-retry is setup properly (2020-09-25 15:39:13 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-09-25

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: ensure open/openat2 name is cleaned on cancelation
      io_uring: don't unconditionally set plug->nowait = true
      io_uring: ensure async buffered read-retry is setup properly

 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B443E365B
	for <lists+io-uring@lfdr.de>; Sat,  7 Aug 2021 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhHGQvv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 12:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhHGQvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 12:51:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E325C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Aug 2021 09:51:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so11465710plk.13
        for <io-uring@vger.kernel.org>; Sat, 07 Aug 2021 09:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jPKR/YsLprdxsDidnfMOoYfJSJNHUO8W8yLOQdXgBKA=;
        b=v47xWbH7LOWEO5sIq5DKvT7P4XWsDEiAKZbtuIMTJuZK6TblKpzmuUngr1B77ENyTR
         bHhOwQOFgnAoxM9YTWOn6hz6jVVsF4HTZ5IVYfy3xXvVBTNOfBNHyHBx1Z2tz5U7r8eb
         oqGkKny/eSH+VBIE0G3Ho6gGzSdCdpTptGzpJHml+0EH62gyM27qC2LeUwIcsvCOnVBm
         Uu4HXBZxz/Pr27r8i3q3fnkWbRTqIp1QkVx2eZSr8l6xsnAdM2fyKCiXjMis1kbQwl9s
         YMe5SkhtQqZXqkKNr08zG1FL/YrBzk1CcS4o1JVZ1jrgRvmMnrY8n7f/h7l/pkgEgTW8
         01ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jPKR/YsLprdxsDidnfMOoYfJSJNHUO8W8yLOQdXgBKA=;
        b=XZq3xNTcYqLirmXVKaCT6YGmxw02XBNTM/n18z/PLeZLHLeQS9qSq93HTzlUCJDMpr
         KyZ0V4Ne/0nPbp00J3fA8cXsLwYzWhNACEwd79hyjeKBEkKk4b9902KgjU4K5WG5uj9K
         MwiG1EQ8nZ/1noR4TwoApD+XQVU3gxQz1mVHKR450UA2SydTU0IOmzbONzHNV7BjNAxK
         gTGt8rPB0x5Z7hV7MPlGNzr8kQ5WWmMUD3NtFlUzsj1VSFbCS3rsoEGbksGOt4loM37a
         J5wQyNqpEJhIMollAVZNIPm09RdOUdbK+h6XrcEdGwAzcj5YRy7leJyrJSYKA6acKOWK
         YtwA==
X-Gm-Message-State: AOAM531tNtBdPZMg9G1XrSAOyOHSwmz20DEr8dmhwVwNt1R032oNfcPe
        WHiAyVZnbS35TW4BNy0oIyqsPUlQso/v6IRD
X-Google-Smtp-Source: ABdhPJxp5dERqtLI+n6AGorX4Jxkbd9nCmjpGhRhLPBHKpRSdVrPBI1ROZhGi93baneC1mUnM1MVsg==
X-Received: by 2002:a17:90a:c57:: with SMTP id u23mr26741437pje.186.1628355091743;
        Sat, 07 Aug 2021 09:51:31 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 16sm14601720pfu.109.2021.08.07.09.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 09:51:31 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc5
Message-ID: <5559f44d-e2b7-cb98-8007-aec9d3075645@kernel.dk>
Date:   Sat, 7 Aug 2021 10:51:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus.

A few io-wq related fixes:

- Fix potential nr_worker race and missing max_workers check from one
  path (Hao)

- Fix race between worker exiting and new work queue (me)

Please pull!


The following changes since commit a890d01e4ee016978776e45340e521b3bbbdf41f:

  io_uring: fix poll requests leaking second poll entries (2021-07-28 07:24:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-07

for you to fetch changes up to 21698274da5b6fc724b005bc7ec3e6b9fbcfaa06:

  io-wq: fix lack of acct->nr_workers < acct->max_workers judgement (2021-08-06 08:28:18 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-08-07

----------------------------------------------------------------
Hao Xu (2):
      io-wq: fix no lock protection of acct->nr_worker
      io-wq: fix lack of acct->nr_workers < acct->max_workers judgement

Jens Axboe (1):
      io-wq: fix race between worker exiting and activating free worker

 fs/io-wq.c | 71 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 26 deletions(-)

-- 
Jens Axboe


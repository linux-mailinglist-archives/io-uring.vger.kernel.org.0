Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654E94685E0
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 16:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbhLDPVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 10:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbhLDPVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 10:21:01 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85FAC061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 07:17:35 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p23so7551390iod.7
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 07:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pOLH9Zc37mQrkwh7t/wZuuspJAx5FV0JovG4QXu6zCY=;
        b=BYnUsC9oYmOdtu49QFQWhFMyKHUwR+gnesJVUzIIVBHLH0w1KPg5tx/z73f1xSpJCI
         fEy55lJ0ZNq4Xt70SfvlqT2vB6OhFkqDp0eatSC1+tArC8U0/t1xscypSLbJHQAHL/xG
         XKm1ylD6Tw5zfx0qFvt84V2IPKKnLlhu53Xwq1Y12Hm5OBoUpJLCmC5G+DFUXMZapOev
         w4Oor67g7b5mZaWwW2rJjVV8Kq99/rM0x2BdCr7+ZeSvh6XHSf+tesRfo7v5qIVuHZct
         Va6tRpmYartZg4N3eXvLIMz9IfC1Td9cgr6m4K/i9KLIWtfa6AEOpd2lg7is450BIEiX
         RVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pOLH9Zc37mQrkwh7t/wZuuspJAx5FV0JovG4QXu6zCY=;
        b=G6VnZh/4pmHkcjNJD+eGSG95D6YJccaqcJVrU7conZD8FgHo0ijA7TH3ki2F0h9Dwj
         YCVljVfjlXs9U7k34R2ABJ0QxOd+kTDt8UkGrL0uvUlA+ukjGL+IiG3TMrrncKkLHJVB
         t24LMxAeuv/BRq6j6s1dySZyfi4ilTrrevrImRqK6PuA5pMnuUdCzLDJ2l0yNnRfSyKp
         r5WuYkXbNy6riSrtmNO8WnL7klmdDKSw4X6V6DEOcw180VDZWltxfH2TwTAIVi2ZSCfX
         LCO2iwjUS6NcRGgeBjWGFSIR3s4c6jDaunS29d13uICKyOAezpwfMxfBT3ICyfXNGLIo
         58bA==
X-Gm-Message-State: AOAM532Vr03kmYb4wFG9t3fzMN70Njw+p2u2Jyzgi6on7vADH1uISygs
        hQXa0sv6QmYsanCfvOZR1ejvFpF3sD6PCoCL
X-Google-Smtp-Source: ABdhPJxdm7L+XU2Jeh6rqZlQo/H3TiDWRWTwKqfrSHVNqp2cnM3M1bQs0A2nHNhh9KvfyWYxVJFNMw==
X-Received: by 2002:a02:1949:: with SMTP id b70mr30837310jab.7.1638631054777;
        Sat, 04 Dec 2021 07:17:34 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r18sm3207719ilh.59.2021.12.04.07.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 07:17:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.16-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <259cf13f-2013-bf3b-4e73-cf38fb78629b@kernel.dk>
Date:   Sat, 4 Dec 2021 08:17:32 -0700
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

Just a single fix preventing repeated retries of task_work based io-wq
thread creation, fixing a regression from when io-wq was made more (a
bit too much) resilient against signals.

Please pull!


The following changes since commit f6223ff799666235a80d05f8137b73e5580077b9:

  io_uring: Fix undefined-behaviour in io_issue_sqe (2021-11-27 06:41:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-03

for you to fetch changes up to a226abcd5d427fe9d42efc442818a4a1821e2664:

  io-wq: don't retry task_work creation failure on fatal conditions (2021-12-03 06:27:32 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-12-03

----------------------------------------------------------------
Jens Axboe (1):
      io-wq: don't retry task_work creation failure on fatal conditions

 fs/io-wq.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
Jens Axboe


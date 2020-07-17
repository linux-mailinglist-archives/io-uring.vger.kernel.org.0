Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A8223FEF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGQPwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQPwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 11:52:15 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89147C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 08:52:15 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u5so5565715pfn.7
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BIJ0H+rrPt+l6s6jH/5QTDHwke6LDMQjCn4+Qb4EHhs=;
        b=PIXLAzYnDdFiOJ0IrkQrjfUPsv/WrmGn3ce139GjtgIaMKENpq3XTAD8nSdi6EMMy8
         JMpBne/E0KyqSmkFCAmglWwFFXpu9/YsVK2eLQRBUVkYh5YmXXYT7f5/1/DEx6A3/qfS
         jKxbQ1Z4oH/wGujc3Sr7qLeFdjYb4FCylCc53gLOQ5Uai1Bs7GIJ1rLEHlqz1I6LMCp1
         gVb9Es1YIfcGXxAsmZN+CsGRfsJ77WnpMNg42QzayiOKdIii7RxECqmwgWLPQMCB9/76
         p9fR2ec/hhwmtjhmQ8eZub+J0qkohwy4QrogNXxDqM7R0toNLOHfmbJ8XsZFhid90+Rp
         SbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BIJ0H+rrPt+l6s6jH/5QTDHwke6LDMQjCn4+Qb4EHhs=;
        b=RQDfiGuLmJCjmXHILm/Xa/8cizjAxBDWs2Af95fPEvOM06pW0b2hqvB6ZN+pnz0Kfq
         VQL4ehRUdwYA+JXSiQQQ6JdYTwpyU8HWB5FwK936wEYyOAKnWZqcZNQBOa1Q62+yUSf8
         CTk2pspPns/1vDOjPqUnKYIkQ4LL5t/Uh5ka50OPixvbsadq/HgnVwm/UWePW//0BBfN
         +C6d4S/Txa5fdcmWIK66TQjaZLQm4A3HQidFkxj6iTrzgCrSlL9o5KCsERFuX160TGFV
         Po/3YSLIblkt3SjS8t5UpIPHhZIj0p52Sa17P8X1rquGZ3ZWoKq7ye5p6AYeEVL04ZWo
         0zOg==
X-Gm-Message-State: AOAM532SWkUJoUthRnlrFsy0Pgg1jktb1Utyjbery9bxoC9bn3GjeaFV
        VxqItdJCJfcOA0e+31uOLcs6fA==
X-Google-Smtp-Source: ABdhPJyB9GpkAjnOjBaf0gAmE9ZbTIUTjcR1GKAIVvzfUFrAqZke/crwFZ+2HHAtlNTCjjJtNdYz2w==
X-Received: by 2002:a63:3d85:: with SMTP id k127mr8541126pga.29.1595001135087;
        Fri, 17 Jul 2020 08:52:15 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k189sm7988029pfd.175.2020.07.17.08.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 08:52:14 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.8-rc6
Message-ID: <7dd248d7-330a-cc1b-9ddc-bac57c3581d0@kernel.dk>
Date:   Fri, 17 Jul 2020 09:52:13 -0600
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

Fix for a case where, with automatic buffer selection, we can leak
the buffer descriptor for recvmsg.

Please pull!


The following changes since commit 16d598030a37853a7a6b4384cad19c9c0af2f021:

  io_uring: fix not initialised work->flags (2020-07-12 09:40:50 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-17

for you to fetch changes up to 681fda8d27a66f7e65ff7f2d200d7635e64a8d05:

  io_uring: fix recvmsg memory leak with buffer selection (2020-07-15 13:35:56 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-17

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: fix recvmsg memory leak with buffer selection

 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
Jens Axboe


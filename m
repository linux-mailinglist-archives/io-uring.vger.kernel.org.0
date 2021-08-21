Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED47F3F3821
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhHUCzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 22:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhHUCzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 22:55:04 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137BDC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 19:54:26 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id v2so11385912ilg.12
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 19:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6y6bpffAYIs7bJKwD1loWZvNKlh1TvBumfGJd7JsB9o=;
        b=ZSQ5USYyHX/0Xb3ndQHqG/XH8vcDZoB48TO858swu7gKHe73j6jkaf/yskucy8mPbZ
         fcjFCQVgBRHL3AiLKzRlhPMQHUzAVKHSNxTWymbApx9rMAJa1KUAuVFpb48JGnyyhWEQ
         VPEu7bkTdpxaFDrsnR0kGxsLiQCxGbT321Fi5WQfXTmAo9cCQnHRW9vHjiDlNBksZpvy
         +ty4BNuI4BO4Nvzq8nzB3cDm1BD6FdbOVyuElf72Q5jLcaJzs+PXZGhfAAfXLAlLIeYw
         7mw4Mzcg/eONypxV/+0Gl9wGCJNqjyqnTwShdvG5nfXvARDahP76xOqXUkDNE4+6/L98
         34tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6y6bpffAYIs7bJKwD1loWZvNKlh1TvBumfGJd7JsB9o=;
        b=DRWb/Jb2TIomiN95HhQlmnpcLOpJekxmWw0LMRkNDuowmUE+F8fYQ8Ccy8VCV+hC3n
         cjewhkpQ/BWb2IM8m20bXUNy2VQFopu/HCO5NoZapVL8RAO/VOUX1LBGj5xZxLslaA6M
         5FdRIt5Pn1DHye/o7w81mZyc/Clf16CYaS0Eb89XfC85qBjJZW1QGCdGix/rG9xBSGNp
         +wBGekma5MLcmCF9JYVeTfPRs6LoiknrGGh8ShFm7XLu1dnfVr9QttlHfzhrXJZbdap/
         vd9kqAJuAlCwYxcpfYf6JxDCvPc/XEj7+WDiFnVorZXYyLN5jKSqPiP4uAqBAhiva6rm
         JqWg==
X-Gm-Message-State: AOAM533ZgoVLKoyTSgiX3LOCIhlUlIjiyYuu1RG7B/jNejwIm+vJrq6B
        MgiFzPP1WE1WfO9XExu1lAwtg+7ETqcOQJoy
X-Google-Smtp-Source: ABdhPJy8LSOfRJ8IQIY6CbjGnR5jcl06c4ZLn31LEiDiwkDXKdOoFQSm9nK52QVtSoYuWMtcuCFB8w==
X-Received: by 2002:a92:2e0d:: with SMTP id v13mr10659138ile.111.1629514465241;
        Fri, 20 Aug 2021 19:54:25 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f5sm4428804ils.3.2021.08.20.19.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 19:54:24 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc7
Message-ID: <9029c179-a0cc-db86-e2e5-4aa234278ee2@kernel.dk>
Date:   Fri, 20 Aug 2021 20:54:22 -0600
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

A few small fixes that should go into this release:

- Fix never re-assigning an initial error value for io_uring_enter() for
  SQPOLL, if asked to do nothing

- Fix xa_alloc_cycle() return value checking, for cases where we have
  wrapped around

- Fix for a ctx pin issue introduced in this cycle (Pavel)

Please pull!


The following changes since commit 8f40d0370795313b6f1b1782035919cfc76b159f:

  tools/io_uring/io_uring-cp: sync with liburing example (2021-08-13 08:58:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-20

for you to fetch changes up to a30f895ad3239f45012e860d4f94c1a388b36d14:

  io_uring: fix xa_alloc_cycle() error return value check (2021-08-20 14:59:58 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-08-20

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: only assign io_uring_enter() SQPOLL error in actual error case
      io_uring: fix xa_alloc_cycle() error return value check

Pavel Begunkov (1):
      io_uring: pin ctx on fallback execution

 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
Jens Axboe


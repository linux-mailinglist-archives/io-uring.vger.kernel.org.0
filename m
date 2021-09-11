Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E757B4078CE
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbhIKOa6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 10:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbhIKOa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 10:30:58 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF480C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 07:29:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id m11so6132997ioo.6
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 07:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TpgvavsUMl3AOjnQvYbMZVFiwBp3wdQKUlkkeOOkevU=;
        b=QxR8+I8mIE7iw2GjgBJ3N3MPU1wjQ2YzgoIL6kRSq/x8yd6WBbcD8NR1FgW0WPwyzr
         NZZYgL0ZVgOOZ+h1VH2LUuGOamJOTwGvtdEO3GzmBa68uiDAz4EMg/zUWoG4QIuMIOJK
         XmNopkRkembV2cLbNLEYwEE1qdWfq5MH3Ty1W0wRMjOiExdq9/kQNsyEr4Y6ixsuzMI+
         j0QljmjqlCkaSpcjHa4knSb8PdW+gLWnoNeNMs3QOTKYzNMmpUr3sWIJTI6rW2XuIbHe
         ugB+0x9tsro5kZQSCE5bidhQQb5/ZYIomKbYMPN1oqdmCWnK2SoUbRlaIIFAkoPquemp
         JRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TpgvavsUMl3AOjnQvYbMZVFiwBp3wdQKUlkkeOOkevU=;
        b=ncEBGM1Zf1ErEquut6xXHfCj0WoOYnc8PGWzEd2vMIyYGLet6xHpGPLjqm6NNBcC3G
         Uq0vwQGYJhIRtSSRVB6BCbxwFNa6qyUIaAGGDi40gNUp2HgwIimFSgWJ8XUcZH4WxpCR
         KMTcjC44oVEoNqRLAnOle4yNahGAwaGztX2gYCS3iYgDil/yhiMyKua8kUYB4UeFZhoS
         2wwQkIjudQGfg9TToULoWTYvtShwm/B08rrhi4ygeSNqtgynTDp+stfogdYIaJQ7mMBG
         ZCjvEultF/9RBg5g0+xBlI8GulQENKNZn7t6LcFjpIJ1tlTQnylhCPd3kKRhYbmeyUk3
         Y5UQ==
X-Gm-Message-State: AOAM533aVAObumqWaXF1XMncYC7+UdkRwmXdaUYkEEjBkG+FX+aqSpJH
        4ztL9/unLze8X3X2cXB810RYjH4c0OaNYA==
X-Google-Smtp-Source: ABdhPJwUr6XGNWhirSb2jY+TjKhnQcAYalipB6wEeVR8wm5g/vfUX1EhStak8HKuPP6HwA12sayYDg==
X-Received: by 2002:a02:5184:: with SMTP id s126mr2373380jaa.126.1631370584966;
        Sat, 11 Sep 2021 07:29:44 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o5sm906618iow.48.2021.09.11.07.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 07:29:44 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.15-rc1
Message-ID: <575336ac-5915-a39d-7cb4-53df92c26bd9@kernel.dk>
Date:   Sat, 11 Sep 2021 08:29:44 -0600
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

- Fix an off-by-one in a BUILD_BUG_ON() check. Not a real issue right
  now as we have plenty of flags left, but could become one. (Hao)

- Fix lockdep issue introduced in this merge window (me)

- Fix a few issues with the worker creation (me, Pavel, Qiang)

- Fix regression with wq_has_sleeper() for IOPOLL (Pavel)

- Timeout link error propagation fix (Pavel)

Please pull!


The following changes since commit 626bf91a292e2035af5b9d9cce35c5c138dfe06d:

  Merge tag 'net-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-07 14:02:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-11

for you to fetch changes up to 32c2d33e0b7c4ea53284d5d9435dd022b582c8cf:

  io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT (2021-09-10 06:24:51 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-09-11

----------------------------------------------------------------
Hao Xu (1):
      io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT

Jens Axboe (2):
      io_uring: drop ctx->uring_lock before acquiring sqd->lock
      io-wq: fix silly logic error in io_task_work_match()

Pavel Begunkov (3):
      io-wq: fix cancellation on create-worker failure
      io_uring: fix missing mb() before waitqueue_active
      io_uring: fail links of cancelled timeouts

Qiang.zhang (1):
      io-wq: fix memory leak in create_io_worker()

 fs/io-wq.c    | 41 ++++++++++++++++++++++++++++++-----------
 fs/io_uring.c | 16 ++++++++++++++--
 2 files changed, 44 insertions(+), 13 deletions(-)


-- 
Jens Axboe


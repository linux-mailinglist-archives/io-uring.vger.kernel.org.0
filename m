Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3863259A9
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 23:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhBYW15 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 17:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhBYW1n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 17:27:43 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD926C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 14:27:01 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id z18so6365566ile.9
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 14:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5TnCKx8QFsrUVjIxnuOZmsHJYy3mkpNpdSFL1K6GXw0=;
        b=sMkKddp2hlMjmHlkUXq0l3XF071fp/O38y7RgrpBme9pW7zIsYVLbBpnQQRAS4t/Ut
         TwgNzOSqjpUAbXAEFa3ATL7nWasBszhhJxztyAVwa+Wnksm7XT9Q7FJSTdzVtf9IROqC
         0vwjB5D9zXsOB86+rRoMjXsv1ir8ZQmPN4SKqlSmynlsvolvvJPfr+YOLSwUOalWr/Uq
         tsYtgHntw+ZOH0RZP+gK6DvPorEU2IDXahfn9C0oaVnyx/ilBN91nALFlkls1k53ujbd
         SDFldtqQyWb6Th7Ixgqr3Y8ulncLhZYPc6japwM9sgdNt+sg6O7dwuhRyR0VJI2a4bBH
         SBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5TnCKx8QFsrUVjIxnuOZmsHJYy3mkpNpdSFL1K6GXw0=;
        b=KFgsb8kSxcEvaY99VvbPzmvZVNJbWTJGG3nyVD5DNC1dN1y4bXyh3+n4E5a8BcqqFV
         SzGc5w0A+jwOoktG5Ov1oHJ0ZDJF/dGyaG3RIEotIDeMMaiv12CugsNZlOMF8uULM/Eb
         894DrofI91SbCQz7ONSbhpmU/Qruww0yF//lVTdj1/y8hQHJfc7SZ+TqhgkaFrlnrgF1
         +0HPf1wa+Xb/TqP4/MCbRe9XDIVLP3wITG2evNgMnILhPSKcgUniS8rYvZ04AyMcg6gY
         5ifj6D8X94ojFS93oEzsRroEh106/AVyNVlq+paWnglglk/+YI3vamGPrvUnRAZWaeNJ
         QY+Q==
X-Gm-Message-State: AOAM531V3Snfo2OXDG9Pa5XqLWxKY2/mWFkof9W6eqf4/Fsz4g68aUf4
        yFUfJP4JWgdNKsFDtSbHA5X5YQGu5eLjZQKo
X-Google-Smtp-Source: ABdhPJxJ6RalUwO2ZsAxSUHoVokNznguw+ozZ6wToKZCvoqzvs2MUl1tRdxQfv9uy17I8CB3xIepXA==
X-Received: by 2002:a92:8bcf:: with SMTP id i198mr4432367ild.152.1614292021094;
        Thu, 25 Feb 2021 14:27:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i6sm3710538ilq.51.2021.02.25.14.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 14:27:00 -0800 (PST)
To:     torvalds@linux-foundation.org
Cc:     io-uring@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 5.12-rc
Message-ID: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
Date:   Thu, 25 Feb 2021 15:27:00 -0700
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

A collection of later fixes that we should get into this release:

- Series of submission cleanups (Pavel)

- A few fixes for issues from earlier this merge window (Pavel, me)

- IOPOLL resubmission fix

- task_work locking fix (Hao)

Please pull!


The following changes since commit 0b81e80c813f92520667c872d499a2dba8377be6:

  io_uring: tctx->task_lock should be IRQ safe (2021-02-16 11:11:20 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.12/io_uring-2021-02-25

for you to fetch changes up to cb5e1b81304e089ee3ca948db4d29f71902eb575:

  Revert "io_uring: wait potential ->release() on resurrect" (2021-02-25 07:37:35 -0700)

----------------------------------------------------------------
for-5.12/io_uring-2021-02-25

----------------------------------------------------------------
Hao Xu (1):
      io_uring: don't hold uring_lock when calling io_run_task_work*

Jens Axboe (3):
      io_uring: make the !CONFIG_NET helpers a bit more robust
      io_uring: don't attempt IO reissue from the ring exit path
      Revert "io_uring: wait potential ->release() on resurrect"

Pavel Begunkov (21):
      io_uring: fix read memory leak
      io_uring: kill fictitious submit iteration index
      io_uring: keep io_*_prep() naming consistent
      io_uring: don't duplicate ->file check in sfr
      io_uring: move io_init_req()'s definition
      io_uring: move io_init_req() into io_submit_sqe()
      io_uring: move req link into submit_state
      io_uring: don't submit link on error
      io_uring: split sqe-prep and async setup
      io_uring: do io_*_prep() early in io_submit_sqe()
      io_uring: don't do async setup for links' heads
      io_uring: fail links more in io_submit_sqe()
      io_uring: don't take uring_lock during iowq cancel
      io_uring: fail io-wq submission from a task_work
      io_uring: zero ref_node after killing it
      io_uring: keep generic rsrc infra generic
      io_uring: wait potential ->release() on resurrect
      io_uring: fix leaving invalid req->flags
      io_uring: run task_work on io_uring_register()
      io_uring: clear request count when freeing caches
      io_uring: fix locked_free_list caches_free()

 fs/io_uring.c | 686 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 346 insertions(+), 340 deletions(-)

-- 
Jens Axboe


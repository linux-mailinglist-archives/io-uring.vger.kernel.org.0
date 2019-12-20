Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6E1281BB
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfLTR6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:58:05 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39139 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfLTR6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:58:05 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so8814652ioh.6
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=s/dwN/k0n9m3KtAUf9EK0ym8SSRroihgFdglxdU0p/E=;
        b=a76eK4O/pDYs2xZJPtXAt/a/VD30n7TTs5hsC4vXzdWFhrSAPZwOT5og8VbTwkoST1
         +d1u2DF/JekZiT4Z1Oj2OZv6/JSdPPAx74cnX93UDRXiiTBnXZbTbTtxaSPVsIFuHn1k
         DE/ablA7BJVswqCeOgpYdAin/ihyGPzpYcCDnyFHMe64sT6exjBvo5o3D20xR1wSFJiW
         1bTs4CrfBoq8RpsTPqfeMuxZFW73iFiKD/0CXvEAfh9f/9YjXzf2CdhqkS6apswjbOxE
         DtlHPZJ8fJkiCfPhDPsVjhObpFj2IGVgEzSMuCQIjvt2PbtPckjqJgc/M/VqERMsmdqc
         mNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=s/dwN/k0n9m3KtAUf9EK0ym8SSRroihgFdglxdU0p/E=;
        b=L52yvn3AVGUEeqRtPb7Aas+Wz6TCFdGb0DhCgEPlLmoERH1VPbCSZl/nUR7puXAyfj
         0d2G/N6DuCIj9+YD8ENv2+qzhijbYHzdo/0jYr3s4jyVpnAAk/xKOlM+d5m1pmacjkZX
         5F8LQU2X+2vRPItb7FQ9aGjraAis3aS1zgT1lqKCCg7SbBO3IT7zpH4sQXbOhKmUoXLE
         LMKj+O8UKwkTyfba4Lv91buIfT5So5iCGx7q59vgnF2x6A0u2ZURqEKhC5OCCad05Uac
         xNtUKo/vWKGU5PcSV/QTB64d0xzLiUEZPG8ns8FxRFgAKbOds2wHawNo8d6h/cVhtr6J
         YuMw==
X-Gm-Message-State: APjAAAUF4irq6MpIYqQDRh8DghQdPDg5Os2Io5IyRGI7SQ0N4fuKMwii
        lP8ZJkqOKW7gmWlfQq6bgkClu9STNxowOQ==
X-Google-Smtp-Source: APXvYqwIj8QkVuuvqvhuJ+noplL+8O1H+1qyjB0TcYeRKHwnrQeV8pL4lHTzbDc455ARHrW6jiokyQ==
X-Received: by 2002:a6b:7201:: with SMTP id n1mr9801834ioc.37.1576864684012;
        Fri, 20 Dec 2019 09:58:04 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m189sm3531776ioa.17.2019.12.20.09.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 09:58:03 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.5-rc3
Message-ID: <43114042-7b13-da79-12cc-83a67b5afd1e@kernel.dk>
Date:   Fri, 20 Dec 2019 10:58:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here's a set of fixes that should go into 5.5-rc3 for io_uring. This is
bigger than I'd like it to be, mainly because we're fixing the case
where an application reuses sqe data right after issue. This really must
work, or it's confusing. With 5.5 we're flagging us as submit stable for
the actual data, this must also be the case for SQEs. Honestly, I'd
really like to add another series on top of this, since it cleans it up
considerable and prevents any SQE reuse by design. I posted that here:

https://lore.kernel.org/io-uring/20191220174742.7449-1-axboe@kernel.dk/T/#u

and may still send it your way early next week once it's been looked at
and had some more soak time (does pass all regression tests). With that
series, we've unified the prep+issue handling, and only the prep phase
even has access to the SQE.

Anyway, outside of that, fixes in here for a few other issues that have
been hit in testing or production. Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-20191220


----------------------------------------------------------------
Brian Gianforcaro (1):
      io_uring: fix stale comment and a few typos

Jens Axboe (11):
      io_uring: fix sporadic -EFAULT from IORING_OP_RECVMSG
      io-wq: re-add io_wq_current_is_worker()
      io_uring: fix pre-prepped issue with force_nonblock == true
      io_uring: remove 'sqe' parameter to the OP helpers that take it
      io_uring: any deferred command must have stable sqe data
      io_uring: make IORING_POLL_ADD and IORING_POLL_REMOVE deferrable
      io_uring: make IORING_OP_CANCEL_ASYNC deferrable
      io_uring: make IORING_OP_TIMEOUT_REMOVE deferrable
      io_uring: read opcode and user_data from SQE exactly once
      io_uring: warn about unhandled opcode
      io_uring: io_wq_submit_work() should not touch req->rw

Pavel Begunkov (2):
      io_uring: make HARDLINK imply LINK
      io_uring: don't wait when under-submitting

 fs/io-wq.c    |   2 +-
 fs/io-wq.h    |   8 +-
 fs/io_uring.c | 712 +++++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 493 insertions(+), 229 deletions(-)

-- 
Jens Axboe


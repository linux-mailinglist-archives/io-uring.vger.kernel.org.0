Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDF344B1BE
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 18:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbhKIRJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 12:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbhKIRJW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 12:09:22 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8955C061764
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 09:06:35 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id c3so10393891iob.6
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 09:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eTKzKZVkgg4/0dGuCZ+cMzGI7UnuhxpqM0b6NgRoEzs=;
        b=KQ/rM9HC563hhr0b56HpUtdbGbOM0WqAm89EjfyfLBamSsARNVMq2Joc1IkLY7pv+I
         jW7V8SgdYOM34BPdNcto8dJvRff6TICociLDr2+grT7mKzIdxLURCiYL1PrwCx4fOeRB
         nENnJz4p4O65lrfmpHhrjx/iwaqV0mE7siqkh6N5bkiBuaVnR/rq5lVBEyytzckKS2rp
         A2EAg3ss39EyAqOfRmaHFqO1B0h1k4Dft6UV27D1qOUj2z5JB1wMheRw+6D8o0sxQn9L
         SA4oKb7NP4k5wPUIxjS3Ai/n74e0cC7HQwfJeQaSDHKKGTUsZ/OtD8M4skESJGMtOB0t
         zEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eTKzKZVkgg4/0dGuCZ+cMzGI7UnuhxpqM0b6NgRoEzs=;
        b=5m2Embm3sDmy+d5KtNZhtt0RmE69oQtXwm8GJFcmtJraugO0+9wadU9D5IC+NOeaHQ
         7AKQICtltjKdc3KguP3mN46T+UMmtfbV/D4KdjaO+6JFqNzgQojjppUKRm0WVMM3ok22
         WZE1cFXut2/8RWxV+GRFe9QIkJ+5e72CuSDT0G0D9b6sKEy05dFhaHDFwVS6pC3HI3+t
         rQ6EMag5OkMiSyE/DUlKF0KtJK1S+ePG0VHoQq9M536lgnmUTdql2xxc0LJ+1iLIvu3A
         kzKzTh8gZ4HXhsw/7ndtEH5U1nKrg1SflE8skL0UATX96WF1a7jBilGZzCsMV9rgL2+O
         aDrw==
X-Gm-Message-State: AOAM530kRtJOP0+P2j0qqFxIJN6ug8Q1/crwD57Lessba3iVxkl3N5gm
        mmq+9lVmJ17G/1ZlvRY/qlMfOFxGsWqJ7mSq
X-Google-Smtp-Source: ABdhPJw5dj8qsVQJatxxRfbzHeAMAUarhSkdLwYgfKVQSS3ZAFH+PfICHpMWIWM5vm+UWVC9+pzsxw==
X-Received: by 2002:a05:6638:1489:: with SMTP id j9mr7052574jak.18.1636477594865;
        Tue, 09 Nov 2021 09:06:34 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r7sm12182900ilb.7.2021.11.09.09.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 09:06:34 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes
Message-ID: <9d956803-8a89-391d-30e3-89350249f697@kernel.dk>
Date:   Tue, 9 Nov 2021 10:06:34 -0700
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

Minr fixes that should go into the 5.16 release:

- Fix max worker setting not working correctly on NUMA (Beld)

- Correctly return current setting for max workers if zeroes are passed
  in (Pavel)

- io_queue_sqe_arm_apoll() cleanup, as identified during the initial
  merge (Pavel)

- Misc fixes (Nghia, me)

Please pull!


The following changes since commit bfc484fe6abba4b89ec9330e0e68778e2a9856b2:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2021-11-01 21:24:02 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-09

for you to fetch changes up to bad119b9a00019054f0c9e2045f312ed63ace4f4:

  io_uring: honour zeroes as io-wq worker limits (2021-11-08 08:39:48 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-11-09

----------------------------------------------------------------
Beld Zhang (1):
      io-wq: fix max-workers not correctly set on multi-node system

Jens Axboe (1):
      io_uring: remove dead 'sqe' store

Nghia Le (1):
      io_uring: remove redundant assignment to ret in io_register_iowq_max_workers()

Pavel Begunkov (2):
      io_uring: clean up io_queue_sqe_arm_apoll
      io_uring: honour zeroes as io-wq worker limits

 fs/io-wq.c    | 16 +++++++++++++---
 fs/io_uring.c | 11 ++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

-- 
Jens Axboe


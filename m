Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AF13A4F76
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 17:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhFLPQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Jun 2021 11:16:33 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:33339 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLPQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Jun 2021 11:16:32 -0400
Received: by mail-pf1-f175.google.com with SMTP id p13so6978170pfw.0
        for <io-uring@vger.kernel.org>; Sat, 12 Jun 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=UH1O9O6VQhtFDUruupurintbU6U12N9QIwt+XXDDyvs=;
        b=pioaqg3kSP/bTgvZuL6tcbOTFvxkN+oIPvsUJUHOnqdDwS4tIOtN0RBBMQZO/qjcl2
         L8sCHpui1FczQG8me7wEyawB7XR15vkGY/YkHDM++kRA9JtiYCP/kU9RahXpju7LFWhE
         f95gU2PGNksfoZ9m7n/0bT+ULXZlgCD0T6O8cqBMpPVjlQvS8Zr61JPSCTqD79b8ewAZ
         ywrs2fS24dJgMvURBAFLXMcN9Dne2V533Q0DU5vETLYY1gapt7ckS4puOm9O00wvbb7j
         T1TGJOKKIvy95l0pnzE88SvzcOP8DgyU53kHGpQeP7A7xFZNOeFnW7zTKWjElXH4PWl4
         iFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=UH1O9O6VQhtFDUruupurintbU6U12N9QIwt+XXDDyvs=;
        b=q9L8TpwS9pL1YJqBoJDT5+PTjqgD9FSoGnebjhdsKsAqELjrzqQZ4XLCVeeIUVSDyn
         +3KcEXYQdKj9YCD/ryIo4T+TUpRBUaXN+AAeDGjRzkYnkB0EaJzcixB6QM0breqv1Jcq
         ueOV8lnlUqKGsTqXJaIB6IQwX3m3vY3b8ZVP1oM41DtTD3v05uTT0KipTmdlBvdvwz4D
         i1ljZ0bOgZwG42hsRlUgE/xoXovZBHUdPIXRlze9fCakYgz9C8pv6mrE8p32EahMbJgv
         VmUlcIIN6MHC7Zrr0b1G5UH2rrRGGdaT8lhnGVF50ekZhefFhNH/cJvyBQHUdettaRx2
         qO+g==
X-Gm-Message-State: AOAM531rYAvj2s8c/O10Vwcaj4qTx1Lntddnc7ozew0ajTCYMwVfIjVy
        yeba+19Q4UrhX4na6uY9mhPzifNZnJ062Q==
X-Google-Smtp-Source: ABdhPJx0p3GOAz6/wqSlBbyOf3/s5oreeDMWvJagsKYCXEBQdf1z7KzmQFbvlIvbFgfKkgLy3mSQMw==
X-Received: by 2002:aa7:8431:0:b029:2e9:dcb1:148f with SMTP id q17-20020aa784310000b02902e9dcb1148fmr13520788pfn.29.1623510812592;
        Sat, 12 Jun 2021 08:13:32 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u1sm8205446pgh.80.2021.06.12.08.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 08:13:32 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.13-rc6
Message-ID: <8a4e5d77-0b4c-cbd4-6ffa-eeff83ed16af@kernel.dk>
Date:   Sat, 12 Jun 2021 09:13:30 -0600
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

Just an API change for the registration changes that went into this
release. Better to get it sorted out now than before it's too late.

Please pull!


The following changes since commit 216e5835966a709bb87a4d94a7343dd90ab0bd64:

  io_uring: fix misaccounting fix buf pinned pages (2021-05-29 19:27:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-06-12

for you to fetch changes up to 9690557e22d63f13534fd167d293ac8ed8b104f9:

  io_uring: add feature flag for rsrc tags (2021-06-10 16:33:51 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-06-12

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: change registration/upd/rsrc tagging ABI
      io_uring: add feature flag for rsrc tags

 fs/io_uring.c                 | 42 +++++++++++++++++++++++++++++-------------
 include/uapi/linux/io_uring.h | 19 ++++++++++---------
 2 files changed, 39 insertions(+), 22 deletions(-)

-- 
Jens Axboe


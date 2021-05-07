Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9945E376861
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhEGQAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhEGQAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:00:42 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1ABC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:59:42 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b10so8380207iot.4
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SkHgZnRaEpk9bcXz+TAe0KDxPB07u2/eIackL1rpHaU=;
        b=fN1g96lLIC3DBxnVbDzF7IPuYYnh1T07fkj4tlp8heq6Y2aqCngMki6kboqBF68Vik
         sF66LezXI97W28boWccATjXrVs5UQ7dFC6gB/sENBKGm4a2aK6Sfaj1416YwWJpPySKW
         iun1IiOzW1cwLhNFIXohNX8RONEiYvh+urLmmG9SixFSVh0qX8P9mYZU5xH0mFQktLZb
         ignvvZIoS3ricuJaUvccPEVA1Djqw9EwWNtvxusOilx9omyYPPwfAl9D4LRcYLQKN511
         zhbJh6o+XEpj1GlFM8YF3ONonkDuLPj/L/txYodlu/jAkydrthSlT9mya8a3abGLasi2
         xYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SkHgZnRaEpk9bcXz+TAe0KDxPB07u2/eIackL1rpHaU=;
        b=Evct6AV9rnopY+SwnGX5QzzGooa9ssC6b5eZpWMDtRNf4omzjmNPpKjm9Vy9FIFaR3
         hiStJx4hn7idgydbE1XOsNg8NsyrwE9ty77cJsOEmOwc7iECYcgNG+OttJ4ryhLOQror
         /8wjV8Q57eKT3SLNuNOrQORjNBwg8IMt9Y/Dp5NOJJ8mchnafUBKWUN7eS3qgQyVWAPz
         fhALtFZ2dlA89z4X/wjJ0dOprpdMSbr8PPZVJsi56tLBc0LjhdJ3HHVAome8Ry52dE+m
         qOJgdStgT9Yn7pj0vieHokz11KS5z+wiklVTCDCfr0tOPGtFV5i+rrsJbjOzbqBqRa5K
         izsw==
X-Gm-Message-State: AOAM532llQpMnt0hftfzRyLP2GrnR/kmwdyFH8KLsPToXwXkMsasfL/b
        VvaYVYdHbsTqCaV599XHZqLUUA==
X-Google-Smtp-Source: ABdhPJxGFtBdIWhaxKXvKzgYGr5qG/qteTAB92+QIpim8CKv4T5he3gCpWXg8O0ALeEHaSFwTgd3PA==
X-Received: by 2002:a05:6602:2f09:: with SMTP id q9mr8061192iow.207.1620403181649;
        Fri, 07 May 2021 08:59:41 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p5sm2461822iod.7.2021.05.07.08.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:59:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.13-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <172809ab-c9c4-fc36-6bba-3ea0128f748b@kernel.dk>
Date:   Fri, 7 May 2021 09:59:40 -0600
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

Mostly fixes for merge window merged code. In detail:

- Error memory leak fixes (Colin, Zqiang)

- Add the tools/io_uring/ to the list of maintained files (Lukas)

- Set of fixes for the modified buffer registration API (Pavel)

- Sanitize io thread setup on x86 (Stefan)

- Ensure we truncate transfer count for registered buffers (Thadeu)

Please pull!


The following changes since commit 635de956a7f5a6ffcb04f29d70630c64c717b56b:

  Merge tag 'x86-mm-2021-04-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-04-29 11:41:43 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-07

for you to fetch changes up to 50b7b6f29de3e18e9d6c09641256a0296361cfee:

  x86/process: setup io_threads more like normal user space threads (2021-05-05 17:47:41 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-05-07

----------------------------------------------------------------
Colin Ian King (1):
      io_uring: Fix premature return from loop and memory leak

Lukas Bulwahn (1):
      MAINTAINERS: add io_uring tool to IO_URING

Pavel Begunkov (5):
      io_uring: fix drain with rsrc CQEs
      io_uring: dont overlap internal and user req flags
      io_uring: add more build check for uapi
      io_uring: allow empty slots for reg buffers
      io_uring: fix unchecked error in switch_start()

Stefan Metzmacher (1):
      x86/process: setup io_threads more like normal user space threads

Thadeu Lima de Souza Cascardo (1):
      io_uring: truncate lengths larger than MAX_RW_COUNT on provide buffers

Zqiang (1):
      io_uring: Fix memory leak in io_sqe_buffers_register()

 MAINTAINERS               |  1 +
 arch/x86/kernel/process.c | 19 ++++++++++++-
 fs/io_uring.c             | 69 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 70 insertions(+), 19 deletions(-)

-- 
Jens Axboe


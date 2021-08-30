Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870533FB89B
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbhH3O6h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 10:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhH3O6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 10:58:36 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF9C061575
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:57:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id j18so20219613ioj.8
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=n8/euC5UNogyxhXxtnFgGEzpR0kFchmYHKRyrYlnylE=;
        b=fzWOv3yE1B7bFggJbXmtvO0vQWPodsuGZMm3dG192a4thB3k05M5zLVAJHDVlnVvNI
         TZ86vP5GIk3jaKZZpiuRITTRftB0YmaPhmvzlghcdByuhNhvvDQIb2Ii2dqjLUTnjzdk
         4CgJK3uLbMdFaQTX4hd62DiveNh+5VMmPNPv5fRGGoh3hK9FdgA4xSKnVSskIIS3NNF9
         ePOg/7ur0l/tYf3wuIXj9T7B1lwftYXWO9BC/3c4zeFFmikzlWXvUfqPg+2PUUi0GDew
         eJ3W0+uRWZa2pIGv6b2gVf7X//OlEMTScJyZSgt0It1Kosr1msph1rDHLJcIYYlH5tXd
         pYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=n8/euC5UNogyxhXxtnFgGEzpR0kFchmYHKRyrYlnylE=;
        b=BwwH2rdSEffTCC1x4LuBRut/6YMkkBPJ+AcdDTObYEMG6oAmZI7YaXQNLr0SK3bN19
         eTfKCRlrbxYW25NhViWlYVg3Co6G5PPSdysSiS2BF6aTzhlS3r4SQAhghRGsOr0W9jU9
         A8ehOscRB4GwFgQxBFUGPGpZ6SKMFRnzrKn7waFkgWLLidcXq1VDzrwl7ABJCUFL89YP
         HGvwdwjsl6WvufR7z6CUg+qkRd9MBvdQ3m8WtuQ8vpvUbd/eFX6XucreVB4M3o1TtT/N
         yEFNPc/f5kI0vYEaOhBhCqVKtDEIxMNK3H/kNQdZsOzkFwSLa7hVsXGR/NDZ3jiG7iOu
         wjaw==
X-Gm-Message-State: AOAM532eEZ2lyDQAnmridahfnqmp3BB0RIxFKW+hye+BuYFUjECUUFx2
        SmF+NufSXKbrO/+yMOY9wiMgzy4bZjJSxw==
X-Google-Smtp-Source: ABdhPJytdN+IwixTzCorQN5jnuDR8avi8ltmU/6Cvm3sZv/V++7o0qN5zDbIWt/T508EOWFx7kS4nw==
X-Received: by 2002:a02:708f:: with SMTP id f137mr20745750jac.68.1630335462619;
        Mon, 30 Aug 2021 07:57:42 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e14sm8607803ilr.62.2021.08.30.07.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 07:57:42 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] bio recycling support
Message-ID: <baf16ffa-1c31-95e8-dae5-ac4b98ee984a@kernel.dk>
Date:   Mon, 30 Aug 2021 08:57:41 -0600
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

Forked off for-5.15/io_uring at some point, hence layered on top of
that.

This adds bio recycling support for polled IO, allowing quick reuse of a
bio for high IOPS scenarios via a percpu bio_set list. It's good for
almost a 10% improvement in performance, bumping our per-core IO limit
from ~3.2M IOPS to ~3.5M IOPS.

Please pull!


The following changes since commit fd08e5309bba8672c1190362dff6c92bfd59218d:

  io_uring: optimise hot path of ltimeout prep (2021-08-23 13:10:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-bio-cache.5-2021-08-30

for you to fetch changes up to 3d5b3fbedad65088ec079a4c4d1a2f47e11ae1e7:

  bio: improve kerneldoc documentation for bio_alloc_kiocb() (2021-08-23 13:45:40 -0600)

----------------------------------------------------------------
io_uring-bio-cache.5-2021-08-30

----------------------------------------------------------------
Christoph Hellwig (1):
      block: use the percpu bio cache in __blkdev_direct_IO

Jens Axboe (7):
      bio: optimize initialization of a bio
      fs: add kiocb alloc cache flag
      bio: add allocation cache abstraction
      block: clear BIO_PERCPU_CACHE flag if polling isn't supported
      io_uring: enable use of bio alloc cache
      block: provide bio_clear_hipri() helper
      bio: improve kerneldoc documentation for bio_alloc_kiocb()

 block/bio.c                | 169 ++++++++++++++++++++++++++++++++++++++++-----
 block/blk-core.c           |   2 +-
 block/blk-merge.c          |   2 +-
 block/blk.h                |   7 ++
 fs/block_dev.c             |   6 +-
 fs/io_uring.c              |   2 +-
 include/linux/bio.h        |  13 ++++
 include/linux/blk_types.h  |   1 +
 include/linux/cpuhotplug.h |   1 +
 include/linux/fs.h         |   2 +
 10 files changed, 184 insertions(+), 21 deletions(-)

-- 
Jens Axboe


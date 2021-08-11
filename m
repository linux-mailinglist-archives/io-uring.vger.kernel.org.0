Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31E83E98D9
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhHKTgF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhHKTgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:36:03 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62477C0613D3
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:39 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b7so4043245plh.7
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJH3lymOu/2QBPJ/xceVs/xyAmriae14qaeOGPuJwZA=;
        b=yMkdQ2HykN3ezRK223iGZjbuxyuJ6LgxM4lhRtAVc5vNexnz1Ma9hNeuVqdfR76hEY
         1W4fPODYg+H5YO++I542ZfSY8hYTcjmwZL2do6tiQQE1xIRSC/ufyw+P1FKB5sAdlcWh
         /U5u2zHMGvCy3dxFiLvE1JJS4MX8HN3rfZRv0wwf82Tpd8D8qr7MmLC8p5zfeDZhgOtj
         COAl6EUa4ynXNu//N6Dh17LNh1MIzo65noc+u9Z9ZS/HTlma1XgMt8Y/aQpQbGBIHtaS
         gEKMrJm6uNAnlnTzzUZ0QeqJrwPbMD9t8SPp4/NFPIngs5blZW/u6QpmsYOb3kSZG5mx
         W+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJH3lymOu/2QBPJ/xceVs/xyAmriae14qaeOGPuJwZA=;
        b=XVkS2fpxquoNbA8jvGIadCq6Mh1pHoYSoHwei+3C8r+jpSb+zeFGohfbEiyAtuz87z
         OULCFRb5Hx2lqxwTF/7nk5jNRgwJ1hNPnxMU1HEShpgcuyq7VkzkMuHbEaz7mzjbwg8j
         rJyk2uh9se49lAaBOVDd9MvptkAGIujwUc747Klg8CWpz2ECzlnVGlULa5BpgXnW32MO
         KZOBO6sjVxQQQxItfjCTYxGhj/87Pl+3ASmrxYD43iOnVTlLjYkRY6WrnwZ0NcBQl+yi
         fX6E6bN0hN8ulgmJC0M8NKRQ40mPCExYPdT248l+Y7KGXuoAds+28T+2QnysTVth1zmo
         dn9g==
X-Gm-Message-State: AOAM531qL1poSwHEoi7DPnB78fpBVLBtBsqE2cj4EJiEVGhN3EY9ztU0
        OByJkl5HW4ClVCUiBXPMscUN6j7z5hJF2uLT
X-Google-Smtp-Source: ABdhPJz+YcRBFznmLrJAzGqpXGIUNRlXUDC8g8zMYIxMfUg2lmkcro+Zh5n82yG2iyYwwsHVBFBcaA==
X-Received: by 2002:a17:90a:b284:: with SMTP id c4mr145741pjr.213.1628710538702;
        Wed, 11 Aug 2021 12:35:38 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u20sm286487pgm.4.2021.08.11.12.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org
Subject: [PATCHSET v4 0/6] Enable bio recycling for polled IO
Date:   Wed, 11 Aug 2021 13:35:27 -0600
Message-Id: <20210811193533.766613-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is v4 of this patchset, and Yet Another method of achieving the
same goal. This one moves into the direction of my old cpu-alloc-cache
branch, where the caches are just per-cpu. The trouble with those is
that we need to make this specific to polled IO to lose the IRQ
safety of them, otherwise it's not a real win and we're better off just
using the slab allocator smarts. This is combined with Christoph's idea
to make it per bio_set, and retains the flagging of the kiocb for
having the IO issuer tell the below layer whether the cache can be
safely used or not.

Another change from last is that we can now grossly simplify the
io_uring side, as we don't need locking for the cache and async retries
are no longer interesting there. This is combined with a block layer
change that clears BIO_PERCPU_CACHE if we clear the HIPRI flag.

The tldr; here is that we get about a 10% bump in polled performance with
this patchset, as we can recycle bio structures essentially for free.
Outside of that, explanations in each patch. I've also got an iomap patch,
but trying to keep this single user until there's agreement on the
direction.

Against for-5.15/io_uring, and can also be found in my
io_uring-bio-cache.4 branch.

 block/bio.c                | 170 +++++++++++++++++++++++++++++++++----
 block/blk-core.c           |   5 +-
 fs/block_dev.c             |   6 +-
 fs/io_uring.c              |   2 +-
 include/linux/bio.h        |  23 +++--
 include/linux/blk_types.h  |   1 +
 include/linux/cpuhotplug.h |   1 +
 include/linux/fs.h         |   2 +
 8 files changed, 185 insertions(+), 25 deletions(-)

-- 
Jens Axboe



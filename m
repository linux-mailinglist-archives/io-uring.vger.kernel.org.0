Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0578A3E4E58
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhHIVY3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhHIVY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2969FC061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 14:24:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so1024035pjn.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 14:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OyG4sh0wZAAWr4TpNXR7PYUy98X4grR2BRtprjaq/ng=;
        b=wBtUeaUay3Kbl/Q5xZ9y+W4HUmLrTZBC1a8kseW9h6BBcCkdAsOZFB1uopMN+6RzY0
         3gTn3l8FKkggS3gtH4WTR7QcFXYslnemtKIkR70dv512Sl9avzMlQlrTRRWR8z5N0HBF
         Gh9bTEPq0EyG0rK9czgQ71iqBSKdUtxKcPF9LrhYiXcjrpu0wgpFMoUhP68q2yb6QnlW
         HHOwhMVTG5Vs7VzipjOScUfluwQ3fspk7tCTSW9zR6VMcCfmuAMaqobGRj1LsL2n77Tz
         KlKJRS3eacjJS6V1gWdXNBSeFoIFKz9D9+9H4VAIZe5E53PdHLetxVIf/dylTZOCJnEC
         LEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OyG4sh0wZAAWr4TpNXR7PYUy98X4grR2BRtprjaq/ng=;
        b=lcv9CBjqAX9OMvzWHbhA2APaToC/AipO4pBFmtDiJ2jdbwwgMVwTZETm7dN/BcQoMx
         z6YTXpEi39HO3CRwkmXHfYQYWHFA8OvVVfG0b7YCZufbPbNrzg4aUu+nn2cAx19PqsU1
         6Sfg1uqqwYo4AesIv1siPBcJ+znslPp/WpxajbxVemRGvEgbJBaVOzbBBWZT5kkSSVea
         hRmGe9oRfTpPNBR+zQg1PDF2eEL1PF6bq87/oLGWBfe5c5bZdqKMGxt0tXNppFS64cp0
         Kp3FjrU1SZnzU9m+dIxa1tW10NUUyFUgtpTl2c7dXl6YRD6GQfkeoE4pfBZjBeTVrv/i
         V7KA==
X-Gm-Message-State: AOAM530M/EC3AI+32xmSI9JjpmfuvzlMIEePDsB4gzg2Db98kZ2jW/Or
        YWBl95X+Ld1y0/iea8t9ULaNAT7qekA03E9W
X-Google-Smtp-Source: ABdhPJz/TCAeS4NFs9JO4ZAXe73KSV/gng93g6PkjAV/jH4S+0vbS7C/hl2rb5pxgxe1fqT/Ya8ciQ==
X-Received: by 2002:a17:90a:c213:: with SMTP id e19mr6832551pjt.58.1628544247361;
        Mon, 09 Aug 2021 14:24:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m16sm439885pjz.30.2021.08.09.14.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:24:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org
Subject: [PATCHSET 0/4] Enable bio recycling for polled IO
Date:   Mon,  9 Aug 2021 15:23:57 -0600
Message-Id: <20210809212401.19807-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is v2 of this patchset. The main change from v1 is that we're no
longer passing the cache pointer in struct kiocb, and the primary reason
for that is to avoid growing it by 8 bytes. That would take it over one
cacheline, and that is a noticeable slowdown for hot users of kiocb. Hence
this was re-architected to store it in the per-task io_uring structure
instead. Only real downside of that imho is that we need calls to get it,
and that it's obviously then io_uring specific rather than being able to
have multiple users of this. The latter I don't consider a big problem, as
nobody else supports async polled IO anyway.

The tldr; here is that we get about a 10% bump in polled performance with
this patchset, as we can recycle bio structures essentially for free.
Outside of that, explanations in each patch. I've also got an iomap patch,
but trying to keep this single user until there's agreement on the
direction.

Against for-5.15/io_uring, and can also be found in my
io_uring-bio-cache.2 branch.

 block/bio.c              | 126 +++++++++++++++++++++++++++++++++++----
 fs/block_dev.c           |  30 ++++++++--
 fs/io_uring.c            |  52 ++++++++++++++++
 include/linux/bio.h      |  24 ++++++--
 include/linux/fs.h       |   2 +
 include/linux/io_uring.h |   7 +++
 6 files changed, 221 insertions(+), 20 deletions(-)

-- 
Jens Axboe



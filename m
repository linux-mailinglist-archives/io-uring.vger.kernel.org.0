Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECC13E7D92
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhHJQh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhHJQh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:37:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE25C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d17so21856870plr.12
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q+7fpP+Ie92YhSLrs9IH27Kmx9JflNEk3yN3M1jDzas=;
        b=K2aoNwcBhLTqZl2tN5is9O4IGvx2f/vGEsoD+NeN+xEQbLFwI9BZs/MXM8CoqhKV70
         kMOVGc2b4T/5M9yvzlR0T2e+c5TNM6MC3Gfr7SvkwNAOP/PTxQtq6jdLyROFFqFjUScM
         jQkZdQ8+fzrQheLYersXNl6+7xwhj5cwqLvc0TcEF5ldF08yFN8tTMqs5VruR9Yl9V3w
         WiLEY7Z8ZzxeHWE5NA9MH4cewyAOVCdp4OzWGPRMxQHuD91podbTq2wgZjkTjPdWb9rO
         5VkTJdUEzYqGeri0UERQt+ciC80Ov4n27vYFQqHyN/AbkdqOUoc3uV0e4dA6hnBHs8f6
         Ux7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q+7fpP+Ie92YhSLrs9IH27Kmx9JflNEk3yN3M1jDzas=;
        b=dAld72gEAtPysFFtabOCw2MuuJhgNuZTKHqzOGmEsB9nJ8vujZEIPD5ZLnSgL6nkqq
         yi83NBK/dMd4ilFDYIB7/Xk8RJ9FsZHwTYlnNOSQMiOvxu9mhOonUCvT88iaEXDZR0gO
         bDRZSuUreX2QMvbBMxTfcGoZLZL9+oWqNAF/KtuKD0sdIdrKRwgYuS0U7n/2VR7XQd28
         zBU44/C55UoCWwJVxc5doUq/l53Q11RUuvKPqfRlhVPBDS/qj7+H0s3gcPeg4zScVjnD
         u2AqkAln3KGtqJwSuoFMCryCABwuSRhTR4XFFBsBxLlMd2wa817f8KC1QgLgLQWg8UZo
         PmZg==
X-Gm-Message-State: AOAM533w79elGZBdrny6V1fZGgE04VMjLucbb2nCSp6bL4rSAhBTlWOm
        fYJq1AqvLVSbnpr6QJENnXbBwBU6y9fTuxIb
X-Google-Smtp-Source: ABdhPJz5gKGhjJ1dakFY8qZU8Z2qVodgv5Fc1rK7xkQdKmXOEOMmouzxYOs5rAJRCu6QjYsmy3un+w==
X-Received: by 2002:a17:902:e843:b029:12c:d520:453e with SMTP id t3-20020a170902e843b029012cd520453emr466336plg.50.1628613453981;
        Tue, 10 Aug 2021 09:37:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm3517744pjb.38.2021.08.10.09.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:37:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org
Subject: [PATCHSET v3 0/5] Enable bio recycling for polled IO
Date:   Tue, 10 Aug 2021 10:37:23 -0600
Message-Id: <20210810163728.265939-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is v3 of this patchset. We're back to passing the cache pointer
in the kiocb, I do think that's the cleanest and it's also the most
efficient approach. A patch has been added to remove a member from
the io_uring req_rw structure, so that the kiocb size bump doesn't
result in the per-command part of io_kiocb to bump into the next
cacheline.

Another benefit of this approach is that we get per-ring caching.
That means if an application splits polled IO into two threads, one
doing submit and one doing reaps, then we still get the full benefit
of the bio caching.

The tldr; here is that we get about a 10% bump in polled performance with
this patchset, as we can recycle bio structures essentially for free.
Outside of that, explanations in each patch. I've also got an iomap patch,
but trying to keep this single user until there's agreement on the
direction.

Against for-5.15/io_uring, and can also be found in my
io_uring-bio-cache.3 branch.

 block/bio.c         | 123 ++++++++++++++++++++++++++++++++++++++++----
 fs/block_dev.c      |  32 ++++++++++--
 fs/io_uring.c       |  67 +++++++++++++++++++++---
 include/linux/bio.h |  24 +++++++--
 include/linux/fs.h  |  11 ++++
 5 files changed, 229 insertions(+), 28 deletions(-)

-- 
Jens Axboe



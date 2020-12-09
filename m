Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6929A2D38C2
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 03:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLICYO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 21:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgLICYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 21:24:09 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE2AC0613CF;
        Tue,  8 Dec 2020 18:23:23 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d3so126230wmb.4;
        Tue, 08 Dec 2020 18:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2oioyFLR2bFNpjjk5al2TpT+eS54q+WK5/M1bDWQq8Y=;
        b=oDJccotZxIU1EHGzNTq4hfh5WcKNEFZmeQ3MaKAzRhp3LvOg33xVS5Zts/JLvl79bc
         2chccfsoBYt8t4MpQJAs85iFB/9O7NAEX1IDyovACFDFoVOzZHk+GL7pWapo7oTjCVTk
         mvBhGOBGqIAG066p4hVZcsRiD7WGBxTmTwygzPu1Q9tcNejuRfoKvsFiDlQDDyxPPLfF
         HTycdtH0HWmnHe5nrXjGKoYySBQAoo/r69ZvKZ9lOf3hQCVrA81/Cx3sKHt5JQprbmdX
         y34y4++GXIP9gSitcNePRN3/htCNhRuSeovkaVJSkiUHXYudshBP8lnjjElY4oKMBBKd
         mOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2oioyFLR2bFNpjjk5al2TpT+eS54q+WK5/M1bDWQq8Y=;
        b=lFopdHnT+kBA95phFPK6k4Ua95CXHVpBzHnNdrG1iaLeCKGZJyWhmEOaR4TfFbb+Xr
         ageeeYyiqr9WEzQgWoi5k6QbGj5NJ5FKaRVm34CkrXDXyXVDDThSChOVQ2onu3a0RN4G
         mQFk6PKs5kuhLrQHaks1hKWrOlOsgkvKANin2a6MTp475aE6qft5dF/y9PpA0jlSWWHg
         k35GTwXjtT/sSC9CKy5Wrydr2OQhll4BgKQ96xnq1lmBHa1gUj2MDta7wl8O7SBKxtDt
         It9ZFWHmW04t6SFsZAFXJxn6OvZDaKuHu5lQU3eBg+heULq4qMc9YrE3NYCfl3nyRoHT
         H5PA==
X-Gm-Message-State: AOAM533EtuqduvlShegIjLaPNnb624c61eIRYJUvxAhHtuGIFDrytgGJ
        xt8dbJKETQz9Y7DGUpALVPI=
X-Google-Smtp-Source: ABdhPJzWr26qXVlQbn+WLoaf5ahxMb42KDZknutFM27XXfuv6U6vlI0gMQaN4rhryPfgRX53lc84dA==
X-Received: by 2002:a1c:309:: with SMTP id 9mr303633wmd.80.1607480602202;
        Tue, 08 Dec 2020 18:23:22 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id k64sm330606wmb.11.2020.12.08.18.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 18:23:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC 0/2] nocopy bvec for direct IO
Date:   Wed,  9 Dec 2020 02:19:50 +0000
Message-Id: <cover.1607477897.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The idea is to avoid copying, merging, etc. bvec from iterator to bio
in direct I/O and use the one we've already got. Hook it up for io_uring.
Had an eye on it for a long, and it also was brought up by Matthew
just recently. Let me know if I forgot or misplaced some tags.

A benchmark got me 430KIOPS vs 540KIOPS, or +25% on bare metal. And perf
shows that bio_iov_iter_get_pages() was taking ~20%. The test is pretty
silly, but still imposing. I'll redo it closer to reality for next
iteration, anyway need to double check some cases.

If same applied to iomap, common chunck can be moved from block_dev
into bio_iov_iter_get_pages(), but if there any benefit for filesystems,
they should explicitly opt in with ITER_BVEC_FLAG_FIXED.

# how to apply
based on Jens' for-11/block
+ Ming's nr_vec patch,
+ io_uring fix, 9c3a205c5ffa36e96903c2 ("io_uring: fix ITER_BVEC check")

or there:
https://github.com/isilence/linux/commits/bvec_nocopy

# how to reproduce
null_blk queue_mode=2 completion_nsec=0 submit_queues=NUM_CPU
fio/t/io_uring with null blk, no iopoll, BS=16*4096


Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>

Pavel Begunkov (2):
  iov: introduce ITER_BVEC_FLAG_FIXED
  block: no-copy bvec for direct IO

 fs/block_dev.c      | 30 +++++++++++++++++++++++++++++-
 fs/io_uring.c       |  1 +
 include/linux/uio.h | 14 +++++++++++---
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.24.0


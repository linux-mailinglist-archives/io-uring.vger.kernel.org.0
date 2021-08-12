Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9213EA7C7
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbhHLPmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbhHLPmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:17 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7955C0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:52 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so8285925otl.1
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2s82tmKVU8sl/Qe4wFsHJc+u0KltczDQHVAOHyV1KHA=;
        b=EvyI0QYzqqVtHvfPjJjjAyUArww/yQnXGepKYknu5bFEGDs/mLvyC6lJBbE7xZY7h+
         Kd8fziecTlJPRNnCBTzTWBPqXMjX82x/wnQof2ULuOipy3Q8b6AxjqxdGnZQXbZtfSWr
         EHRgubfFXQrG8Bb4tx49Kh8/CxvcWeuhcTDS/nfuc6NXs41xWev2NTZGOcjh8MJA6u5V
         0XipNRRAhtBmRDZAcTF+jT83rrCtybFhsmEipPdPZdttb7oNwoggiKIW8jCAcDt+SPrH
         9pr5GSiN4Cak0cmopjkmB37rkvZ8PIMme0tQyPdjC67RhdBEO7HGM1Ui3vi0CRQnlfYB
         /3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2s82tmKVU8sl/Qe4wFsHJc+u0KltczDQHVAOHyV1KHA=;
        b=ngNNSDvGMyNPMdIHQBGj9t0O0lXI4Rm3b2cEykuslNt6sIVai97t4Mhqkzn4XAZGa7
         lYqqrZsXm5BmH2Ok9KgfnEs8ZpZ9/6jvCCGCJ6Ypr7tVzS9PtAti/nytW4Vq+gENehti
         EaBzB1N//JCv77w7AEKXIw684ZJBnkDZtQHP2MZjR1yCvJAZlVfhxunyThGX/BXEnrBn
         ac7OLShq9aYIZbnXXtcu01gLGaTJ0XMysMn4zean+uRk7vkxFyrFn5JAhhHDFAyIFQF+
         Qy6wCVsM1GRTHPt1YQjHO8DpQpiBwuT7G/lhRqkJRORioV1/EYHd3RoozxGCLGBFoh7B
         uksg==
X-Gm-Message-State: AOAM530jeqnbxFPuopph4YkvnNeE+UeL/+vHbDt8gNQtFg206xBn4pcF
        ahfrOp0D6sstJvZj76RsTzUUTQImiFn6UAZ/
X-Google-Smtp-Source: ABdhPJw5qfTKvc2KfY7vLODdNAZyhiCxNItt1a+NNJaTy//R4Rx9EadYZ7b5ICf2anLEYGTENpdtYQ==
X-Received: by 2002:a9d:560a:: with SMTP id e10mr3935453oti.219.1628782911898;
        Thu, 12 Aug 2021 08:41:51 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org
Subject: [PATCHSET v5 0/6] Enable bio recycling for polled IO
Date:   Thu, 12 Aug 2021 09:41:43 -0600
Message-Id: <20210812154149.1061502-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

For v4, see posting here:

https://lore.kernel.org/io-uring/20210811193533.766613-1-axboe@kernel.dk/

3.5M+ IOPS per core:

axboe@amd ~/g/fio (master)> sudo taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 /dev/nvme3n1
i 8, argc 9
Added file /dev/nvme3n1 (submitter 0)
sq_ring ptr = 0x0x7fdab1a8d000
sqes ptr    = 0x0x7fdab1a8b000
cq_ring ptr = 0x0x7fdab1a89000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=1757
IOPS=3520608, IOS/call=32/31, inflight=47 (47)
IOPS=3514432, IOS/call=32/32, inflight=32 (32)
IOPS=3513440, IOS/call=32/31, inflight=128 (128)
IOPS=3507616, IOS/call=32/32, inflight=32 (32)
IOPS=3505984, IOS/call=32/32, inflight=32 (32)
IOPS=3511328, IOS/call=32/31, inflight=64 (64)
[snip]

Changes can also be bound in my io_uring-bio-cache.5 branch, and sit
on top of for-5.15/io_uring.

 block/bio.c                | 164 +++++++++++++++++++++++++++++++++----
 block/blk-core.c           |   5 +-
 fs/block_dev.c             |   6 +-
 fs/io_uring.c              |   2 +-
 include/linux/bio.h        |  13 +++
 include/linux/blk_types.h  |   1 +
 include/linux/cpuhotplug.h |   1 +
 include/linux/fs.h         |   2 +
 8 files changed, 175 insertions(+), 19 deletions(-)

Changes since v4:

- Kill __bio_init() helper
- Kill __bio_put() helper
- Cleanup bio_alloc_kiocb()
- Expand commit messages
- Various little tweaks
- Add kerneldoc for bio_alloc_kiocb()
- Fix attribution on last patch
- Remove bio.h list manipulation leftovers
- Move cpuhp_dead notifier to end of bio_set
- Rebase on for-5.15/io_uring

-- 
Jens Axboe



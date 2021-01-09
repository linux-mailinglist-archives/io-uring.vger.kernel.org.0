Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097A2F0117
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhAIQH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbhAIQH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:07:27 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C8AC061786;
        Sat,  9 Jan 2021 08:06:45 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a6so10177991wmc.2;
        Sat, 09 Jan 2021 08:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbCju64JezN5aP0eyaXdTCbh4XXGllceBuZwEInsYMA=;
        b=V6eWj2vQOBLhnXOnb47gMqadM7AX1Rtl4ilBrdmNjQuF6+M/VHgwh90XSfgN9bADPS
         E6dVUuVffggqdmHzqBopCX9KF8KorzTo4vzPMhq3ikFHlRyVqGGov5d+j6+rPXrPNnH7
         a85vLqnOEBECzrD3OaUHBWeiuYSoUthGyysmvgH0iSUn7Ocd6X4w9hVXXsmVQtiJCdNB
         0irXPBcgLwtbXFq2/BP8/MduySxaAr/7nQqEN764dF1e2g0/5Mry8SgC/Obkh82I3RMd
         3TRySLPSkOs0zGOcn86DZKWRLprviHm59Hnut1SYjV+CbZopoPfrmiCPZHIZxpyisufk
         H+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbCju64JezN5aP0eyaXdTCbh4XXGllceBuZwEInsYMA=;
        b=MzvsIW0EeRK6gMsrnuyGrJtbNGVOCOZfT5hxaTaiJcMkI62LmEEhdyOVi8A8vpiT0X
         GR0JLIZkp8ScHJofc9IrVc5fQWr7dPMuvPFod5Vvwqv2wKhgdwXmYVrmbXoc4veV1bux
         X+C8B/7mZAgUr1HL+Y/tjSVA8gOlA7sDDaPVRLqhAUoIBvB7NBq8Y90MnTJcrpWoFuQa
         RPWFOepLh9CpL4zU4IHm8GwmlAAiJa27EC4JUoETq1i2KrI+XebJtCADr1ZKh1OL9XKs
         00/7sBQleMC4ZW1EZk6/bXQK5Iy6O0mc2mjWtd1cE1qwuz2VZ9syiyNgk13X9EP/0dQF
         soog==
X-Gm-Message-State: AOAM533ezZ3WELuiCYazonrFBFpnAHMymhKCFW4Nc2bc8rqJDRrI8bFz
        VamVZolGAW7MKXL+/HUWLGv10sOY0zphjbY1
X-Google-Smtp-Source: ABdhPJz86Pohk+Bm+A9/1RhdHTzwGj6SIoPa3IBIhw88i50LQL82IqpT5rAZ5qOLtDaU8dPw6ij2bQ==
X-Received: by 2002:a1c:4907:: with SMTP id w7mr7810298wma.175.1610208404000;
        Sat, 09 Jan 2021 08:06:44 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 0/7] no-copy bvec
Date:   Sat,  9 Jan 2021 16:02:56 +0000
Message-Id: <cover.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, when iomap and block direct IO gets a bvec based iterator
the bvec will be copied, with all other accounting that takes much
CPU time and causes additional allocation for larger bvecs. The
patchset makes it to reuse the passed in iter bvec.

[1,2] are forbidding zero-length bvec segments to not pile special
cases, [3] skip/fix PSI tracking to not iterate over bvecs extra
time.


nullblk completion_nsec=0 submit_queues=NR_CORES, no merges, no stats
fio/t/io_uring /dev/nullb0 -d 128 -s 32 -c 32 -p 0 -B 1 -F 1 -b BLOCK_SIZE

BLOCK_SIZE             512     4K      8K      16K     32K     64K
===================================================================
old (KIOPS)            1208    1208    1131    1039    863     699
new (KIOPS)            1222    1222    1170    1137    1083    982

Previously, Jens got before 10% difference for polling real HW and small
block sizes, but that was for an older version that had one
iov_iter_advance() less


since RFC:
- add target_core_file patch by Christoph
- make no-copy default behaviour, remove iter flag
- iter_advance() instead of hacks to revert to work
- add bvec iter_advance() optimisation patch
- remove PSI annotations from direct IO (iomap, block and fs/direct)
- note in d/f/porting

since v1:
- don't allow zero-length bvec segments (Ming)
- don't add a BIO_WORKINGSET-less version of bio_add_page(), just clear
  the flag at the end and leave it for further cleanups (Christoph)
- commit message and comments rewording (Dave)
- other nits by Christoph

since v2:
- add a comment in 1/7 (Christoph)
- add a note about 0-len bvecs in biovecs.rst (Matthew)

Christoph Hellwig (1):
  target/file: allocate the bvec array as part of struct
    target_core_file_cmd

Pavel Begunkov (6):
  splice: don't generate zero-len segement bvecs
  bvec/iter: disallow zero-length segment bvecs
  block/psi: remove PSI annotations from direct IO
  iov_iter: optimise bvec iov_iter_advance()
  bio: add a helper calculating nr segments to alloc
  bio: don't copy bvec for direct IO

 Documentation/block/biovecs.rst       |  2 +
 Documentation/filesystems/porting.rst | 16 ++++++
 block/bio.c                           | 71 +++++++++++++--------------
 drivers/target/target_core_file.c     | 20 +++-----
 fs/block_dev.c                        |  7 +--
 fs/direct-io.c                        |  2 +
 fs/iomap/direct-io.c                  |  9 ++--
 fs/splice.c                           |  9 ++--
 include/linux/bio.h                   | 13 +++++
 lib/iov_iter.c                        | 21 +++++++-
 10 files changed, 106 insertions(+), 64 deletions(-)

-- 
2.24.0


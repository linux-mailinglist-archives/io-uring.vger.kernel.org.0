Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02D5F367C
	for <lists+io-uring@lfdr.de>; Mon,  3 Oct 2022 21:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJCTkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 15:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJCTkV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 15:40:21 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A32D24095
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 12:40:19 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b23so8941498iof.2
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 12:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=So1wXI+U6eoG/PUGPDwz8jZW35iglBolD2VBcHf/xEI=;
        b=NsvVyO/1/dF2hEa/7O0u/5xPwUyERbgpGrezWS4C/20auMHVp4bey0vpXkFyal9knG
         oUsixp3iKpEuvCm7oCi1dF9XtlOMYIc+Um1qdLZQlEH/1VBNZ425VfN7PMnDIDZiEsb9
         BJl3cbx7U+q6WRR9aTt3sHhuoYLYwLDmutT3UWNpioJgTxGoGDDZgTNkBduhG2oE4bgO
         V44Ybdcfvb1VEYJpdQ6OGvSaqggZlQW7Z8c+vTWJVbBz6C2ksbOdlDPUUHCX4fa7bD2q
         ezsQX4YmHq6Dyf95bBAb2r2+fOht2fcSYcWnQ7+8KUDlfdC77fTjUL9H5V4uZduv6U1M
         xnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=So1wXI+U6eoG/PUGPDwz8jZW35iglBolD2VBcHf/xEI=;
        b=FlnfVSmGnZM6lFJ/+fqBRPQscW+0vgneWyRsbMtPmM10i9lKb6IGQIhk6I80oUKptB
         tfLmU94lUZMdaxQRwWTyavP3Y6VnZnp1CkS1mofIfbsJ4I1mSob9YRlymJcpQYSXGkEb
         tve4uKWM5p4ZmuEz8CQTzoklooLeTQD1ZoWi+0GgTiNearl6DruWfpxXMGycil6Ep1bA
         zkxPb3iKlbdI2cjwWiwRNSsJMmj8RSikXvmEn2bIDoOvxyGShHFH8SVgTKKGo19S9UtG
         PxwXPMzjuLtMxgI0mIoHAwXVL4wbevAAz3yq2RhIz2M+HR8Jcvm+ZT1vvBAi4c5MKt95
         Sqdg==
X-Gm-Message-State: ACrzQf26Fk4XCpdkID9fahINlZFjowNzeT6wXKJ0UMqYGwgYLoxNSCo/
        HMuFnM1fcQ8i/IxiIhtVAuSQmBDp+cQYWg==
X-Google-Smtp-Source: AMsMyM4LlFbwF9Y9QNTbZlIL3aV8Dwaxh0QrA6BX2me2SufkKvJprcviPfg87OIOhxl6rv1ys2Vqew==
X-Received: by 2002:a05:6638:168e:b0:35a:196a:9e7e with SMTP id f14-20020a056638168e00b0035a196a9e7emr11053137jat.201.1664826018878;
        Mon, 03 Oct 2022 12:40:18 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u12-20020a02b1cc000000b003435c50f000sm4461260jah.14.2022.10.03.12.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 12:40:18 -0700 (PDT)
Message-ID: <dcefcabc-db87-f285-ddce-ad8db26feb2e@kernel.dk>
Date:   Mon, 3 Oct 2022 13:40:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Passthrough updates for 6.1-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

On top of the block and io_uring branches, here are a set of updates for
the passthrough support that was merged in the 6.0 kernel. With these
changes, passthrough NVMe support over io_uring now performs at the same
level as block device O_DIRECT, and in many cases 6-8% better. This pull
request contains:

- Add support for fixed buffers for passthrough (Anuj, Kanchan)

- Enable batched allocations and freeing on passthrough, similarly to
  what we support on the normal storage path (me)

Please pull!


The following changes since commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0:

  sbitmap: fix lockup while swapping (2022-09-29 17:58:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.1/passthrough-2022-10-03

for you to fetch changes up to 23fd22e55b767be9c31fda57205afb2023cd6aad:

  nvme: wire up fixed buffer support for nvme passthrough (2022-09-30 07:51:13 -0600)

----------------------------------------------------------------
for-6.1/passthrough-2022-10-03

----------------------------------------------------------------
Anuj Gupta (6):
      io_uring: add io_uring_cmd_import_fixed
      io_uring: introduce fixed buffer support for io_uring_cmd
      block: add blk_rq_map_user_io
      scsi: Use blk_rq_map_user_io helper
      nvme: Use blk_rq_map_user_io helper
      block: rename bio_map_put to blk_mq_map_bio_put

Jens Axboe (8):
      Merge branch 'for-6.1/block' into for-6.1/passthrough
      Merge branch 'for-6.1/io_uring' into for-6.1/passthrough
      block: kill deprecated BUG_ON() in the flush handling
      block: enable batched allocation for blk_mq_alloc_request()
      block: change request end_io handler to pass back a return value
      block: allow end_io based requests in the completion batch handling
      nvme: split out metadata vs non metadata end_io uring_cmd completions
      nvme: enable batched completions of passthrough IO

Kanchan Joshi (6):
      nvme: refactor nvme_add_user_metadata
      nvme: refactor nvme_alloc_request
      block: factor out blk_rq_map_bio_alloc helper
      block: extend functionality to map bvec iterator
      nvme: pass ubuffer as an integer
      nvme: wire up fixed buffer support for nvme passthrough

 block/blk-flush.c                  |  11 +-
 block/blk-map.c                    | 150 ++++++++++++++++---
 block/blk-mq.c                     | 107 ++++++++++++--
 drivers/md/dm-rq.c                 |   4 +-
 drivers/nvme/host/core.c           |   6 +-
 drivers/nvme/host/ioctl.c          | 227 +++++++++++++++++++----------
 drivers/nvme/host/pci.c            |  12 +-
 drivers/nvme/target/passthru.c     |   5 +-
 drivers/scsi/scsi_error.c          |   4 +-
 drivers/scsi/scsi_ioctl.c          |  22 +--
 drivers/scsi/sg.c                  |  31 +---
 drivers/scsi/st.c                  |   4 +-
 drivers/target/target_core_pscsi.c |   6 +-
 drivers/ufs/core/ufshpb.c          |   8 +-
 include/linux/blk-mq.h             |  12 +-
 include/linux/io_uring.h           |  10 +-
 include/uapi/linux/io_uring.h      |   9 ++
 io_uring/uring_cmd.c               |  29 +++-
 18 files changed, 476 insertions(+), 181 deletions(-)

-- 
Jens Axboe

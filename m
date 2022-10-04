Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0B25F4BB3
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 00:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiJDWMP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 18:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJDWMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 18:12:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AE45C36F
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 15:12:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x32-20020a17090a38a300b00209dced49cfso157037pjb.0
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 15:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=7DqxR/qKtk6ps4xalZ1dcZ6Xj4vfAqGCt50HxUw/7Kg=;
        b=7AL2g8wuVL7PNfrFAVdiSnGPRnWUbaVRUv/UlZKulQBHv2U7LGe3OLHfQ3vEQmFlnV
         zKXXT6k7yePy33BpKv1K48iwEIW+s4LZY2UrJp0zqlasac/9q+qVwz9BOtMyhvaq0G5s
         keSH/iRuJ3WvkzAlJ9+NOGJKO71b4pnR46opnCE8tT0sgV/pyZ2WHI6qKltH3TP5YRX4
         E2wK6bowCdFs99YrFtOApmK76O+Eb+IkWvrigx6IRrjq4dtTdRmudFtT90RL4iPaS1lQ
         eK+3vLfZJVoJUgG3Lf56HF4b1ANwDQWnU4pqpcyzMar3/oMUvt8iRY59pocCI+/3Dv7+
         /HDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=7DqxR/qKtk6ps4xalZ1dcZ6Xj4vfAqGCt50HxUw/7Kg=;
        b=a9zgTtfUmUC+RlOr1F1QpVf6ZbJ8rX7UwyN7odoEx2mQALdop7rJ3WY6AuBo37A/92
         X+hHQqJ6G4GYCqTNgcbzqDIRMtG8mtBAfcTghtqbCbUrOumRfannx+HY717cL9Lr/R+V
         /1RL1ggo9X/Fgg4ObWbzKBIcQGcnJa18PIfaVZ7YQMOO3UPfHVjcIbAWcI8Mc2tUCFQe
         ebKLTaRy/nHGMxMdOBaPOoC7e2nIT61flaCVKmp1duHQeScpRtSqLFyKwP5Qkxp1D8Ii
         qPdjDXwjBFQJ8vgEoduMzbgQ1/ijJT698fjQhi+eokVeuG1aKSwHxBWUEwTyjIovbJSu
         OdxQ==
X-Gm-Message-State: ACrzQf2yEDEh+17Ic5/GVr7DYZpY7ZtbMqYTUg3Nt4ZufI6ox1yLyQoI
        Sl/1vm9cJUzdLGG1OoDr24ivZg==
X-Google-Smtp-Source: AMsMyM6OjpZO4EvuhzmTHvk47SOLaIoyUBHPhL76y1d/nf2rUV0ARDnCDxfL62OyG67grK89yvM0KQ==
X-Received: by 2002:a17:90a:dc05:b0:20a:d73b:53a3 with SMTP id i5-20020a17090adc0500b0020ad73b53a3mr1826354pjv.67.1664921531504;
        Tue, 04 Oct 2022 15:12:11 -0700 (PDT)
Received: from ?IPV6:2600:380:4b7a:dece:391e:b400:2f06:c12f? ([2600:380:4b7a:dece:391e:b400:2f06:c12f])
        by smtp.gmail.com with ESMTPSA id f19-20020a63de13000000b00434e1d3b2ecsm8872044pgg.79.2022.10.04.15.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:12:11 -0700 (PDT)
Message-ID: <8bbcb3e9-118c-ea25-a906-24aa28a6c48c@kernel.dk>
Date:   Tue, 4 Oct 2022 16:12:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] v2 Passthrough updates for 6.1-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
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

- Fix from Geert fixing an issue with !CONFIG_IO_URING

Please pull!


The following changes since commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0:

  sbitmap: fix lockup while swapping (2022-09-29 17:58:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.1/passthrough-2022-10-04

for you to fetch changes up to 0e0abad2a71bcd7ba0f30e7975f5b4199ade4e60:

  io_uring: Add missing inline to io_uring_cmd_import_fixed() dummy (2022-10-04 08:13:20 -0600)

----------------------------------------------------------------
for-6.1/passthrough-2022-10-04

----------------------------------------------------------------
Anuj Gupta (6):
      io_uring: add io_uring_cmd_import_fixed
      io_uring: introduce fixed buffer support for io_uring_cmd
      block: add blk_rq_map_user_io
      scsi: Use blk_rq_map_user_io helper
      nvme: Use blk_rq_map_user_io helper
      block: rename bio_map_put to blk_mq_map_bio_put

Geert Uytterhoeven (1):
      io_uring: Add missing inline to io_uring_cmd_import_fixed() dummy

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

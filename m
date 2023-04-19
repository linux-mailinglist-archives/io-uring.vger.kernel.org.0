Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814C06E7768
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjDSK3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 06:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjDSK3s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 06:29:48 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D357EE4;
        Wed, 19 Apr 2023 03:29:46 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-3f17edbc15eso4998775e9.3;
        Wed, 19 Apr 2023 03:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681900185; x=1684492185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6btso1L71pcY+YPY7KZNXSdrcfDyGPFY3TrsX5cprdY=;
        b=b5uYoZy7N9QX2C1rfk23tMenn41cLaWRsKXenLKoJ+QifIt3IB0g4Yd61xoa9wMEYu
         UDt98mdm2sieggZdPt2hmkJzCJGYXnXPkv4iobTgb2J6JWZ61nriw4L+gyuZJJe9EcmT
         tVyYMjHRJ5DgWiQ3NfbnNw5FTqHyRONXxEgfsJZorHvuXTVIn34UGJklTlAJ1yaXptmP
         y3AYhbK3NscBYqlmiNrT4Q1alCiR1BxZDHk7IJCMIjlSaJpnRkw++ZrZzo58bRS/XEsU
         DY6SRaABOFT9ol3M3X++KuVl00E6u7p1JPn7aq+VYEFEmuMIRS+21S/Ey2JhNdBq1vYt
         IdJw==
X-Gm-Message-State: AAQBX9f+i+HmKnctqhPFHCd8vg7gHYOc+xNSeLMxLmDstUsdJgCv/r2h
        IiK05Me+9Now+Rc5j6vnJUBIbU00q7vynK8d
X-Google-Smtp-Source: AKy350YSXaxkNwcYpcVtkau7hNF6PvCrlceUhslw2AjAfKL1bNW7FBp7Icj95GLJy/s3X+EAgGXR7A==
X-Received: by 2002:adf:f9cd:0:b0:2f0:833:6acc with SMTP id w13-20020adff9cd000000b002f008336accmr3427087wrr.61.1681900184647;
        Wed, 19 Apr 2023 03:29:44 -0700 (PDT)
Received: from localhost (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d4e90000000b002f2782978d8sm15333574wru.20.2023.04.19.03.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 03:29:44 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: [PATCH 0/2] io_uring: Pass whole sqe to commands
Date:   Wed, 19 Apr 2023 03:29:28 -0700
Message-Id: <20230419102930.2979231-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These two patches prepares for the sock support in the io_uring cmd, as
described in the following RFC:

	https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/

Since the support described above depends on other refactors, such as the sock
ioctl() sock refactor[1], I would like to start integrating patches that have
consensus and can bring value right now.  This will also reduce the patchset
size later.

Regarding to these two patches, they are simple changes that turn io_uring cmd
subsystem more flexible (by passing the whole SQE to the command), and cleaning up an
unnecessary compile check.

These patches were tested by creating a filesyste and mounting an NVME disk
using ubdsrv/ublkb0.

[1] https://lore.kernel.org/lkml/ZD6Zw1GAZR28++3v@gmail.com/

Breno Leitao (2):
  io_uring: Pass whole sqe to commands
  io_uring: Remove unnecessary BUILD_BUG_ON

 drivers/block/ublk_drv.c  | 24 ++++++++++++------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  2 +-
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      | 14 ++++++--------
 io_uring/uring_cmd.h      |  8 --------
 6 files changed, 21 insertions(+), 31 deletions(-)

-- 
2.34.1


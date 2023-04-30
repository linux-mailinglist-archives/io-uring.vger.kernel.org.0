Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594E96F2939
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjD3OgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjD3OgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:36:08 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BA1211D;
        Sun, 30 Apr 2023 07:36:06 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so8602275e9.2;
        Sun, 30 Apr 2023 07:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865365; x=1685457365;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDvF+4jn75c0U/4/y4sFW3z5VmXzCZCBCvnk0YKahgs=;
        b=jTHdELDZkKDM9s61nVMjGr+erzCuq8+Tvaazs/25XZbQ3OG5C2iB/7LFdn4Tngvthd
         k6hsdgi9PyplKZsa9gordQ+Q5EAS7LXGsMeK7nFwx3JI4eyGTTpKNeAiG5Nk2YGB+NFR
         tpgURyYERwnUs4INvqD2KvoGjDmEWWofCoH9a0LxgyjYuosmH+2CymXGBBpeNzT1aVnM
         wWCgt2rwgziXVNRX0tm+FV+GCvckJ+xRBfDlEG5WAuB5s6LpTk9y17Eh6DOORLuSSTwy
         96KYSQ8uOJUm5LA+ZCFhlubjcw4G9Lq7qjlPqnujAm11AQF0jTf8taXp0eY4llkojxyL
         MymA==
X-Gm-Message-State: AC+VfDwgQ6Gd5ApEt9Cbve9vRZpuPoWMs40Il6ba6ytWb6mHWg+DV18D
        eMaYnB7Ojy335YBYn1kSeIH6Yhj2nww=
X-Google-Smtp-Source: ACHHUZ6U+r3db8m41a6zCKCOVuqsc8/ZfYMBGuFIxgonr34g47cljfqoJluo9jKELqhg+WCaxYAT3A==
X-Received: by 2002:a5d:6e83:0:b0:2f7:e3aa:677a with SMTP id k3-20020a5d6e83000000b002f7e3aa677amr7785255wrz.46.1682865364669;
        Sun, 30 Apr 2023 07:36:04 -0700 (PDT)
Received: from localhost (fwdproxy-cln-018.fbsv.net. [2a03:2880:31ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id z18-20020adfe552000000b002f3e1122c1asm26079134wrm.15.2023.04.30.07.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:36:03 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        hch@lst.de, kbusch@kernel.org
Subject: [PATCH v3 0/4] io_uring: Pass the whole sqe to commands
Date:   Sun, 30 Apr 2023 07:35:28 -0700
Message-Id: <20230430143532.605367-1-leitao@debian.org>
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

These three patches prepare for the sock support in the io_uring cmd, as
described in the following RFC:

	https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/

Since the support linked above depends on other refactors, such as the sock
ioctl() sock refactor[1], I would like to start integrating patches that have
consensus and can bring value right now.  This will also reduce the patchset
size later.

Regarding to these three patches, they are simple changes that turn
io_uring cmd subsystem more flexible (by passing the whole SQE to the
command), and cleaning up an unnecessary compile check.

These patches were tested by creating a file system and mounting an NVME disk
using ubdsrv/ublkb0.

[1] ZD6Zw1GAZR28++3v@gmail.com/">https://lore.kernel.org/lkml/ZD6Zw1GAZR28++3v@gmail.com/

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

V1 -> V2 :
  * Create a helper to return the size of the SQE
V2 -> V3:
  * Transformed uring_sqe_size() into a proper function
  * Fixed some commit messages
  * Created a helper function for nvme/host to avoid casting
  * Added a fourth patch to avoid ublk_drv's casts by using a proper helper

Breno Leitao (4):
  io_uring: Create a helper to return the SQE size
  io_uring: Pass whole sqe to commands
  io_uring: Remove unnecessary BUILD_BUG_ON
  block: ublk_drv: Add a helper instead of casting

 drivers/block/ublk_drv.c  | 36 ++++++++++++++++++++++++------------
 drivers/nvme/host/ioctl.c |  8 +++++++-
 include/linux/io_uring.h  |  2 +-
 io_uring/io_uring.h       | 10 ++++++++++
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      | 13 ++++---------
 io_uring/uring_cmd.h      |  8 --------
 7 files changed, 47 insertions(+), 32 deletions(-)

-- 
2.34.1


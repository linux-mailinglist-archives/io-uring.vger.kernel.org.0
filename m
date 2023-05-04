Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5A6F6B02
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 14:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjEDMTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjEDMTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 08:19:07 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A38A6585;
        Thu,  4 May 2023 05:19:05 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3f19afc4fbfso4347575e9.2;
        Thu, 04 May 2023 05:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683202744; x=1685794744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3bfwAGdzZox0nAzfwe0N1qLqTcM9TeHkTSwpiTSRY0=;
        b=OY1DEGYRuKb1h/wq5byRZiSK9goMESYV4YFhKeqXFu7UATixR6lWUIQ3oN6PHJgrbU
         VUgg9an+i09SBQL4vqtjzDfnJvtk0uvKjv2lOO41f5VW2Rxxchg5CU4GtifjI9Se8mLO
         vW78zMtwdb7Imd19fBF+YiX2p1X2f4ISRXtrZHf0248J1qlHmRq+ClVMB4gXWXi0knam
         mmNExWPu5epsI8dkiNqYDZ08TcD5XotWEI5Vqv6/XDPUe3h/qgaN6M//+LpYq/f+2wcp
         zaSeA/pLOgkJ0mcbxDkYEh5FrAXWS9TtOzFcis94W0gilgQ9JTrrMET4finx6OhhlAzc
         p6ow==
X-Gm-Message-State: AC+VfDxQu8hsHq16B44wY+gvCirjU+lkDDyUdh3dB3ucgUDf7cLPn9cN
        1Rm2yQC6OJr4LFVEwzzIbGTgBsqFUS8uvg==
X-Google-Smtp-Source: ACHHUZ7+aTJs+OA6fdjH1WYQZ7Yvv4IhxhIXgBxFX3f1gp6uaNWvciZ8ApcS3InCHVUXHdGLqFWDgw==
X-Received: by 2002:a05:600c:2941:b0:3f2:5777:27d4 with SMTP id n1-20020a05600c294100b003f2577727d4mr16631789wmd.25.1683202743592;
        Thu, 04 May 2023 05:19:03 -0700 (PDT)
Received: from localhost (fwdproxy-cln-023.fbsv.net. [2a03:2880:31ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id f12-20020a7bcc0c000000b003f17848673fsm4821518wmh.27.2023.05.04.05.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 05:19:03 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
Subject: [PATCH v4 0/3] io_uring: Pass the whole sqe to commands
Date:   Thu,  4 May 2023 05:18:53 -0700
Message-Id: <20230504121856.904491-1-leitao@debian.org>
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

Link: https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/

Since the support linked above depends on other refactors, such as the sock
ioctl() sock refactor, I would like to start integrating patches that have
consensus and can bring value right now.  This will also reduce the
patchset size later.

Regarding to these three patches, they are simple changes that turn
io_uring cmd subsystem more flexible (by passing the whole SQE to the
command), and cleaning up an unnecessary compile check.

These patches were tested by creating a file system and mounting an NVME disk
using ubdsrv/ublkb0.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

V1 -> V2 :
  * Create a helper to return the size of the SQE
V2 -> V3:
  * Transformed uring_sqe_size() into a proper function
  * Fixed some commit messages
  * Created a helper function for nvme/host to avoid casting
  * Added a fourth patch to avoid ublk_drv's casts by using a proper helper
V3 -> V4:
  * Create a function that returns a null pointer (io_uring_sqe_cmd()),
    and uses it to get the cmd private data from the sqe.

Breno Leitao (3):
  io_uring: Create a helper to return the SQE size
  io_uring: Pass whole sqe to commands
  io_uring: Remove unnecessary BUILD_BUG_ON

 drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  7 ++++++-
 io_uring/io_uring.h       | 10 ++++++++++
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      | 12 +++---------
 io_uring/uring_cmd.h      |  8 --------
 7 files changed, 34 insertions(+), 33 deletions(-)

-- 
2.34.1


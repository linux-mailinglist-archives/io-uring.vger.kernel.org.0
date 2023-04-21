Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12F26EA98C
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 13:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDULq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 07:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDULq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 07:46:59 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D37C3;
        Fri, 21 Apr 2023 04:46:57 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-2f939bea9ebso1501474f8f.0;
        Fri, 21 Apr 2023 04:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682077615; x=1684669615;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drtJY3bzG70qwaMh3FrpvU2+Y1e1A4ULSdaEvu4w4Po=;
        b=EOJ7JbXW2POm4MAEP8Q3Dk/oMUsLe+/FZDvgiRJR2LZQX8Lw7fuGv33rsokdl6Tdlk
         6jIz+TwxmvxlQPk6iZt7DcWx27gRU+MCBX9KVclzIgLLNMPS0zdZG0NJrg1aeO+AjeTl
         Dl0mVL/FXkioozVBOTllzspH/LHqL9H9WIco1kOyHsufCjJe2z13CiL/LZ6Wb20in05K
         SJ0ppVIru5vtyUAhnNyrtoi0Vu9xBmNxp66rMn0R94QxdRL38qxs99fv5zxATOmuybMt
         68sP6fLCj1rZ01M9wBhMT3IlxDFG8gPMZWaCwydvWNZmniUHcFt6UvgGMnojnkBa7+Z5
         V92w==
X-Gm-Message-State: AAQBX9dUvJsq9yFg4vcCCK4ZQwflcEr13hVK8smlCq5ouKteZqvbZh96
        9eJ21m6Sso4DA/Lxovfv+8Hp3uP8nm/2QQ==
X-Google-Smtp-Source: AKy350Z6FaO9dagmTH/zhPsTsiWB9kCDDLYbt3lKidgLFGw1aZUHkPY05gtP2GpQhwHrfkyzdSr6OQ==
X-Received: by 2002:a5d:5902:0:b0:2fd:1a81:6b0e with SMTP id v2-20020a5d5902000000b002fd1a816b0emr3474376wrd.33.1682077615300;
        Fri, 21 Apr 2023 04:46:55 -0700 (PDT)
Received: from localhost (fwdproxy-cln-019.fbsv.net. [2a03:2880:31ff:13::face:b00c])
        by smtp.gmail.com with ESMTPSA id s13-20020adfeb0d000000b002fb6a79dea0sm4298485wrn.7.2023.04.21.04.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 04:46:54 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: [PATCH v2 0/3] io_uring: Pass the whole sqe to commands
Date:   Fri, 21 Apr 2023 04:44:37 -0700
Message-Id: <20230421114440.3343473-1-leitao@debian.org>
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

V1 -> V2 : 
  * Create a helper to return the size of the SQE

Breno Leitao (3):
  io_uring: Create a helper to return the SQE size
  io_uring: Pass whole sqe to commands
  io_uring: Remove unnecessary BUILD_BUG_ON

 drivers/block/ublk_drv.c  | 24 ++++++++++++------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  2 +-
 io_uring/io_uring.h       |  3 +++
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      | 13 ++++---------
 io_uring/uring_cmd.h      |  8 --------
 7 files changed, 22 insertions(+), 32 deletions(-)

-- 
2.34.1


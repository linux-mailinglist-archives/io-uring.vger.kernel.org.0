Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63E8550DD2
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiFTA0e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbiFTA0c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F484A1B0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:32 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a10so4951920wmj.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V/+T61q0Dn1gyzcu/B1XUf1IkvnHv5BGoD400mbO2BY=;
        b=k1LtQv/3o+vYlzTKGXW9nI/O/cU6K7QyphulPd7dKwgIhzl7UDZRoURiI1AbfgWBqT
         P26D2DxETvBLDzq36TMAsJskZSRbStvOuaIkRWj9WDhlCsoL2pVgqAqRsAp5iuwMfKiK
         jqo9t9PpAKTwyWLQmkgS8tuFcI2TmJlLK8RcSuU1dTAKnhU+mMLyhJ9QBL99sxE9WuP0
         QmgDNNkMA0J1pZZj4UcKs39jBZJbbNCYU9VS4VR42nVDOIzEmCUresRArQKp+ZohWwfE
         ouL3Ln0eqRUKHsCNfnbtV3IKPIOZYA8SpBC1w1TIdmgS5ueKzZ/4tY6QfuTdWBIOrmJD
         MaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V/+T61q0Dn1gyzcu/B1XUf1IkvnHv5BGoD400mbO2BY=;
        b=gMQ87Zc5bnKJkQkRSuz6+3Ge5qQ19JPsE1c5aKRNqyBhAGUIvp/vBQv850ejgpqbm+
         DeL6RKJsI8wBmJBzdKVWcpj8e12QiBwN+lvwMixKuLwBacbRAh2oKTLwmanMhyqVdJoF
         vGpj6Ilk0T/3nwCrcUYPX4/T1lj/hOJDFzujmMQOb+RNc0ciGfFc8IeCBmpRS/zl03Ph
         UScDPqawMhuO2/mMHCTrTpqNElG499IyDHFLRu3N1ppFWF1qHBsfaeB+RuQ4apVzo0bM
         VihpJHUtNqltqgtTNnO5KnjVvbnV5ta/4PEOWzR/FVQsMnxwb/BWXoSvsys081OxGZzT
         5k3g==
X-Gm-Message-State: AOAM533Z0LjJtO0ZNqYZ1Ep57i1R5TNU1ZluJk8bYXQ9peAbcQ9Lxf5r
        ZdaEnjTfBjyBCJzVWEf1O9NBGkzgJhSQwQ==
X-Google-Smtp-Source: ABdhPJz9kzXfdbKqnXFP72NaPSlcJTZw8Tt7r0ax7U3DRtOXfUHIR7JSEk41/rndgO2lk/QpG2PTiA==
X-Received: by 2002:a05:600c:1986:b0:39c:8417:5da3 with SMTP id t6-20020a05600c198600b0039c84175da3mr32596331wmq.20.1655684790207;
        Sun, 19 Jun 2022 17:26:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 00/10] 5.20 patches
Date:   Mon, 20 Jun 2022 01:25:51 +0100
Message-Id: <cover.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/10 fixes multi ring cancellation bugs
2-3 are cleanups
4-6 is a resend of the dropped patches
7-10 are rebased cleanups

Pavel Begunkov (10):
  io_uring: fix multi ctx cancellation
  io_uring: improve task exit timeout cancellations
  io_uring: fix io_poll_remove_all clang warnings
  io_uring: hide eventfd assumptions in evenfd paths
  io_uring: introduce locking helpers for CQE posting
  io_uring: add io_commit_cqring_flush()
  io_uring: opcode independent fixed buf import
  io_uring: move io_import_fixed()
  io_uring: consistent naming for inline completion
  io_uring: add an warn_once for poll_find

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            | 191 +++++++++++++++++----------------
 io_uring/io_uring.h            |  25 ++++-
 io_uring/poll.c                |  12 ++-
 io_uring/rsrc.c                |  60 +++++++++++
 io_uring/rsrc.h                |   3 +
 io_uring/rw.c                  |  74 +------------
 io_uring/timeout.c             |  16 ++-
 8 files changed, 205 insertions(+), 178 deletions(-)

-- 
2.36.1


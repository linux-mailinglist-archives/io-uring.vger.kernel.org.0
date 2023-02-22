Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBAB69FAA5
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjBVSAl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 13:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjBVSAl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 13:00:41 -0500
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBC738B6D;
        Wed, 22 Feb 2023 10:00:39 -0800 (PST)
Received: by mail-wm1-f48.google.com with SMTP id p3-20020a05600c358300b003e206711347so5947726wmq.0;
        Wed, 22 Feb 2023 10:00:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB8V6SnbhQl8mQXpiuOZR/SGgLZPL4Xx8Q+WzhCE+9Y=;
        b=62nkeBQNBJIhOnLZ73PuGXym3ZqBL1uZSfVavGBfrlM7Vp6TSEQQpfuVNW7r685ix4
         QJzSbDvLsboOtflz3h1Xie3kYGi8rcnr/A4EfSteHGABVTJrYvXJMVtqQ+C4qhhmIz+M
         bDk+4ZGbE033tM3+u6gvi06bfJjTinZvKcV/514T07xmRWm9+t0DSH/tG6oUS5GtRhEy
         jEZ+R/uFz7zGhlciU+gEI/Tph7qNs1zND4+HbAQmenxXOfKPd5SqDB+Nfb0JxdmpRgqP
         VjTItWIhYHPzg2AXdL2fGp+MTJLluVT4HMzdV/YTUk0jEeMogR3+RrhorbocuAROv9tM
         KDSw==
X-Gm-Message-State: AO0yUKWW0F/Zd5RDyQDdm5b6KFxrsNSKqum4Mk+LZBsZyxf/ognfciPY
        u3RfK/lW7eZmSLKwmZqAwH7QEpJP3EoHkfYu
X-Google-Smtp-Source: AK7set/kUKG7xWon2SULW4XbykLQc6xn/fjiAevh+UNSvLafp16zSFrsMXHGM48heVondcim8RjMOA==
X-Received: by 2002:a05:600c:3c8e:b0:3db:1f68:28f with SMTP id bg14-20020a05600c3c8e00b003db1f68028fmr7097858wmb.24.1677088838291;
        Wed, 22 Feb 2023 10:00:38 -0800 (PST)
Received: from localhost (fwdproxy-cln-033.fbsv.net. [2a03:2880:31ff:21::face:b00c])
        by smtp.gmail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm2554050wmi.3.2023.02.22.10.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 10:00:37 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com, Breno Leitao <leit@fb.com>
Subject: [PATCH v2 0/2] io_uring: Add KASAN support for alloc caches
Date:   Wed, 22 Feb 2023 10:00:33 -0800
Message-Id: <20230222180035.3226075-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Breno Leitao <leit@fb.com>

This patchset enables KASAN for alloc cache buffers. These buffers are
used by apoll and netmsg code path. These buffers will now be poisoned
when not used, so, if randomly touched, a KASAN warning will pop up.

This patchset moves the alloc_cache from using double linked list to single
linked list, so, we do not need to touch the poisoned node when adding
or deleting a sibling node.

Changes from v1 to v2:
   * Get rid of an extra "struct io_wq_work_node" variable in
     io_alloc_cache_get() (suggested by Pavel Begunkov)
   * Removing assignement during "if" checks (suggested by Pavel Begunkov
     and Jens Axboe)
   * Do not use network structs if CONFIG_NET is disabled (as reported
     by kernel test robot)

Breno Leitao (2):
  io_uring: Move from hlist to io_wq_work_node
  io_uring: Add KASAN support for alloc_caches

 include/linux/io_uring_types.h |  2 +-
 io_uring/alloc_cache.h         | 35 +++++++++++++++++++---------------
 io_uring/io_uring.c            | 14 ++++++++++++--
 io_uring/net.c                 |  2 +-
 io_uring/net.h                 |  4 ----
 io_uring/poll.c                |  2 +-
 6 files changed, 35 insertions(+), 24 deletions(-)

-- 
2.30.2


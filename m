Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B06A0E27
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 17:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbjBWQoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjBWQoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 11:44:22 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD414EAB;
        Thu, 23 Feb 2023 08:44:20 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so6818742wmq.2;
        Thu, 23 Feb 2023 08:44:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eruQWB2/18nDotnnWoGStXzb4aFnYUrYHZ3mQIMO230=;
        b=QuyPSrLGWROMJuZb1HAn3ZGgmbOJpN2xa73jfdZ7EJKAfQU7VGI0aST583uzA+3Wo5
         0qz8g/ecB64R2KzmZYgQ8N5++ulSe4z5otpHQI9FOyyQsyeG+6rxy2m3RR6P6k+y9pNR
         QY1/iAhBXe03mTYz6YRMZU1HVRppLECBakeVA8105aLOqJ0yRWm9I10JbvfGLjWzp4WB
         54C8URzCyfKCWP5/zF6uc9CBnKI5lIZE2ciXGBJc8Q2x8NekfhA4KNxSn2Vjd7vwwvoK
         zQgtrsHrlqZ+HQAS8uN8zd0FQOtwyESYky7vYmrQv7IXs2XThC6C9uju4UCT8BFkPwD5
         jTMw==
X-Gm-Message-State: AO0yUKWPCBrzKIkHEZ+vRehFO9A5h61Q/QfJVSHugeW23gq7jKvDvEsU
        xY8Ru1a4UuM/Bgy0lzdGGH4=
X-Google-Smtp-Source: AK7set/jDHcM+n4wOut1aNg2wr8xBwY7DveDGuxa+7+xqu8SYgHdOb/H74Wx+XiE/Lx0/wHBIro4OQ==
X-Received: by 2002:a05:600c:331b:b0:3dc:4318:d00d with SMTP id q27-20020a05600c331b00b003dc4318d00dmr9262047wmp.11.1677170659002;
        Thu, 23 Feb 2023 08:44:19 -0800 (PST)
Received: from localhost (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c4f4600b003df245cd853sm14739855wmq.44.2023.02.23.08.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 08:44:18 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: [PATCH v3 0/2] io_uring: Add KASAN support for alloc caches
Date:   Thu, 23 Feb 2023 08:43:51 -0800
Message-Id: <20230223164353.2839177-1-leitao@debian.org>
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

Changes from v2 to v3:
   * Store elem_size in the io_alloc_cache, so, we don't need to pass
     the size when getting the cache element.


Breno Leitao (2):
  io_uring: Move from hlist to io_wq_work_node
  io_uring: Add KASAN support for alloc_caches

 include/linux/io_uring_types.h |  3 ++-
 io_uring/alloc_cache.h         | 30 ++++++++++++++++++------------
 io_uring/io_uring.c            |  4 ++--
 io_uring/net.h                 |  5 ++++-
 4 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.30.2




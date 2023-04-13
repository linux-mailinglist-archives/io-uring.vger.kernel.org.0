Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A817E6E0FFA
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDMO25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjDMO25 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:28:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E61BEA
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v6so14366240wrv.8
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396134; x=1683988134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IxX8hszJSYPsySwsjdnMKoQ3gBr0T1V7Zv88RxMD03c=;
        b=WG1NBqikfs2gCqFXcpnfS08QBHm/F6DOoGQ2ioZ99Prn7O18oezbbpnujXrH8G7P+3
         vs44qGEZMLHsVaXCOaUXXDnN1T9/bfGBgaDOuamT9xfODv2vuE3mVSOt4RrZklz6MWa5
         6bFxJA2zLKsWAhCclv6E5271q9GWBebwCRA4z4BHWeF8AspCGKlEvLkvwJfm18s7SCYk
         C7ovV/o1uiNQZY/syJ5WJkZa+UdxLfAJ4y78b+D75uwVnbGRpdbSsNu/aqWlBOObs/MF
         L5bbsyZIgJNOnnpiuAuAYvd12rEapmQQdCo73I8ntCjM4I+cg6W0IRyXT40LSq8m09bd
         OpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396134; x=1683988134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IxX8hszJSYPsySwsjdnMKoQ3gBr0T1V7Zv88RxMD03c=;
        b=booEEKRpY+uOVqfbH4BZwoNaMvD6OO2vhM8DlvYtvar1KUCle4RhCw8qYtdvtoEbmM
         QrBBbojjbjVkRd4Bsegsh0Zot8DGBPlnzhcjTboNKOhq0uw+bQQAt8lv5JQgDF3Ohg4P
         XYHG/aEmHBYV8yOSVSeo/tEPrtL3v678m+7Ul6cKZsvtNZsQdhdQ9JIGvu6M2dKw0Px3
         teW2I9HqM0M9aZDhIWiUEzKcksiHb4mISQfIZGX0NA7T+OzT+v8GBJDikrbaNyqEjvrp
         KCPlAVRHUO3YVNslHSlxX5Dq56P+SHzjVQ07dXkNFacjKjKe1yxwNneiE/ypBGPD1ob9
         jEDA==
X-Gm-Message-State: AAQBX9dSNbjpaKKr1wo1vfYFbK5q+iBfNq1JFdFFDT8zIft39PvjbRSH
        fwvNFFZIQEiaOiLU8tMT0oKFLWj5cGI=
X-Google-Smtp-Source: AKy350Yhq6TAFLA5C7pVx2sOqy1U782kS1depWfcZDmKWnstxrJI9ncVjxBcO2IHcBaxiUyaWgDjmA==
X-Received: by 2002:a05:6000:104a:b0:2ee:f1f0:14bb with SMTP id c10-20020a056000104a00b002eef1f014bbmr1681069wrx.49.1681396133717;
        Thu, 13 Apr 2023 07:28:53 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.4 00/10] some rsrc fixes and clean ups
Date:   Thu, 13 Apr 2023 15:28:04 +0100
Message-Id: <cover.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch 1 is a simple fix for using indexes w/o array_index_nospec()
protection.

Patches 2-5 are fixing a file / buffer table unregistration issue
when the ring is configured with DEFER_TASKRUN.

The rest are clean ups on top.


Pavel Begunkov (10):
  io_uring/rsrc: use nospec'ed indexes
  io_uring/rsrc: remove io_rsrc_node::done
  io_uring/rsrc: refactor io_rsrc_ref_quiesce
  io_uring/rsrc: use wq for quiescing
  io_uring/rsrc: fix DEFER_TASKRUN rsrc quiesce
  io_uring/rsrc: remove rsrc_data refs
  io_uring/rsrc: inline switch_start fast path
  io_uring/rsrc: clean up __io_sqe_buffers_update()
  io_uring/rsrc: simplify single file node switching
  io_uring/rsrc: refactor io_queue_rsrc_removal

 include/linux/io_uring_types.h |  2 +
 io_uring/filetable.c           | 11 ++---
 io_uring/io_uring.c            |  5 +-
 io_uring/rsrc.c                | 90 ++++++++++++++--------------------
 io_uring/rsrc.h                | 13 +++--
 5 files changed, 53 insertions(+), 68 deletions(-)

-- 
2.40.0


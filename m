Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4A635BD8
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbiKWLfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbiKWLfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:04 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4445310EA18
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:03 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i12so25084133wrb.0
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ve0X4PGzCkkMQ5vx6tc+RxP+ddZMGFp49eQUkuIcVrI=;
        b=Hddn8LMq/jJLvex3f2nR4usnZTB+noxSs8QYsbxO+PP5aewKCUVlQkQUByzEAhywmG
         xidhAFa20zGFmVPP5g23+HVp7dZmeQ+niDYK0MK2N4M0IT8dZQ9ib43D0QtuZBBVDGld
         oLVdraLbztrFgtfG2UsY/vNe2xrmDnLtvxDRsLQiO4qyxlMbt3Hs8NVpb6yrEgA4UvoD
         8buLY2Uz1UY32+rK3Kqpuiq46VLtrcmZNDLPbHYHTgN1vmFHFJv01YnSAxhRqEL2Cv5/
         2pFCDPl4xEUTu2Ynqg6Y7JXZQ3O47Av47AzI0MVdEQ1XXHdY0uZgZ0gon1cx4A8+rVeo
         1kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ve0X4PGzCkkMQ5vx6tc+RxP+ddZMGFp49eQUkuIcVrI=;
        b=iYj8E/QcHQuIqDIxFuPuge+YbnGbiyU5BqypPwNuM0rtXbOfcfgwdh7hhiEzqhqH15
         xHFb42jxm6fjijaYO4zG9abVHitg77jVlXKYTLgUr6WSOELUOcq4vCzOa1mNaVZZ885X
         euU3S03gSy7YmLKaTCX6xg3/brdLDnANRipFts/rpq+hYrGuBzcU01A3FmbeNi/NYo6/
         NRBRKH4VISdYW3971LCIomWowCE6xy6JSENEMnMkHlR7MdWMOLf7y5KRFUdEOpMxeMrI
         u8w0rwA/bMVdTYc/5QFka2CRHCw/boXe/zlmlmAquMSIRPvcnSOjabYc3x7+TkrQBjKm
         blOA==
X-Gm-Message-State: ANoB5pm+5eXjD6Hn2YPabIQ3Jwrh53f93UZm0URW6IM/QGeQ/LAddnH9
        uHDUuu0KA0ZeUZmECBZLbXyTP+hXZ1U=
X-Google-Smtp-Source: AA0mqf7/p/Lj9g7Jya7LJfeqjBEn4/4nAwwUjQDKW+ERU9zBxN2tPpOw00cZCADcbQJweFhOdjJD1Q==
X-Received: by 2002:adf:ef0a:0:b0:22e:75e4:c6d1 with SMTP id e10-20020adfef0a000000b0022e75e4c6d1mr8171488wro.289.1669203301516;
        Wed, 23 Nov 2022 03:35:01 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] iopoll cqe posting fixes
Date:   Wed, 23 Nov 2022 11:33:35 +0000
Message-Id: <cover.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

We need to fix up a few more spots for IOPOLL. 1/7 adds locking
and is intended to be backported, all 2-5 prepare the code and 5/6,
fixes the problem and 7/7 reverts the first patch for-next. 

Pavel Begunkov (7):
  io_uring: add completion locking for iopoll
  io_uring: hold locks for io_req_complete_failed
  io_uring: use io_req_task_complete() in timeout
  io_uring: remove io_req_tw_post_queue
  io_uring: inline __io_req_complete_put()
  io_uring: iopoll protect complete_post
  io_uring: remove iopoll spinlock

 io_uring/io_uring.c  | 57 ++++++++++++++++++++------------------------
 io_uring/io_uring.h  | 18 +++++++++++---
 io_uring/kbuf.c      |  4 ++--
 io_uring/poll.c      |  2 +-
 io_uring/timeout.c   | 10 ++++----
 io_uring/uring_cmd.c |  2 +-
 6 files changed, 50 insertions(+), 43 deletions(-)

-- 
2.38.1


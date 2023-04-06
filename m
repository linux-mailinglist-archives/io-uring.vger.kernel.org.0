Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4116D97E9
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbjDFNVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbjDFNU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B03B9ED7;
        Thu,  6 Apr 2023 06:20:25 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-930e691e34eso108810266b.0;
        Thu, 06 Apr 2023 06:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bQnJmNTlCd7Gp0yJXnxtAGpYcfqiysBD6ZHlqPg+cT4=;
        b=exUjrwimKbVYwFi6ACeSjkaV6qQ0gaUUI8LUhOFpD+Fb5H79XdpADBGsggkysr/VXo
         iXvsPS5AcVPyuo5XVVrrxQ/o/8KDDdI5QOvl/1XaSoXUwfUj6e61S3Q6ARJwj8t0ST0k
         k5IJSr+EHMZLlCUvcQqfaq+7jw6g2MTvb7F8eyNyS/bdzcZdoeDm10ul1c26HlVBB1QN
         3t77rSdaPl6WEnFpIvrMYlqcUI6hipLKS9uRVO0LYuDlXbuFYkc8h1mct4i++Tt4hgna
         0Enchjt+/IfTdro4Chbr1yIVFlwjf6Vfk4Zs41uzwfIKyAHyuAA4X6ARs4+fYZhzy5Md
         lPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bQnJmNTlCd7Gp0yJXnxtAGpYcfqiysBD6ZHlqPg+cT4=;
        b=Yu6hi3QkzhgSr5bgmSfpX+QNeEV+0schqx6JzJuYdzrgYdHbbpSH1t1phBYBm+UWQ5
         tgBlq0R6st+JVIjkaQQjgDVSrY16noWnwRNKRGJiHUQTLYNcX2fXcPPRB12ElX8E6Ad0
         bfZwoZGcmhycw3WETrGmL6Q2nOz8qDtKkfHW7h+vCxcCeZGSmaWtbSoQCRlTKpx8Izwv
         m8fVVw9JdfBEFf5I8ZPVREw2x3WFJNZ0cq5ocXRHXn9KCfsYg7frMDicuGB49tMWQyKZ
         FCgbrB/rTSPOjcBgKy+Mv8zOGZIe3P+WSEh7ke+K2MyoiLAqPyFo0+b3Zcwzw6jcv1jR
         bXMQ==
X-Gm-Message-State: AAQBX9d6rexyqpHwEdSGAi0dx7VNaagZqU1ukkYLVQm75RmuvFQg1b2M
        v5hxt4lifjlvHvVn+MU8xcC4CsvB5z8=
X-Google-Smtp-Source: AKy350bC1hRKUyPZk0eOxbe/zfttU2uPmCwEl0NtIsX5lngU3LCHeUYyD67PQZpDrl/TmYi7AXm1HQ==
X-Received: by 2002:a05:6402:6d9:b0:502:22fe:ef3c with SMTP id n25-20020a05640206d900b0050222feef3cmr4678466edy.41.1680787223198;
        Thu, 06 Apr 2023 06:20:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] optimise resheduling due to deferred tw
Date:   Thu,  6 Apr 2023 14:20:06 +0100
Message-Id: <cover.1680782016.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring extensively uses task_work, but when a task is waiting
every new queued task_work batch will try to wake it up and so
cause lots of scheduling activity. This series optimises it,
specifically applied for rw completions and send-zc notifications
for now, and will helpful for further optimisations.

Quick testing shows similar to v1 results, numbers from v1:
For my zc net test once in a while waiting for a portion of buffers
I've got 10x descrease in the number of context switches and 2x
improvement in CPU util (17% vs 8%). In profiles, io_cqring_work()
got down from 40-50% of CPU to ~13%.

There is also an improvement on the softirq side for io_uring
notifications as io_req_local_work_add() doesn't trigger wake_up()
as often. System wide profiles show reduction of cycles taken
by io_req_local_work_add() from 3% -> 0.5%, which is mostly not
reflected in the numbers above as it was firing off of a different
CPU.

v2: Remove atomics decrements by the queueing side and instead carry
    all the info in requests. It's definitely simpler and removes extra
    atomics, the downside is touching the previous request, which might
    be not cached.

    Add a couple of patches from backlog optimising and cleaning
    io_req_local_work_add().

Pavel Begunkov (8):
  io_uring: move pinning out of io_req_local_work_add
  io_uring: optimie local tw add ctx pinning
  io_uring: refactor __io_cq_unlock_post_flush()
  io_uring: add tw add flags
  io_uring: inline llist_add()
  io_uring: reduce scheduling due to tw
  io_uring: refactor __io_cq_unlock_post_flush()
  io_uring: optimise io_req_local_work_add

 include/linux/io_uring_types.h |   3 +-
 io_uring/io_uring.c            | 131 ++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  29 +++++---
 io_uring/notif.c               |   2 +-
 io_uring/notif.h               |   2 +-
 io_uring/rw.c                  |   2 +-
 6 files changed, 110 insertions(+), 59 deletions(-)

-- 
2.40.0


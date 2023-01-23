Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B42677E3E
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjAWOmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjAWOmL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:11 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62376126FD
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:10 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d14so7338554wrr.9
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XYHv4O2/o6luiDqr8o8sj/GV6I5YSQhqKdCjGJeSNaI=;
        b=UVmsmw9BfL/n9YWBzwmd0LrB3NprqD2lgcxhd/N8CI0Dk8sOxc7WrdzNRYTyU4JPnH
         CGfyR5IseRGElo6e6BcCy8JjPgjbk4DoeO8DR/hoXD11MMaK1jpEbHbx645RM+bz3XRN
         9qYoxJWD1XZcZYiz5n53ohD5PXE/7JYleA1nL/f98KmOVlRZd7jcKhveDHe7+Gr3ZLEj
         XCjOg5LvyetCKS4bp9euAT9J4ACChtqGx0aGIxnHB8rZI79NjA1f1QDQhzJ4wcATNbsA
         IBZIBeAs50iZtviZkOG+vuu/bEyPFwfxQbkNhXzHBxA1xIKhEgf8Buxmz2z5PZlfgYgL
         ftBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYHv4O2/o6luiDqr8o8sj/GV6I5YSQhqKdCjGJeSNaI=;
        b=wUAQu5KQEBE2f2glbZTJB+w3lAkrjhOq9TDMwPSejzriYVheB/gFS2bFRPplGCshOy
         1aYhAQTeRJen3tjsx35m4/AwTda8AHLu7oprsMe33PE9wo+zMTfI3j23ydeGf3hJYsiT
         AY1aIp0UMcX3ILr+c+/sNYrie+/Ng33gD7LPi1XFWNl0rWID6vLfMfmbmFRvDqdD4XGd
         BinlO/6Zt8VVJbXEn5+RyQCQ64V3kEv5wT960/T2ALUjzewTFRMvPUHgTE5s4PQHfyJL
         gt9auKoBJQub25/Ocj1L3A3Z671gyjAEbta7eiWvsGOoYRn2cA4eZ1ZVjrmOkcWf1PmW
         aN0g==
X-Gm-Message-State: AFqh2krxK7AWrrr24nzSwWL7Jdj59CTOOB1DKwOMiixXnpISn6zpiHga
        Jo6ktTwFPgw1uBhCM00tsytyI/41d9Y=
X-Google-Smtp-Source: AMrXdXu01ArhnRdEt8XO/MIyeIyIVjfDaeusp1EpUOE+1d8Aks/UhuxeKlP28P5yA2ANcutvSFA2UA==
X-Received: by 2002:adf:d4cb:0:b0:2bf:4520:8c80 with SMTP id w11-20020adfd4cb000000b002bf45208c80mr10257914wrk.6.1674484928604;
        Mon, 23 Jan 2023 06:42:08 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] normal tw optimisation + refactoring
Date:   Mon, 23 Jan 2023 14:37:12 +0000
Message-Id: <cover.1674484266.git.asml.silence@gmail.com>
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

1-5 are random refactoring patches
6 is a prep patch, which also helps to inline handle_tw_list
7 returns a link tw run optimisation for normal tw

Pavel Begunkov (7):
  io_uring: use user visible tail in io_uring_poll()
  io_uring: kill outdated comment about overflow flush
  io_uring: improve io_get_sqe
  io_uring: refactor req allocation
  io_uring: refactor io_put_task helpers
  io_uring: refactor tctx_task_work
  io_uring: return normal tw run linking optimisation

 io_uring/io_uring.c | 57 +++++++++++++++++++++++++++------------------
 io_uring/io_uring.h | 19 ++++++++-------
 io_uring/notif.c    |  3 +--
 3 files changed, 46 insertions(+), 33 deletions(-)

-- 
2.38.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF3D5A953C
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiIAK6j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiIAK6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBEACE32
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e18so14503908edj.3
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=/exuUs9C9TISBsagVVrD7PEUhpHG4+LJeQ0ticZbA6Y=;
        b=dbuVmoKJZfUCD4Py4xhYIAbLJwXTJrFD42N+UftsZJvmoG1mbDcbfcvV+2yhJdhC8k
         FkNeosM/GmTviicWsEQcrYZKBpdwwSmrHuDlAMxdOj59T+cnuA9YufrG/TXTuZNWVrBZ
         Kk0+EVX8RZjS2/CF1K0HLSVC5XNqxIEIbUejnsiqBVE1xGwKtPMjIVm7vAf+YYJymdjk
         Xsy7L1N54q/2tanPzu+8+pdUZ6vFgsvNhT4y3bi/kNW7z38nrlDqEss0tpTBUUJteqYv
         VEcLKKRrWBpU4rbGJxsHp5bAKuk0gjOv8DUk+okUc+hfouV9p6GD5UeVICTfrj2Fuuyd
         yKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=/exuUs9C9TISBsagVVrD7PEUhpHG4+LJeQ0ticZbA6Y=;
        b=w79CGpn/xabC5TB5HHGqzUKHYDhXzN55OqWQrm7pQjSWpDWyugEcpQEvFgI+EMP1r8
         utevIUluKVRkWmOMx4aiTVuFezwIrJ7QCifN0//S1QAvx0gPhEuTp4gOXNwrigUb46x4
         UTKBSstTHFhtOzGf6xZ6MNbqqNrivCLK4+L/+thFgUQcxRP2KM494+Fyq6cWbcjZn8c/
         T+OBVCG58q9FoG6eHJd13IVlipR18tdDcWElGNNt2+k12TuDgo8CULH+yqgjuZQqYCnM
         S4yaCkMcrfpjONn2xni7f4qZnsXF93YhNX0ap3rUxVY2v1DdGySxI1NLmfC99lRSDT8U
         kmbg==
X-Gm-Message-State: ACgBeo19pZbnLWxo4vVfUbpmXfPI/7AeT6ldbmBQhk7hSVd9x2DrJXq9
        pzlWsxyDl7kYWFM5nLAn+kGzn6ab5J4=
X-Google-Smtp-Source: AA6agR4E/9uFPaxy2gEwhww0+DLxSZLtxvB8guS2DzsQMH/eUKgxrQg+ZxaX5ulsKF8mdR4ij61C0w==
X-Received: by 2002:a05:6402:26c4:b0:448:6e4:7cda with SMTP id x4-20020a05640226c400b0044806e47cdamr21913394edd.325.1662029908292;
        Thu, 01 Sep 2022 03:58:28 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 0/6] io_uring simplify zerocopy send API
Date:   Thu,  1 Sep 2022 11:53:59 +0100
Message-Id: <cover.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

We're changing zerocopy send API making it a bit less flexible but
much simpler based on the feedback we've got from people trying it
out. We replace slots and flushing with a per request notifications.
The API change is described in 5/6 in more details.
more in 5/6.

The only real functional change is in 5/6, 2-4 are reverts, and patches
1 and 6 are fixing selftests.

Pavel Begunkov (6):
  selftests/net: temporarily disable io_uring zc test
  Revert "io_uring: add zc notification flush requests"
  Revert "io_uring: rename IORING_OP_FILES_UPDATE"
  io_uring/notif: remove notif registration
  io_uring/net: simplify zerocopy send user API
  selftests/net: return back io_uring zc send tests

 include/uapi/linux/io_uring.h                 |  28 ++---
 io_uring/io_uring.c                           |  14 +--
 io_uring/net.c                                |  57 ++++++----
 io_uring/net.h                                |   1 +
 io_uring/notif.c                              |  83 +-------------
 io_uring/notif.h                              |  54 +---------
 io_uring/opdef.c                              |  12 +--
 io_uring/rsrc.c                               |  55 +---------
 io_uring/rsrc.h                               |   4 +-
 .../selftests/net/io_uring_zerocopy_tx.c      | 101 +++++++-----------
 .../selftests/net/io_uring_zerocopy_tx.sh     |  10 +-
 11 files changed, 98 insertions(+), 321 deletions(-)

-- 
2.37.2


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1E55BFCD5
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIULUp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiIULUo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2946FA3F
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:42 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n35-20020a05600c502300b003b4924c6868so2170250wmr.1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=UhyYLzFYzhVCiXiKAWh4nkl/cUU83KULJwmwWlsMI+A=;
        b=Io/PcDvYteJBiOd68MbZmmuSM89gc3st1hajEyU/JrVH8hH2bNHAA6VoqpbphoiCtQ
         Yb8WmX6CYKTS+HpJdQXlIJtpxc36m0WhdOO2yDcTIzhSsLR9uF6AbEh92YAEeWPr8hCF
         n/B2Hi+FrXU28NJ9NTvdqcSgtUAwE9jyxJp9uSUOABf1QXBL9yxzgZNQlfx/1kuaWawm
         CEmXQ0VPZc5dH4aS4ogDjGMNzNIAtglYxzO1dGpGGdfbA2eXhGX+sEPv8ySNavYKQGf9
         2k1izJUG8G+wBJKmPq2CTF7edA8eYaX83kxBPLRjiZOxTqm86FL2jEikeWPGl2EyJGSo
         ktHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=UhyYLzFYzhVCiXiKAWh4nkl/cUU83KULJwmwWlsMI+A=;
        b=EAC6TGjdHrtWIlSAZWx/NGc6x8gWjLQheHUvtK77K0wKokRDlUnXKNZZRNMMLLP2Ai
         AfyY6dDOw+zZMXbGnkwJX9CTfkwMNtcOAyAduzcnyMLtyu/DHn/rCRtffC/028qFbNhR
         V/QJ/GMiaOJpPuwfRy2Kn7TZeIhA39xMt5ZsBbPn6ePYXTKaq54ZJLwiQpr1SJBhYcNf
         4x9Nt+UVRWSjN8q3QOKdgdNYeqISjmID8Ngi0JcFJRcK4i/u0auyNcL2CMclST1lemlU
         72qlNCwvu1bdw9sDJnav1Af6jvUxRbkL2QnF9R/9ZQnPaUz2MF2NR4tDswZROf1gw2ms
         OrTg==
X-Gm-Message-State: ACrzQf1wTsY4qn0QCVGC4ciUqXZpyQQYSz+vDmuEHMl2Sl1LNioeaQDv
        EyZqyKY2OZJNdL0dyWiNNNnbfAmEsr4=
X-Google-Smtp-Source: AMsMyM4OxIfZN9wGSD4Aa5yz7vCJKY1Ss7UExitHLhG4GA070hFuQiL+ovwMpSbXpXDXXtNwQtgBDg==
X-Received: by 2002:a05:600c:4fcb:b0:3b4:a4dd:6154 with SMTP id o11-20020a05600c4fcb00b003b4a4dd6154mr5388424wmq.60.1663759240370;
        Wed, 21 Sep 2022 04:20:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/9] mix of 6.1 net patches
Date:   Wed, 21 Sep 2022 12:17:45 +0100
Message-Id: <cover.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

0-4 fix a rare scenario when a partial I/O is completed with an error
code rather than the number of bytes processed, which is especially
bad with sockets and other non-idempotent files.

5-9 add some net features, specifically 6/9 optionally transforms normal
sends into sendto, and 9/9 adds zerocopy sendmsg.

Pavel Begunkov (9):
  io_uring: add custom opcode hooks on fail
  io_uring/rw: don't lose partial IO result on fail
  io_uring/net: don't lose partial send/recv on fail
  io_uring/net: don't lose partial send_zc on fail
  io_uring/net: refactor io_setup_async_addr
  io_uring/net: support non-zerocopy sendto
  io_uring/net: rename io_sendzc()
  io_uring/net: combine fail handlers
  io_uring/net: zerocopy sendmsg

 include/uapi/linux/io_uring.h |   1 +
 io_uring/io_uring.c           |   4 +
 io_uring/net.c                | 176 +++++++++++++++++++++++++++++-----
 io_uring/net.h                |  12 ++-
 io_uring/opdef.c              |  41 +++++++-
 io_uring/opdef.h              |   1 +
 io_uring/rw.c                 |   8 ++
 io_uring/rw.h                 |   1 +
 8 files changed, 214 insertions(+), 30 deletions(-)

-- 
2.37.2


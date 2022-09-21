Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573AA5BFCE8
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIULYg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiIULYe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:24:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73177F75
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r7so9375861wrm.2
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=nM507M7dSaz6A9vxYGLBVyDUf2upxuxKhruDLIFnOj0=;
        b=MrYq7eNEJQn1ubGRh5q9kBt1zOXb0HLMnfmjNLyZ1+NAhKuoqsuCq7FuhwT0Aqcasb
         H3+euo+X/vbkN5GxpcJBD43+QyqchQDDm/iafPt9BIpkDKfv4vQmlxDon3qE3gIAm6sF
         JNDFZaQFZyzBeFpMYctkbJB9jsxs6zRDtnTGA8ObQQhjxg2uh8PJg71Z5N8XiTJUA7y0
         EQSvnhxKSd6dnlQVIJynjZdNd1zLkLauntKE7Yzqsc/ML0kQ5C3GTArdWEWGfXFNOMS1
         3pYc+l3mqGPu4dnMvBfGHncRks86tP+wNbMD7iX8KnCl2TOzXKHACKp01w11/DFK4gdr
         e1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=nM507M7dSaz6A9vxYGLBVyDUf2upxuxKhruDLIFnOj0=;
        b=ho/QrUZRahlF/ETvmJPX6jE07rVliJTKN5zqFTqPNYiHXYiNoPtgUIf3KzZimGKiX4
         3a0qTZqXn3DdN74sGX7FfZsf4/Q7IZgLf0jYt1P/pumKCf4PFqqlhRq+dGBe8dJBXqGC
         3IE17Ya3t3F7m2Jyz58s1A7Bg+jJ0AfRYH6XGJzyzlvA/4wfgyGRA9676yhg5UYzQ3WS
         8KFlFcok7YVTjicGvaP1b6Y2dcoKQd+KFAUfpx5x9okXyaL2ICmtC8b8v2JdteZ4QUYH
         Myh8JiK0JZbBRzQjGBx4NgdX/Oubko59TVMCZlepbUSZpfij/Yc3zN/jE3JWbiWecQjs
         G9DA==
X-Gm-Message-State: ACrzQf0k2D56lREXzTJLa5mBaHTkpd6xvTpw1zpvaHRWmDUuLYgRq2/Y
        J1yjisMAVR3GJubmQMbuCN5TR9s8zuY=
X-Google-Smtp-Source: AMsMyM7k71PMOWzRg8AS1rnkdpjZv8DvdaQKSBl+cxb4rSBARJBpEQ3Tn1l2QCbO7pfNa8nitKSN4w==
X-Received: by 2002:adf:d1ef:0:b0:228:a9ee:8f13 with SMTP id g15-20020adfd1ef000000b00228a9ee8f13mr16157882wrd.686.1663759471368;
        Wed, 21 Sep 2022 04:24:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id bw25-20020a0560001f9900b0022ac1be009esm2467539wrb.16.2022.09.21.04.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:24:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/4] zc changes
Date:   Wed, 21 Sep 2022 12:21:54 +0100
Message-Id: <cover.1663759148.git.asml.silence@gmail.com>
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

We're decoupling notifications generation from whether the request
failed or not. Adjust the tests, so nobody is confused reading it,
and put a note in man.

Also, 4/4 adds a test for just sent zc sendmsg.

Pavel Begunkov (4):
  examples: fix sendzc notif handling
  test: fix zc tests
  man: note about notification generation
  tests: add sendmsg_zc tests

 examples/send-zerocopy.c        |  17 +++---
 man/io_uring_enter.2            |   5 +-
 src/include/liburing/io_uring.h |   1 +
 test/send-zerocopy.c            | 101 ++++++++++++++++++++++++--------
 4 files changed, 88 insertions(+), 36 deletions(-)

-- 
2.37.2


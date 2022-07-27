Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBD2582329
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 11:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiG0JdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 05:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiG0JdJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 05:33:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1732871D
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 02:33:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q18so12945906wrx.8
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 02:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=giAsigE0efN/stLJlofKcRgbyeZb/i+ni79NmWS2CPg=;
        b=BWp0TJO1C44DTZVgOJ/PWwAkhw0zFhCK6OTqEOKsI+ubqMxrX6MRA7FZw4pCYOcu4g
         bX3Emdc0CJ9Gwr7J2qKUhgc2heBAJ3CBHg97kT87UpHXaFJDXj8jjLvuQwS9PMMiEXVv
         j5Rt0/tCZ+h0RU+VXJPig3phPYDqLg5xZ8IRR0pV6p5jvtClB4xnuQFk22lxKr4GdeAu
         Q3PBzk8vomCk6n3M+sl5SPKe3GlBsbJyxzsbLzeJY9bXC9YqSDyU18xfsc6Q4sPsrNrl
         9EX7FtwmHyIhd/std7M1WQt2I+Suyx/T2NYoBbO7014+4XQo7ntCJOYmJ/wYtVuh+7Yi
         Vh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=giAsigE0efN/stLJlofKcRgbyeZb/i+ni79NmWS2CPg=;
        b=UVR+Ga/YXze+mX90pTKIHpN6HYfG+ngq8nXkp144ykAo7erKVn+yCEkmyCuC+9JabD
         vQPUFZjyA/y4fqafwcz1wFKo3eKh6dZgtBiLUDNlY90LTuQbFuz7a4iH29xzBuTpwSmk
         DYnhkLkoIKzM9cFtCvXC4w4h7vtUEmPc28z5df14Gl5a9uiPILLVH6/6T3eZYAlHO6OF
         pGpmNQuWANUkFAy2CZdrfSUeFagSfz3jWjZx83pPrIiwAznow8G90S3SrHGNtwAXHyBo
         TcW5B2pTrfhdFs/nhKk6SEtUXA5yeJlX6QIfRORIY1MSaokneXLKreXWkvfaPiqxR42Q
         yp/g==
X-Gm-Message-State: AJIora9xU3B6i3bes2tQmmH+Luq6h2iU0Jgfs4yUuvh6jxSLXAMCtV6D
        VKc27ic/H0BKj3nV0wO9i6ct8zmohnuaTg==
X-Google-Smtp-Source: AGRyM1v3Kt1DJc9LRLMiuwj1frTWSDShtmEEHm3zKeDjAxdvSvkJBN+BKlUcmjUyc0UzZBqt0O8Z5A==
X-Received: by 2002:a05:6000:68b:b0:21e:5134:c80c with SMTP id bo11-20020a056000068b00b0021e5134c80cmr13741675wrb.625.1658914386279;
        Wed, 27 Jul 2022 02:33:06 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:754a])
        by smtp.gmail.com with ESMTPSA id v1-20020adfe281000000b0021e5adb92desm15605302wri.60.2022.07.27.02.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 02:33:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 0/2] notification optimisation
Date:   Wed, 27 Jul 2022 10:30:39 +0100
Message-Id: <cover.1658913593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Reuse request infra for zc notifications for optimisation and also
a nice line count reduction.

v2:
    add missing patch exporting io_alloc_req()

Pavel Begunkov (2):
  io_uring: export req alloc from core
  io_uring: notification completion optimisation

 include/linux/io_uring_types.h |   7 --
 io_uring/io_uring.c            |  25 +-----
 io_uring/io_uring.h            |  21 +++++
 io_uring/net.c                 |   4 +-
 io_uring/notif.c               | 159 +++++++++++----------------------
 io_uring/notif.h               |  42 +++------
 6 files changed, 89 insertions(+), 169 deletions(-)

-- 
2.37.0

